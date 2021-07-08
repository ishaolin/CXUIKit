//
//  UIImage+CXExtensions.m
//  Pods
//
//  Created by wshaolin on 2017/6/14.
//
//

#import "UIImage+CXExtensions.h"
#import <CXFoundation/CXFoundation.h>

@implementation UIImage (CXExtensions)

+ (UIImage *)cx_imageNamed:(NSString *)imageName{
    return [self cx_imageNamed:imageName
                      inBundle:nil];
}

+ (UIImage *)cx_imageNamed:(NSString *)imageName
                  inBundle:(NSString *)bundleName{
    return [self cx_imageNamed:imageName
                      inBundle:bundleName
                  forframework:nil];
}

+ (UIImage *)cx_imageNamed:(NSString *)imageName
                  inBundle:(NSString *)bundleName
              forframework:(NSString *)frameworkName{
    if(CXStringIsEmpty(imageName)){
        return nil;
    }
    
    if(CXStringIsEmpty(bundleName)){
        return [UIImage imageNamed:imageName];
    }
    
    NSString *_bundleName = nil;
    if([bundleName hasSuffix:CX_BUNDLE_NAME_SUFFIX]){
        _bundleName = bundleName;
    }else{
        _bundleName = [NSString stringWithFormat:@"%@%@", bundleName, CX_BUNDLE_NAME_SUFFIX];
    }
    
    UIImage *image = [UIImage imageNamed:[_bundleName stringByAppendingPathComponent:imageName]];
    if(image){
        return image;
    }
    
    if(CXStringIsEmpty(frameworkName)){
        return nil;
    }
    
    NSString *_frameworkName = nil;
    if([frameworkName hasSuffix:CX_FRAMEWORK_NAME_SUFFIX]){
        _frameworkName = frameworkName;
    }else{
        _frameworkName = [NSString stringWithFormat:@"%@%@", frameworkName, CX_FRAMEWORK_NAME_SUFFIX];
    }
    
    _bundleName = [NSString stringWithFormat:@"Frameworks/%@/%@", _frameworkName, _bundleName];
    return [UIImage imageNamed:[_bundleName stringByAppendingPathComponent:imageName]];
}

+ (UIImage *)cx_noCacheImage:(NSString *)imageName{
    return [self cx_noCacheImage:imageName extension:@"png"];
}

+ (UIImage *)cx_noCacheImage:(NSString *)imageName extension:(NSString *)extension{
    return [self cx_noCacheImage:imageName extension:extension inBundle:[NSBundle mainBundle]];
}

+ (UIImage *)cx_noCacheImage:(NSString *)imageName extension:(NSString *)extension inBundle:(NSBundle *)bundle{
    if(CXStringIsEmpty(imageName)){
        return nil;
    }
    
    NSString *imagePath = [bundle pathForResource:imageName ofType:extension];
    if(CXStringIsEmpty(imagePath)){
        return nil;
    }
    
    return [UIImage imageWithContentsOfFile:imagePath];
}

+ (UIImage *)cx_imageWithColor:(UIColor *)color{
    return [self cx_imageWithColor:color size:CGSizeMake(1.0, 1.0)];
}

+ (UIImage *)cx_imageWithColor:(UIColor *)color size:(CGSize)size{
    if(!color || size.width <= 0 || size.height <= 0){
        return nil;
    }
    
    CGRect rect = (CGRect){CGPointZero, size};
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)cx_imageWithColors:(NSArray<UIColor *> *)colors
               gradientEndPoint:(CGPoint)endPoint{
    return [self cx_imageWithColors:colors
                   gradientEndPoint:endPoint
                               size:CGSizeMake(1.0, 1.0)];
}

+ (UIImage *)cx_imageWithColors:(NSArray<UIColor *> *)colors
             gradientStartPoint:(CGPoint)startPoint
               gradientEndPoint:(CGPoint)endPoint{
    return [self cx_imageWithColors:colors
                 gradientStartPoint:startPoint
                   gradientEndPoint:endPoint
                               size:CGSizeMake(1.0, 1.0)];
}

+ (UIImage *)cx_imageWithColors:(NSArray<UIColor *> *)colors
               gradientEndPoint:(CGPoint)endPoint
                           size:(CGSize)size{
    return [self cx_imageWithColors:colors
                 gradientStartPoint:CGPointMake(0, 0.5)
                   gradientEndPoint:endPoint size:size];
}

+ (UIImage *)cx_imageWithColors:(NSArray<UIColor *> *)colors
             gradientStartPoint:(CGPoint)startPoint
               gradientEndPoint:(CGPoint)endPoint
                           size:(CGSize)size{
    if(size.width <= 0 || size.height <= 0){
        return nil;
    }
    
    if(CXArrayIsEmpty(colors)){
        return nil;
    }
    
    NSMutableArray *CGColors = [NSMutableArray array];
    [colors enumerateObjectsUsingBlock:^(UIColor * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [CGColors addObject:(id)obj.CGColor];
    }];
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpaceRef, (CFArrayRef)CGColors, NULL);
    CGColorSpaceRelease(colorSpaceRef);
    
    CGRect rect = (CGRect){CGPointZero, size};
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);
    CGContextSaveGState(context);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)cx_imageWithColors:(NSArray<UIColor *> *)colors
              gradientDirection:(CXColorGradientDirection)gradientDirection{
    return [self cx_imageWithColors:colors
                  gradientDirection:gradientDirection
                               size:CGSizeMake(1.0, 1.0)];
}

+ (UIImage *)cx_imageWithColors:(NSArray<UIColor *> *)colors
              gradientDirection:(CXColorGradientDirection)gradientDirection
                           size:(CGSize)size{
    CGPoint start = CGPointZero;
    CGPoint end = CGPointZero;
    switch (gradientDirection) {
        case CXColorGradientHorizontal:
            start.y = 0.5;
            end.x = 1.0;
            break;
        case CXColorGradientVertical:
            start.x = 0.5;
            end.y = 1.0;
            break;
        case CXColorGradientUpDiagonal:
            start.y = 1.0;
            end.x = 1.0;
            break;
        case CXColorGradientDownDiagonal:
            end.x = 1.0;
            end.y = 1.0;
            break;
        default:
            return nil;
    }
    
    return [self cx_imageWithColors:colors
                 gradientStartPoint:start
                   gradientEndPoint:end
                               size:size];
}

- (UIImage *)cx_imageForTintColor:(UIColor *)tintColor{
    return [self cx_imageForTintColor:tintColor blendMode:kCGBlendModeDestinationIn];
}

- (UIImage *)cx_imageForTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode{
    if(!tintColor){
        return self;
    }
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    [tintColor setFill];
    CGRect bounds = (CGRect){CGPointZero, self.size};
    UIRectFill(bounds);
    
    [self drawInRect:bounds blendMode:blendMode alpha:1.0];
    
    if (blendMode != kCGBlendModeDestinationIn) {
        [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0];
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)cx_resizableImage{
    CGFloat top = self.size.height * 0.5 - 1.0;
    CGFloat left = self.size.width * 0.5 - 1.0;
    CGFloat bottom = self.size.height * 0.5 + 1.0;
    CGFloat right = self.size.width * 0.5 + 1.0;
    
    return [self resizableImageWithCapInsets:UIEdgeInsetsMake(top, left, bottom, right)];
}

- (UIImage *)cx_resizeImage:(CGSize)size{
    if(size.width <= 0 || size.height <= 0){
        return self;
    }
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [self drawInRect:(CGRect){CGPointZero, size}];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)cx_roundImage{
    return [self cx_roundImageWithRadius:CGFLOAT_MAX];
}

- (UIImage *)cx_roundImageWithRadius:(CGFloat)radius{
    if(radius <= 0){
        return self;
    }
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = (CGRect){CGPointZero, self.size};
    if(radius >= MAX(self.size.width, self.size.height)){
        CGContextAddEllipseInRect(context, rect);
        CGContextClip(context);
    }else{
        [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius] addClip];
    }
    
    [self drawInRect:rect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)cx_composeImage:(UIImage *)image rect:(CGRect)rect{
    if(!image){
        return self;
    }
    
    UIGraphicsBeginImageContextWithOptions(self.size , NO, 0.0);
    [self drawInRect:(CGRect){CGPointZero, self.size}];
    [image drawInRect:rect];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)cx_writeToSavedPhotosAlbum:(CXPhotosAlbumAccessAuthorizationBlock)authorization
                        completion:(CXWriteToSavedPhotosAlbumCompletionBlock)completion{
    CXPhotosAlbumAuthorizeResultBlock authorizeResultBlock = ^(BOOL isAuthorised){
        if(!isAuthorised){
            return;
        }
        
        SEL selector = @selector(cx_writeToSavedPhotosAlbum:didFinishSavingWithError:contextInfo:);
        UIImageWriteToSavedPhotosAlbum(self, self, selector, (__bridge void *)(completion));
    };
    
    if(authorization){
        authorization([PHPhotoLibrary authorizationStatus], authorizeResultBlock);
    }else{
        authorizeResultBlock(YES);
    }
}

- (void)cx_writeToSavedPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    CXWriteToSavedPhotosAlbumCompletionBlock completion = (__bridge CXWriteToSavedPhotosAlbumCompletionBlock)(contextInfo);
    if(completion){
        completion(error);
    }
}

@end
