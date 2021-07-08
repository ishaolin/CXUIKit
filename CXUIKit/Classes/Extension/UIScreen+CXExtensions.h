//
//  UIScreen+CXExtensions.h
//  Pods
//
//  Created by wshaolin on 2018/6/19.
//

#import <UIKit/UIKit.h>

#define UI_SCREEN_SIZE_EQUALS(W, H) (CGSizeEqualToSize(CGSizeMake(W, H), [UIScreen mainScreen].bounds.size))
#define CX_SCREEN_SIZE_EQUALS(W, H) (UI_SCREEN_SIZE_EQUALS(W, H) || UI_SCREEN_SIZE_EQUALS(H, W))

#define CX_SCREEN_INCH_IS_6_7   CX_SCREEN_SIZE_EQUALS(428.0, 926.0) // // iPhone：12ProMax

// 6.1寸的屏幕尺寸大小和6.5寸的是一样的，但scale不一样
// 6.1寸：iPhone XR/iPhone 11
// 6.5寸：iPhone XS Max/iPhone 11 Pro Max
#define CX_SCREEN_INCH_IS_6_5   CX_SCREEN_SIZE_EQUALS(414.0, 896.0) // iPhone：XR/XSMax/11/11ProMax

#define CX_SCREEN_INCH_IS_6_1   CX_SCREEN_SIZE_EQUALS(390.0, 844.0) // iPhone：12/12Pro

#define CX_SCREEN_INCH_IS_5_8   CX_SCREEN_SIZE_EQUALS(375.0, 812.0) // iPhone：X/XS/11Pro
#define CX_SCREEN_INCH_IS_5_5   CX_SCREEN_SIZE_EQUALS(414.0, 736.0) // iPhone：6P/6SP/7P/8P
#define CX_SCREEN_INCH_IS_5_4   CX_SCREEN_SIZE_EQUALS(360.0, 780.0) // iPhone：12 min

#define CX_SCREEN_INCH_IS_4_7   CX_SCREEN_SIZE_EQUALS(375.0, 667.0) // iPhone：6/6S/7/8
#define CX_SCREEN_INCH_IS_4_0   CX_SCREEN_SIZE_EQUALS(320.0, 568.0) // iPhone：5/5S/5C/SE
#define CX_SCREEN_INCH_IS_3_5   CX_SCREEN_SIZE_EQUALS(320.0, 480.0) // iPhone：4/4S

@interface UIScreen (CXExtensions)

@property (nonatomic, assign, readonly) UIEdgeInsets cx_safeAreaInsets;
@property (nonatomic, assign, readonly) UIEdgeInsets cx_scrollViewSafeAreaInset;
@property (nonatomic, assign, readonly) BOOL cx_isBangs;

@end
