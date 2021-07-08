//
//  CXUIUtils.h
//  Pods
//
//  Created by wshaolin on 2017/6/20.
//
//

#import <UIKit/UIKit.h>

#define CX_MARGIN_MIN(X) [CXUIUtils relativeMinWidthForScreenInch4_7:X]
#define CX_MARGIN_MAX(X) [CXUIUtils relativeMaxWidthForScreenInch4_7:X]

#define CX_ASPECT_MIN(X) [CXUIUtils relativeMinHeightForScreenInch4_7:X]
#define CX_ASPECT_MAX(X) [CXUIUtils relativeMaxHeightForScreenInch4_7:X]

#define CX_ADAPTER_H(X)  [CXUIUtils relativeWidthForScreenInch4_7:X]
#define CX_ADAPTER_V(X)  [CXUIUtils relativeHeightForScreenInch4_7:X]

#define CX_MARGIN(X) CX_MARGIN_MIN(X)
#define CX_ASPECT(X) CX_ASPECT_MAX(X)

@interface CXUIUtils : NSObject

+ (CGFloat)relativeMinWidthForScreenInch4_7:(CGFloat)width;

+ (CGFloat)relativeMaxWidthForScreenInch4_7:(CGFloat)width;

+ (CGFloat)relativeMinHeightForScreenInch4_7:(CGFloat)height;

+ (CGFloat)relativeMaxHeightForScreenInch4_7:(CGFloat)height;

+ (CGFloat)relativeWidthForScreenInch4_7:(CGFloat)width;

+ (CGFloat)relativeHeightForScreenInch4_7:(CGFloat)height;

@end
