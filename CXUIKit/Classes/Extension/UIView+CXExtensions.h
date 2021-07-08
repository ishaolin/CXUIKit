//
//  UIView+CXExtensions.h
//  Pods
//
//  Created by wshaolin on 2018/12/21.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, CXShadowOptions) {
    CXShadowTop     = 1 << 0,
    CXShadowLeft    = 1 << 1,
    CXShadowBottom  = 1 << 2,
    CXShadowRight   = 1 << 3,
    CXShadowAll     = CXShadowTop | CXShadowLeft | CXShadowBottom | CXShadowRight
};

@interface UIView (CXExtensions)

- (UIImage *)cx_image;
- (UIViewController *)cx_viewController;

- (void)cx_roundedCornerRadii:(CGFloat)cornerRadii;
- (void)cx_roundedByCorners:(UIRectCorner)corners cornerRadii:(CGFloat)cornerRadii;
- (void)cx_roundedRect:(CGRect)rect byRoundingCorners:(UIRectCorner)corners cornerRadii:(CGFloat)cornerRadii;

- (void)cx_addShadow;
- (void)cx_addShadowByOption:(CXShadowOptions)options;
- (void)cx_addShadowByOption:(CXShadowOptions)options shadowOffset:(CGSize)shadowOffset shadowRadius:(CGFloat)shadowRadius;

@end
