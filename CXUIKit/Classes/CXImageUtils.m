//
//  CXImageUtils.m
//  Pods
//
//  Created by wshaolin on 2019/1/25.
//

#import "CXImageUtils.h"
#import <CXFoundation/CXFoundation.h>

@implementation CXImageUtils

+ (void)imageBase64:(NSArray<UIImage *> *)images completion:(CXImageBase64CompletionBlock)completion{
    [self imageBase64:images compressMaxQuality:(300 * 1000.0) completion:completion];
}

+ (void)imageBase64:(NSArray<UIImage *> *)images compressMaxQuality:(CGFloat)compressMaxQuality completion:(CXImageBase64CompletionBlock)completion{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray<NSString *> *array = [NSMutableArray array];
        [images enumerateObjectsUsingBlock:^(UIImage * _Nonnull image, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *base64String = [self base64StringWithImage:image compressMaxQuality:compressMaxQuality];
            [array addObject:base64String ?: @""];
        }];
        
        [CXDispatchHandler asyncOnMainQueue:^{
            if(completion){
                completion([array copy]);
            }
        }];
    });
}

+ (NSString *)base64StringWithImage:(UIImage *)image compressMaxQuality:(CGFloat)compressMaxQuality{
    if(!image){
        return nil;
    }
    
    NSData *data = nil;
    @autoreleasepool{
        data = [self compressImage:image maxQuality:compressMaxQuality];
        data = [data base64EncodedDataWithOptions:0];
    }
    
    if(!data){
        return nil;
    }
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

+ (NSData *)compressImage:(UIImage *)image maxQuality:(CGFloat)maxQuality{
    if(!image){
        return nil;
    }
    
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    return [self compressImageData:data maxQuality:maxQuality];
}

+ (NSData *)compressImageData:(NSData *)imageData maxQuality:(CGFloat)maxQuality{
    if(maxQuality <= 0 || imageData.length < maxQuality){
        return imageData;
    }
    
    UIImage *image = [UIImage imageWithData:imageData];
    imageData = UIImageJPEGRepresentation(image, 0.75); // 75%的质量压缩
    if(imageData.length < maxQuality){
        return imageData;
    }
    
    image = [UIImage imageWithData:imageData];
    CGFloat scale = MAX([UIScreen mainScreen].scale, 1.0) / 0.8; // 80%比例的尺寸x压缩
    CGSize size = CGSizeZero;
    size.width = floor(image.size.width / scale);
    size.height = floor(image.size.height / scale);
    UIGraphicsBeginImageContextWithOptions(size, NO, 1.0);
    [image drawInRect:(CGRect){CGPointZero, size}];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [self compressImage:image maxQuality:maxQuality];
}

+ (NSString *)imageBase64PNG:(NSString *)base64{
    return [self imageBase64:base64 type:@"png"];
}

+ (NSString *)imageBase64JPG:(NSString *)base64{
    return [self imageBase64:base64 type:@"jpg"];
}

+ (NSString *)imageBase64:(NSString *)base64 type:(NSString *)type{
    if(CXStringIsEmpty(base64)){
        return nil;
    }
    
    return [NSString stringWithFormat:@"data:image/%@;base64,%@", type, base64];
}

+ (UIImage *)rotateImageOrientationToUp:(UIImage *)image orientation:(UIImageOrientation)orientation{
    if(!image || orientation == UIImageOrientationUp){
        return image;
    }
    
    CGSize size = CGSizeMake(image.size.width, image.size.height);
    float rotate = 0.0;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            size = CGSizeMake(image.size.height, image.size.width);
            translateX = 0;
            translateY = -size.width;
            scaleY = size.width / size.height;
            scaleX = size.height / size.width;
            break;
        case UIImageOrientationRight:
            rotate = -M_PI_2;
            size = CGSizeMake(image.size.height, image.size.width);
            translateX = -size.height;
            translateY = 0;
            scaleY = size.width / size.height;
            scaleX = size.height / size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            size = CGSizeMake(image.size.width, image.size.height);
            translateX = -size.width;
            translateY = -size.height;
            break;
        default:
            break;
    }
    
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0, size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    CGContextScaleCTM(context, scaleX, scaleY);
    CGContextDrawImage(context, (CGRect){CGPointZero, size}, image.CGImage);
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
