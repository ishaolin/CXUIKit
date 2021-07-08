//
//  CXWebImage.h
//  Pods
//
//  Created by wshaolin on 2019/1/21.
//

#import <UIKit/UIKit.h>

typedef void(^CXImageDownloadCompletionBlock)(UIImage *image, NSData *data);
typedef void(^CXImageComposeCompletionBlock)(UIImage *image);

@interface CXWebImage : NSObject

// 从缓存读取
+ (void)imageForURL:(NSURL *)url completion:(CXImageDownloadCompletionBlock)completion;
+ (void)imageForKey:(NSString *)key completion:(CXImageDownloadCompletionBlock)completion;

+ (void)storeImage:(UIImage *)image forURL:(NSURL *)URL;
+ (void)storeImage:(UIImage *)image forKey:(NSString *)key;

// 优先从缓存读取，缓存没有就下载
+ (void)downloadImageWithURL:(id)url completion:(CXImageDownloadCompletionBlock)completion;

+ (void)composeURLImage:(NSArray<NSString *> *)imageUrls
                   size:(CGFloat)size
                spacing:(CGFloat)spacing
             completion:(CXImageComposeCompletionBlock)completion;

@end
