//
//  UIButton+CXExtensions.m
//  Pods
//
//  Created by wshaolin on 2017/6/14.
//
//

#import "UIButton+CXExtensions.h"
#import <SDWebImage/UIButton+WebCache.h>

@implementation UIButton (CXExtensions)

- (void)cx_setBackgroundColor:(UIColor *)backgroundColor
                     forState:(UIControlState)state{
    UIImage *image = [UIImage cx_imageWithColor:backgroundColor];
    if(!image){
        return;
    }
    
    [self setBackgroundImage:image forState:state];
}

- (void)cx_setBackgroundColors:(NSArray<UIColor *> *)colors
             gradientDirection:(CXColorGradientDirection)gradientDirection
                      forState:(UIControlState)state{
    UIImage *image = [UIImage cx_imageWithColors:colors gradientDirection:gradientDirection];
    if(!image){
        return;
    }
    
    [self setBackgroundImage:image forState:state];
}

- (void)cx_setBackgroundColors:(NSArray<UIColor *> *)colors
            gradientStartPoint:(CGPoint)startPoint
              gradientEndPoint:(CGPoint)endPoint
                      forState:(UIControlState)state{
    UIImage *image = [UIImage cx_imageWithColors:colors
                              gradientStartPoint:startPoint
                                gradientEndPoint:endPoint
                                            size:CGSizeMake(1.0, 1.0)];
    if(!image){
        return;
    }
    
    [self setBackgroundImage:image forState:state];
}

- (void)cx_setImageWithURL:(NSString *)url
                  forState:(UIControlState)state{
    [self cx_setImageWithURL:url forState:state placeholderImage:nil];
}

- (void)cx_setImageWithURL:(NSString *)url
                  forState:(UIControlState)state
          placeholderImage:(UIImage *)placeholder{
    NSURL *URL = [NSURL URLWithString:url];
    
    if(URL){
        [self sd_setImageWithURL:URL forState:state placeholderImage:placeholder];
    }else{
        [self setImage:placeholder forState:state];
    }
}

@end
