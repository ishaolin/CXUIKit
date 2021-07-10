//
//  CXActionSheetPanel.m
//  Pods
//
//  Created by wshaolin on 2018/8/30.
//

#import "CXActionSheetPanel.h"
#import "UIFont+CXExtensions.h"
#import "UIColor+CXExtensions.h"
#import "UIScreen+CXExtensions.h"
#import <CXFoundation/CXFoundation.h>
#import "CXStringBounding.h"

@interface CXActionSheetPanel () {
    UIView *_titleView;
    UILabel *_titleLabel;
    
    CXActionSheetItemButton *_cancelItemButton;
    NSMutableArray<CXActionSheetItemButton *> *_actionItemButtons;
    CGFloat _safeAreaBottom;
}

@end

@implementation CXActionSheetPanel

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = CXHexIColor(0xE5E5E5);
        self.animationType = CXActionPanelAnimationUp;
        
        _titleView = [[UIView alloc] init];
        _titleView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_titleView];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = CX_PingFangSC_RegularFont(14.0);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = CXHexIColor(0x888888);
        _titleLabel.numberOfLines = 0;
        [_titleView addSubview:_titleLabel];
        
        _actionItemButtons = [NSMutableArray array];
        _safeAreaBottom = [UIScreen mainScreen].cx_safeAreaInsets.bottom;
    }
    
    return self;
}

- (void)setTitle:(NSString *)title{
    _title = title;
    
    _titleLabel.text = title;
}

- (void)addActionItemModel:(CXAlertActionItemModel *)actionItemModel{
    if(!actionItemModel || _actionItemButtons.count == 5){
        return;
    }
    
    [super addActionItemModel:actionItemModel];
    
    CXActionSheetItemButton *actionItemButton = [CXActionSheetItemButton buttonWithType:UIButtonTypeCustom];
    UIColor *titleColor = actionItemModel.isDestructive ? [UIColor redColor] : CXHexIColor(0x333333);
    [actionItemButton setTitleColor:titleColor forState:UIControlStateNormal];
    [actionItemButton setTitle:actionItemModel.title forState:UIControlStateNormal];
    [actionItemButton addTarget:self action:@selector(handleActionForActionItemButton:) forControlEvents:UIControlEventTouchUpInside];
    actionItemButton.tag = _actionItemButtons.count;
    
    [self addSubview:actionItemButton];
    [_actionItemButtons addObject:actionItemButton];
}

- (void)setCancelItemModel:(CXAlertActionItemModel *)cancelItemModel{
    _cancelItemModel = cancelItemModel;
    [_cancelItemButton removeFromSuperview];
    if(!cancelItemModel){
        return;
    }
    
    _cancelItemButton = [CXActionSheetItemButton buttonWithType:UIButtonTypeCustom];
    [_cancelItemButton setTitleColor:CXHexIColor(0x333333) forState:UIControlStateNormal];
    [_cancelItemButton setTitle:cancelItemModel.title forState:UIControlStateNormal];
    [_cancelItemButton addTarget:self action:@selector(handleActionForActionItemButton:) forControlEvents:UIControlEventTouchUpInside];
    _cancelItemButton.lineView.hidden = YES;
    _cancelItemButton.tag = -1;
    if(_safeAreaBottom > 0){
        _cancelItemButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, _safeAreaBottom - 10.0, 0);
    }
    [self addSubview:_cancelItemButton];
}

- (void)handleActionForActionItemButton:(CXActionSheetItemButton *)actionItemButton{
    if(actionItemButton == _cancelItemButton){
        [self handleActionItem:self.cancelItemModel withIndex:actionItemButton.tag];
    }else{
        [self handleActionItemAtIndex:actionItemButton.tag];
    }
}

- (void)dismissForRotateScreen{
    [self cancel];
}

- (void)dismissForTapOverlayView:(UITouch *)touch{
    [self cancel];
}

- (void)layoutForSupperRect:(CGRect)rect{
    CGFloat titleLabel_X = 15.0;
    CGFloat titleLabel_Y = 16.0;
    CGFloat titleLabel_W = CGRectGetWidth(rect) - titleLabel_X * 2;
    CGFloat titleLabel_H = 0;
    if(CXStringIsEmpty(self.title)){
        _titleView.hidden = YES;
    }else{
        // 最多显示两行title
        CGSize size = CGSizeMake(titleLabel_W, _titleLabel.font.lineHeight * 2);
        titleLabel_H = [CXStringBounding bounding:self.title
                                     rectWithSize:size
                                             font:_titleLabel.font].size.height;
    }
    _titleLabel.frame = (CGRect){titleLabel_X, titleLabel_Y, titleLabel_W, titleLabel_H};
    
    CGFloat titleView_X = 0;
    CGFloat titleView_Y = 0;
    CGFloat titleView_W = CGRectGetWidth(rect);
    CGFloat titleView_H = _titleView.isHidden ? 0 : (titleLabel_Y * 2 + titleLabel_H);
    _titleView.frame = (CGRect){titleView_X, titleView_Y, titleView_W, titleView_H};
    
    CGFloat actionItemButton_X = titleView_X;
    CGFloat actionItemButton_W = titleView_W;
    CGFloat actionItemButton_H = 50.0;
    __block CGFloat actionItemButton_Y = CGRectGetMaxY(_titleView.frame);
    [_actionItemButtons enumerateObjectsUsingBlock:^(CXActionSheetItemButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.lineView.hidden = (idx == 0 && self->_titleView.isHidden);
        obj.frame = (CGRect){actionItemButton_X, actionItemButton_Y, actionItemButton_W, actionItemButton_H};
        actionItemButton_Y += actionItemButton_H;
    }];
    
    if(_actionItemButtons.count > 0 && !_cancelItemButton && _safeAreaBottom > 0){
        CXActionSheetItemButton *itemButton = _actionItemButtons.lastObject;
        itemButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, _safeAreaBottom - 10.0, 0);
        CGRect frame = itemButton.frame;
        frame.size.height += _safeAreaBottom;
        itemButton.frame = frame;
    }
    
    CGFloat cancelItemButton_X = actionItemButton_X;
    CGFloat cancelItemButton_W = actionItemButton_W;
    CGFloat cancelItemButton_H = actionItemButton_H + _safeAreaBottom;
    CGFloat cancelItemButton_Y = CGRectGetMaxY(_titleView.frame) + 10.0;
    if(_actionItemButtons.count > 0){
        cancelItemButton_Y = CGRectGetMaxY(_actionItemButtons.lastObject.frame) + 10.0;
    }
    _cancelItemButton.frame = (CGRect){cancelItemButton_X, cancelItemButton_Y, cancelItemButton_W, cancelItemButton_H};
    
    CGFloat panelHeight = CGRectGetMaxY(_titleView.frame) + _safeAreaBottom;
    if(_actionItemButtons > 0){
        panelHeight = CGRectGetMaxY(_actionItemButtons.lastObject.frame);
    }
    
    if(_cancelItemButton){
        panelHeight = CGRectGetMaxY(_cancelItemButton.frame);
    }
    
    panelHeight = MAX(panelHeight, actionItemButton_H);
    self.panelSize = CGSizeMake(0, panelHeight);
}

@end

@implementation CXActionSheetItemButton

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = CXHexIColor(0xE5E5E5);
        
        [self addSubview:_lineView];
    }
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat lineView_X = 0;
    CGFloat lineView_Y = 0;
    CGFloat lineView_W = CGRectGetWidth(self.bounds);
    CGFloat lineView_H = 0.5;
    _lineView.frame = (CGRect){lineView_X, lineView_Y, lineView_W, lineView_H};
}

@end
