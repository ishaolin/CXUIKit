//
//  CXAlertControllerUtils.h
//  Pods
//
//  Created by wshaolin on 2017/6/14.
//
//

#import <Foundation/Foundation.h>
#import "CXUIKitDefines.h"

@class CXAlertControllerConfigModel;

typedef void(^CXAlertControllerConfigBlock)(CXAlertControllerConfigModel *config);
typedef void(^CXAlertControllerCompletionBlock)(NSUInteger buttonIndex);
typedef void(^CXAlertControllerCancelBlock)(void);

@interface CXAlertControllerUtils : NSObject

+ (void)showAlertWithConfigBlock:(CXAlertControllerConfigBlock)configBlock
                      completion:(CXAlertControllerCompletionBlock)completion;

+ (void)showAlertWithConfigBlock:(CXAlertControllerConfigBlock)configBlock
                      completion:(CXAlertControllerCompletionBlock)completion
                     cancelBlock:(CXAlertControllerCancelBlock)cancelBlock;

@end

CX_UIKIT_EXTERN NSInteger const CXActionSheetCancelButtonIndex;

@class CXActionSheetControllerConfigModel;

typedef void(^CXActionSheetControllerConfigBlock)(CXActionSheetControllerConfigModel *config);
typedef void(^CXActionSheetCompletionBlock)(NSInteger buttonIndex);
typedef void(^CXActionSheetCancelBlock)(void);

@interface CXActionSheetUtils : NSObject

+ (void)showActionSheetWithConfigBlock:(CXActionSheetControllerConfigBlock)configBlock
                            completion:(CXActionSheetCompletionBlock)completion;

+ (void)showActionSheetWithConfigBlock:(CXActionSheetControllerConfigBlock)configBlock
                            completion:(CXActionSheetCompletionBlock)completion
                           cancelBlock:(CXActionSheetCancelBlock)cancelBlock;

@end

@class UIViewController;
@class UIWindow;

@interface CXActionControllerConfigModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSArray<NSString *> *buttonTitles;
@property (nonatomic, weak) UIViewController *viewController; // Optional
@property (nonatomic, weak) UIWindow *window; // Optional
@property (nonatomic, assign) NSInteger destructiveIndex; // Default NSNotFound

@end

@interface CXAlertControllerConfigModel : CXActionControllerConfigModel

@property (nonatomic, copy) NSString *message;

@end

@interface CXActionSheetControllerConfigModel : CXActionControllerConfigModel

@property (nonatomic, copy) NSString *cancelButtonTitle; // Default "取消"

@end
