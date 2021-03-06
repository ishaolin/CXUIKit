//
//  CXShadowView.h
//  Pods
//
//  Created by lcc on 2018/8/24.
//

#import "UIView+CXUIKit.h"

@interface CXShadowView : UIView

- (instancetype)initWithShadowOptions:(CXShadowOptions)shadowOptions;

- (instancetype)initWithShadowOptions:(CXShadowOptions)shadowOptions
                          cornerRadii:(CGFloat)cornerRadii;

- (instancetype)initWithShadowOptions:(CXShadowOptions)shadowOptions
                     roundedByCorners:(UIRectCorner)corners
                          cornerRadii:(CGFloat)cornerRadii;

@end
