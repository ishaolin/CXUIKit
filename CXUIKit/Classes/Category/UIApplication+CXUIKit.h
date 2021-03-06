//
//  UIApplication+CXUIKit.h
//  Pods
//
//  Created by wshaolin on 2021/7/6.
//

#import <UIKit/UIKit.h>

@interface UIApplication (CXUIKit)

- (UIWindow *)cx_activeWindow;

- (UIWindow *)cx_createWindow:(id)delegate
                        scene:(id)scene
           rootViewController:(UIViewController *)rootViewController;

- (UIViewController *)cx_visibleViewController;

@end
