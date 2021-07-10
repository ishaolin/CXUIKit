//
//  CXNumberKeyboardPanel.m
//  Pods
//
//  Created by wshaolin on 2018/12/24.
//

#import "CXNumberKeyboardPanel.h"
#import "UIColor+CXExtensions.h"
#import "UIButton+CXExtensions.h"
#import "UIFont+CXExtensions.h"
#import "UIScreen+CXExtensions.h"
#import "CXImageUtils.h"
#import "UIView+CXExtensions.h"

@interface CXNumberKeyboardKeyButton : UIView {
    CALayer *_shadowLayer;
    UIButton *_actionButton;
}

@property (nonatomic, copy) NSString *keyTitle;

- (void)addTarget:(nullable id)target action:(SEL)action;

@end

@implementation CXNumberKeyboardKeyButton

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        _shadowLayer = [CALayer layer];
        _shadowLayer.backgroundColor = [UIColor whiteColor].CGColor;
        _shadowLayer.shadowColor = [UIColor blackColor].CGColor;
        _shadowLayer.shadowOpacity = 0.5;
        _shadowLayer.shadowRadius = 0.5;
        _shadowLayer.shadowOffset = CGSizeMake(0, 1.0);
        [self.layer addSublayer:_shadowLayer];
        
        _actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _actionButton.titleLabel.font = CX_PingFangSC_LightFont(28.0);
        [_actionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_actionButton cx_setBackgroundColor:CXHexIColor(0xFFFFFF) forState:UIControlStateNormal];
        [_actionButton cx_setBackgroundColor:CXHexIColor(0xB8C2D0) forState:UIControlStateHighlighted];
        [self addSubview:_actionButton];
    }
    
    return self;
}

- (void)setKeyTitle:(NSString *)keyTitle{
    [_actionButton setTitle:keyTitle forState:UIControlStateNormal];
}

- (NSString *)keyTitle{
    return [_actionButton titleForState:UIControlStateNormal];
}

- (void)addTarget:(id)target action:(SEL)action{
    [_actionButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat shadowLayer_X = 1.0;
    CGFloat shadowLayer_Y = 1.0;
    CGFloat shadowLayer_W = CGRectGetWidth(self.bounds) - shadowLayer_X * 2;
    CGFloat shadowLayer_H = CGRectGetHeight(self.bounds) - shadowLayer_Y;
    _shadowLayer.frame = (CGRect){shadowLayer_X, shadowLayer_Y, shadowLayer_W, shadowLayer_H};
    _actionButton.frame = self.bounds;
    
    CGFloat cornerRadius = 5.0;
    _shadowLayer.cornerRadius = cornerRadius;
    [_actionButton cx_roundedCornerRadii:cornerRadius];
}

@end

@interface CXNumberKeyboardPanel () {
    NSMutableArray<UIView *> *_keyItems;
}

@end

@implementation CXNumberKeyboardPanel

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = CXHexIColor(0xD0D3DB);
        
        _keyItems = [NSMutableArray array];
        [@[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"", @"0"] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CXNumberKeyboardKeyButton *keyButton = [[CXNumberKeyboardKeyButton alloc] init];
            [keyButton addTarget:self action:@selector(handleActionForKeyButton:)];
            keyButton.keyTitle = obj;
            keyButton.hidden = obj.length == 0;
            [self addSubview:keyButton];
            [self->_keyItems addObject:keyButton];
        }];
        
        UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *deleteImage = CX_UIKIT_IMAGE(@"ui_keyboard_delete");
        [deleteButton setImage:deleteImage forState:UIControlStateNormal];
        [deleteButton setImage:[deleteImage cx_imageForTintColor:[UIColor grayColor]] forState:UIControlStateHighlighted];
        [deleteButton addTarget:self action:@selector(handleActionForDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:deleteButton];
        [_keyItems addObject:deleteButton];
    }
    
    return self;
}

- (void)handleActionForKeyButton:(UIButton *)keyButton{
    if([self.delegate respondsToSelector:@selector(numberKeyboardPanel:didInputCharacter:)]){
        [self.delegate numberKeyboardPanel:self didInputCharacter:[keyButton titleForState:UIControlStateNormal]];
    }
}

- (void)handleActionForDeleteButton:(UIButton *)deleteButton{
    if([self.delegate respondsToSelector:@selector(numberKeyboardPanelDidDelete:)]){
        [self.delegate numberKeyboardPanelDidDelete:self];
    }
}

- (void)setFrame:(CGRect)frame{
    frame.size = self.bounds.size;
    [super setFrame:frame];
}

- (CGRect)bounds{
    CGSize size = [UIApplication sharedApplication].keyWindow.bounds.size;
    size.height = 230.0 + [UIScreen mainScreen].cx_safeAreaInsets.bottom;
    return (CGRect){CGPointZero, size};
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    NSUInteger columnCount = 3;
    CGFloat keyButton_M = 6.0;
    CGFloat keyButton_W = (CGRectGetWidth(self.bounds) - keyButton_M * (columnCount + 1)) / columnCount;
    CGFloat keyButton_H = 50.0;
    [_keyItems enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat keyButton_X = keyButton_M + (keyButton_W + keyButton_M) * (idx % columnCount);
        CGFloat keyButton_Y = keyButton_M + (keyButton_H + keyButton_M) * (idx / columnCount);
        obj.frame = (CGRect){keyButton_X, keyButton_Y, keyButton_W, keyButton_H};
    }];
}

@end
