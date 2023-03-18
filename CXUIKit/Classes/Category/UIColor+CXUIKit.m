//
//  UIColor+CXUIKit.m
//  Pods
//
//  Created by wshaolin on 2017/6/14.
//
//

#import "UIColor+CXUIKit.h"

#define CX_I_0xFF  0xFF
#define CX_F_0xFF  (CX_I_0xFF * 1.0)

static inline unsigned CXColorRGBValueFromString(NSString *string, NSRange range){
    string = [string substringWithRange:range];
    if(range.length == 1){
        string = [NSString stringWithFormat:@"%@%@", string, string];
    }
    
    unsigned value = 0;
    [[NSScanner scannerWithString:string] scanHexInt:&value];
    return value;
}

@implementation UIColor (CXUIKit)

+ (UIColor *)cx_colorWithHex:(uint32_t)hex{
    return [self cx_colorWithHex:hex alpha:1.0];
}

+ (UIColor *)cx_colorWithHex:(uint32_t)hex alpha:(CGFloat)alpha{
    CXColorRGB colorRGB = CXColorRGBFromHex(hex);
    colorRGB.a = alpha;
    return [self cx_colorWithColorRGB:colorRGB];
}

+ (UIColor *)cx_colorWithHexString:(NSString *)string{
    CXColorRGB colorRGB = CXColorRGBMake(0, 0, 0, 1.0);
    string = [string stringByReplacingOccurrencesOfString:@"#" withString:@""];
    switch(string.length){
        case 3:{
            colorRGB.r = CXColorRGBValueFromString(string, (NSRange){0, 1});
            colorRGB.g = CXColorRGBValueFromString(string, (NSRange){1, 1});
            colorRGB.b = CXColorRGBValueFromString(string, (NSRange){2, 1});
        }
            break;
        case 4:{
            colorRGB.a = CXColorRGBValueFromString(string, (NSRange){0, 1}) / CX_F_0xFF;
            colorRGB.r = CXColorRGBValueFromString(string, (NSRange){1, 1});
            colorRGB.g = CXColorRGBValueFromString(string, (NSRange){2, 1});
            colorRGB.b = CXColorRGBValueFromString(string, (NSRange){3, 1});
        }
            break;
        case 6:{
            colorRGB.r = CXColorRGBValueFromString(string, (NSRange){0, 2});
            colorRGB.g = CXColorRGBValueFromString(string, (NSRange){2, 2});
            colorRGB.b = CXColorRGBValueFromString(string, (NSRange){4, 2});
        }
            break;
        case 8:{
            colorRGB.a = CXColorRGBValueFromString(string, (NSRange){0, 2}) / CX_F_0xFF;
            colorRGB.r = CXColorRGBValueFromString(string, (NSRange){2, 2});
            colorRGB.g = CXColorRGBValueFromString(string, (NSRange){4, 2});
            colorRGB.b = CXColorRGBValueFromString(string, (NSRange){6, 2});
        }
            break;
        default:
            return nil;
    }
    
    colorRGB.a = MIN(colorRGB.a, 1.0);
    
    return [self cx_colorWithColorRGB:colorRGB];
}

+ (UIColor *)cx_colorWithColorRGB:(CXColorRGB)colorRGB{
    return [self colorWithRed:MIN((colorRGB.r / CX_F_0xFF), 1.0)
                        green:MIN((colorRGB.g / CX_F_0xFF), 1.0)
                         blue:MIN((colorRGB.b / CX_F_0xFF), 1.0)
                        alpha:MAX(MIN(colorRGB.a, 1.0), 0)];
}

- (CXColorRGB)cx_colorRGB{
    CGFloat r = 0;
    CGFloat g = 0;
    CGFloat b = 0;
    CGFloat a = 0;
    
    [self getRed:&r green:&g blue:&b alpha:&a];
    
    return CXColorRGBMake(r * CX_I_0xFF, g * CX_I_0xFF, b * CX_I_0xFF, a);
}

- (NSString *)cx_hexString{
    CXColorRGB colorRGB = [self cx_colorRGB];
    NSUInteger value = 0;
    if(colorRGB.a < 1){
        value = ((NSInteger)(colorRGB.a * CX_I_0xFF)) << 24;
    }
    
    value += (colorRGB.r << 16) + (colorRGB.g << 8) + colorRGB.b;
    return [NSString stringWithFormat:@"#%X", value];
}

@end

CXColorRGB CXColorRGBMake(NSUInteger r, NSUInteger g, NSUInteger b, CGFloat a){
    return (CXColorRGB){r, g, b, a};
}

CXColorRGB CXColorRGBFromHex(uint32_t hex){
    NSUInteger r, g, b;
    CGFloat a = 1.0;
    
    if(hex > 0xFFFFFF){
        a = ((hex >> 24) & CX_I_0xFF) / CX_F_0xFF;
    }
    r = (hex >> 16) & CX_I_0xFF;
    g = (hex >> 8) & CX_I_0xFF;
    b = hex & CX_I_0xFF;
    
    return CXColorRGBMake(r, g, b, a);
}

UIColor *CXRGBAColor(NSUInteger r, NSUInteger g, NSUInteger b, CGFloat a){
    CXColorRGB colorRGB = CXColorRGBMake(r, g, b, a);
    return [UIColor cx_colorWithColorRGB:colorRGB];
}

UIColor *CXRGBColor(NSUInteger r, NSUInteger g, NSUInteger b){
    return CXRGBAColor(r, g, b, 1.0);
}
