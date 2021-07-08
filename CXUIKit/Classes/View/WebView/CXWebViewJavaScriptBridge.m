//
//  CXWebViewJavaScriptBridge.m
//  Pods
//
//  Created by wshaolin on 2017/11/15.
//

#import "CXWebViewJavaScriptBridge.h"
#import "CXWebJavaScriptHandler.h"
#import "CXWebView.h"
#import <CXFoundation/CXFoundation.h>

#define CX_WEBVIEW_BRIDGE_SCHEME @"bridge"
#define CX_WEBVIEW_BRIDGE_HOST   @"invoke.native.method"

static inline NSString *_CXWebViewBridgeScript(){
    static NSString *script = @CX_WEBVIEW_CODE_SOURCE(;(function () {
        if (window.bridge) {
            return;
        }
        
        window.bridge = {
            handlers: new Set(),
            messages: {},
            callId: 0
        };
        
        bridge.register = function (handler) {
            if (this.handlers.has(handler)) {
                return;
            }
            
            this.handlers.add(handler);
        };
        
        bridge.getParams = function (id) {
            return JSON.stringify(this.messages[id].params);
        };
        
        bridge.console = function (data) {
            invokeNative('console', {data : data}, null);
        };
        
        bridge.invoke = function (handler, params, callback) {
            if (this.handlers.has(handler)) {
                invokeNative(handler, params, callback);
            } else {
                this.console('"' + handler + '" handler unregistered.');
            }
        };
        
        bridge.callback = function (id, data) {
            var message = this.messages[id];
            if (!message) {
                return;
            }
            
            if (message.callback) {
                message.callback(JSON.parse(data));
            }
            
            delete this.messages[id];
        };
        
        function invokeNative(handler, params, callback) {
            bridge.callId ++;
            bridge.messages[bridge.callId] = {params : params, callback : callback};
            
            if (window.webkit && window.webkit.messageHandlers) {
                var data = JSON.stringify({id : bridge.callId, params : params});
                try {
                    eval('window.webkit.messageHandlers.' + handler + '.postMessage(' + data + ')');
                } catch (error) {}
            } else {
                var e = document.createElement('iframe');
                e.src = 'bridge://invoke.native.method?handler=' + handler + '&id=' + bridge.callId;
                e.style.display = 'none';
                document.documentElement.appendChild(e);
                
                setTimeout(function () { document.documentElement.removeChild(e); }, 0);
            }
        };
    })(););
    
    return script;
}

@interface CXWebViewJavaScriptBridge() <CXWebJavaScriptMessageHandler>{
    NSMutableDictionary<NSString *, id> *_handlers;
    NSString *_readyScript;
}

@property (nonatomic, weak) CXWebJavaScriptHandler *javaScriptHandler;

@end

@implementation CXWebViewJavaScriptBridge

- (instancetype)initWithWebView:(CXWebView *)webView {
    return [self initWithWebView:webView readyScript:nil];
}

- (instancetype)initWithWebView:(CXWebView *)webView readyScript:(NSString *)readyScript{
    if(self = [super init]){
        _webView = webView;
        _readyScript = readyScript;
        _handlers = [NSMutableDictionary dictionary];
        
        CXWebJavaScriptHandler *javaScriptHandler = [[CXWebJavaScriptHandler alloc] initWithUserController:webView.configuration.userContentController];
        javaScriptHandler.delegate = self;
        self.javaScriptHandler = javaScriptHandler;
    }
    
    return self;
}

- (BOOL)isJavaScriptBridgeRequest:(NSURLRequest *)request{
    return ([request.URL.scheme isEqualToString:CX_WEBVIEW_BRIDGE_SCHEME] &&
            [request.URL.host isEqualToString:CX_WEBVIEW_BRIDGE_HOST]);
}

- (void)handleJavaScriptBridgeRequest:(NSURLRequest *)request{
    NSDictionary<NSString *, NSString *> *params = [request.URL cx_params];
    NSString *handlerName = params[@"handler"];
    NSString *callId = params[@"id"];
    
    if(handlerName){
        [self invokeHandler:handlerName withCallId:callId];
    }
}

- (void)registerHandler:(NSString *)handlerName handler:(CXWebViewBridgeHandler)handler{
    if(handlerName && handler){
        [self.javaScriptHandler registerHandler:handlerName];
        _handlers[handlerName] = [handler copy];
    }
}

- (void)webJavaScriptHandler:(NSString *)handlerName didMessageWithParams:(NSDictionary<NSString *,id> *)params callId:(NSString *)callId{
    if(handlerName){
        CXWebViewBridgeHandler handler = _handlers[handlerName];
        [self invokeHandler:handler withParams:params callId:callId];
    }
}

- (NSArray<NSString *> *)registeredHandlers{
    return _handlers.allKeys;
}

- (void)invokeHandler:(NSString *)handlerName withCallId:(NSString *)callId{
    CXWebViewBridgeHandler handler = _handlers[handlerName];
    if(!handler){
        return;
    }
    
    NSString *javaScript = [NSString stringWithFormat:@"bridge.getParams('%@');", callId];
    [self.webView evaluateJavaScript:javaScript completionHandler:^(id data, NSError *error) {
        NSDictionary<NSString *, id> *params = [NSJSONSerialization cx_deserializeJSONToDictionary:data];
        [self invokeHandler:handler withParams:params callId:callId];
    }];
}

- (void)invokeHandler:(CXWebViewBridgeHandler)handler withParams:(NSDictionary<NSString *, id> *)params callId:(NSString *)callId{
    if(!handler){
        return;
    }
    
    CXWebViewBridgeCallback callback = ^(NSDictionary<NSString *, id> *dictionary){
        NSString *data = [NSJSONSerialization cx_stringWithJSONObject:dictionary ?: @{}];
        data = [data stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
        data = [data stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
        data = [data stringByReplacingOccurrencesOfString:@"\'" withString:@"\\\'"];
        data = [data stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
        data = [data stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r"];
        data = [data stringByReplacingOccurrencesOfString:@"\f" withString:@"\\f"];
        data = [data stringByReplacingOccurrencesOfString:@"\u2028" withString:@"\\u2028"];
        data = [data stringByReplacingOccurrencesOfString:@"\u2029" withString:@"\\u2029"];
        [self.webView evaluateJavaScript:[NSString stringWithFormat:@"bridge.callback('%@', '%@');", callId, data]];
    };
    
    handler(params, callback);
}

- (void)webViewDidFinishLoad{
    // 先注册脚本，脚本注册完成之后再注册handler
    [self.webView evaluateJavaScript:_CXWebViewBridgeScript() completionHandler:^(id data, NSError *error) {
        [self flushRegisteredHandlers];
    }];
}

- (void)flushRegisteredHandlers{
    [_handlers enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [self.webView evaluateJavaScript:[NSString stringWithFormat:@"bridge.register('%@');", key]];
    }];
    
    if(_readyScript){
        [self.webView evaluateJavaScript:_readyScript];
    }
}

@end
