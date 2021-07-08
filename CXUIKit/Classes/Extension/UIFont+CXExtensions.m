//
//  UIFont+CXExtensions.m
//  Pods
//
//  Created by wshaolin on 2017/6/21.
//
//

#import "UIFont+CXExtensions.h"
#import <CXFoundation/CXFoundation.h>

@implementation UIFont (CXExtensions)

+ (UIFont *)cx_defaultFontOfSize:(CGFloat)fontSize{
    return [self cx_PingFangSC_RegularFontOfSize:fontSize];
}

+ (UIFont *)cx_boldDefaultFontOfSize:(CGFloat)fontSize{
    return [self cx_PingFangSC_MediumFontOfSize:fontSize];
}

+ (UIFont *)cx_PingFangSC_UltralightFontOfSize:(CGFloat)fontSize{
    return [self cx_fontWithName:CXUIFontNamePingFangSC_Ultralight size:fontSize];
}

+ (UIFont *)cx_PingFangSC_LightFontOfSize:(CGFloat)fontSize{
    return [self cx_fontWithName:CXUIFontNamePingFangSC_Light size:fontSize];
}

+ (UIFont *)cx_PingFangSC_ThinFontOfSize:(CGFloat)fontSize{
    return [self cx_fontWithName:CXUIFontNamePingFangSC_Thin size:fontSize];
}

+ (UIFont *)cx_PingFangSC_RegularFontOfSize:(CGFloat)fontSize{
    return [self cx_fontWithName:CXUIFontNamePingFangSC_Regular size:fontSize];
}

+ (UIFont *)cx_PingFangSC_MediumFontOfSize:(CGFloat)fontSize{
    return [self cx_fontWithName:CXUIFontNamePingFangSC_Medium size:fontSize];
}

+ (UIFont *)cx_PingFangSC_SemiboldFontOfSize:(CGFloat)fontSize{
    return [self cx_fontWithName:CXUIFontNamePingFangSC_Semibold size:fontSize];
}

+ (UIFont *)cx_fontWithName:(CXUIFontName)fontName size:(CGFloat)fontSize{
    if(CXStringIsEmpty(fontName)){
        return [self systemFontOfSize:fontSize];
    }
    
    UIFont *font = [self fontWithName:fontName size:fontSize];
    if(font){
        return font;
    }
    
    CXUIFontStyle fontStyle = CXUIFontStyleFromFontName(fontName);
    if(fontStyle == CXUIFontStyleItalic){
        return [self italicSystemFontOfSize:fontSize];
    }
    
    if(fontStyle == CXUIFontStyleBold){
        return [self boldSystemFontOfSize:fontSize];
    }
    
    return [self systemFontOfSize:fontSize];
}

@end
