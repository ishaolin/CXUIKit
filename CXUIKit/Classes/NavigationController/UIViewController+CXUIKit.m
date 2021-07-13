//
//  UIViewController+CXUIKit.m
//  Pods
//
//  Created by wshaolin on 2019/1/31.
//

#import "UIViewController+CXUIKit.h"
#import <CXFoundation/CXFoundation.h>

@implementation UIViewController (CXUIKit)

+ (void)load{
    if(@available(iOS 13.0, *)){
        // 此方式太过暴力，不保证不出现未知问题
        // CXSwizzleInstanceMethod(self, @selector(modalPresentationStyle), @selector(cx_modalPresentationStyle));
        CXSwizzleInstanceMethod(self, @selector(presentViewController:animated:completion:), @selector(cx_hookPresentViewController:animated:completion:));
    }
}

- (void)cx_destroyAfterPushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if(!viewController){
        return;
    }
    
    NSMutableArray<UIViewController *> *viewControllers = [NSMutableArray array];
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(obj != self){
            [viewControllers addObject:obj];
        }
    }];
    
    [viewControllers addObject:viewController];
    [self.navigationController cx_setViewControllers:[viewControllers copy] animated:animated];
}

- (void)cx_hookPresentViewController:(UIViewController *)viewController
                            animated:(BOOL)animated
                          completion:(void(^)(void))completion{
    viewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self cx_hookPresentViewController:viewController
                              animated:animated
                            completion:completion];
}

- (UIModalPresentationStyle)cx_modalPresentationStyle{
    /* 尝试过 https://stackoverflow.com/questions/59031218/ios-13-modalpresentationstyle-uimodalpresentationfullscreen-not-working-for-mf 提供的解决方案，也不能解决问题。
     */
    return UIModalPresentationFullScreen;
}

@end

@implementation UINavigationController (CXUIKit)

- (void)cx_pushViewController:(UIViewController *)viewController
                     pushType:(CXSchemePushType)pushType
                     animated:(BOOL)animated{
    if(!viewController){
        return;
    }
    
    switch (pushType) {
        case CXSchemePushAfterDestroyCurrentVC:{
            if(self.viewControllers.count <= 1){
                [self pushViewController:viewController animated:animated];
            }else{
                [self.topViewController cx_destroyAfterPushViewController:viewController animated:animated];
            }
        }
            break;
        case CXSchemePushFromRootVC:{
            if(self.viewControllers.count <= 1){
                [self pushViewController:viewController animated:animated];
            }else{
                [self cx_setViewControllers:@[self.viewControllers.firstObject, viewController]
                                   animated:animated];
            }
        }
            break;
        case CXSchemePushFromCurrentVC:
        default:
            [self pushViewController:viewController animated:animated];
            break;
    }
}

- (void)cx_setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated{
    if(CXArrayIsEmpty(viewControllers)){
        return;
    }
    
    if(animated){
        [self pushViewController:viewControllers.lastObject animated:animated];
        
        if(viewControllers.count > 1){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self setViewControllers:viewControllers animated:NO];
            });
        }
    }else{
        [self setViewControllers:viewControllers animated:animated];
    }
}

@end
