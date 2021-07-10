//
//  CXNavigationItem.h
//  Pods
//
//  Created by wshaolin on 2017/5/17.
//
//

#import "CXBarButtonItem.h"
#import "CXNavigationTitleView.h"

@class CXNavigationItem;
@class CXNavigationConfig;

@protocol CXNavigationItemDelegate <NSObject>

@optional

- (void)navigationItem:(CXNavigationItem *)navigationItem didClickBackBarButtonItem:(CXBarButtonItem *)backBarButtonItem;

- (void)navigationItemNoticeNavigationBarLayout:(CXNavigationItem *)navigationItem;

@end

@interface CXNavigationItem : NSObject

+ (instancetype)navigationItem;

- (instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle;

@property (nonatomic, weak) id<CXNavigationItemDelegate> delegate;

@property (nonatomic, strong, readonly) CXNavigationTitleView *titleView;
@property (nonatomic, strong) UIView *customTitleView;

@property (nonatomic, assign, getter = isAutoSetCustomTitleViewFrame) BOOL autoSetCustomTitleViewFrame;

@property (nonatomic, strong, readonly) CXBarButtonItem *backBarButtonItem;

/*!
 *  @brief 如果leftBarButtonItems.count大于1时，设置leftBarButtonItem无效
 */
@property (nonatomic, strong) CXBarButtonItem *leftBarButtonItem;

/*!
 *  @brief 如果rightBarButtonItems.count大于1时，设置rightBarButtonItem无效
 */
@property (nonatomic, strong) CXBarButtonItem *rightBarButtonItem;

/*!
 *  @brief 设置leftBarButtonItems且count大于1时，leftBarButtonItem会被设置为nil, leftBarButtonItems最多2个，多于2个时设置失败
 */
@property (nonatomic, copy) NSArray<CXBarButtonItem *> *leftBarButtonItems;

/*!
 *  @brief 设置rightBarButtonItems且count大于1时，rightBarButtonItem会被设置为nil，rightBarButtonItems最多2个，多于2个时设置失败
 */
@property (nonatomic, copy) NSArray<CXBarButtonItem *> *rightBarButtonItems;

/*!
 *  @brief 更新样式
 */
- (void)setUpdateStyleIfNeed:(UIStatusBarStyle)style;

- (void)setUpdateStyleWithConfig:(CXNavigationConfig *)config;

@end
