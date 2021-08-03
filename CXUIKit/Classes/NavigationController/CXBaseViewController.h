//
//  CXBaseViewController.h
//  Pods
//
//  Created by wshaolin on 2017/5/17.
//
//

#import "CXGesturePopInteractionController.h"
#import "CXNavigationBar.h"

typedef NS_ENUM(NSInteger, CXAnimatedTransitioningStyle){
    CXAnimatedTransitioningStyleCoverHorizontal = 0, // push & pop 效果
    CXAnimatedTransitioningStyleCoverVertical   = 1, // Present & dismiss 效果
};

@protocol CXAnimatedTransitioningSupporter <NSObject>

@required
- (CXAnimatedTransitioningStyle)animatedTransitioningStyle;

@end

@class CXBaseViewController;

@interface CXBaseViewController : UIViewController <CXGesturePopInteractionDelegate>

@property (nonatomic, assign, getter = isStatusBarHidden) BOOL statusBarHidden;
@property (nonatomic, assign, getter = isDisplaying) BOOL displaying;
@property (nonatomic, assign, readonly) BOOL isAnimating;
@property (nonatomic, strong, readonly) CXNavigationBar *navigationBar;
@property (nonatomic, copy) NSString *subtitle;

/*!
 *  @brief 注册ApplicationNotification的事件监听，默认包括如下：
 *
 *  UIApplicationWillEnterForegroundNotification
 *  UIApplicationWillResignActiveNotification
 *  UIApplicationDidEnterBackgroundNotification
 *  UIApplicationDidBecomeActiveNotification
 *  UIApplicationWillChangeStatusBarOrientationNotification
 *  UIApplicationDidChangeStatusBarOrientationNotification
 */
- (void)registerApplicationNotificationObserver;

/*!
 *  @brief 子类可以配合displaying做一些事情，例如打开和关闭一些耗资源的服务
 *
 */
- (void)willEnterForegroundNotification:(NSNotification *)notification;
- (void)willResignActiveNotification:(NSNotification *)notification;
- (void)didEnterBackgroundNotification:(NSNotification *)notification;
- (void)didBecomeActiveNotification:(NSNotification *)notification;
- (void)willChangeStatusBarOrientationNotification:(NSNotification *)notification;
- (void)didChangeStatusBarOrientationNotification:(NSNotification *)notification;

/*!
 *  @brief 数据埋点的事件（页面显示与消失）id，需要子类重写并返回对应的id，否则无埋点
 *
 */
- (NSString *)viewAppearOrDisappearRecordDataKey;

/*!
 *  @brief 数据埋点的事件（页面显示与消失）参数
 *
 */
- (NSDictionary<NSString *, id> *)viewAppearOrDisappearRecordDataParams;

/*!
 *  @brief 触发一次页面显示与消失事件的埋点，一般情况下子类无需重写和调用
 *  @param viewAppear 页面是否显示
 */
- (void)recordDataWithViewAppear:(BOOL)viewAppear;

/*!
 *  @brief 点击返回按钮（对外暴露，可拱子类重写）
 *
 *  @param backBarButtonItem 返回按钮
 */
- (void)didClickBackBarButtonItem:(CXBarButtonItem *)backBarButtonItem;

/*!
 *  @brief navigationBar是否支持透明值变化的回调，禁止直接调用（navigationBar的代理方法），通过设置navigationBar.translucent的值回调，子类有需要时可以根据此回调做一些UI布局的改变
 *
 *  @param navigationBar 导航条
 *  @param translucent   YES:导航条支持透明, NO:导航条不支持透明
 */
- (void)navigationBar:(CXNavigationBar *)navigationBar didChangeTranslucent:(BOOL)translucent;

/*!
 *  @brief 是否禁用手势侧滑返回功能，默认NO
 */
- (BOOL)disableGesturePopInteraction;

/*!
 *  @brief 页面dismiss，如果有navigationController，则调用navigationController的dismiss，否则调用自己的dismiss
 */
- (void)dismissAnimated:(BOOL)animated completion:(void (^)(void))completion;

/*!
 *  @brief 返回按钮的图片，return nil时使用默认图片
 */
- (UIImage *)backBarButtonImage;

@end
