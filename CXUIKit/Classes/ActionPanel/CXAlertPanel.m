//
//  CXAlertPanel.m
//  Pods
//
//  Created by wshaolin on 2018/8/29.
//

#import "CXAlertPanel.h"
#import "UIView+CXExtensions.h"
#import "UIFont+CXExtensions.h"
#import "UIColor+CXExtensions.h"
#import "UIScreen+CXExtensions.h"
#import <CXFoundation/CXFoundation.h>
#import "CXStringBounding.h"

@interface CXAlertPanel () {
    UILabel *_titleLabel;
    UITextView *_messageView;
    NSMutableArray<CXAlertActionItemButton *> *_actionItemButtons;
    UIView *_vLineView;
    UIView *_hLineView;
}

@end

@implementation CXAlertPanel

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.animationType = CXActionPanelAnimationCustom;
        self.dismissWhenTapOverlayView = NO;
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = CX_PingFangSC_MediumFont(17.0);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.tintColor = CXHexIColor(0x333333);
        _titleLabel.numberOfLines = 0;
        
        _messageView = [[UITextView alloc] init];
        _messageView.font = CX_PingFangSC_RegularFont(14.0);
        _messageView.textAlignment = NSTextAlignmentCenter;
        _messageView.textColor = CXHexIColor(0x333333);
        _messageView.editable = NO;
        _messageView.selectable = NO;
        _messageView.scrollEnabled = NO;
        _messageView.textContainerInset = UIEdgeInsetsZero;
        
        _vLineView = [[UIView alloc] init];
        _vLineView.backgroundColor = CXHexIColor(0xE5E5E5);
        
        _hLineView = [[UIView alloc] init];
        _hLineView.backgroundColor = CXHexIColor(0xE5E5E5);
        
        [self addSubview:_titleLabel];
        [self addSubview:_messageView];
        [self addSubview:_vLineView];
        [self addSubview:_hLineView];
        
        _actionItemButtons = [NSMutableArray array];
    }
    
    return self;
}

- (void)setTitle:(NSString *)title{
    _title = title;
    
    _titleLabel.text = title;
}

- (void)setMessage:(NSString *)message{
    _message = message;
    
    _messageView.text = self.message;
}

- (void)addActionItemModel:(CXAlertActionItemModel *)actionItemModel{
    if(!actionItemModel || _actionItemButtons.count == 2){ // 目前最多支持两个按钮
        return;
    }
    
    [super addActionItemModel:actionItemModel];
    
    CXAlertActionItemButton *actionItemButton = [CXAlertActionItemButton buttonWithType:UIButtonTypeCustom];
    UIColor *titleColor = actionItemModel.isDestructive ? CXHexIColor(0x007AFF) : CXHexIColor(0x333333);
    [actionItemButton setTitleColor:titleColor forState:UIControlStateNormal];
    [actionItemButton setTitle:actionItemModel.title forState:UIControlStateNormal];
    [actionItemButton addTarget:self action:@selector(handleActionForActionItemButton:) forControlEvents:UIControlEventTouchUpInside];
    actionItemButton.tag = _actionItemButtons.count;
    if([actionItemModel isKindOfClass:[CXAlertPanelItemModel class]]){
        actionItemButton.enabled = ((CXAlertPanelItemModel *)actionItemModel).isEnabled;
    }
    
    [self addSubview:actionItemButton];
    [_actionItemButtons addObject:actionItemButton];
}

- (void)handleActionForActionItemButton:(CXAlertActionItemButton *)actionItemButton{
    [self handleActionItemAtIndex:actionItemButton.tag];
}

- (void)setPanelItem:(CXAlertPanelItemModel *)panelItem enabled:(BOOL)enabled{
    if(!panelItem){
        return;
    }
    
    [self setPanelItemEnabled:enabled atIndex:[self.actionItemModels indexOfObject:panelItem]];
}

- (void)setPanelItemEnabled:(BOOL)enabled atIndex:(NSUInteger)index{
    if(index < _actionItemButtons.count){
        _actionItemButtons[index].enabled = enabled;
    }
}

- (CXActionAnimationBlock)showAnimationWithSuperView:(UIView *)superView{
    CGFloat x = (superView.bounds.size.width - self.panelSize.width) * 0.5;
    CGFloat y = (superView.bounds.size.height - self.panelSize.height) * 0.5;
    self.frame = (CGRect){x, y, self.panelSize};
    [self addActionPanelShowAnimation];
    superView.alpha = 0;
    
    return ^{
        superView.alpha = 1.0;
    };
}

- (void)addActionPanelShowAnimation{
    NSString *animationKey = @"CXAlertOptionsPanelShowAnimationKey";
    CAKeyframeAnimation *animation = [self.layer animationForKey:animationKey];
    if(animation){
        return;
    }
    
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    NSValue *transform1 = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)];
    NSValue *transform2 = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05, 1.05, 1.0)];
    NSValue *transform3 = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)];
    
    animation.values = @[transform1, transform2, transform3];
    animation.keyTimes = @[@(0), @(0.5), @(1.0)];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.duration = self.animationDuration;
    
    [self.layer addAnimation:animation forKey:animationKey];
}

- (CXActionAnimationBlock)dismissAnimationWithSuperView:(UIView *)superView{
    [self addActionPanelDismissAnimation];
    
    return ^{
        superView.alpha = 0;
    };
}

- (void)addActionPanelDismissAnimation{
    NSString *animationKey = @"CXAlertOptionsPanelDismissAnimationKey";
    CAKeyframeAnimation *animation = [self.layer animationForKey:animationKey];
    if(animation){
        return;
    }
    
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    NSValue *transform1 = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)];
    NSValue *transform2 = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.95, 0.95, 1.0)];
    NSValue *transform3 = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1.0)];
    
    animation.values = @[transform1, transform2, transform3];
    animation.keyTimes = @[@(0), @(0.5), @(1.0)];
    animation.fillMode = kCAFillModeRemoved;
    animation.duration = self.animationDuration;
    
    [self.layer addAnimation:animation forKey:animationKey];
}

- (void)layoutForSupperRect:(CGRect)rect{
    CGFloat width = MAX(280.0, CGRectGetWidth(rect) - 100.0);
    CGFloat x = (CGRectGetWidth(rect) - width) * 0.5;
    
    CGFloat maxHeight = CGRectGetHeight(rect) - x * 2;
    if(CX_SCREEN_INCH_IS_5_8){
        maxHeight = CGRectGetHeight(rect) - MAX(x, 35.0) * 2;
    }
    
    CGFloat hLineView_X = 0;
    CGFloat hLineView_W = width;
    CGFloat hLineView_H = 0.5;
    
    CGFloat vLineView_W = 0.5;
    CGFloat vLineView_H = 45.0;
    CGFloat vLineView_X = (width - vLineView_W) * 0.5;
    
    CGFloat titleLabel_X = 25.0;
    CGFloat titleLabel_Y = 25.0;
    CGFloat titleLabel_W = width - titleLabel_X * 2;
    CGFloat titleLabel_H = 0;
    if(!CXStringIsEmpty(self.title)){
        CGSize size = CGSizeMake(titleLabel_W, CGFLOAT_MAX);
        if(CXStringIsEmpty(self.message)){
            // 有message时title最多显示三行
            size.height = _titleLabel.font.lineHeight * 3;
        }
        titleLabel_H = [CXStringBounding bounding:self.title
                                     rectWithSize:size
                                             font:_titleLabel.font].size.height;
        CGFloat titleLabel_MH = maxHeight - titleLabel_Y - vLineView_H - titleLabel_Y;
        if(titleLabel_H > titleLabel_MH){
            titleLabel_H = titleLabel_MH;
        }
    }
    _titleLabel.frame = (CGRect){titleLabel_X, titleLabel_Y, titleLabel_W, titleLabel_H};
    
    CGFloat messageView_X = 15.0;
    CGFloat messageView_Y = CXStringIsEmpty(self.title) ? titleLabel_Y : CGRectGetMaxY(_titleLabel.frame) + 10.0;
    CGFloat messageView_W = width - messageView_X * 2;
    CGFloat messageView_MH = maxHeight - messageView_Y - vLineView_H - titleLabel_Y;
    CGFloat messageView_H = 0;
    if(!CXStringIsEmpty(self.message)){
        messageView_H = [CXStringBounding bounding:self.message
                                      rectWithSize:CGSizeMake(messageView_W, CGFLOAT_MAX)
                                              font:_messageView.font].size.height;
        // 控制在合适的范围内显示
        if(messageView_H > messageView_MH){
            messageView_H = messageView_MH;
            _messageView.scrollEnabled = YES;
        }
        
        // 超过两行时居左对齐
        if(messageView_H > _messageView.font.lineHeight * 2){
            _messageView.textAlignment = NSTextAlignmentLeft;
        }
    }
    _messageView.frame = (CGRect){messageView_X, messageView_Y, messageView_W, messageView_H};
    
    CGFloat vLineView_Y = MAX(CGRectGetMaxY(_titleLabel.frame), CGRectGetMaxY(_messageView.frame)) + titleLabel_Y;
    _vLineView.frame = (CGRect){vLineView_X, vLineView_Y, vLineView_W, vLineView_H};
    _vLineView.hidden = _actionItemButtons.count < 2;
    
    CGFloat hLineView_Y = vLineView_Y - hLineView_H;
    _hLineView.frame = (CGRect){hLineView_X, hLineView_Y, hLineView_W, hLineView_H};
    _hLineView.hidden = CXArrayIsEmpty(_actionItemButtons);
    
    CGFloat actionButton_Y = vLineView_Y;
    CGFloat actionButton_H = vLineView_H;
    CGFloat actionButton_W = width;
    if(_actionItemButtons.count > 1){
        actionButton_W = vLineView_X;
    }
    
    [_actionItemButtons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat actionButton_X = (actionButton_W + vLineView_W) * idx;
        obj.frame = (CGRect){actionButton_X, actionButton_Y, actionButton_W, actionButton_H};
    }];
    
    self.panelSize = CGSizeMake(width, MAX(CGRectGetMaxY(_hLineView.frame), CGRectGetMaxY(_actionItemButtons.firstObject.frame)));
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self cx_roundedCornerRadii:8.0];
}

@end

@implementation CXAlertPanelItemModel

- (instancetype)init{
    if(self = [super init]){
        _enabled = YES;
    }
    
    return self;
}

@end
