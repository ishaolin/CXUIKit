//
//  CXHUD.h
//  Pods
//
//  Created by wshaolin on 2017/11/24.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CXHUDBackgroundStyle){
    CXHUDBackgroundStyleClear = 0, // 全透明
    CXHUDBackgroundStyleDark  = 1, // 半透明
    CXHUDBackgroundStyleBlur  = 2  // 高斯模糊
};

UIKIT_EXTERN void CXSetHUDBackgroundStyle(CXHUDBackgroundStyle style);
UIKIT_EXTERN CXHUDBackgroundStyle CXGetHUDBackgroundStyle(void);

@interface CXHUD : UIView

+ (CXHUD *)showHUD;

+ (CXHUD *)showHUD:(NSString *)msg;

+ (CXHUD *)showHUDAddedTo:(UIView *)view;

+ (CXHUD *)showHUDAddedTo:(UIView *)view animated:(BOOL)animated;

+ (CXHUD *)showHUDAddedTo:(UIView *)view msg:(NSString *)msg animated:(BOOL)animated;

+ (BOOL)dismiss;

+ (BOOL)dismissForView:(UIView *)view;

+ (BOOL)dismissForView:(UIView *)view completion:(void(^)(void))completion;

+ (BOOL)dismissForView:(UIView *)view animated:(BOOL)animated completion:(void(^)(void))completion;

+ (CXHUD *)showMsg:(NSString *)msg;

+ (CXHUD *)showMsg:(NSString *)msg completion:(void(^)(void))completion;

+ (CXHUD *)showMsg:(NSString *)msg HUDAddedTo:(UIView *)view completion:(void(^)(void))completion;

+ (CXHUD *)showMsg:(NSString *)msg HUDAddedTo:(UIView *)view delay:(NSTimeInterval)delay completion:(void(^)(void))completion;

- (void)setHUDCenterPoint:(CGPoint)centerPoint;

- (void)dismiss;

@end
