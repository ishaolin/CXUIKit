//
//  CXPickerController.h
//  Pods
//
//  Created by wshaolin on 2021/7/6.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CXPickerFinishState){
    CXPickerFinishStateUnauthorized = -1, // 操作需要授权，但未授权或者授权失败
    CXPickerFinishStateSucceed      = 0,  // 操作成功
    CXPickerFinishStateFailed       = 1,  // 操作失败
    CXPickerFinishStateCancelled    = 2   // 取消操作
};

@class CXPickerController;

typedef void(^CXPickerControllerActionSheetBlock)(CXPickerController *pickerController);

@interface CXPickerController : NSObject

@property (nonatomic, weak, readonly) UIViewController *fromViewController;

- (instancetype)initWithFromViewController:(UIViewController *)fromViewController;

- (void)invoke;
- (void)finish;

- (void)setContentController:(UIViewController *)contentController;

@end

@interface UIViewController (CXPickerController)

@property (nonatomic, strong) CXPickerController *cx_pickerController;

@end
