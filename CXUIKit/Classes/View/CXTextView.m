//
//  CXTextView.m
//  Pods
//
//  Created by wshaolin on 2019/2/20.
//

#import "CXTextView.h"
#import <CXFoundation/CXFoundation.h>

@interface CXTextView () {
    UILabel *_placeholderLabel;
}

@end

@implementation CXTextView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        _placeholderLabel = [[UILabel alloc] init];
        _placeholderLabel.font = self.font;
        _placeholderLabel.textAlignment = self.textAlignment;
        [self addSubview:_placeholderLabel];
        
        [NSNotificationCenter addObserver:self action:@selector(textDidChangeNotification:) name:UITextViewTextDidChangeNotification object:self];
    }
    
    return self;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor{
    _placeholderLabel.textColor = placeholderColor;
}

- (UIColor *)placeholderColor{
    return _placeholderLabel.textColor;
}

- (void)setPlaceholder:(NSString *)placeholder{
    _placeholderLabel.text = placeholder;
}

- (NSString *)placeholder{
    return _placeholderLabel.text;
}

- (void)setFont:(UIFont *)font{
    [super setFont:font];
    
    _placeholderLabel.font = font;
}

- (void)textDidChangeNotification:(NSNotification *)notification{
    _placeholderLabel.hidden = !CXStringIsEmpty(self.text);
    
    [self textDidChange:self.text];
}

- (void)textDidChange:(NSString *)text{
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat placeholderLabel_X = 7.0;
    CGFloat placeholderLabel_Y = 8.0;
    CGFloat placeholderLabel_H = self.font.lineHeight;
    CGFloat placeholderLabel_W = CGRectGetWidth(self.bounds) - placeholderLabel_X * 2;
    _placeholderLabel.frame = (CGRect){placeholderLabel_X, placeholderLabel_Y, placeholderLabel_W, placeholderLabel_H};
}

- (void)dealloc{
    [NSNotificationCenter removeObserver:self];
}

@end
