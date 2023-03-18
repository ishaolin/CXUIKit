//
//  UIActivityIndicatorView+CXUIKit.m
//  CXUIKit
//
//  Created by Michael Lynn on 2023/3/18.
//

#import "UIActivityIndicatorView+CXUIKit.h"

@implementation UIActivityIndicatorView (CXUIKit)

+ (UIActivityIndicatorView *)largeIndicatorView{
    UIActivityIndicatorViewStyle style;
    if(@available(iOS 13.0, *)){
        style = UIActivityIndicatorViewStyleLarge;
    }else{
        style = UIActivityIndicatorViewStyleWhiteLarge;
    }
    
    return [self indicatorViewWithStyle:style color:[UIColor whiteColor]];
}

+ (UIActivityIndicatorView *)whiteIndicatorView{
    UIActivityIndicatorViewStyle style;
    if(@available(iOS 13.0, *)){
        style = UIActivityIndicatorViewStyleMedium;
    }else{
        style = UIActivityIndicatorViewStyleWhite;
    }
    
    return [self indicatorViewWithStyle:style color:[UIColor whiteColor]];
}

+ (UIActivityIndicatorView *)grayIndicatorView{
    UIActivityIndicatorViewStyle style;
    if(@available(iOS 13.0, *)){
        style = UIActivityIndicatorViewStyleMedium;
    }else{
        style = UIActivityIndicatorViewStyleGray;
    }
    
    return [self indicatorViewWithStyle:style color:[UIColor grayColor]];
}

+ (UIActivityIndicatorView *)indicatorViewWithStyle:(UIActivityIndicatorViewStyle)style color:(UIColor *)color{
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
    if(@available(iOS 13.0, *)){
        indicatorView.color = color;
    }
    
    return indicatorView;
}

@end
