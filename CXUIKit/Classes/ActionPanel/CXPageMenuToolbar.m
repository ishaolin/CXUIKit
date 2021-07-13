//
//  CXPageMenuToolbar.m
//  Pods
//
//  Created by wshaolin on 2019/1/10.
//

#import "CXPageMenuToolbar.h"
#import "UIColor+CXUIKit.h"

@implementation CXPageMenuToolbar

@dynamic delegate;

- (instancetype)initWithItemNodes:(NSArray<CXActionToolBarItemNode *> *)itemNodes style:(CXActionToolBarStyle *)style{
    if(!style){
        style = [[CXActionToolBarStyle alloc] init];
        style.hiddenTopSeparatorLine = YES;
        style.hiddenVerticalSeparatorLine = YES;
        style.hiddenBottomSeparatorLine = NO;
    }
    
    if(self = [super initWithItemNodes:itemNodes style:style]){
        _selectedIndex = NSNotFound;
        self.marker.backgroundColor = CXHexIColor(0x1DBEFF).CGColor;
    }
    
    return self;
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex{
    [self setSelectItemAtIndex:selectedIndex scrollToVisible:YES notifyDelegate:NO];
}

- (void)triggerDelegateSelectedNotice{
    if(!self.selectedItemNode){
        return;
    }
    
    if([self.delegate respondsToSelector:@selector(pageMenuToolbar:didSelectItemAtIndex:fromIndex:)]){
        [self.delegate pageMenuToolbar:self didSelectItemAtIndex:self.selectedIndex fromIndex:NSNotFound];
    }
}

- (void)setSelectedItemNode:(CXActionToolBarItemNode *)itemNode
                   forIndex:(NSUInteger)index
             notifyDelegate:(BOOL)notifyDelegate{
    NSUInteger fromIndex = self.selectedIndex;
    _selectedIndex = index;
    _selectedItemNode = itemNode;
    
    if(!notifyDelegate){
        return;
    }
    
    if([self.delegate respondsToSelector:@selector(pageMenuToolbar:didSelectItemAtIndex:fromIndex:)]){
        [self.delegate pageMenuToolbar:self didSelectItemAtIndex:index fromIndex:fromIndex];
    }
}

- (void)scrollView:(UIScrollView *)scrollView scrollItemButtonToVisible:(UIView *)itemButton{
    if(scrollView.contentSize.width > CGRectGetWidth(scrollView.bounds)){
        CGRect rect = [scrollView convertRect:itemButton.bounds fromView:itemButton];
        [scrollView scrollRectToVisible:rect animated:YES];
    }
}

- (BOOL)enableActionItemButtonHighlighted{
    return NO;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if(CGRectGetWidth(self.bounds) > 0 && CGRectGetHeight(self.bounds) > 0){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self setSelectItemAtIndex:(self->_selectedIndex == NSNotFound) ? 0 : self->_selectedIndex
                       scrollToVisible:YES
                        notifyDelegate:YES];
        });
    }
}

@end
