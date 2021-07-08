//
//  CXShadowView.m
//  CXUIKit
//
//  Created by lcc on 2018/8/24.
//

#import "CXShadowView.h"

@interface CXShadowView(){
    CXShadowOptions _shadowOptions;
    UIRectCorner _corners;
    CGFloat _cornerRadii;
    UIView *_backShadowView;
}

@end

@implementation CXShadowView

- (instancetype)initWithShadowOptions:(CXShadowOptions)shadowOptions{
    return [self initWithShadowOptions:shadowOptions cornerRadii:0];
}

- (instancetype)initWithShadowOptions:(CXShadowOptions)shadowOptions
                          cornerRadii:(CGFloat)cornerRadii{
    return [self initWithShadowOptions:shadowOptions
                      roundedByCorners:UIRectCornerAllCorners
                           cornerRadii:cornerRadii];
}

- (instancetype)initWithShadowOptions:(CXShadowOptions)shadowOptions
                     roundedByCorners:(UIRectCorner)corners
                          cornerRadii:(CGFloat)cornerRadii{
    if (self = [super initWithFrame:CGRectZero]) {
        _shadowOptions = shadowOptions;
        _corners = corners;
        _cornerRadii = cornerRadii;
        _backShadowView = [[UIView alloc] init];
        
        [self addSubview:_backShadowView];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _shadowOptions = CXShadowAll;
        _corners = 0;
        _cornerRadii = UIRectCornerAllCorners;
        _backShadowView = [[UIView alloc] init];
        
        [self addSubview:_backShadowView];
    }
    
    return self;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor{
    [super setBackgroundColor:[UIColor clearColor]];
    
    _backShadowView.backgroundColor = backgroundColor;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    _backShadowView.frame = self.bounds;
    [_backShadowView cx_roundedByCorners:_corners
                             cornerRadii:_cornerRadii];
    [self cx_addShadowByOption:_shadowOptions];
}

@end
