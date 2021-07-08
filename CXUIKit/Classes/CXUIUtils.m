//
//  CXUIUtils.m
//  Pods
//
//  Created by wshaolin on 2017/6/20.
//
//

#import "CXUIUtils.h"

@implementation CXUIUtils

+ (CGFloat)relativeMinWidthForScreenInch4_7:(CGFloat)width{
    return MIN(width, (width / 375.0 * [UIScreen mainScreen].bounds.size.width));
}

+ (CGFloat)relativeMaxWidthForScreenInch4_7:(CGFloat)width{
    return MAX(width, (width / 375.0 * [UIScreen mainScreen].bounds.size.width));
}

+ (CGFloat)relativeMinHeightForScreenInch4_7:(CGFloat)height{
    return MIN(height, (height / 667.0 * [UIScreen mainScreen].bounds.size.height));
}

+ (CGFloat)relativeMaxHeightForScreenInch4_7:(CGFloat)height{
    return MAX(height, (height / 667.0 * [UIScreen mainScreen].bounds.size.height));
}

+ (CGFloat)relativeWidthForScreenInch4_7:(CGFloat)width{
    return (width / 375.0 * [UIScreen mainScreen].bounds.size.width);
}

+ (CGFloat)relativeHeightForScreenInch4_7:(CGFloat)height{
    return (height / 667.0 * [UIScreen mainScreen].bounds.size.height);
}

@end
