//
//  CXWebJavaScriptHandler.m
//  Pods
//
//  Created by wshaolin on 2019/1/23.
//

#import "CXWebJavaScriptHandler.h"
#import <WebKit/WebKit.h>
#import <CXFoundation/CXFoundation.h>

@interface CXWebJavaScriptHandler () <WKScriptMessageHandler> {
    
}

@property (nonatomic, weak) WKUserContentController *userController;

@end

@implementation CXWebJavaScriptHandler

- (instancetype)initWithUserController:(WKUserContentController *)userController{
    if(self = [super init]){
        self.userController = userController;
        
        // 先调用一次以保证自己不被销毁
        [self registerHandler:@"console"];
    }
    
    return self;
}

- (void)registerHandler:(NSString *)handlerName{
    if(handlerName){
        [self.userController removeScriptMessageHandlerForName:handlerName];
        [self.userController addScriptMessageHandler:self name:handlerName];
    }
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    if([self.delegate respondsToSelector:@selector(webJavaScriptHandler:didMessageWithParams:callId:)]){
        NSDictionary<NSString *, id> *data = [NSJSONSerialization cx_deserializeJSONToDictionary:message.body];
        NSString *callId = [data cx_stringForKey:@"id"];
        NSDictionary<NSString *, id> *params = [data cx_dictionaryForKey:@"params"];
        
        [self.delegate webJavaScriptHandler:message.name didMessageWithParams:params callId:callId];
    }
}

@end
