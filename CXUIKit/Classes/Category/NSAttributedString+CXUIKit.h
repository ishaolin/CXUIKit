//
//  NSAttributedString+CXUIKit.h
//  Pods
//
//  Created by wshaolin on 2017/6/15.
//
//

#import <UIKit/UIKit.h>

typedef void(^CXAttributedStringFormatBlock)(NSMutableAttributedString *attributedString,
                                             NSInteger idx,
                                             NSRange range);

@interface NSAttributedString (CXUIKit)

+ (NSAttributedString *)cx_attributedString:(NSString *)string
                           highlightedColor:(UIColor *)highlightedColor
                            highlightedFont:(UIFont *)highlightedFont;

+ (NSAttributedString *)cx_attributedString:(NSString *)string
                                formatBlock:(CXAttributedStringFormatBlock)formatBlock;

+ (NSAttributedString *)cx_attributedHTML:(NSString *)HTML;

+ (NSAttributedString *)cx_attributedHTMLForPingFangSCRegularFont:(NSString *)HTML;

+ (NSAttributedString *)cx_attributedHTML:(NSString *)HTML forFont:(NSString *)fontName;

@end
