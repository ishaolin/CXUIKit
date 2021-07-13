//
//  UIScreen+CXUIKit.m
//  Pods
//
//  Created by wshaolin on 2018/6/19.
//

#import "UIScreen+CXUIKit.h"
#import <objc/runtime.h>

@implementation UIScreen (CXUIKit)

- (UIEdgeInsets)cx_safeAreaInsets{
    NSValue *safeAreaInsets = objc_getAssociatedObject(self, _cmd);
    if(safeAreaInsets){
        return safeAreaInsets.UIEdgeInsetsValue;
    }
    
    UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
    if(self.cx_isBangs){
        edgeInsets = UIEdgeInsetsMake(24.0, 0, 34.0, 0);
    }
    
    objc_setAssociatedObject(self, _cmd, [NSValue valueWithUIEdgeInsets:edgeInsets], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return edgeInsets;
}

- (UIEdgeInsets)cx_scrollViewSafeAreaInset{
    UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
    edgeInsets.bottom = [self cx_safeAreaInsets].bottom;
    return edgeInsets;
}

- (BOOL)cx_isBangs {
    return (CX_SCREEN_INCH_IS_5_8 ||
            CX_SCREEN_INCH_IS_6_1 ||
            CX_SCREEN_INCH_IS_6_5 ||
            CX_SCREEN_INCH_IS_6_7);
}

@end
