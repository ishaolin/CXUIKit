//
//  UIColor+CXUIKit.h
//  Pods
//
//  Created by wshaolin on 2017/6/14.
//
//

#import <UIKit/UIKit.h>
#import "CXUIKitDefines.h"

#define CXHexIColor(i) [UIColor cx_colorWithHex:(i)]
#define CXHexSColor(s) [UIColor cx_colorWithHexString:s]

typedef struct{
    NSUInteger r; // red, [0, 0xFF]
    NSUInteger g; // green, [0, 0xFF]
    NSUInteger b; // blue, [0, 0xFF]
    CGFloat a; // alpha, [0, 1]
} CXColorRGB;

@interface UIColor (CXUIKit)

+ (UIColor *)cx_colorWithHex:(uint32_t)hex;
+ (UIColor *)cx_colorWithHex:(uint32_t)hex alpha:(CGFloat)alpha;

+ (UIColor *)cx_colorWithHexString:(NSString *)hexString;

+ (UIColor *)cx_colorWithColorRGB:(CXColorRGB)colorRGB;

- (CXColorRGB)cx_colorRGB;

- (NSString *)cx_hexString;

@end

CX_UIKIT_EXTERN CXColorRGB CXColorRGBMake(NSUInteger r, NSUInteger g, NSUInteger b, CGFloat a);
CX_UIKIT_EXTERN CXColorRGB CXColorRGBFromHex(uint32_t hex);

CX_UIKIT_EXTERN UIColor *CXRGBAColor(NSUInteger r, NSUInteger g, NSUInteger b, CGFloat a);
CX_UIKIT_EXTERN UIColor *CXRGBColor(NSUInteger r, NSUInteger g, NSUInteger b);
