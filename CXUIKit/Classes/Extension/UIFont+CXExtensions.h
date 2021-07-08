//
//  UIFont+CXExtensions.h
//  Pods
//
//  Created by wshaolin on 2017/6/21.
//
//

#import <UIKit/UIKit.h>
#import "CXUIFontName.h"

#define CX_PingFangSC_LightFont(size)    [UIFont cx_PingFangSC_LightFontOfSize:size]
#define CX_PingFangSC_RegularFont(size)  [UIFont cx_PingFangSC_RegularFontOfSize:size]
#define CX_PingFangSC_MediumFont(size)   [UIFont cx_PingFangSC_MediumFontOfSize:size]
#define CX_PingFangSC_SemiboldFont(size) [UIFont cx_PingFangSC_SemiboldFontOfSize:size]

#define CX_DefaultFontOfSize(size)       [UIFont cx_defaultFontOfSize:size]
#define CX_BoldDefaultFontOfSize(size)   [UIFont cx_boldDefaultFontOfSize:size]

@interface UIFont (CXExtensions)

+ (UIFont *)cx_defaultFontOfSize:(CGFloat)fontSize;
+ (UIFont *)cx_boldDefaultFontOfSize:(CGFloat)fontSize;

+ (UIFont *)cx_PingFangSC_UltralightFontOfSize:(CGFloat)fontSize;
+ (UIFont *)cx_PingFangSC_LightFontOfSize:(CGFloat)fontSize;
+ (UIFont *)cx_PingFangSC_ThinFontOfSize:(CGFloat)fontSize;
+ (UIFont *)cx_PingFangSC_RegularFontOfSize:(CGFloat)fontSize;
+ (UIFont *)cx_PingFangSC_MediumFontOfSize:(CGFloat)fontSize;
+ (UIFont *)cx_PingFangSC_SemiboldFontOfSize:(CGFloat)fontSize;

+ (UIFont *)cx_fontWithName:(CXUIFontName)fontName size:(CGFloat)fontSize;

@end
