//
//  CXActionToolBarStyle.m
//  Pods
//
//  Created by wshaolin on 2017/11/20.
//

#import "CXActionToolBarStyle.h"
#import "UIFont+CXExtensions.h"
#import "UIColor+CXExtensions.h"

@interface CXActionToolBarStyle (){
    NSMutableDictionary<NSNumber *, UIFont *> *_itemTitleFonts;
    NSMutableDictionary<NSNumber *, UIColor *> *_itemTitleColors;
    NSMutableDictionary<NSNumber *, UIColor *> *_itemBackgroundColors;
}

@end

@implementation CXActionToolBarStyle

- (instancetype)init{
    if(self = [super init]){
        _itemTitleFonts = [NSMutableDictionary dictionary];
        _itemTitleColors = [NSMutableDictionary dictionary];
        _itemBackgroundColors = [NSMutableDictionary dictionary];
        
        _separatorLineWidth = 0.75;
        _separatorLineColor = CXHexIColor(0xF0F0F0);
        
        _rowItemCount = 4;
        _itemHeight = 50.0;
        _verticalLineHeight = 50.0;
        
        _markerSize = CGSizeMake(24.0, 2.0);
        _markerOffset = UIOffsetZero;
        
        _itemTitleFonts[@(UIControlStateNormal)] = CX_PingFangSC_RegularFont(18.0);
        _itemTitleFonts[@(UIControlStateSelected)] = CX_PingFangSC_MediumFont(18.0);
        _itemTitleColors[@(UIControlStateNormal)] = [CXHexIColor(0x353C43) colorWithAlphaComponent:0.7];
        _itemTitleColors[@(UIControlStateSelected)] = CXHexIColor(0x353C43);
        _itemBackgroundColors[@(UIControlStateHighlighted)] = CXHexIColor(0xFFFFFF);
        _itemBackgroundColors[@(UIControlStateSelected)] = CXHexIColor(0xFFFFFF);
    }
    
    return self;
}

- (void)setItemTitleFont:(UIFont *)itemTitleFont forState:(UIControlState)state{
    if(!itemTitleFont){
        [_itemTitleFonts removeObjectForKey:@(state)];
        return;
    }
    
    _itemTitleFonts[@(state)] = itemTitleFont;
}

- (void)setItemTitleColor:(UIColor *)itemTitleColor forState:(UIControlState)state{
    if(!itemTitleColor){
        [_itemTitleColors removeObjectForKey:@(state)];
        return;
    }
    
    _itemTitleColors[@(state)] = itemTitleColor;
}

- (void)setItemBackgroundColor:(UIColor *)itemBackgroundColor forState:(UIControlState)state{
    if(!itemBackgroundColor){
        [_itemBackgroundColors removeObjectForKey:@(state)];
        return;
    }
    
    _itemBackgroundColors[@(state)] = itemBackgroundColor;
}

- (UIFont *)itemTitleFontForState:(UIControlState)state{
    return _itemTitleFonts[@(state)];
}

- (UIColor *)itemTitleColorForState:(UIControlState)state{
    return _itemTitleColors[@(state)];
}

- (UIColor *)itemBackgroundColorForState:(UIControlState)state{
    return _itemBackgroundColors[@(state)];
}

- (void)enumerateTitleFontsForHandler:(CXDictionaryEnumerateHandler)handler{
    [_itemTitleFonts enumerateKeysAndObjectsUsingBlock:handler];
}

- (void)enumerateTitleColorsForHandler:(CXDictionaryEnumerateHandler)handler{
    [_itemTitleColors enumerateKeysAndObjectsUsingBlock:handler];
}

- (void)enumerateBackgroundColorsForHandler:(CXDictionaryEnumerateHandler)handler{
    [_itemBackgroundColors enumerateKeysAndObjectsUsingBlock:handler];
}

@end
