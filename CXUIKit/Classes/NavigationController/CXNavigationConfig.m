//
//  CXNavigationConfig.m
//  Pods
//
//  Created by wshaolin on 2017/5/28.
//
//

#import "CXNavigationConfig.h"
#import "UIFont+CXUIKit.h"

static UIStatusBarStyle _navigationBarStyleDefault = UIStatusBarStyleDefault;
static UIImage *_navigationBarBackIconDefault = nil;

static inline NSMutableDictionary<NSNumber *, CXNavigationConfig *> *_CXNavigationBarStyleConfigs(void){
    static NSMutableDictionary<NSNumber *, CXNavigationConfig *> *configs;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        configs = [NSMutableDictionary dictionary];
    });
    
    return configs;
}

@interface CXNavigationConfig(){
    NSMutableDictionary<NSNumber *, UIColor *> *_mutableItemTitleColors;
}

@end

@implementation CXNavigationConfig

- (instancetype)init{
    if(self = [super init]){
        _mutableItemTitleColors = [NSMutableDictionary dictionary];
        
        _titleFont = CX_PingFangSC_MediumFont(16.0);
        _subtitleFont = CX_PingFangSC_RegularFont(14.0);
        _itemTitleFont = CX_PingFangSC_RegularFont(15.0);
        
        _titleColor = [UIColor blackColor];
        
        [self setItemTitleColor:_titleColor forState:UIControlStateNormal];
    }
    
    return self;
}

- (void)setItemTitleColor:(UIColor *)color forState:(UIControlState)state{
    if(color){
        _mutableItemTitleColors[@(state)] = color;
    }else{
        [_mutableItemTitleColors removeObjectForKey:@(state)];
    }
}

- (UIColor *)itemTitleColorForState:(UIControlState)state{
    return _mutableItemTitleColors[@(state)];
}

@end

void CXSetNavigationConfigForStyle(CXNavigationConfig *config, UIStatusBarStyle style){
    if(config){
        [_CXNavigationBarStyleConfigs() setObject:config forKey:@(style)];
    }else{
        [_CXNavigationBarStyleConfigs() removeObjectForKey:@(style)];
    }
}

CXNavigationConfig *CXNavigationConfigForStyle(UIStatusBarStyle style){
    return [_CXNavigationBarStyleConfigs() objectForKey:@(style)];
}

CXNavigationConfig *CXNavigationConfigDefault(void){
    return CXNavigationConfigForStyle(CXNavigationBarDefaultStyle());
}

void CXSetNavigationBarDefaultStyle(UIStatusBarStyle style){
    _navigationBarStyleDefault = style;
}

UIStatusBarStyle CXNavigationBarDefaultStyle(void){
    return _navigationBarStyleDefault;
}

void CXSetNavigationBarDefaultBackIcon(UIImage *backIcon){
    _navigationBarBackIconDefault = backIcon;
}

UIImage *CXGetNavigationBarDefaultBackIcon(void){
    return _navigationBarBackIconDefault;
}
