//
//  CXBaseActionPanel.h
//  Pods
//
//  Created by wshaolin on 2018/5/21.
//

#import <UIKit/UIKit.h>
#import "CXBaseActionDefines.h"

typedef NS_ENUM(NSInteger, CXActionPanelOverlayStyle) {
    CXActionPanelOverlayStyleDark             = 0, // 背景蒙层半透明
    CXActionPanelOverlayStyleClear            = 1, // 背景蒙层全透明
    CXActionPanelOverlayStyleBlurExtraLight   = 2, // 背景蒙层高斯模糊（ExtraLight）
    CXActionPanelOverlayStyleBlurLight        = 3, // 背景蒙层高斯模糊（Light）
    CXActionPanelOverlayStyleBlurDark         = 4  // 背景蒙层高斯模糊（Dark）
};

typedef NS_ENUM(NSInteger, CXActionPanelAnimationType) {
    CXActionPanelAnimationUp     = 0, // 从下往上
    CXActionPanelAnimationDown   = 1, // 从上往下
    CXActionPanelAnimationCenter = 2, // 从中间弹出
    CXActionPanelAnimationCustom = 3  // 需实现showAnimationWithSuperView:和dismissAnimationWithSuperView:方法。供子类扩展
};

@class CXBaseActionPanel;

typedef void(^CXActionPanelHandler)(CXBaseActionPanel *actionPanel);

@protocol CXActionPanelDelegate <NSObject>

@optional

- (void)actionPanelWillPresent:(CXBaseActionPanel *)actionPanel;
- (void)actionPanelDidPresent:(CXBaseActionPanel *)actionPanel;
- (void)actionPanelWillDismiss:(CXBaseActionPanel *)actionPanel;
- (void)actionPanelDidDismiss:(CXBaseActionPanel *)actionPanel;

@end

@interface CXBaseActionPanel : UIView

@property (nonatomic, assign)  NSTimeInterval animationDuration;
@property (nonatomic, weak) id<CXActionPanelDelegate> delegate;
@property (nonatomic, assign) CXActionPanelAnimationType animationType;

@property (nonatomic, assign) CXActionPanelOverlayStyle overlayStyle; // Default = CXActionPanelOverlayStyleDark;
@property (nonatomic, strong) UIColor *overlayBackgroundColor;

@property (nonatomic, assign) CGSize panelSize;

@property (nonatomic, assign, getter = isDismissWhenTapOverlayView) BOOL dismissWhenTapOverlayView; // Default = YES;

@property (nonatomic, copy) CXActionPanelHandler willPresentHandler;
@property (nonatomic, copy) CXActionPanelHandler didPresentHandler;
@property (nonatomic, copy) CXActionPanelHandler willDismissHandler;
@property (nonatomic, copy) CXActionPanelHandler didDismissHandler;

- (void)showInView:(UIView *)view;
- (void)showInView:(UIView *)view animated:(BOOL)animated;

- (void)showInViewController:(UIViewController *)viewController;
- (void)showInViewController:(UIViewController *)viewController animated:(BOOL)animated;

- (void)showInWindow:(UIWindow *)window;
- (void)showInWindow:(UIWindow *)window animated:(BOOL)animated;

- (void)dismissWithAnimated:(BOOL)animated;

- (void)setPanelSize:(CGSize)panelSize animated:(BOOL)animated;

- (CXActionAnimationBlock)showAnimationWithSuperView:(UIView *)superView;

- (CXActionAnimationBlock)dismissAnimationWithSuperView:(UIView *)superView;

- (void)willPresent;
- (void)didPresent;
- (void)willDismiss;
- (void)didDismiss;

- (void)didAddToSuperView:(UIView *)superView;

- (void)dismissForRotateScreen;
- (void)dismissForTapOverlayView:(UITouch *)touch;

// 子类重写可以实现自己的蒙层; 不需要蒙层时请return nil;
- (UIView *)overlayView;

+ (UIWindow *)overlayWindow;

@end
