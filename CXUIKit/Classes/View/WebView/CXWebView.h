//
//  CXWebView.h
//  Pods
//
//  Created by wshaolin on 2017/11/9.
//

#import "CXWebViewBridgeDefines.h"
#import "CXUIKitDefines.h"
#import <WebKit/WebKit.h>

#define CX_WEBVIEW_CODE_SOURCE(x) #x

@class CXWebView;

@protocol CXWebViewDelegate <NSObject>

@optional

- (BOOL)webView:(CXWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(WKNavigationType)navigationType;

- (void)webViewDidStartLoad:(CXWebView *)webView;

- (void)webViewDidFinishLoad:(CXWebView *)webView;

- (void)webView:(CXWebView *)webView didFailLoadWithError:(NSError *)error;

- (void)webView:(CXWebView *)webView didLongPressImage:(UIImage *)image;

@end

@interface CXWebView : WKWebView

@property (nonatomic, weak) id<CXWebViewDelegate> delegate;

@property (nonatomic, assign, getter = isHiddenProgressBar) BOOL hiddenProgressBar;
@property (nonatomic, strong) UIColor *progressBarColor;
@property (nonatomic, assign) UIOffset progressBarOffset;

- (void)registerHandler:(NSString *)handlerName handler:(CXWebViewBridgeHandler)handler;

- (void)addJavaScript:(NSString *)javaScript forMainFrameOnly:(BOOL)mainFrameOnly;

- (void)evaluateJavaScript:(NSString *)javaScript;

- (void)flushRegisteredHandlers;

- (void)bringProgressBarToFront;

@end

CX_UIKIT_EXTERN void CXWebViewUserAgentAppending(NSString *userAgentAppending);
