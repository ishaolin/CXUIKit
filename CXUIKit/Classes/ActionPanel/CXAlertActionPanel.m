//
//  CXAlertActionPanel.m
//  Pods
//
//  Created by wshaolin on 2018/8/30.
//

#import "CXAlertActionPanel.h"
#import "UIFont+CXExtensions.h"
#import "UIColor+CXExtensions.h"
#import "UIButton+CXExtensions.h"

static CXAlertActionPanel *_ActiveActionPanel = nil;

@interface CXAlertActionPanel () {
    NSMutableArray<CXAlertActionItemModel *> *_actionItmeModels;
}

@property (nonatomic, copy) CXAlertActionPanelCompletionBlock completionBlock;

@end

@implementation CXAlertActionPanel

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor whiteColor];
        
        _actionItmeModels = [NSMutableArray array];
    }
    
    return self;
}

- (NSArray<CXAlertActionItemModel *> *)actionItemModels{
    return [_actionItmeModels copy];
}

- (void)addActionItemModel:(CXAlertActionItemModel *)actionItemModel{
    if(!actionItemModel){
        return;
    }
    
    [_actionItmeModels addObject:actionItemModel];
}

- (void)showInViewController:(UIViewController *)viewController
                  completion:(CXAlertActionPanelCompletionBlock)completion{
    self.completionBlock = completion;
    if(viewController){
        [self layoutForSupperRect:viewController.view.bounds];
    }else{
        [self layoutForSupperRect:[self.class overlayWindow].bounds];
    }
    [self showInViewController:viewController];
    
    _ActiveActionPanel = self;
}

- (void)showInWindow:(UIWindow *)window
          completion:(CXAlertActionPanelCompletionBlock)completion{
    self.completionBlock = completion;
    if(window){
        [self layoutForSupperRect:window.bounds];
    }else{
        [self layoutForSupperRect:[self.class overlayWindow].bounds];
    }
    [self showInWindow:window];
    
    _ActiveActionPanel = self;
}

- (void)handleActionItemAtIndex:(NSUInteger)index{
    if(index < _actionItmeModels.count){
        [self handleActionItem:_actionItmeModels[index] withIndex:index];
    }
}

- (void)handleActionItem:(CXAlertActionItemModel *)actionItemModel withIndex:(NSInteger)index{
    !self.completionBlock ?: self.completionBlock(self, actionItemModel, index);
    self.completionBlock = nil;
    
    [self dismissWithAnimated:YES];
}

- (void)layoutForSupperRect:(CGRect)rect{
    
}

- (void)cancel{
    !self.cancelBlock ?: self.cancelBlock(self);
    self.cancelBlock = nil;
    
    [self dismissWithAnimated:YES];
}

- (void)didDismiss{
    _ActiveActionPanel = nil;
}

+ (CXAlertActionPanel *)activeActionPanel{
    return _ActiveActionPanel;
}

@end

@implementation CXAlertActionItemModel

@end

@implementation CXAlertActionItemButton

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.titleLabel.font = CX_PingFangSC_RegularFont(17.0);
        [self setTitleColor:CXHexIColor(0x999999) forState:UIControlStateDisabled];
        [self cx_setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self cx_setBackgroundColor:CXHexIColor(0xEEEEEE) forState:UIControlStateHighlighted];
    }
    
    return self;
}

@end
