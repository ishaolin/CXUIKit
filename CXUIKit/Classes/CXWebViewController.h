//
//  CXWebViewController.h
//  Pods
//
//  Created by wshaolin on 2019/10/16.
//

#import "CXFailureViewController.h"
#import "CXWebView.h"

@class CXWebView;

typedef NSString *CXBridgeBarItemAction;

@interface CXWebViewController : CXFailureViewController

@property (nonatomic, strong, readonly) NSURLRequest *currentRequest;
@property (nonatomic, strong, readonly) UIScrollView *scrollView;

- (instancetype)initWithURL:(NSString *)url;

- (instancetype)initWithURL:(NSString *)url params:(NSDictionary<NSString *, id> *)params;

- (void)layoutWebView:(CXWebView *)webView;

- (void)loadRequestWithURL:(NSURL *)url;

- (void)loadRequest:(NSURLRequest *)request;

- (void)reload;

- (void)reloadRequest:(NSURLRequest *)request;

- (void)registerHandler:(NSString *)handlerName handler:(CXWebViewBridgeHandler)handler;

- (void)registerBridgeHandlers;

- (void)loadJavaScripts;

- (void)addJavaScript:(NSString *)javaScript forMainFrameOnly:(BOOL)mainFrameOnly;

- (void)evaluateJavaScript:(NSString *)javaScript;

- (void)evaluateJavaScript:(NSString *)javaScript completionHandler:(void (^)(id data, NSError * error))completionHandler;

- (void)handleOpenURLString:(NSString *)url params:(NSDictionary<NSString *, id> *)params;

- (void)handleShareWithData:(NSDictionary<NSString *, id> *)data callback:(CXWebViewBridgeCallback)callback;

- (NSURL *)URLWithURLString:(NSString *)url params:(NSDictionary<NSString *, id> *)params;

#pragma CXWebView代理回调

- (BOOL)webView:(CXWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(WKNavigationType)navigationType;

- (void)webViewDidStartLoad:(CXWebView *)webView;

- (void)webViewDidFinishLoad:(CXWebView *)webView;

- (void)webView:(CXWebView *)webView didFailLoadWithError:(NSError *)error;

- (void)webView:(CXWebView *)webView didLongPressImage:(UIImage *)image;

@end

@class CXWebViewBridgeActionNode;

@interface CXBarButtonItem (CXWebViewBridgeActionSupported)

@property (nonatomic, strong, readonly) CXWebViewBridgeActionNode *actionNode;

- (instancetype)initWithActionNode:(CXWebViewBridgeActionNode *)actionNode
                            target:(id)target
                            action:(SEL)action;

@end

@class CXWebViewBridgeActionTracker;

@interface CXWebViewBridgeActionNode : NSObject

@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *iconUrl;
@property (nonatomic, copy, readonly) CXBridgeBarItemAction action;
@property (nonatomic, strong, readonly) NSDictionary<NSString *, id> *params;
@property (nonatomic, strong, readonly) CXWebViewBridgeActionTracker *tracker;

- (instancetype)initWithDictionary:(NSDictionary<NSString *, id> *)dictionary;

@end

@interface CXWebViewBridgeActionTracker : NSObject

@property (nonatomic, copy, readonly) NSString *id;
@property (nonatomic, strong, readonly) NSDictionary<NSString *, id> *params;

- (instancetype)initWithTrackerId:(NSString *)trackerId params:(NSDictionary<NSString *, id> *)params;

@end

CX_UIKIT_EXTERN CXBridgeBarItemAction const CXBridgeBarItemActionHandleScheme;
CX_UIKIT_EXTERN CXBridgeBarItemAction const CXBridgeBarItemActionSharePanel;
CX_UIKIT_EXTERN CXBridgeBarItemAction const CXBridgeBarItemActionCallJavaScript;
CX_UIKIT_EXTERN CXBridgeBarItemAction const CXBridgeBarItemActionRefresh;
