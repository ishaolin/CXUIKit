//
//  UILabel+CXUIKit.h
//  Pods
//
//  Created by wshaolin on 2017/6/14.
//
//

#import <UIKit/UIKit.h>

@interface UILabel (CXUIKit)

- (void)cx_setAttributedText:(NSString *)attributedText;

- (void)cx_setAttributedText:(NSString *)attributedText
            highlightedColor:(UIColor *)highlightedColor;

- (void)cx_setAttributedText:(NSString *)attributedText
            highlightedColor:(UIColor *)highlightedColor
             highlightedFont:(UIFont *)highlightedFont;

- (void)cx_setHTML:(NSString *)HTML;

- (void)cx_setText:(NSString *)text;

- (CGSize)cx_sizeThatFits:(CGSize)size;

@end
