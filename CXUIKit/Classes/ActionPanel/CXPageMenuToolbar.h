//
//  CXPageMenuToolbar.h
//  Pods
//
//  Created by wshaolin on 2019/1/10.
//

#import "CXActionToolBar.h"

@class CXPageMenuToolbar;

@protocol CXPageMenuToolbarDelegate <CXActionToolBarDelegate>

@optional

- (void)pageMenuToolbar:(CXPageMenuToolbar *)pageMenuToolbar
   didSelectItemAtIndex:(NSUInteger)index
              fromIndex:(NSUInteger)fromIndex;

@end

@interface CXPageMenuToolbar : CXActionToolBar

@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, strong, readonly) CXActionToolBarItemNode *selectedItemNode;
@property (nonatomic, weak) id<CXPageMenuToolbarDelegate> delegate;

- (void)triggerDelegateSelectedNotice;

@end
