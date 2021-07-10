//
//  CXActionToolBar.m
//  Pods
//
//  Created by wshaolin on 2017/11/20.
//

#import "CXActionToolBar.h"
#import "UIButton+CXExtensions.h"
#import "CXActionItemButton.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "UIFont+CXExtensions.h"
#import <CXFoundation/CXFoundation.h>
#import "CXStringBounding.h"

@interface CXActionToolBar (){
    NSMutableArray<CXActionToolBarItemNode *> *_itemNodes;
    NSMutableArray<CXActionItemButton *> *_itemButtons;
    NSMutableArray<NSNumber *> *_estimatedItemWidths;
    
    CALayer *_topLine;
    CALayer *_bottomLine;
    CALayer *_marker;
    NSMutableArray<CALayer *> *_vLines;
    UIScrollView *_contentView;
}

@end

@implementation CXActionToolBar

- (instancetype)initWithItemTitles:(NSArray<NSString *> *)itemTitles{
    return [self initWithItemTitles:itemTitles style:nil];
}

- (instancetype)initWithItemTitles:(NSArray<NSString *> *)itemTitles
                             style:(CXActionToolBarStyle *)style{
    NSMutableArray<CXActionToolBarItemNode *> *itemNodes = [NSMutableArray array];
    [itemTitles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CXActionToolBarItemNode *itemNode = [[CXActionToolBarItemNode alloc] initWithTitle:obj];
        [itemNodes addObject:itemNode];
    }];
    
    return [self initWithItemNodes:[itemNodes copy] style:style];
}

- (instancetype)initWithItemNodes:(NSArray<CXActionToolBarItemNode *> *)itemNodes{
    return [self initWithItemNodes:itemNodes style:nil];
}

- (instancetype)initWithItemNodes:(NSArray<CXActionToolBarItemNode *> *)itemNodes style:(CXActionToolBarStyle *)style{
    if(self = [super init]){
        _itemNodes = [NSMutableArray array];
        _vLines = [NSMutableArray array];
        _itemButtons = [NSMutableArray array];
        _estimatedItemWidths = [NSMutableArray array];
        
        _style = style;
        if(!_style){
            _style = [[CXActionToolBarStyle alloc] init];
        }
        
        _contentView = [[UIScrollView alloc] init];
        _contentView.backgroundColor = [UIColor clearColor];
        _contentView.showsVerticalScrollIndicator = NO;
        _contentView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_contentView];
        
        _topLine = [CALayer layer];
        _topLine.backgroundColor = _style.separatorLineColor.CGColor;
        _topLine.hidden = _style.isHiddenTopSeparatorLine;
        [self.layer addSublayer:_topLine];
        
        _bottomLine = [CALayer layer];
        _bottomLine.backgroundColor = _style.separatorLineColor.CGColor;
        _bottomLine.hidden = _style.isHiddenBottomSeparatorLine;
        [self.layer addSublayer:_bottomLine];
        
        CALayer *marker = [CALayer layer];
        marker.backgroundColor = [_style itemTitleColorForState:UIControlStateSelected].CGColor;
        self.marker = marker;
        
        if(itemNodes){
            [_itemNodes addObjectsFromArray:itemNodes];
        }
        
        [self itemNodesDidChanged];
    }
    
    return self;
}

- (NSUInteger)itemCount{
    return _itemNodes.count;
}

- (void)setMarker:(CALayer *)marker{
    [_marker removeFromSuperlayer];
    _marker = marker;
    _marker.zPosition = 10.0;
    [_contentView.layer addSublayer:_marker];
}

- (CXActionToolBarItemNode *)itemNodeOfIndex:(NSUInteger)index{
    if(index < _itemNodes.count){
        return _itemNodes[index];
    }
    
    return nil;
}

- (NSUInteger)indexOfItemNode:(CXActionToolBarItemNode *)itemNode{
    if(!itemNode){
        return NSNotFound;
    }
    
    return [_itemNodes indexOfObject:itemNode];
}

- (void)addItemNode:(CXActionToolBarItemNode *)itemNode{
    [self insertItemNode:itemNode atIndex:NSNotFound];
}

- (void)insertItemNode:(CXActionToolBarItemNode *)itemNode atIndex:(NSUInteger)index{
    if(!itemNode){
        return;
    }
    
    if(index < _itemNodes.count){
        [_itemNodes insertObject:itemNode atIndex:index];
    }else{
        [_itemNodes addObject:itemNode];
    }
    
    [self itemNodesDidChanged];
}

- (void)updateItemNode:(CXActionToolBarItemNode *)itemNode atIndex:(NSUInteger)index{
    if(!itemNode || index >= _itemNodes.count){
        return;
    }
    
    [_itemNodes replaceObjectAtIndex:index withObject:itemNode];
    
    if(index < _itemButtons.count){
        CXActionItemButton *itemButton = _itemButtons[index];
        [self actionItemButton:itemButton assembleItemNode:itemNode];
    }
}

- (void)actionItemButton:(CXActionItemButton *)itemButton assembleItemNode:(CXActionToolBarItemNode *)itemNode {
    if(!itemButton || !itemNode){
        return;
    }
    
    [itemButton setTitle:itemNode.title forState:UIControlStateNormal];
    
    if([itemNode.image isKindOfClass:[UIImage class]]){
        [itemButton setImage:(UIImage *)itemNode.image forState:UIControlStateNormal];
    }else if([itemNode.image isKindOfClass:[NSString class]]){
        NSURL *url =  [NSURL cx_validURL:itemNode.image];
        if(url){
            [itemButton sd_setImageWithURL:url forState:UIControlStateNormal];
        }
    }
    
    itemButton.enabled = itemNode.isEnabled;
}

- (void)removeItemNode:(CXActionToolBarItemNode *)itemNode{
    NSUInteger index = [self indexOfItemNode:itemNode];
    [self removeItemNodeAtIndex:index];
}

- (void)removeItemNodeAtIndex:(NSUInteger)index{
    if(index < _itemNodes.count){
        [_itemNodes removeObjectAtIndex:index];
        [_vLines.lastObject removeFromSuperlayer];
        [_vLines removeLastObject];
        
        [self itemNodesDidChanged];
    }
}

- (void)resetItemNodes:(NSArray<CXActionToolBarItemNode *> *)itemNodes{
    [_itemNodes removeAllObjects];
    
    [_vLines enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperlayer];
    }];
    [_vLines removeAllObjects];
    
    [_itemButtons enumerateObjectsUsingBlock:^(CXActionItemButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [_itemButtons removeAllObjects];
    
    if(itemNodes){
        [_itemNodes addObjectsFromArray:itemNodes];
    }
    
    [self itemNodesDidChanged];
}

- (void)itemNodesDidChanged{
    NSUInteger rowCount = 1;
    if(_style.rowItemCount > 0){
        rowCount = _itemNodes.count / _style.rowItemCount;
        if(_itemNodes.count % _style.rowItemCount > 0){
            rowCount ++;
        }
    }
    
    _suitableHeight = rowCount * _style.itemHeight;
    if(self.frame.size.height != _suitableHeight){
        if([self.delegate respondsToSelector:@selector(actionToolBar:didNeedsUpdateFrameHeight:)]){
            [self.delegate actionToolBar:self didNeedsUpdateFrameHeight:_suitableHeight];
        }
    }
    
    [_estimatedItemWidths removeAllObjects];
    
    if(_style.rowItemCount == 0){
        UIFont *font = [_style itemTitleFontForState:UIControlStateNormal];
        if(!font){
            font = CX_PingFangSC_RegularFont(15.0);
        }
        
        [_itemNodes enumerateObjectsUsingBlock:^(CXActionToolBarItemNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CGFloat width = [CXStringBounding bounding:obj.title
                                          rectWithSize:CGSizeMake(self.bounds.size.width * 0.4, self->_style.itemHeight)
                                                  font:font].size.width;
            if(obj.image){
                width += obj.imageSize.width + 5.0;
            }
            
            width += 30.0;
            [self->_estimatedItemWidths addObject:@(width)];
        }];
    }
    
    [self setNeedsLayout];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    NSUInteger rowItemCount = _itemNodes.count;
    if(_style.rowItemCount > 0 && rowItemCount > _style.rowItemCount){
        rowItemCount = _style.rowItemCount;
    }
    
    if(rowItemCount == 0){
        return;
    }
    
    _contentView.frame = self.bounds;
    CGSize contentSize = self.bounds.size;
    [self setupSubViewsIfNeed];
    
    CGFloat topLine_X = 0;
    CGFloat topLine_Y = 0;
    CGFloat topLine_H = _style.isHiddenTopSeparatorLine ? 0 : _style.separatorLineWidth;
    CGFloat topLine_W = self.bounds.size.width - topLine_X * 2;
    _topLine.frame = (CGRect){topLine_X, topLine_Y, topLine_W, topLine_H};
    
    CGFloat bottomLine_X = topLine_X;
    CGFloat bottomLine_W = topLine_W;
    CGFloat bottomLine_H = _style.isHiddenBottomSeparatorLine ? 0 : _style.separatorLineWidth;
    CGFloat bottomLine_Y = self.bounds.size.height - bottomLine_H;
    _bottomLine.frame = (CGRect){bottomLine_X, bottomLine_Y, bottomLine_W, bottomLine_H};
    
    CGFloat vLine_H = _style.verticalLineHeight;
    CGFloat vLine_W = _style.isHiddenVerticalSeparatorLine ? 0 : _style.separatorLineWidth;
    
    CGFloat itemButton_H = _style.itemHeight;
    __block CGFloat itemButton_W = (contentSize.width - (rowItemCount - 1) * vLine_W) / rowItemCount;
    __block CGFloat itemButton_X = 0;
    
    [_itemButtons enumerateObjectsUsingBlock:^(CXActionItemButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.tag = idx;
        
        if(idx < self->_itemNodes.count){
            obj.hidden = NO;
            [self actionItemButton:obj assembleItemNode:self->_itemNodes[idx]];
            
            CGFloat itemButton_Y = 0;
            CGFloat vLine_Y = 0;
            CGFloat vLine_X = 0;
            
            if(self->_style.rowItemCount == 0){
                if(idx < self->_estimatedItemWidths.count){
                    itemButton_W = self->_estimatedItemWidths[idx].doubleValue;
                }else{
                    itemButton_W = 100.0;
                }
                
                if(!self->_style.isHiddenVerticalSeparatorLine){
                    vLine_X = itemButton_X + itemButton_W;
                    if(idx < self->_vLines.count){
                        vLine_Y = itemButton_Y + (itemButton_H - vLine_H) * 0.5;
                        CALayer *vLine = self->_vLines[idx];
                        vLine.frame = (CGRect){vLine_X, vLine_Y, vLine_W, vLine_H};
                    }
                }
            }else{
                NSUInteger row = idx / self->_style.rowItemCount;
                NSUInteger column = idx % self->_style.rowItemCount;
                itemButton_X = (itemButton_W + vLine_W) * column;
                itemButton_Y = itemButton_H * row;
                
                if(!self->_style.isHiddenVerticalSeparatorLine){
                    if(column > 0 && column < self->_style.rowItemCount){
                        NSUInteger vLineIndex = row * (self->_style.rowItemCount - 1) + column - 1;
                        vLine_X = itemButton_X - vLine_W;
                        vLine_Y = itemButton_Y + (itemButton_H - vLine_H) * 0.5;
                        CALayer *vLine = self->_vLines[vLineIndex];
                        vLine.frame = (CGRect){vLine_X, vLine_Y, vLine_W, vLine_H};
                    }
                    
                    // 处理最后一条竖线的frame，如果itemButton不是第一行且不是这行的最后一个，则需要显示后面的竖线
                    if(row > 0 && idx == self->_itemButtons.count - 1 && column != self->_style.rowItemCount - 1){
                        vLine_X = itemButton_X + itemButton_W;
                        vLine_Y = itemButton_Y + (itemButton_H - vLine_H) * 0.5;
                        CALayer *vLine = self->_vLines.lastObject;
                        vLine.frame = (CGRect){vLine_X, vLine_Y, vLine_W, vLine_H};
                    }
                }
            }
            
            obj.frame = (CGRect){itemButton_X, itemButton_Y, itemButton_W, itemButton_H};
            itemButton_X += itemButton_W + vLine_W;
        }else{
            obj.hidden = YES;
        }
    }];
    
    NSUInteger vLineCount = [self vLineCount];
    [_vLines enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.hidden = self->_style.isHiddenVerticalSeparatorLine || idx >= vLineCount;
    }];
    
    if(_style.rowItemCount == 0 && _itemNodes.count > 0){
        CXActionItemButton *itemButton = _itemButtons[_itemNodes.count - 1];
        contentSize.width = CGRectGetMaxX(itemButton.frame);
    }
    
    _contentView.contentSize = contentSize;
}

- (void)setupSubViewsIfNeed{
    NSInteger newItemCount = _itemNodes.count - _itemButtons.count;
    for(NSInteger index = 0; index < newItemCount; index ++){
        CXActionItemButton *itemButton = nil;
        if([self.delegate respondsToSelector:@selector(actionToolBar:createItemButtonWithItemNode:)]){
            itemButton = [self.delegate actionToolBar:self createItemButtonWithItemNode:_itemNodes[_itemButtons.count]];
        }
        
        if(!itemButton){
            itemButton = [CXActionItemButton buttonWithType:UIButtonTypeCustom];
        }
        
        itemButton.enableHighlighted = [self enableActionItemButtonHighlighted];
        [itemButton addTarget:self action:@selector(triggerActionForItemButton:) forControlEvents:UIControlEventTouchUpInside];
        [_style enumerateTitleFontsForHandler:^(NSNumber *key, UIFont *obj, BOOL *stop) {
            [itemButton setTitleFont:obj forState:key.unsignedIntegerValue];
        }];
        
        [_style enumerateTitleColorsForHandler:^(NSNumber *key, UIColor *obj, BOOL *stop) {
            [itemButton setTitleColor:obj forState:key.unsignedIntegerValue];
        }];
        
        [_style enumerateBackgroundColorsForHandler:^(NSNumber *key, UIColor *obj, BOOL *stop) {
            [itemButton cx_setBackgroundColor:obj forState:key.unsignedIntegerValue];
        }];
        
        [_contentView addSubview:itemButton];
        [_itemButtons addObject:itemButton];
    }
    
    NSInteger newVLineCount = [self vLineCount] - _vLines.count;
    for(NSInteger index = 0; index < newVLineCount; index ++){
        CALayer *vLine = [CALayer layer];
        vLine.backgroundColor = _style.separatorLineColor.CGColor;
        [_contentView.layer addSublayer:vLine];
        [_vLines addObject:vLine];
    }
}

- (void)setSelectItemAtIndex:(NSUInteger)index
             scrollToVisible:(BOOL)scrollToVisible
              notifyDelegate:(BOOL)notifyDelegate{
    if(index >= _itemButtons.count){
        return;
    }
    
    CXActionToolBarItemNode *itemNode = [self itemNodeOfIndex:index];
    if(!itemNode){
        return;
    }
    
    CXActionItemButton *itemButton = _itemButtons[index];
    if(itemButton.isSelected){
        return;
    }
    
    [_itemButtons enumerateObjectsUsingBlock:^(CXActionItemButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected = obj == itemButton;
    }];
    
    if(!_marker.isHidden){
        CGFloat marker_W = (_style.markerSize.width > 0 ? _style.markerSize.width : CGRectGetWidth(itemButton.frame)) + _style.markerOffset.horizontal;
        CGFloat marker_H = _style.markerSize.height;
        CGFloat marker_X = CGRectGetMidX(itemButton.frame) - marker_W * 0.5;
        CGFloat marker_Y = CGRectGetMaxY(itemButton.frame) - marker_H + _style.markerOffset.vertical;
        CGRect markerFrame = (CGRect){marker_X, marker_Y, marker_W, marker_H};
        if(CGSizeEqualToSize(_marker.frame.size, CGSizeZero)){
            _marker.frame = markerFrame;
        }else{
            [UIView animateWithDuration:0.25 animations:^{
                self->_marker.frame = markerFrame;
            }];
        }
    }
    
    [self setSelectedItemNode:itemNode forIndex:index notifyDelegate:notifyDelegate];
    
    if(scrollToVisible){
        [self scrollView:_contentView scrollItemButtonToVisible:itemButton];
    }
    
    if(notifyDelegate && [self.delegate respondsToSelector:@selector(actionToolBar:didClickedItemNode:atIndex:)]){
        [self.delegate actionToolBar:self didClickedItemNode:itemNode atIndex:index];
    }
}

- (void)scrollView:(UIScrollView *)scrollView scrollItemButtonToVisible:(UIView *)itemButton{
    
}

- (NSUInteger)vLineCount{
    NSUInteger itemNodeCount = _itemNodes.count;
    if(itemNodeCount == 0){
        return 0;
    }
    
    if(_style.rowItemCount == 0){
        return itemNodeCount - 1;
    }
    
    NSUInteger row = itemNodeCount / _style.rowItemCount;
    NSUInteger vLineCount = row * (_style.rowItemCount - 1);
    if(itemNodeCount % _style.rowItemCount > 0){
        vLineCount += (itemNodeCount % _style.rowItemCount) + row > 0 ? 1 : 0;
    }
    
    return vLineCount;
}

- (void)triggerActionForItemButton:(CXActionItemButton *)itemButton{
    [self setSelectItemAtIndex:itemButton.tag scrollToVisible:NO notifyDelegate:YES];
}

- (void)setSelectedItemNode:(CXActionToolBarItemNode *)itemNode
                   forIndex:(NSUInteger)index
             notifyDelegate:(BOOL)notifyDelegate{
    
}

- (BOOL)enableActionItemButtonHighlighted{
    return YES;
}

@end
