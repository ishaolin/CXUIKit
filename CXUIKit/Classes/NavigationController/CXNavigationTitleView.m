//
//  CXNavigationTitleView.m
//  Pods
//
//  Created by wshaolin on 2017/5/17.
//
//

#import "CXNavigationTitleView.h"
#import "CXNavigationConfig.h"
#import <CXFoundation/CXFoundation.h>

@interface CXNavigationTitleView(){
    UILabel *_titleLabel;
    UILabel *_subtitleLabel;
}

@end

@implementation CXNavigationTitleView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = CXNavigationConfigDefault().titleFont;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
        _subtitleLabel = [[UILabel alloc] init];
        _subtitleLabel.font = CXNavigationConfigDefault().subtitleFont;
        _subtitleLabel.textAlignment = _titleLabel.textAlignment;
        _subtitleLabel.hidden = YES;
        
        [self addSubview:_titleLabel];
        [self addSubview:_subtitleLabel];
        [self setTitleColor:CXNavigationConfigDefault().titleColor];
    }
    
    return self;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor{
    
}

- (void)setTitle:(NSString *)title{
    _titleLabel.text = title;
    
    [self setNeedsLayout];
}

- (NSString *)title{
    return _titleLabel.text;
}

- (void)setSubtitle:(NSString *)subtitle{
    _subtitleLabel.text = subtitle;
    _subtitleLabel.hidden = CXStringIsEmpty(subtitle);
    
    [self setNeedsLayout];
}

- (NSString *)subtitle{
    return _subtitleLabel.text;
}

- (void)setTitleFont:(UIFont *)font{
    if(font){
        _titleLabel.font = font;
    }
}

- (void)setSubtitleFont:(UIFont *)font{
    if(font){
        _subtitleLabel.font = font;
    }
}

- (void)setTitleColor:(UIColor *)color{
    if(color){
        _titleLabel.textColor = color;
    }
}

- (void)setSubtitleColor:(UIColor *)color{
    if(color){
        _subtitleLabel.textColor = color;
    }
}

- (void)setTitleLineBreakMode:(NSLineBreakMode)lineBreakMode{
    _titleLabel.lineBreakMode = lineBreakMode;
}

- (void)setSubtitleLineBreakMode:(NSLineBreakMode)lineBreakMode{
    _subtitleLabel.lineBreakMode = lineBreakMode;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat subtitleLabel_X = 0;
    CGFloat subtitleLabel_H = _subtitleLabel.font.lineHeight;
    CGFloat subtitleLabel_W = self.bounds.size.width;
    if(_subtitleLabel.isHidden){
        subtitleLabel_H = 0;
    }
    
    CGFloat titleLabel_X = 0;
    CGFloat titleLabel_W = subtitleLabel_W;
    CGFloat titleLabel_H = _titleLabel.font.lineHeight;
    CGFloat titleLabel_Y = (self.bounds.size.height - subtitleLabel_H - titleLabel_H) * 0.5;
    
    CGFloat subtitleLabel_Y = titleLabel_Y + titleLabel_H;
    
    _titleLabel.frame = CGRectMake(titleLabel_X, titleLabel_Y, titleLabel_W, titleLabel_H);
    _subtitleLabel.frame = CGRectMake(subtitleLabel_X, subtitleLabel_Y, subtitleLabel_W, subtitleLabel_H);
}

@end
