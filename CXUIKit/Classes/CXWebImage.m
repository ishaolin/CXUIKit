//
//  CXWebImage.m
//  Pods
//
//  Created by wshaolin on 2019/1/21.
//

#import "CXWebImage.h"
#import <SDWebImage/SDWebImageManager.h>
#import <CXFoundation/CXFoundation.h>

typedef NS_ENUM(NSInteger, CXImageClipType) {
    CXImageClipLeft             = 0, // 左右分，返回左半部分
    CXImageClipRight            = 1, // 左右分，返回右半部分
    CXImageClipTop              = 2, // 上下分，返回上半部分
    CXImageClipBottom           = 3, // 上下分，返回下半部分
    CXImageClipHorizontalCenter = 4, // 左中右三分，左右各占1/4，中间占1/2，返回中间的部分
    CXImageClipVerticalCenter   = 5  // 上中下三分，上下各占1/4，中间占1/2，返回中间的部分
};

@implementation CXWebImage

+ (NSString *)imageCacheKeyForURL:(NSURL *)URL{
    return [[SDWebImageManager sharedManager] cacheKeyForURL:URL];
}

+ (void)imageForURL:(NSURL *)URL completion:(CXImageDownloadCompletionBlock)completion{
    [self imageForKey:[self imageCacheKeyForURL:URL] completion:completion];
}

+ (void)imageForKey:(NSString *)key completion:(CXImageDownloadCompletionBlock)completion{
    if(CXStringIsEmpty(key)||!completion){
        return;
    }
    
    id<SDImageCache> imageCache = [SDWebImageManager sharedManager].imageCache;
    [imageCache queryImageForKey:key options:0 context:nil completion:^(UIImage * _Nullable image, NSData * _Nullable data, SDImageCacheType cacheType) {
        completion(image, data);
    }];
}

+ (void)storeImage:(UIImage *)image forURL:(NSURL *)URL{
    [self storeImage:image forKey:[self imageCacheKeyForURL:URL]];
}

+ (void)storeImage:(UIImage *)image forKey:(NSString *)key{
    if(!image || CXStringIsEmpty(key)){
        return;
    }
    
    id<SDImageCache> imageCache = [SDWebImageManager sharedManager].imageCache;
    [imageCache storeImage:image
                 imageData:nil
                    forKey:key
                 cacheType:SDImageCacheTypeAll
                completion:nil];
}

+ (void)downloadImageWithURL:(id)url completion:(CXImageDownloadCompletionBlock)completion{
    NSURL *URL = [NSURL cx_validURL:url];
    if(!URL){
        completion(nil, nil);
        return;
    }
    
    [[SDWebImageManager sharedManager] loadImageWithURL:url
                                                options:0
                                               progress:nil
                                              completed:^(UIImage * _Nullable image,
                                                          NSData * _Nullable data,
                                                          NSError * _Nullable error,
                                                          SDImageCacheType cacheType,
                                                          BOOL finished,
                                                          NSURL * _Nullable imageURL) {
        completion(image, data);
    }];
}

+ (void)composeURLImage:(NSArray<NSString *> *)imageUrls
                   size:(CGFloat)size
                spacing:(CGFloat)spacing
             completion:(CXImageComposeCompletionBlock)completion{
    if(!completion){
        return;
    }
    
    if(CXArrayIsEmpty(imageUrls)){
        completion(nil);
        return;
    }
    
    NSMutableArray<NSString *> *validUrls = [NSMutableArray array];
    [imageUrls enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([CXStringUtil isHTTPURL:obj]){
            [validUrls addObject:obj];
        }
    }];
    
    if(CXArrayIsEmpty(validUrls)){
        completion(nil);
        return;
    }
    
    NSString *imageCacheKey = [NSString stringWithFormat:@"%@%@", [validUrls componentsJoinedByString:@","], @(size)];
    imageCacheKey = [CXUCryptor MD5:imageCacheKey];
    [self imageForKey:imageCacheKey completion:^(UIImage *image, NSData *data) {
        if(image){
            completion(image);
        }else{
            [self invokeOperationQueue:validUrls
                                  size:size
                               spacing:spacing
                         imageCacheKey:imageCacheKey
                            completion:completion];
        }
    }];
}

+ (void)invokeOperationQueue:(NSArray *)validUrls
                        size:(CGFloat)size
                     spacing:(CGFloat)spacing
               imageCacheKey:(NSString *)imageCacheKey
                  completion:(CXImageComposeCompletionBlock)completion{
    CXBlockOperationQueue *operationQueue = [[CXBlockOperationQueue alloc] init];
    [validUrls enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [operationQueue addOperationHandler:^(CXBlockOperationResultNotify notify) {
            [self downloadImageWithURL:obj completion:^(UIImage *image, NSData *data) {
                notify(image);
            }];
        }];
    }];
    
    operationQueue.completion = ^(NSArray<CXBlockOperationHandlerResult *> *results) {
        NSMutableArray<UIImage *> *images = [NSMutableArray array];
        [[results sortedArrayUsingComparator:^NSComparisonResult(CXBlockOperationHandlerResult * _Nonnull obj1, CXBlockOperationHandlerResult * _Nonnull obj2) {
            return [obj1.key compare:obj2.key];
        }] enumerateObjectsUsingBlock:^(CXBlockOperationHandlerResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if([obj.data isKindOfClass:[UIImage class]]){
                [images addObject:(UIImage *)obj.data];
            }
        }];
        
        UIImage *image = [self composeImage:images size:size spacing:spacing];
        [self storeImage:image forKey:imageCacheKey];
        completion(image);
    };
    
    [operationQueue invoke];
}

+ (UIImage *)composeImage:(NSArray<UIImage *> *)images
                     size:(CGFloat)size
                  spacing:(CGFloat)spacing{
    if(CXArrayIsEmpty(images)){
        return nil;
    }
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(size, size) , NO, 0.0);
    if(images.count == 1){
        [images[0] drawInRect:(CGRect){CGPointZero, size, size}];
    }else if(images.count == 2){
        // 左侧
        CGFloat x1 = 0;
        CGFloat y1 = 0;
        CGFloat w1 = (size - spacing) * 0.5;
        CGFloat h1 = size;
        UIImage *image = [self clipImage:images[0] clipType:CXImageClipHorizontalCenter];
        [image drawInRect:(CGRect){x1, y1, w1, h1}];
        
        // 右侧
        CGFloat x2 = (x1 + w1) + spacing;
        CGFloat y2 = y1;
        CGFloat w2 = w1;
        CGFloat h2 = h1;
        image = [self clipImage:images[1] clipType:CXImageClipHorizontalCenter];
        [image drawInRect:(CGRect){x2, y2, w2, h2}];
    }else if(images.count == 3){
        // 左侧
        CGFloat x1 = 0;
        CGFloat y1 = 0;
        CGFloat w1 = (size - spacing) * 0.5;
        CGFloat h1 = size;
        UIImage *image = [self clipImage:images[0] clipType:CXImageClipHorizontalCenter];
        [image drawInRect:(CGRect){x1, y1, w1, h1}];
        
        // 右上
        CGFloat x2 = (x1 + w1) + spacing;
        CGFloat y2 = y1;
        CGFloat w2 = w1;
        CGFloat h2 = (h1 - spacing) * 0.5;
        [images[1] drawInRect:(CGRect){x2, y2, w2, h2}];
        
        // 右下
        CGFloat x3 = x2;
        CGFloat y3 = (y2 + h2) + spacing;
        CGFloat w3 = w2;
        CGFloat h3 = h2;
        [images[2] drawInRect:(CGRect){x3, y3, w3, h3}];
    }else{
        // 左上
        CGFloat x1 = 0;
        CGFloat y1 = 0;
        CGFloat w1 = (size - spacing) * 0.5;
        CGFloat h1 = (size - spacing) * 0.5;
        [images[0] drawInRect:(CGRect){x1, y1, w1, h1}];
        
        // 右上
        CGFloat x2 = (x1 + w1) + spacing;
        CGFloat y2 = y1;
        CGFloat w2 = w1;
        CGFloat h2 = h1;
        [images[1] drawInRect:(CGRect){x2, y2, w2, h2}];
        
        // 左下
        CGFloat x3 = x1;
        CGFloat y3 = (y1 + h1) + spacing;
        CGFloat w3 = w1;
        CGFloat h3 = h1;
        [images[2] drawInRect:(CGRect){x3, y3, w3, h3}];
        
        // 右下
        CGFloat x4 = x2;
        CGFloat y4 = y3;
        CGFloat w4 = w1;
        CGFloat h4 = h1;
        [images[3] drawInRect:(CGRect){x4, y4, w4, h4}];
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)clipImage:(UIImage *)image clipType:(CXImageClipType)clipType{
    if(!image){
        return nil;
    }
    
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = image.size.width * image.scale;
    CGFloat h = image.size.height * image.scale;
    switch (clipType) {
        case CXImageClipLeft:
            w *= 0.5;
            break;
        case CXImageClipRight:
            w *= 0.5;
            x = w;
            break;
        case CXImageClipTop:
            h *= 0.5;
            break;
        case CXImageClipBottom:
            h *= 0.5;
            y = h;
            break;
        case CXImageClipHorizontalCenter:
            w *= 0.5;
            x = w * 0.5;
            break;
        case CXImageClipVerticalCenter:
            h *= 0.5;
            y = h * 0.5;
            break;
        default:
            break;
    }
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, (CGRect){x, y, w, h});
    UIImage *clipImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return clipImage;
}

@end
