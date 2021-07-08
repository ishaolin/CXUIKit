//
//  CXWebViewJavaScriptBridge.h
//  Pods
//
//  Created by wshaolin on 2017/11/15.
//

#import <Foundation/Foundation.h>
#import "CXWebViewBridgeDefines.h"

@class CXWebView;

@interface CXWebViewJavaScriptBridge : NSObject

@property (nonatomic, weak, readonly) CXWebView *webView;

@property (nonatomic, strong, readonly) NSArray<NSString *> *registeredHandlers;

- (instancetype)initWithWebView:(CXWebView *)webView;

- (instancetype)initWithWebView:(CXWebView *)webView readyScript:(NSString *)readyScript;

- (BOOL)isJavaScriptBridgeRequest:(NSURLRequest *)request;

- (void)handleJavaScriptBridgeRequest:(NSURLRequest *)request;

- (void)registerHandler:(NSString *)handlerName handler:(CXWebViewBridgeHandler)handler;

- (void)webViewDidFinishLoad;

- (void)flushRegisteredHandlers;

@end
