//
//  UIApplication+CXUIKit.m
//  Pods
//
//  Created by wshaolin on 2021/7/6.
//

#import "UIApplication+CXUIKit.h"

@implementation UIApplication (CXUIKit)

- (UIWindow *)cx_activeWindow {
    __block UIWindow *window = nil;
    if (@available(iOS 13.0, *)) {
        [self.connectedScenes enumerateObjectsUsingBlock:^(UIScene * _Nonnull scene, BOOL * _Nonnull stop) {
            if (scene.activationState == UISceneActivationStateForegroundActive) {
                UIWindowScene *windowScene = (UIWindowScene *)scene;
                window = ((id<UIWindowSceneDelegate>)windowScene.delegate).window;
                *stop = YES;
            }
        }];
    } else {
        window = self.delegate.window;
    }
    
    return window;
}

- (void)cx_createWindow:(id)delegate scene:(id)scene rootViewController:(UIViewController *)rootViewController{
    UIWindow *window = nil;
    if (@available(iOS 13.0, *)) {
        UIWindowScene *windowScene = (UIWindowScene *)scene;
        window = [[UIWindow alloc] initWithWindowScene:windowScene];
        window.frame = windowScene.coordinateSpace.bounds;
        ((id<UIWindowSceneDelegate>)delegate).window = window;
    } else {
        window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        ((id<UIApplicationDelegate>)delegate).window = window;
    }
    
    window.backgroundColor = [UIColor whiteColor];
    window.rootViewController = rootViewController;
    [window makeKeyAndVisible];
}

- (UIViewController *)cx_visibleViewController{
    UIViewController *viewController = [self cx_activeWindow].rootViewController;
    if([viewController isKindOfClass:[UITabBarController class]]){
        UITabBarController *tabBarController = (UITabBarController *)viewController;
        viewController = tabBarController.selectedViewController;
    }
    
    if([viewController isKindOfClass:[UINavigationController class]]){
        UINavigationController *navigationController = (UINavigationController *)viewController;
        viewController = navigationController.visibleViewController;
    }
    
    while (viewController.presentedViewController) {
        viewController = viewController.presentedViewController;
    }
    
    return viewController;
}

@end
