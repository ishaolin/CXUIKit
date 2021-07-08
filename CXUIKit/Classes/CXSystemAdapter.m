//
//  CXSystemAdapter.m
//  Pods
//
//  Created by wshaolin on 2019/10/12.
//

#import "CXSystemAdapter.h"

@implementation CXSystemAdapter

+ (UIActivityIndicatorView *)largeActivityIndicatorView{
    UIActivityIndicatorViewStyle style;
    if(@available(iOS 13.0, *)){
        style = UIActivityIndicatorViewStyleLarge;
    }else{
        style = UIActivityIndicatorViewStyleWhiteLarge;
    }
    
    return [self activityIndicatorViewWithStyle:style color:[UIColor whiteColor]];
}

+ (UIActivityIndicatorView *)whiteActivityIndicatorView{
    UIActivityIndicatorViewStyle style;
    if(@available(iOS 13.0, *)){
        style = UIActivityIndicatorViewStyleMedium;
    }else{
        style = UIActivityIndicatorViewStyleWhite;
    }
    
    return [self activityIndicatorViewWithStyle:style color:[UIColor whiteColor]];
}

+ (UIActivityIndicatorView *)grayActivityIndicatorView{
    UIActivityIndicatorViewStyle style;
    if(@available(iOS 13.0, *)){
        style = UIActivityIndicatorViewStyleMedium;
    }else{
        style = UIActivityIndicatorViewStyleGray;
    }
    
    return [self activityIndicatorViewWithStyle:style color:[UIColor grayColor]];
}

+ (UIActivityIndicatorView *)activityIndicatorViewWithStyle:(UIActivityIndicatorViewStyle)style color:(UIColor *)color{
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
    if(@available(iOS 13.0, *)){
        indicatorView.color = color;
    }
    
    return indicatorView;
}

@end
