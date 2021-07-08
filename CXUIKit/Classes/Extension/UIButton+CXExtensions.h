//
//  UIButton+CXExtensions.h
//  Pods
//
//  Created by wshaolin on 2017/6/14.
//
//

#import "UIImage+CXExtensions.h"

@interface UIButton (CXExtensions)

- (void)cx_setBackgroundColor:(UIColor *)backgroundColor
                     forState:(UIControlState)state;

- (void)cx_setBackgroundColors:(NSArray<UIColor *> *)colors
             gradientDirection:(CXColorGradientDirection)gradientDirection
                      forState:(UIControlState)state;

- (void)cx_setBackgroundColors:(NSArray<UIColor *> *)colors
            gradientStartPoint:(CGPoint)startPoint
              gradientEndPoint:(CGPoint)endPoint
                      forState:(UIControlState)state;

- (void)cx_setImageWithURL:(NSString *)url
                  forState:(UIControlState)state;

- (void)cx_setImageWithURL:(NSString *)url
                  forState:(UIControlState)state
          placeholderImage:(UIImage *)placeholder;

@end
