//
//  UILabel+CXUIKit.m
//  Pods
//
//  Created by wshaolin on 2017/6/14.
//
//

#import "UILabel+CXUIKit.h"
#import "NSAttributedString+CXUIKit.h"
#import <CXFoundation/CXFoundation.h>
#import "CXStringBounding.h"

@implementation UILabel (CXUIKit)

- (void)cx_setAttributedText:(NSString *)attributedText{
    [self cx_setAttributedText:attributedText
              highlightedColor:nil];
}

- (void)cx_setAttributedText:(NSString *)attributedText
            highlightedColor:(UIColor *)highlightedColor{
    [self cx_setAttributedText:attributedText
              highlightedColor:highlightedColor
               highlightedFont:self.font];
}

- (void)cx_setAttributedText:(NSString *)attributedText
            highlightedColor:(UIColor *)highlightedColor
             highlightedFont:(UIFont *)highlightedFont{
    self.text = nil;
    self.attributedText = [NSAttributedString cx_attributedString:attributedText
                                                 highlightedColor:highlightedColor
                                                  highlightedFont:highlightedFont];
}

- (void)cx_setHTML:(NSString *)HTML{
    self.text = nil;
    self.attributedText = [NSAttributedString cx_attributedHTML:HTML];
}

- (void)cx_setText:(NSString *)text{
    if(CXStringIsEmpty(text)){
        self.text = nil;
        self.attributedText = nil;
        return;
    }
    
    if([text rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch].location != NSNotFound){
        [self cx_setHTML:text];
    }else{
        self.text = text;
    }
}

- (CGSize)cx_sizeThatFits:(CGSize)size{
    if(self.text && !self.attributedText){
        return [CXStringBounding bounding:self.text
                             rectWithSize:size
                                     font:self.font].size;
    }
    
    CGSize _size = [self sizeThatFits:size];
    _size.width = MIN(_size.width, size.width);
    _size.height = MIN(_size.height, size.height);
    return _size;
}

@end
