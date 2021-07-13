//
//  UIView+CXUIKit.m
//  Pods
//
//  Created by wshaolin on 2018/12/21.
//

#import "UIView+CXUIKit.h"
#import <objc/runtime.h>

@interface UIView (CXUIKit)

@property (nonatomic, assign) CGRect cx_roundedRect;
@property (nonatomic, assign) UIRectCorner cx_roundedCorners;
@property (nonatomic, assign) CGFloat cx_roundedCornerRadii;

@property (nonatomic, assign) CXShadowOptions cx_shadowOptions;
@property (nonatomic, assign) CGSize cx_shadowOffset;
@property (nonatomic, assign) CGFloat cx_shadowRadius;

@end

@implementation UIView (CXUIKit)

- (UIImage *)cx_image{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIViewController *)cx_viewController{
    UIViewController *viewController = nil;
    UIResponder *responder = self.nextResponder;
    while (responder) {
        if([responder isKindOfClass:[UIViewController class]]){
            viewController = (UIViewController *)responder;
            break;
        }
        
        responder = [responder nextResponder];
    }
    
    return viewController;
}

#pragma mark - rounded corner

- (void)cx_roundedCornerRadii:(CGFloat)cornerRadii{
    [self cx_roundedByCorners:UIRectCornerAllCorners
                  cornerRadii:cornerRadii];
}

- (void)cx_roundedByCorners:(UIRectCorner)corners
                cornerRadii:(CGFloat)cornerRadii{
    [self cx_roundedRect:self.bounds
       byRoundingCorners:corners
             cornerRadii:cornerRadii];
}

- (void)cx_roundedRect:(CGRect)rect
     byRoundingCorners:(UIRectCorner)corners
           cornerRadii:(CGFloat)cornerRadii{
    if([self cx_shouldRoundedRect:rect
                byRoundingCorners:corners
                      cornerRadii:cornerRadii]){
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect
                                                         byRoundingCorners:corners
                                                               cornerRadii:CGSizeMake(cornerRadii, cornerRadii)];
        shapeLayer.path = bezierPath.CGPath;
        self.layer.mask = shapeLayer;
        self.cx_roundedRect = rect;
        self.cx_roundedCorners = corners;
        self.cx_roundedCornerRadii = cornerRadii;
    }
}

- (BOOL)cx_shouldRoundedRect:(CGRect)rect
           byRoundingCorners:(UIRectCorner)corners
                 cornerRadii:(CGFloat)cornerRadii{
    if(CGRectEqualToRect(rect, CGRectZero)){
        return NO;
    }
    
    if(CGRectEqualToRect(rect, self.cx_roundedRect) &&
       corners == self.cx_roundedCorners &&
       cornerRadii == self.cx_roundedCornerRadii){
        return NO;
    }
    
    return YES;
}

#pragma mark - shadow

- (void)cx_addShadow{
    [self cx_addShadowByOption:CXShadowAll];
}

- (void)cx_addShadowByOption:(CXShadowOptions)options{
    [self cx_addShadowByOption:options
                  shadowOffset:CGSizeZero
                  shadowRadius:5.0];
}

- (void)cx_addShadowByOption:(CXShadowOptions)options
                shadowOffset:(CGSize)shadowOffset
                shadowRadius:(CGFloat)shadowRadius{
    if(![self cx_shouldShadowByOption:options
                         shadowOffset:shadowOffset
                         shadowRadius:shadowRadius]){
        return;
    }
    
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.1;
    self.layer.shadowOffset = shadowOffset;
    self.layer.shadowRadius = shadowRadius;
    
    if(options == 0 || options == CXShadowAll){
        self.layer.shadowPath = NULL;
        return;
    }
    
    CGPoint topLeft = CGPointZero;
    CGPoint topRight = CGPointMake(CGRectGetWidth(self.frame), 0);
    CGPoint bottomLeft = CGPointMake(0, CGRectGetHeight(self.frame));
    CGPoint bottomRight = CGPointMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    CGPoint center = CGPointMake(CGRectGetWidth(self.frame) * 0.5, CGRectGetHeight(self.frame) * 0.5);
    
    UIBezierPath *shadowPath = [[UIBezierPath alloc] init];
    if(options & CXShadowTop){
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:topLeft];
        [path addLineToPoint:center];
        [path addLineToPoint:topRight];
        [shadowPath appendPath:path];
    }
    
    if(options & CXShadowLeft){
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:topLeft];
        [path addLineToPoint:center];
        [path addLineToPoint:bottomLeft];
        [shadowPath appendPath:path];
    }
    
    if(options & CXShadowBottom){
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:bottomLeft];
        [path addLineToPoint:center];
        [path addLineToPoint:bottomRight];
        [shadowPath appendPath:path];
    }
    
    if(options & CXShadowRight){
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:topRight];
        [path addLineToPoint:center];
        [path addLineToPoint:bottomRight];
        [shadowPath appendPath:path];
    }
    
    self.layer.shadowPath = shadowPath.CGPath;
    self.cx_shadowOptions = options;
    self.cx_shadowOffset = shadowOffset;
    self.cx_shadowRadius = shadowRadius;
}

- (BOOL)cx_shouldShadowByOption:(CXShadowOptions)options
                   shadowOffset:(CGSize)shadowOffset
                   shadowRadius:(CGFloat)shadowRadius{
    if(shadowRadius <= 0){
        return NO;
    }
    
    if(options == self.cx_shadowOptions &&
       CGSizeEqualToSize(shadowOffset, self.cx_shadowOffset) &&
       shadowRadius == self.cx_shadowRadius){
        return NO;
    }
    
    return YES;
}

#pragma mark - property setter

- (void)setCx_roundedRect:(CGRect)roundedRect{
    NSValue *value = [NSValue valueWithCGRect:roundedRect];
    [self objc_setAssociatedObject:value forKey:@selector(cx_roundedRect)];
}

- (void)setCx_roundedCorners:(UIRectCorner)roundedCorners{
    [self objc_setAssociatedObject:@(roundedCorners) forKey:@selector(cx_roundedCorners)];
}

- (void)setCx_roundedCornerRadii:(CGFloat)roundedCornerRadii{
    [self objc_setAssociatedObject:@(roundedCornerRadii) forKey:@selector(cx_roundedCornerRadii)];
}

- (void)setCx_shadowOptions:(CXShadowOptions)shadowOptions{
    [self objc_setAssociatedObject:@(shadowOptions) forKey:@selector(cx_shadowoptions)];
}

- (void)setCx_shadowOffset:(CGSize)shadowOffset{
    NSValue *value = [NSValue valueWithCGSize:shadowOffset];
    [self objc_setAssociatedObject:value forKey:@selector(cx_shadowOffset)];
}

- (void)setCx_shadowRadius:(CGFloat)shadowRadius{
    [self objc_setAssociatedObject:@(shadowRadius) forKey:@selector(cx_shadowRadius)];
}

#pragma mark - property getter

- (CGRect)cx_roundedRect{
    return [objc_getAssociatedObject(self, _cmd) CGRectValue];
}

- (UIRectCorner)cx_roundedCorners{
    return (UIRectCorner)[objc_getAssociatedObject(self, _cmd) unsignedIntegerValue];
}

- (CGFloat)cx_roundedCornerRadii{
    return (UIRectCorner)[objc_getAssociatedObject(self, _cmd) doubleValue];
}

- (CXShadowOptions)cx_shadowOptions{
    return (CXShadowOptions)[objc_getAssociatedObject(self, _cmd) unsignedIntegerValue];
}

- (CGSize)cx_shadowOffset{
    return [objc_getAssociatedObject(self, _cmd) CGSizeValue];
}

- (CGFloat)cx_shadowRadius{
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
}

#pragma mark - setAssociatedObject

- (void)objc_setAssociatedObject:(id)value forKey:(const void *)key{
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
