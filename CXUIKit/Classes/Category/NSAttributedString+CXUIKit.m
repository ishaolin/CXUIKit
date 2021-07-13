//
//  NSAttributedString+CXUIKit.m
//  Pods
//
//  Created by wshaolin on 2017/6/15.
//
//

#import "NSAttributedString+CXUIKit.h"
#import <CXFoundation/CXFoundation.h>
#import "UIFont+CXUIKit.h"

@implementation NSAttributedString (CXUIKit)

+ (NSAttributedString *)cx_attributedString:(NSString *)string
                           highlightedColor:(UIColor *)highlightedColor
                            highlightedFont:(UIFont *)highlightedFont{
    return [self cx_attributedString:string formatBlock:^(NSMutableAttributedString *attributedString, NSInteger idx, NSRange range) {
        if(highlightedColor){
            [attributedString addAttribute:NSForegroundColorAttributeName
                                     value:highlightedColor
                                     range:range];
        }
        
        if(highlightedFont){
            [attributedString addAttribute:NSFontAttributeName
                                     value:highlightedFont
                                     range:range];
        }
    }];
}

+ (NSAttributedString *)cx_attributedString:(NSString *)string
                                formatBlock:(CXAttributedStringFormatBlock)formatBlock{
    if(CXStringIsEmpty(string)){
        return nil;
    }
    
    CXStringSymbolRange *symbolRange = [[CXStringSymbolRange alloc] initWithBeginSymbol:@"{" endSymbol:@"}" formatString:string];
    NSArray<NSValue *> *ranges = [symbolRange pairedSymbolRanges];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[symbolRange replacedString]];
    if(formatBlock){
        [ranges enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            formatBlock(attributedString, idx, obj.rangeValue);
        }];
    }
    
    return [attributedString copy];
}

+ (NSAttributedString *)cx_attributedHTML:(NSString *)HTML{
    return [self cx_attributedHTML:HTML forFont:nil];
}

+ (NSAttributedString *)cx_attributedHTMLForPingFangSCRegularFont:(NSString *)HTML{
    return [self cx_attributedHTML:HTML forFont:CXUIFontNamePingFangSC_Regular];
}

+ (NSAttributedString *)cx_attributedHTML:(NSString *)HTML forFont:(NSString *)fontName{
    if(CXStringIsEmpty(HTML)){
        return nil;
    }
    
    NSData *HTMLData = [HTML dataUsingEncoding:NSUnicodeStringEncoding];
    if(!HTMLData){
        return nil;
    }
    
    NSDictionary<NSString *, id> *options = @{NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType};
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:HTMLData options:options documentAttributes:nil error:nil];
    if(CXStringIsEmpty(fontName)){
        return attributedString;
    }
    
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:attributedString.string];
    [attributedString enumerateAttributesInRange:NSMakeRange(0, attributedString.string.length) options:0 usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        NSMutableDictionary<NSString *, id> *attributes = [NSMutableDictionary dictionary];
        [attributes addEntriesFromDictionary:attrs];
        UIFont *font = attributes[NSFontAttributeName];
        if(font){
            attributes[NSFontAttributeName] = [UIFont cx_fontWithName:fontName size:font.pointSize];
            [mutableAttributedString setAttributes:attributes range:range];
        }
    }];
    
    return [mutableAttributedString copy];
}

@end
