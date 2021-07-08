//
//  CXActionToolBarStyle.h
//  Pods
//
//  Created by wshaolin on 2017/11/20.
//

#import <UIKit/UIKit.h>

typedef void(^CXDictionaryEnumerateHandler)(id key, id obj, BOOL *stop);

@interface CXActionToolBarStyle : NSObject

@property (nonatomic, assign) CGSize markerSize; // 默认{24.0, 2.0}
@property (nonatomic, assign) UIOffset markerOffset;

@property (nonatomic, assign) CGFloat separatorLineWidth;
@property (nonatomic, strong) UIColor *separatorLineColor;
@property (nonatomic, assign) CGFloat verticalLineHeight; // 默认50.0

@property (nonatomic, assign, getter = isHiddenTopSeparatorLine) BOOL hiddenTopSeparatorLine;
@property (nonatomic, assign, getter = isHiddenBottomSeparatorLine) BOOL hiddenBottomSeparatorLine;
@property (nonatomic, assign, getter = isHiddenVerticalSeparatorLine) BOOL hiddenVerticalSeparatorLine;

// 一行显示的最大item数，如果为0，则表示不控制，默认4
@property (nonatomic, assign) NSUInteger rowItemCount;
@property (nonatomic, assign) CGFloat itemHeight; // 默认50.0

- (void)setItemTitleFont:(UIFont *)itemTitleFont forState:(UIControlState)state;
- (void)setItemTitleColor:(UIColor *)itemTitleColor forState:(UIControlState)state;
- (void)setItemBackgroundColor:(UIColor *)itemBackgroundColor forState:(UIControlState)state;

- (UIFont *)itemTitleFontForState:(UIControlState)state;
- (UIColor *)itemTitleColorForState:(UIControlState)state;
- (UIColor *)itemBackgroundColorForState:(UIControlState)state;

- (void)enumerateTitleFontsForHandler:(CXDictionaryEnumerateHandler)handler;
- (void)enumerateTitleColorsForHandler:(CXDictionaryEnumerateHandler)handler;
- (void)enumerateBackgroundColorsForHandler:(CXDictionaryEnumerateHandler)handler;

@end
