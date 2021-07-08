//
//  CXNavigationBar.h
//  Pods
//
//  Created by wshaolin on 2017/5/17.
//
//

#import <UIKit/UIKit.h>
#import "CXNavigationItem.h"

@class CXNavigationBar;
@class CXNavigationConfig;

@protocol CXNavigationBarDelegate <NSObject>

@optional

- (void)navigationBar:(CXNavigationBar *)navigationBar didClickBackBarButtonItem:(CXBarButtonItem *)backBarButtonItem;

- (void)navigationBar:(CXNavigationBar *)navigationBar didChangeTranslucent:(BOOL)translucent;

@end

@interface CXNavigationBar : UIView

@property (nonatomic, strong, readonly) CXNavigationItem *navigationItem;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, assign) UIEdgeInsets contentInset;

@property (nonatomic, weak) id<CXNavigationBarDelegate> delegate;

@property (nonatomic, assign, getter = isHiddenBottomHorizontalLine) BOOL hiddenBottomHorizontalLine;
@property (nonatomic, assign, getter = isTranslucent) BOOL translucent;
// defaults NO, auto hide bottom line when set YES.
@property (nonatomic, assign, getter = isShadowEnabled) BOOL shadowEnabled;

- (instancetype)initWithNavigationItem:(CXNavigationItem *)navigationItem;

+ (instancetype)navigationBar;

- (void)setUpdateStyle:(UIStatusBarStyle)style;

- (void)setUpdateStyleWithConfig:(CXNavigationConfig *)config;

- (void)setHidden:(BOOL)hidden animated:(BOOL)animated;

@end
