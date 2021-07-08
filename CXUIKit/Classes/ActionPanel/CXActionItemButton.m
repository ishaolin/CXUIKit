//
//  CXActionItemButton.m
//  Pods
//
//  Created by wshaolin on 2017/11/20.
//

#import "CXActionItemButton.h"
#import "UIView+CXExtensions.h"

@interface CXActionItemButton (){
    NSMutableDictionary<NSNumber *, UIFont *> *_titleFonts;
}

@end

@implementation CXActionItemButton

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        _titleFonts = [[NSMutableDictionary alloc] init];
        
        self.enableHighlighted = YES;
    }
    
    return self;
}

- (void)setTitleFont:(UIFont *)titleFont forState:(UIControlState)state{
    if(!titleFont){
        return;
    }
    
    _titleFonts[@(state)] = titleFont;
    if(state == UIControlStateNormal){
        [self setTitleFontForState:state];
    }
}

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state{
    if(!color){
        return;
    }
    
    [super setTitleColor:color forState:state];
}

- (void)setHighlighted:(BOOL)highlighted{
    if(!self.isEnableHighlighted){
        return;
    }
    
    [super setHighlighted:highlighted];
    
    [self setTitleFontForState:highlighted ? UIControlStateHighlighted : UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    
    [self setTitleFontForState:selected ? UIControlStateSelected : UIControlStateNormal];
}

- (void)setEnabled:(BOOL)enabled{
    [super setEnabled:enabled];
    
    [self setTitleFontForState:enabled ? UIControlStateNormal : UIControlStateDisabled];
}

- (void)setTitleFontForState:(UIControlState)state{
    UIFont *titleFont = _titleFonts[@(state)];
    if(!titleFont){
        return;
    }
    
    self.titleLabel.font = titleFont;
}

- (void)setCornerRadii:(CGFloat)cornerRadii{
    if(_cornerRadii == cornerRadii){
        return;
    }
    
    _cornerRadii = cornerRadii;
    [self cx_roundedCornerRadii:_cornerRadii];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if(_cornerRadii > 0){
        [self cx_roundedCornerRadii:_cornerRadii];
    }
}

@end
