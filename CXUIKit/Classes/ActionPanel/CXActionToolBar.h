//
//  CXActionToolBar.h
//  Pods
//
//  Created by wshaolin on 2017/11/20.
//

#import "CXActionToolBarStyle.h"
#import "CXActionToolBarItemNode.h"

@class CXActionToolBar;
@class CXActionItemButton;

@protocol CXActionToolBarDelegate <NSObject>

@optional

- (void)actionToolBar:(CXActionToolBar *)actionToolBar didClickedItemNode:(CXActionToolBarItemNode *)itemNode atIndex:(NSUInteger)index;

- (void)actionToolBar:(CXActionToolBar *)actionToolBar didNeedsUpdateFrameHeight:(CGFloat)frameHeight;

// 需要自定义某些按钮样式的时候实现
- (CXActionItemButton *)actionToolBar:(CXActionToolBar *)actionToolBar createItemButtonWithItemNode:(CXActionToolBarItemNode *)itemNode;

@end

@interface CXActionToolBar : UIView

@property (nonatomic, weak) id<CXActionToolBarDelegate> delegate;

@property (nonatomic, strong, readonly) CXActionToolBarStyle *style;
@property (nonatomic, assign, readonly) CGFloat suitableHeight;
@property (nonatomic, assign, readonly) NSUInteger itemCount;

@property (nonatomic, strong) CALayer *marker;

- (instancetype)initWithItemTitles:(NSArray<NSString *> *)itemTitles;

- (instancetype)initWithItemTitles:(NSArray<NSString *> *)itemTitles style:(CXActionToolBarStyle *)style;

- (instancetype)initWithItemNodes:(NSArray<CXActionToolBarItemNode *> *)itemNodes;

- (instancetype)initWithItemNodes:(NSArray<CXActionToolBarItemNode *> *)itemNodes style:(CXActionToolBarStyle *)style;

- (CXActionToolBarItemNode *)itemNodeOfIndex:(NSUInteger)index;
- (NSUInteger)indexOfItemNode:(CXActionToolBarItemNode *)itemNode;

- (void)addItemNode:(CXActionToolBarItemNode *)itemNode;
- (void)insertItemNode:(CXActionToolBarItemNode *)itemNode atIndex:(NSUInteger)index;

- (void)updateItemNode:(CXActionToolBarItemNode *)itemNode atIndex:(NSUInteger)index;

- (void)removeItemNode:(CXActionToolBarItemNode *)itemNode;
- (void)removeItemNodeAtIndex:(NSUInteger)index;

- (void)resetItemNodes:(NSArray<CXActionToolBarItemNode *> *)itemNodes;

- (void)setSelectItemAtIndex:(NSUInteger)index scrollToVisible:(BOOL)scrollToVisible notifyDelegate:(BOOL)notifyDelegate;

@end
