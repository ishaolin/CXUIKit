//
//  UIImageView+CXExtensions.m
//  Pods
//
//  Created by wshaolin on 2019/1/24.
//

#import "UIImageView+CXExtensions.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CXWebImage.h"

@implementation UIImageView (CXExtensions)

- (void)cx_setImageWithURL:(NSString *)URL{
    [self cx_setImageWithURL:URL placeholderImage:nil];
}

- (void)cx_setImageWithURL:(NSString *)URL
          placeholderImage:(UIImage *)placeholder{
    [self cx_setImageWithURL:URL placeholderImage:placeholder completion:nil];
}

- (void)cx_setImageWithURL:(NSString *)URL
          placeholderImage:(UIImage *)placeholder
                completion:(CXWebImageCompletionBlock)completion{
    [self sd_setImageWithURL:[NSURL URLWithString:URL] placeholderImage:placeholder completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        !completion ?: completion(image);
    }];
}

- (void)cx_setImageWithURLArray:(NSArray<NSString *> *)URLArray
                    composeSize:(CGFloat)composeSize
                        spacing:(CGFloat)spacing{
    [self cx_setImageWithURLArray:URLArray
                      composeSize:composeSize
                          spacing:spacing
                      placeholder:nil
                       completion:nil];
}

- (void)cx_setImageWithURLArray:(NSArray<NSString *> *)URLArray
                    composeSize:(CGFloat)composeSize
                        spacing:(CGFloat)spacing
                    placeholder:(UIImage *)placeholder
                     completion:(CXWebImageCompletionBlock)completion{
    self.image = placeholder;
    [CXWebImage composeURLImage:URLArray size:composeSize spacing:spacing completion:^(UIImage *image) {
        if(image){
            self.image = image;
        }
        !completion ?: completion(image);
    }];
}

@end
