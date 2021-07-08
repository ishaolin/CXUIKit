//
//  UIApplication+CXExtensions.h
//  CXUIKit
//
//  Created by wshaolin on 2021/7/6.
//

#import <UIKit/UIKit.h>

@interface UIApplication (CXExtensions)

- (UIWindow *)cx_activeWindow;

- (void)cx_createWindow:(id)delegate
                  scene:(nullable id)scene
     rootViewController:(UIViewController *)rootViewController;

- (UIViewController *)cx_visibleViewController;

@end
