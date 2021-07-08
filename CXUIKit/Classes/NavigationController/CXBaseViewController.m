//
//  CXBaseViewController.m
//  Pods
//
//  Created by wshaolin on 2017/5/17.
//
//

#import "CXBaseViewController.h"
#import "CXNavigationConfig.h"
#import "CXDataRecord.h"

@interface CXBaseViewController() <CXNavigationBarDelegate> {
    
}

@end

@implementation CXBaseViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
        _navigationBar = [CXNavigationBar navigationBar];
        _navigationBar.translucent = NO;
        _navigationBar.delegate = self;
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _isAnimating = animated;
    
    [self.view bringSubviewToFront:_navigationBar];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    _isAnimating = NO;
    self.displaying = YES;
    
    [self recordDataWithViewAppear:_displaying];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    _isAnimating = animated;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    self.displaying = NO;
}

- (NSString *)viewAppearOrDisappearRecordDataKey{
    return nil;
}

- (NSDictionary<NSString *, id> *)viewAppearOrDisappearRecordDataParams{
    return nil;
}

- (void)recordDataWithViewAppear:(BOOL)viewAppear{
    CXDataRecordX([self viewAppearOrDisappearRecordDataKey], [self viewAppearOrDisappearRecordDataParams]);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIStatusBarStyle statusBarStyle = [self preferredStatusBarStyle];
    if(statusBarStyle != CXNavigationBarDefaultStyle()){
        [_navigationBar setUpdateStyle:statusBarStyle];
    }
    [self.view addSubview:_navigationBar];
    
    [self handleBackBarButtonImageUpdate];
    [self registerApplicationNotificationObserver];
}

- (void)registerApplicationNotificationObserver{
    [NSNotificationCenter addObserver:self
                               action:@selector(didBecomeActiveNotification:)
                                 name:UIApplicationDidBecomeActiveNotification];
    [NSNotificationCenter addObserver:self
                               action:@selector(didEnterBackgroundNotification:)
                                 name:UIApplicationDidEnterBackgroundNotification];
    [NSNotificationCenter addObserver:self
                               action:@selector(willEnterForegroundNotification:)
                                 name:UIApplicationWillEnterForegroundNotification];
    [NSNotificationCenter addObserver:self
                               action:@selector(willResignActiveNotification:)
                                 name:UIApplicationWillResignActiveNotification];
}

- (void)willEnterForegroundNotification:(NSNotification *)notification{
    
}

- (void)willResignActiveNotification:(NSNotification *)notification{
    
}

- (void)didEnterBackgroundNotification:(NSNotification *)notification{
    
}

- (void)didBecomeActiveNotification:(NSNotification *)notification{
    
}

- (void)setTitle:(NSString *)title{
    _navigationBar.navigationItem.titleView.title = title;
    
    [super setTitle:title];
}

- (void)setSubtitle:(NSString *)subtitle{
    _navigationBar.navigationItem.titleView.subtitle = subtitle;
}

- (NSString *)subtitle{
    return _navigationBar.navigationItem.titleView.subtitle;
}

- (void)navigationBar:(CXNavigationBar *)navigationBar didClickBackBarButtonItem:(CXBarButtonItem *)backBarButtonItem{
    [self didClickBackBarButtonItem:backBarButtonItem];
}

- (void)navigationBar:(CXNavigationBar *)navigationBar didChangeTranslucent:(BOOL)translucent{
    
}

- (void)didClickBackBarButtonItem:(CXBarButtonItem *)backBarButtonItem{
    if(self.navigationController){
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (BOOL)disableGesturePopInteraction{
    if([self conformsToProtocol:@protocol(CXAnimatedTransitioningSupportor)]){
        CXAnimatedTransitioningStyle transitioningStyle = [(id<CXAnimatedTransitioningSupportor>)self animatedTransitioningStyle];
        return transitioningStyle == CXAnimatedTransitioningStyleCoverVertical;
    }
    
    return NO;
}

- (void)dismissAnimated:(BOOL)animated completion:(void (^)(void))completion{
    if(self.navigationController){
        [self.navigationController dismissViewControllerAnimated:animated completion:completion];
    }else{
        [self dismissViewControllerAnimated:animated completion:completion];
    }
}

- (UIImage *)backBarButtonImage{
    return nil;
}

- (void)handleBackBarButtonImageUpdate{
    UIImage *image = [self backBarButtonImage];
    if(!image){
        return;
    }
    
    CXBarButtonItem *backBarButtonItem = self.navigationBar.navigationItem.backBarButtonItem;
    UIButton *backBarButton = (UIButton *)backBarButtonItem.view;
    [backBarButton setImage:image forState:UIControlStateNormal];
    [backBarButton setImage:nil forState:UIControlStateHighlighted];
    [backBarButton setImage:nil forState:UIControlStateDisabled];
    CXNavigationConfig *config = CXNavigationConfigForStyle([self preferredStatusBarStyle]);
    [backBarButtonItem setBarButtonItemStyleWithConfig:config];
}

- (BOOL)prefersStatusBarHidden{
    return self.isStatusBarHidden;
}

- (void)setStatusBarHidden:(BOOL)statusBarHidden{
    if(_statusBarHidden == statusBarHidden){
        return;
    }
    
    _statusBarHidden = statusBarHidden;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (BOOL)shouldAutorotate{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)dealloc{
    [NSNotificationCenter removeObserver:self];
    
#ifdef DEBUG
    LOG_INFO(@"%@ dealloc", NSStringFromClass([self class]));
#endif
}

@end
