//
//  UIImageView+CXExtensions.h
//  Pods
//
//  Created by wshaolin on 2019/1/24.
//

#import <UIKit/UIKit.h>

typedef void(^CXWebImageCompletionBlock)(UIImage *image);

@interface UIImageView (CXExtensions)

- (void)cx_setImageWithURL:(NSString *)URL;

- (void)cx_setImageWithURL:(NSString *)URL
          placeholderImage:(UIImage *)placeholder;

- (void)cx_setImageWithURL:(NSString *)URL
          placeholderImage:(UIImage *)placeholder
                completion:(CXWebImageCompletionBlock)completion;

- (void)cx_setImageWithURLArray:(NSArray<NSString *> *)URLArray
                    composeSize:(CGFloat)composeSize
                        spacing:(CGFloat)spacing;

- (void)cx_setImageWithURLArray:(NSArray<NSString *> *)URLArray
                    composeSize:(CGFloat)composeSize
                        spacing:(CGFloat)spacing
                    placeholder:(UIImage *)placeholder
                     completion:(CXWebImageCompletionBlock)completion;

@end
