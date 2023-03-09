//
//  CXWebView.m
//  Pods
//
//  Created by wshaolin on 2017/11/9.
//

#import "CXWebView.h"
#import "CXAlertControllerUtils.h"
#import "UIColor+CXUIKit.h"
#import "CXWebViewJavaScriptBridge.h"
#import "CXWebImage.h"
#import "CXWebViewProgressBar.h"

#define CX_WKWEBVIEW_KVO_PROGRESS @"estimatedProgress"

static NSString *_CXUserAgentAppending = nil;

static inline WKWebViewConfiguration *_CXUserAgentConfiguration(WKWebViewConfiguration *configuration){
    if(CXStringIsEmpty(_CXUserAgentAppending)){
        return configuration;
    }
    
    NSString *userAgent = configuration.applicationNameForUserAgent;
    if(CXStringIsEmpty(userAgent)){
        userAgent = _CXUserAgentAppending;
    }else{
        userAgent = [NSString stringWithFormat:@"%@ %@", userAgent, _CXUserAgentAppending];
    }
    
    configuration.applicationNameForUserAgent = userAgent;
    return configuration;
}

static inline NSString *_CXWebViewScalesPageToFitScript(){
    static NSString *javaScript = @CX_WEBVIEW_CODE_SOURCE(;(function (_name, _content) {
        var meta = document.getElementsByTagName('meta')[_name];
        if (!meta) {
            meta = document.createElement('meta');
            meta.name = _name;
            meta.content = _content;
            var head = document.getElementsByTagName('head')[0];
            head.appendChild(meta);
        }
    }) ('viewport', 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no'););
    
    return javaScript;
}

static inline NSString *_CXWebViewSaveImageToPhotosAlbumScript(){
    static NSString *script = @CX_WEBVIEW_CODE_SOURCE(;(function() {
        var timeoutId;
        document.addEventListener('touchstart', function(event) {
            clearTimeout(timeoutId);
            timeoutId = setTimeout(function() {
                var x = event.targetTouches[0].clientX;
                var y = event.targetTouches[0].clientY;
                var element = document.elementFromPoint(x, y);
                if (element.tagName == 'IMG') {
                    window.bridge.saveImageToPhotosAlbum({image : element.src})
                }
            }, 1000);
        });
        
        document.addEventListener('touchmove', function(event) {
            clearTimeout(timeoutId);
        });
        
        document.addEventListener('touchend', function(event) {
            clearTimeout(timeoutId);
        });
    })(););
    
    return script;
}

static inline NSString *_CXWebViewBridgeReadyScript(){
    static NSString *script = @CX_WEBVIEW_CODE_SOURCE(;(function() {
        if (window.bridgeReady && !window.bridge.isReady) {
            window.bridgeReady();
            window.bridge.isReady = true;
        }
        
        // 禁用IMG标签的用户选择和长按弹出框
        Array.prototype.slice.call(document.getElementsByTagName('img')).forEach(function (item) {
            item.style.webkitUserSelect = 'none';
            item.style.webkitTouchCallout = 'none';
        });
    })(););
    
    return script;
}

@interface CXWebView ()<WKNavigationDelegate, WKUIDelegate> {
    CXWebViewProgressBar *_progressBar;
    CXWebViewJavaScriptBridge *_bridge;
}

@end

@implementation CXWebView

- (instancetype)initWithFrame:(CGRect)frame configuration:(WKWebViewConfiguration *)configuration{
    if(self = [super initWithFrame:CGRectZero configuration:_CXUserAgentConfiguration(configuration)]){
        [self setup];
    }
    
    return self;
}

- (void)setup{
    self.navigationDelegate = self;
    self.UIDelegate = self;
    
    _bridge = [[CXWebViewJavaScriptBridge alloc] initWithWebView:self readyScript:_CXWebViewBridgeReadyScript()];
    _progressBar = [[CXWebViewProgressBar alloc] init];
    _progressBar.progressColor = CXHexIColor(0x007AFF);
    [self addSubview:_progressBar];
    
    NSString *javaScript = _CXWebViewScalesPageToFitScript();
    WKUserScript *userScript = [[WKUserScript alloc] initWithSource:javaScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:NO];
    [self.configuration.userContentController addUserScript:userScript];
    
    [self addObserver:self
           forKeyPath:CX_WKWEBVIEW_KVO_PROGRESS
              options:NSKeyValueObservingOptionNew
              context:nil];
    
    if(@available(iOS 11.0, *)){
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    [self registerDefaultHandlers];
}

- (void)registerDefaultHandlers {
    [self addJavaScript:_CXWebViewSaveImageToPhotosAlbumScript() forMainFrameOnly:YES];
    
    // saveImageToPhotosAlbum
    @weakify(self);
    [self registerHandler:@"saveImageToPhotosAlbum" handler:^(NSDictionary<NSString *,id> *data, CXWebViewBridgeCallback callback) {
        @strongify(self);
        if([self.delegate respondsToSelector:@selector(webView:didLongPressImage:)]){
            NSString *imageData = [data cx_stringForKey:@"image"];
            if([CXStringUtils isHTTPURL:imageData] || [imageData hasPrefix:@"data:image/"]){
                [CXActionSheetUtils showActionSheetWithConfigBlock:^(CXActionSheetControllerConfigModel *config) {
                    config.window = self.window;
                    config.buttonTitles = @[@"保存图片"];
                } completion:^(NSInteger buttonIndex) {
                    if(buttonIndex == 0){
                        [self writeWebViewImageToSavedPhotosAlbum:imageData];
                    }
                }];
            }
        }
        
        callback(nil);
    }];
    
    // console
    [self registerHandler:@"console" handler:^(NSDictionary<NSString *,id> *data, CXWebViewBridgeCallback callback) {
        LOG_INFO(@"javaScriptConsole: %@", [data cx_stringForKey:@"data"]);
        callback(nil);
    }];
    
    // showAlert
    [self registerHandler:@"showAlert" handler:^(NSDictionary<NSString *,id> *data, CXWebViewBridgeCallback callback) {
        @strongify(self);
        [CXAlertControllerUtils showAlertWithConfigBlock:^(CXAlertControllerConfigModel *config) {
            config.title = [data cx_stringForKey:@"title"];
            config.message = [data cx_stringForKey:@"message"];
            config.buttonTitles = [data cx_arrayForKey:@"buttonTitles"];
            config.window = self.window;
            [self setConfigModel:config destructiveIndexWithData:data];
        } completion:^(NSUInteger buttonIndex) {
            callback(@{@"clicked" : @(buttonIndex)});
        } cancelBlock:^{
            callback(@{@"clicked" : @(CXActionSheetCancelButtonIndex)});
        }];
    }];
    
    // showActionSheet
    [self registerHandler:@"showActionSheet" handler:^(NSDictionary<NSString *,id> *data, CXWebViewBridgeCallback callback) {
        @strongify(self);
        [CXActionSheetUtils showActionSheetWithConfigBlock:^(CXActionSheetControllerConfigModel *config) {
            config.title = [data cx_stringForKey:@"title"];
            config.buttonTitles = [data cx_arrayForKey:@"buttonTitles"];
            config.window = self.window;
            [self setConfigModel:config destructiveIndexWithData:data];
        } completion:^(NSInteger buttonIndex) {
            callback(@{@"clicked" : @(buttonIndex)});
        } cancelBlock:^{
            callback(@{@"clicked" : @(CXActionSheetCancelButtonIndex)});
        }];
    }];
}

- (void)setConfigModel:(CXActionControllerConfigModel *)config destructiveIndexWithData:(NSDictionary<NSString *,id> *)data{
    NSString *destructiveIndex = @"destructiveIndex";
    if([data cx_hasKey:destructiveIndex]){
        config.destructiveIndex = [data cx_numberForKey:destructiveIndex].integerValue;
    }
}

- (void)setHiddenProgressBar:(BOOL)hiddenProgressBar{
    _progressBar.hidden = hiddenProgressBar;
}

- (BOOL)isHiddenProgressBar{
    return _progressBar.isHidden;
}

- (void)setProgressBarColor:(UIColor *)progressBarColor{
    _progressBar.progressColor = progressBarColor;
}

- (UIColor *)progressBarColor{
    return _progressBar.progressColor;
}

- (void)registerHandler:(NSString *)handlerName handler:(CXWebViewBridgeHandler)handler{
    [_bridge registerHandler:handlerName handler:handler];
}

- (void)addJavaScript:(NSString *)javaScript forMainFrameOnly:(BOOL)mainFrameOnly{
    if(!javaScript){
        return;
    }
    
    WKUserScript *userScript = [[WKUserScript alloc] initWithSource:javaScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:mainFrameOnly];
    [self.configuration.userContentController addUserScript:userScript];
}

- (void)evaluateJavaScript:(NSString *)javaScript{
    [self evaluateJavaScript:javaScript completionHandler:NULL];
}

- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^)(id _Nullable, NSError * _Nullable))completionHandler{
    // 解决某些情况下的crash，详见：http://www.cnblogs.com/NSong/p/6489802.html
    [super evaluateJavaScript:javaScriptString completionHandler:^(id data, NSError *error) {
        if(error){
            LOG_INFO(@"evaluateJavaScript error: %@", error);
        }
        
        !completionHandler ?: completionHandler(data, error);
    }];
}

- (void)flushRegisteredHandlers{
    [_bridge flushRegisteredHandlers];
}

- (void)bringProgressBarToFront{
    [self bringSubviewToFront:_progressBar];
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    [CXAlertControllerUtils showAlertWithConfigBlock:^(CXAlertControllerConfigModel *config) {
        config.message = message;
        config.window = self.window;
    } completion:^(NSUInteger buttonIndex) {
        !completionHandler ?: completionHandler();
    } cancelBlock:^{
        !completionHandler ?: completionHandler();
    }];
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
    [CXAlertControllerUtils showAlertWithConfigBlock:^(CXAlertControllerConfigModel *config) {
        config.message = message;
        config.buttonTitles = @[@"取消", @"确认"];
        config.window = self.window;
    } completion:^(NSUInteger buttonIndex) {
        !completionHandler ?: completionHandler(buttonIndex == 1);
    } cancelBlock:^{
        !completionHandler ?: completionHandler(NO);
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if(_progressBar.isHidden){
        return;
    }
    
    if([keyPath isEqualToString:CX_WKWEBVIEW_KVO_PROGRESS]){
        float progress = [change[NSKeyValueChangeNewKey] floatValue];
        [_progressBar setProgress:progress animated:YES];
    }
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    if([self webViewShouldStartLoadWithRequest:navigationAction.request navigationType:navigationAction.navigationType]){
        decisionHandler(WKNavigationActionPolicyAllow);
    }else{
        decisionHandler(WKNavigationActionPolicyCancel);
    }
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    [self webViewDidStartLoad];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [self webViewDidFinishLoad];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError: (NSError *)error{
    [self webViewDidFailLoadWithError:error];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    [self webViewDidFailLoadWithError:error];
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
    // 解决某些情况下的白屏问题，详见：http://www.cnblogs.com/NSong/p/6489802.html
    [webView reload];
}

- (BOOL)webViewShouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(WKNavigationType)navigationType{
    if([_bridge isJavaScriptBridgeRequest:request]){
        [_bridge handleJavaScriptBridgeRequest:request];
        return NO;
    }
    
    if([_delegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]){
        return [_delegate webView:self shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    
    return YES;
}

- (void)webViewDidStartLoad{
    if([_delegate respondsToSelector:@selector(webViewDidStartLoad:)]){
        [_delegate webViewDidStartLoad:self];
    }
}

- (void)webViewDidFinishLoad{
    [_bridge webViewDidFinishLoad];
    
    if([_delegate respondsToSelector:@selector(webViewDidFinishLoad:)]){
        [_delegate webViewDidFinishLoad:self];
    }
}

- (void)webViewDidFailLoadWithError:(NSError *)error{
    if([_delegate respondsToSelector:@selector(webView:didFailLoadWithError:)]){
        [_delegate webView:self didFailLoadWithError:error];
    }
}

- (void)writeWebViewImageToSavedPhotosAlbum:(NSString *)webViewImageData{
    if([CXStringUtils isHTTPURL:webViewImageData]){
        [CXWebImage downloadImageWithURL:webViewImageData completion:^(UIImage *image, NSData *data) {
            [self.delegate webView:self didLongPressImage:image];
        }];
    }else{
        NSString *base64Data = [webViewImageData componentsSeparatedByString:@","].lastObject;
        NSData *imageData = [[NSData alloc] initWithBase64EncodedString:base64Data options:NSDataBase64DecodingIgnoreUnknownCharacters];
        UIImage *image = [UIImage imageWithData:imageData];
        [self.delegate webView:self didLongPressImage:image];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat progressBar_X = self.progressBarOffset.horizontal;
    CGFloat progressBar_Y = self.progressBarOffset.vertical;
    CGFloat progressBar_W = self.bounds.size.width - progressBar_X * 2;
    CGFloat progressBar_H = 3.0;
    _progressBar.frame = (CGRect){progressBar_X, progressBar_Y, progressBar_W, progressBar_H};
}

- (void)dealloc{
    [self stopLoading];
    [self removeObserver:self forKeyPath:CX_WKWEBVIEW_KVO_PROGRESS];
}

@end

void CXWebViewUserAgentAppending(NSString *userAgentAppending){
    _CXUserAgentAppending = userAgentAppending;
}
