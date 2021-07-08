//
//  UIView+CXExtensions.m
//  Pods
//
//  Created by wshaolin on 2018/12/21.
//

#import "UIView+CXExtensions.h"
#import <objc/runtime.h>

@implementation UIView (CXExtensions)

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

- (void)cx_roundedCornerRadii:(CGFloat)cornerRadii{
    [self cx_roundedByCorners:UIRectCornerAllCorners cornerRadii:cornerRadii];
}

- (void)cx_roundedByCorners:(UIRectCorner)corners cornerRadii:(CGFloat)cornerRadii{
    [self cx_roundedRect:self.bounds byRoundingCorners:corners cornerRadii:cornerRadii];
}

- (void)cx_roundedRect:(CGRect)rect byRoundingCorners:(UIRectCorner)corners cornerRadii:(CGFloat)cornerRadii{
    if([self cx_shouldRoundedRect:rect byRoundingCorners:corners cornerRadii:cornerRadii]){
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:CGSizeMake(cornerRadii, cornerRadii)];
        shapeLayer.path = bezierPath.CGPath;
        self.layer.mask = shapeLayer;
        [self cx_setRoundedRect:rect corners:corners cornerRadii:cornerRadii];
    }
}

- (BOOL)cx_shouldRoundedRect:(CGRect)rect byRoundingCorners:(UIRectCorner)corners cornerRadii:(CGFloat)cornerRadii{
    if(!CGRectEqualToRect(rect, CGRectZero)){
        CGRect oldRect = [self cx_roundedRect];
        UIRectCorner oldCorners = [self cx_roundedCorners];
        CGFloat oldCornerRadii = [self cx_roundedCornerRadii];
        
        return !(CGRectEqualToRect(oldRect, rect) &&
                 oldCorners == corners &&
                 oldCornerRadii == cornerRadii);
    }
    
    return NO;
}

- (void)cx_setRoundedRect:(CGRect)rect corners:(UIRectCorner)corners cornerRadii:(CGFloat)cornerRadii{
    [self cx_setRoundedRect:rect];
    [self cx_setRoundedCorners:corners];
    [self cx_setRoundedCornerRadii:cornerRadii];
}

- (void)cx_setRoundedRect:(CGRect)rect{
    NSValue *value = [NSValue valueWithCGRect:rect];
    objc_setAssociatedObject(self, @selector(cx_roundedRect), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)cx_setRoundedCorners:(UIRectCorner)corners{
    objc_setAssociatedObject(self, @selector(cx_roundedCorners), @(corners), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)cx_setRoundedCornerRadii:(CGFloat)cornerRadii{
    objc_setAssociatedObject(self, @selector(cx_roundedCornerRadii), @(cornerRadii), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGRect)cx_roundedRect{
    return [objc_getAssociatedObject(self, _cmd) CGRectValue];
}

- (UIRectCorner)cx_roundedCorners{
    return (UIRectCorner)[objc_getAssociatedObject(self, _cmd) intValue];
}

- (CGFloat)cx_roundedCornerRadii{
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)cx_addShadow{
    [self cx_addShadowByOption:CXShadowAll];
}

- (void)cx_addShadowByOption:(CXShadowOptions)options{
    [self cx_addShadowByOption:options shadowOffset:CGSizeZero shadowRadius:5.0];
}

- (void)cx_addShadowByOption:(CXShadowOptions)options
                shadowOffset:(CGSize)shadowOffset
                shadowRadius:(CGFloat)shadowRadius{
    if(![self cx_shouldShadowByOption:options shadowOffset:shadowOffset shadowRadius:shadowRadius]){
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
    [self cx_setOptions:options shadowOffset:shadowOffset shadowRadius:shadowRadius];
}

- (BOOL)cx_shouldShadowByOption:(CXShadowOptions)options shadowOffset:(CGSize)shadowOffset shadowRadius:(CGFloat)shadowRadius{
    if(shadowRadius > 0){
        CXShadowOptions oldOptions = [self cx_shadowoptions];
        CGSize oldShadowOffset = [self cx_shadowOffset];
        CGFloat oldShadowRadius = [self cx_shadowRadius];
        return !(oldOptions == options &&
                 CGSizeEqualToSize(oldShadowOffset, shadowOffset) &&
                 oldShadowRadius == shadowRadius);
    }
    
    return NO;
}

- (void)cx_setOptions:(CXShadowOptions)options shadowOffset:(CGSize)shadowOffset shadowRadius:(CGFloat)shadowRadius{
    [self cx_setShadowOptions:options];
    [self cx_setShadowOffset:shadowOffset];
    [self cx_setShadowRadius:shadowRadius];
}

- (void)cx_setShadowOptions:(CXShadowOptions)options{
    objc_setAssociatedObject(self, @selector(cx_shadowoptions), @(options), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)cx_setShadowOffset:(CGSize)shadowOffset{
    NSValue *value = [NSValue valueWithCGSize:shadowOffset];
    objc_setAssociatedObject(self, @selector(cx_shadowOffset), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)cx_setShadowRadius:(CGFloat)shadowRadius{
    objc_setAssociatedObject(self, @selector(cx_shadowRadius), @(shadowRadius), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CXShadowOptions)cx_shadowoptions{
    return (CXShadowOptions)[objc_getAssociatedObject(self, _cmd) intValue];
}

- (CGSize)cx_shadowOffset{
    return [objc_getAssociatedObject(self, _cmd) CGSizeValue];
}

- (CGFloat)cx_shadowRadius{
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

@end
