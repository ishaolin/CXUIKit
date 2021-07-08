//
//  CXAlertActionPanel.h
//  Pods
//
//  Created by wshaolin on 2018/8/30.
//

#import "CXBaseActionPanel.h"

@class CXAlertActionPanel;
@class CXAlertActionItemModel;

typedef void(^CXAlertActionPanelCompletionBlock)(CXAlertActionPanel *panel,
                                                 CXAlertActionItemModel *itemModel,
                                                 NSInteger index);

typedef void(^CXAlertActionPanelCancelBlock)(CXAlertActionPanel *panel);

@interface CXAlertActionPanel : CXBaseActionPanel

@property (nonatomic, strong, readonly) NSArray<CXAlertActionItemModel *> *actionItemModels;
@property (nonatomic, copy) CXAlertActionPanelCancelBlock cancelBlock;

- (void)addActionItemModel:(CXAlertActionItemModel *)actionItemModel;

- (void)showInViewController:(UIViewController *)viewController
                  completion:(CXAlertActionPanelCompletionBlock)completion;

- (void)showInWindow:(UIWindow *)window
          completion:(CXAlertActionPanelCompletionBlock)completion;

- (void)handleActionItemAtIndex:(NSUInteger)index;

- (void)handleActionItem:(CXAlertActionItemModel *)actionItemModel withIndex:(NSInteger)index;

- (void)layoutForSupperRect:(CGRect)rect;

- (void)cancel;

+ (CXAlertActionPanel *)activeActionPanel;

@end

@interface CXAlertActionItemModel : NSObject

@property (nonatomic, assign, getter = isDestructive) BOOL destructive;
@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) id userInfo;

@end

@interface CXAlertActionItemButton : UIButton

@end
