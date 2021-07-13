//
//  CXWebViewController.m
//  Pods
//
//  Created by wshaolin on 2019/10/16.
//

#import "CXWebViewController.h"
#import "CXBarButtonItem.h"
#import "UIColor+CXUIKit.h"
#import "UIImage+CXUIKit.h"
#import "UIDevice+CXUIKit.h"
#import "CXPageErrorView.h"
#import "CXDataRecord.h"
#import <objc/runtime.h>

@interface CXWebViewController ()<CXWebViewDelegate>{
    CXBarButtonItem *_closeBarButtonItem;
    CXWebView *_webView;
    NSString *_url;
    NSDictionary<NSString *, id> *_params;
}

@end

@implementation CXWebViewController

- (instancetype)initWithURL:(NSString *)url{
    return [self initWithURL:url params:nil];
}

- (instancetype)initWithURL:(NSString *)url params:(NSDictionary<NSString *, id> *)params{
    if(self = [super init]){
        _url = url;
        _params = params;
    }
    
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    _closeBarButtonItem = [[CXBarButtonItem alloc] initWithImage:[UIImage cx_imageNamed:@"page_close"] highlightedImage:nil target:self action:@selector(didClickCloseBarButtonItem:)];
    ((UIButton *)_closeBarButtonItem.view).contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _closeBarButtonItem.hidden = YES;
    self.navigationBar.navigationItem.leftBarButtonItem = _closeBarButtonItem;
    
    _webView = [[CXWebView alloc] init];
    _webView.delegate = self;
    _webView.scrollView.alwaysBounceVertical = NO;
    _webView.progressBarColor = [UIColor systemBlueColor];
    [self.view addSubview:_webView];
    [self layoutWebView:_webView];
    [self registerBridgeHandlers];
    
    if([CXStringUtils isHTTPURL:_url]){
        [self loadJavaScripts];
        NSURL *URL = [self URLWithURLString:_url params:_params];
        [self loadRequestWithURL:URL];
    }else{
        LOG_BREAKPOINT(@"非法的url：%@", _url);
    }
}

- (void)layoutWebView:(CXWebView *)webView{
    CGFloat webView_X = 0;
    CGFloat webView_Y = CGRectGetMaxY(self.navigationBar.frame);
    CGFloat webView_W = self.view.bounds.size.width - webView_X * 2;
    CGFloat webView_H = self.view.bounds.size.height - webView_Y;
    webView.frame = (CGRect){webView_X, webView_Y, webView_W, webView_H};
}

- (void)didClickCloseBarButtonItem:(CXBarButtonItem *)closeBarButtonItem{
    [super didClickBackBarButtonItem:closeBarButtonItem];
}

- (void)didClickBackBarButtonItem:(CXBarButtonItem *)backBarButtonItem{
    if(_webView.canGoBack){
        [_webView goBack];
    }else{
        [super didClickBackBarButtonItem:backBarButtonItem];
    }
}

- (UIScrollView *)scrollView{
    return _webView.scrollView;
}

- (void)loadRequestWithURL:(NSURL *)url{
    if(!url){
        return;
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    [self loadRequest:request];
}

- (void)loadRequest:(NSURLRequest *)request{
    if(!request || _currentRequest == request){
        return;
    }
    
    _currentRequest = request;
    [_webView loadRequest:_currentRequest];
}

- (void)reload{
    [_webView reload];
}

- (void)reloadRequest:(NSURLRequest *)request{
    if(!request){
        return;
    }
    
    _currentRequest = request;
    [_webView loadRequest:request];
}

- (NSURL *)URLWithURLString:(NSString *)url params:(NSDictionary<NSString *, id> *)params{
    NSURLComponents *URLComponents = [NSURLComponents componentsWithString:url];
    NSMutableArray<NSURLQueryItem *> *queryItems = [NSMutableArray array];
    [URLComponents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [queryItems addObject:obj];
    }];
    
    [params enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *value = [NSString stringWithFormat:@"%@", obj];
        NSURLQueryItem *queryItem = [[NSURLQueryItem alloc] initWithName:key value:value];
        [queryItems addObject:queryItem];
    }];
    
    URLComponents.queryItems = [queryItems copy];
    return URLComponents.URL;
}

- (void)registerHandler:(NSString *)handlerName handler:(CXWebViewBridgeHandler)handler{
    [_webView registerHandler:handlerName handler:handler];
}

- (void)registerBridgeHandlers{
    @weakify(self);
    [self registerHandler:@"setNavigationRightAction" handler:^(NSDictionary<NSString *, id> *data, CXWebViewBridgeCallback callback) {
        @strongify(self);
        if(CXDictionaryIsEmpty(data)){
            self.navigationBar.navigationItem.rightBarButtonItem.hidden = YES;
        }else{
            CXWebViewBridgeActionNode *actionNode = [[CXWebViewBridgeActionNode alloc] initWithDictionary:data];
            self.navigationBar.navigationItem.rightBarButtonItem = [[CXBarButtonItem alloc] initWithActionNode:actionNode target:self action:@selector(handleNavigationRightActionForButtonItem:)];
        }
        
        callback(nil);
    }];
    
    [self registerHandler:@"channelShare" handler:^(NSDictionary<NSString *, id> *data, CXWebViewBridgeCallback callback) {
        @strongify(self);
        [self handleShareWithData:data callback:callback];
    }];
    
    [self registerHandler:@"callPhone" handler:^(NSDictionary<NSString *, id> *data, CXWebViewBridgeCallback callback) {
        @strongify(self);
        [[UIDevice currentDevice] cx_callPhone:[data cx_stringForKey:@"phone"]];
        callback(nil);
    }];
    
    [self registerHandler:@"setPageTitle" handler:^(NSDictionary<NSString *, id> *data, CXWebViewBridgeCallback callback) {
        @strongify(self);
        self.title = [data cx_stringForKey:@"title"];
        callback(nil);
    }];
    
    [self registerHandler:@"closePage" handler:^(NSDictionary<NSString *, id> *data, CXWebViewBridgeCallback callback) {
        @strongify(self);
        [self didClickBackBarButtonItem:self.navigationBar.navigationItem.backBarButtonItem];
        callback(nil);
    }];
}

- (void)loadJavaScripts{
    
}

- (void)addJavaScript:(NSString *)javaScript forMainFrameOnly:(BOOL)mainFrameOnly{
    [_webView addJavaScript:javaScript forMainFrameOnly:mainFrameOnly];
}

- (void)evaluateJavaScript:(NSString *)javaScript{
    [_webView evaluateJavaScript:javaScript];
}

- (void)evaluateJavaScript:(NSString *)javaScript completionHandler:(void (^)(id data, NSError * error))completionHandler{
    [_webView evaluateJavaScript:javaScript completionHandler:completionHandler];
}

- (void)handleOpenURLString:(NSString *)url params:(NSDictionary<NSString *, id> *)params{
    
}

- (void)handleShareWithData:(NSDictionary<NSString *, id> *)data callback:(CXWebViewBridgeCallback)callback{
    
}

#pragma mark - CXWebView 代理方法

- (BOOL)webView:(CXWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(WKNavigationType)navigationType{
    return YES;
}

- (void)webViewDidStartLoad:(CXWebView *)webView{
    
}

- (void)webViewDidFinishLoad:(CXWebView *)webView{
    [self hideErrorView];
    
    [webView evaluateJavaScript:@"document.title" completionHandler:^(id data, NSError *error) {
        NSLog(@"document.title = %@", data);
        if(!data){
            return;
        }
        
        self.title = (NSString *)data;
        if([self.title isEqualToString:@"404 Not Found"]){
            [self showErrorViewWithCode:2];
        }
    }];
}

- (void)webView:(CXWebView *)webView didFailLoadWithError:(NSError *)error{
    if(([error.domain isEqualToString:@"WebKitErrorDomain"] && error.code == 102)){
        return;
    }
    
    [self showErrorViewWithError:error];
}

- (void)webView:(CXWebView *)webView didLongPressImage:(UIImage *)image{
    
}

- (void)addErrorView:(UIView<CXPageErrorViewDefinition> *)errorView toView:(UIView *)view{
    errorView.frame = _webView.bounds;
    errorView.backgroundColor = _webView.backgroundColor ?: [UIColor whiteColor];
    [_webView addSubview:errorView];
    [_webView bringProgressBarToFront];
}

- (void)pageErrorViewDidNeedsReload:(UIView<CXPageErrorViewDefinition> *)errorView{
    [self hideErrorView];
    [self reloadRequest:_currentRequest];
}

- (void)pageErrorView:(UIView<CXPageErrorViewDefinition> *)errorView showErrorWithPageTitle:(NSString *)pageTitle{
    if(pageTitle){
        self.navigationBar.navigationItem.titleView.title = pageTitle;
    }
}

- (void)handleNavigationRightActionForButtonItem:(CXBarButtonItem *)barButtonItem{
    CXWebViewBridgeActionNode *actionNode = barButtonItem.actionNode;
    CXDataRecordX(actionNode.tracker.id, actionNode.tracker.params);
    
    if([actionNode.action isEqualToString:CXBridgeBarItemActionHandleScheme]){
        NSString *url = [actionNode.params cx_stringForKey:@"scheme"];
        NSDictionary<NSString *, id> *params = [actionNode.params cx_dictionaryForKey:@"params"];
        [self handleOpenURLString:url params:params];
    }else if([actionNode.action isEqualToString:CXBridgeBarItemActionCallJavaScript]){
        NSString *javaScript = [actionNode.params cx_stringForKey:@"method"];
        [self evaluateJavaScript:javaScript];
    }else if([actionNode.action isEqualToString:CXBridgeBarItemActionSharePanel]){
        [self handleShareWithData:actionNode.params callback:nil];
    }else if ([actionNode.action isEqualToString:CXBridgeBarItemActionRefresh]){
        [self reload];
    }
}

@end

@implementation CXBarButtonItem (CXWebViewBridgeActionSupported)

- (CXWebViewBridgeActionNode *)actionNode{
    return objc_getAssociatedObject(self, _cmd);
}

- (instancetype)initWithActionNode:(CXWebViewBridgeActionNode *)actionNode target:(id)target action:(SEL)action{
    if(self = [self initWithTitle:actionNode.title target:target action:action]){
        [self setImageWithURL:actionNode.iconUrl];
        objc_setAssociatedObject(self, @selector(actionNode), actionNode, OBJC_ASSOCIATION_RETAIN);
    }
    
    return self;
}

@end

@implementation CXWebViewBridgeActionNode

- (instancetype)initWithDictionary:(NSDictionary<NSString *, id> *)dictionary{
    if(CXDictionaryIsEmpty(dictionary)){
        return nil;
    }
    
    if(self = [super init]){
        _title = [dictionary cx_stringForKey:@"title"];
        _iconUrl = [dictionary cx_stringForKey:@"iconUrl"];
        _action = [dictionary cx_stringForKey:@"actionType"];
        _params = [dictionary cx_dictionaryForKey:@"actionParams"];
        
        NSDictionary<NSString *, id> *tracker = [dictionary cx_dictionaryForKey:@"tracker"];
        NSString *trackerId = [tracker cx_stringForKey:@"id"];
        _tracker = [[CXWebViewBridgeActionTracker alloc] initWithTrackerId:trackerId params:[tracker cx_dictionaryForKey:@"params"]];
    }
    
    return self;
}

@end

@implementation CXWebViewBridgeActionTracker

- (instancetype)initWithTrackerId:(NSString *)trackerId params:(NSDictionary<NSString *, id> *)params{
    if(!trackerId){
        return nil;
    }
    
    if(self = [super init]){
        _id = trackerId;
        _params = params;
    }
    
    return self;
}

@end

CXBridgeBarItemAction const CXBridgeBarItemActionHandleScheme = @"handleScheme";
CXBridgeBarItemAction const CXBridgeBarItemActionSharePanel = @"sharePanel";
CXBridgeBarItemAction const CXBridgeBarItemActionCallJavaScript = @"callJavaScriptMethod";
CXBridgeBarItemAction const CXBridgeBarItemActionRefresh = @"refresh";
