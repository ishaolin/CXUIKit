//
//  UIViewController+CXExtensions.h
//  Pods
//
//  Created by wshaolin on 2019/1/31.
//

#import <UIKit/UIKit.h>
#import "CXSchemeDefines.h"

@interface UIViewController (CXExtensions)

- (void)cx_destroyAfterPushViewController:(UIViewController *)viewController animated:(BOOL)animated;

@end

@interface UINavigationController (CXExtensions)

- (void)cx_pushViewController:(UIViewController *)viewController
                     pushType:(CXSchemePushType)pushType
                     animated:(BOOL)animated;

- (void)cx_setViewControllers:(NSArray<UIViewController *> *)viewControllers
                     animated:(BOOL)animated;

@end
