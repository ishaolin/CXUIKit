//
//  CXAlertControllerUtils.m
//  Pods
//
//  Created by wshaolin on 2017/6/14.
//
//

#import "CXAlertControllerUtils.h"
#import "CXAlertPanel.h"
#import "CXActionSheetPanel.h"

@implementation CXAlertControllerUtils

+ (void)showAlertWithConfigBlock:(CXAlertControllerConfigBlock)configBlock
                      completion:(CXAlertControllerCompletionBlock)completion{
    [self showAlertWithConfigBlock:configBlock
                        completion:completion
                       cancelBlock:nil];
}

+ (void)showAlertWithConfigBlock:(CXAlertControllerConfigBlock)configBlock
                      completion:(CXAlertControllerCompletionBlock)completion
                     cancelBlock:(CXAlertControllerCancelBlock)cancelBlock{
    if(!configBlock){
        return;
    }
    
    CXAlertControllerConfigModel *configModel = [[CXAlertControllerConfigModel alloc] init];
    configBlock(configModel);
    [self showAlertWithConfigModel:configModel
                        completion:completion
                       cancelBlock:cancelBlock];
}

+ (void)showAlertWithConfigModel:(CXAlertControllerConfigModel *)configModel
                      completion:(CXAlertControllerCompletionBlock)completion
                     cancelBlock:(CXAlertControllerCancelBlock)cancelBlock{
    [[CXAlertActionPanel activeActionPanel] cancel];
    
    CXAlertPanel *alertPanel = [[CXAlertPanel alloc] init];
    alertPanel.title = configModel.title;
    alertPanel.message = configModel.message;
    [configModel.buttonTitles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CXAlertPanelItemModel *itemModel = [[CXAlertPanelItemModel alloc] init];
        itemModel.title = obj;
        itemModel.destructive = (idx == configModel.destructiveIndex);
        if(configModel.destructiveIndex == NSNotFound && idx == configModel.buttonTitles.count - 1){
            itemModel.destructive = YES;
        }
        
        [alertPanel addActionItemModel:itemModel];
    }];
    
    if(cancelBlock){
        alertPanel.cancelBlock = ^(CXAlertActionPanel *panel) {
            cancelBlock();
        };
    }
    
    if(configModel.viewController){
        [alertPanel showInViewController:configModel.viewController completion:^(CXAlertActionPanel *panel, CXAlertActionItemModel *itemModel, NSInteger index) {
            if(completion){
                completion(index);
            }
        }];
    }else{
        [alertPanel showInWindow:configModel.window completion:^(CXAlertActionPanel *panel, CXAlertActionItemModel *itemModel, NSInteger index) {
            if(completion){
                completion(index);
            }
        }];
    }
}

@end

NSInteger const CXActionSheetCancelButtonIndex = -1;

@implementation CXActionSheetUtils

+ (void)showActionSheetWithConfigBlock:(CXActionSheetControllerConfigBlock)configBlock
                            completion:(CXActionSheetCompletionBlock)completion{
    [self showActionSheetWithConfigBlock:configBlock
                              completion:completion
                             cancelBlock:nil];
}

+ (void)showActionSheetWithConfigBlock:(CXActionSheetControllerConfigBlock)configBlock
                            completion:(CXActionSheetCompletionBlock)completion
                           cancelBlock:(CXActionSheetCancelBlock)cancelBlock{
    if(!configBlock){
        return;
    }
    
    CXActionSheetControllerConfigModel *configModel = [[CXActionSheetControllerConfigModel alloc] init];
    configBlock(configModel);
    [self showActionSheetWithConfigModel:configModel
                              completion:completion
                             cancelBlock:cancelBlock];
}

+ (void)showActionSheetWithConfigModel:(CXActionSheetControllerConfigModel *)configModel
                            completion:(CXActionSheetCompletionBlock)completion
                           cancelBlock:(CXActionSheetCancelBlock)cancelBlock{
    [[CXAlertActionPanel activeActionPanel] cancel];
    
    CXActionSheetPanel *actionSheetPanel = [[CXActionSheetPanel alloc] init];
    actionSheetPanel.title = configModel.title;
    [configModel.buttonTitles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CXAlertActionItemModel *actionItemModel = [[CXAlertActionItemModel alloc] init];
        actionItemModel.title = obj;
        actionItemModel.destructive = (idx == configModel.destructiveIndex);
        [actionSheetPanel addActionItemModel:actionItemModel];
    }];
    
    if(!CXStringIsEmpty(configModel.cancelButtonTitle)){
        CXAlertActionItemModel *cancelItemModel = [[CXAlertActionItemModel alloc] init];
        cancelItemModel.title = configModel.cancelButtonTitle;
        actionSheetPanel.cancelItemModel = cancelItemModel;
    }
    
    if(cancelBlock){
        actionSheetPanel.cancelBlock = ^(CXAlertActionPanel *panel) {
            cancelBlock();
        };
    }
    
    if(configModel.viewController){
        [actionSheetPanel showInViewController:configModel.viewController completion:^(CXAlertActionPanel *panel, CXAlertActionItemModel *itemModel, NSInteger index) {
            if(completion){
                completion(index);
            }
        }];
    }else{
        [actionSheetPanel showInWindow:configModel.window completion:^(CXAlertActionPanel *panel, CXAlertActionItemModel *itemModel, NSInteger index) {
            if(completion){
                completion(index);
            }
        }];
    }
}

@end

@implementation CXActionControllerConfigModel

- (instancetype)init{
    if(self = [super init]){
        _destructiveIndex = NSNotFound;
    }
    
    return self;
}

@end

@implementation CXAlertControllerConfigModel

- (instancetype)init{
    if(self = [super init]){
        self.title = @"";
        self.buttonTitles = @[@"我知道了"];
    }
    
    return self;
}

@end

@implementation CXActionSheetControllerConfigModel

- (instancetype)init{
    if(self = [super init]){
        _cancelButtonTitle = @"取消";
    }
    
    return self;
}

@end
