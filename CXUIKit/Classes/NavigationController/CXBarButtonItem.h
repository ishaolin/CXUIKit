//
//  CXBarButtonItem.h
//  Pods
//
//  Created by wshaolin on 2017/5/17.
//
//

#import <UIKit/UIKit.h>

@class CXNavigationConfig;

@interface CXBarButtonItem : NSObject

@property (nonatomic, strong, readonly) UIView *view;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign, getter = isEnabled) BOOL enabled;
@property (nonatomic, assign, getter = isHidden) BOOL hidden;
@property (nonatomic, assign) UIStatusBarStyle style;
@property (nonatomic, assign, readonly) BOOL isCustomed;

- (instancetype)initWithImage:(UIImage *)normalImage
             highlightedImage:(UIImage *)highlightedImage
                       target:(id)target
                       action:(SEL)action;

- (instancetype)initWithTitle:(NSString *)title
                       target:(id)target
                       action:(SEL)action;

- (instancetype)initWithCustomView:(UIView *)customView;

- (void)setBarButtonItemStyleWithConfig:(CXNavigationConfig *)config;

@end

@interface CXBarButtonItem (CXUIKit)

+ (instancetype)buttonItemWithTarget:(id)target action:(SEL)action;

- (void)setImageWithURL:(NSString *)url;

- (void)setImageWithURL:(NSString *)url forState:(UIControlState)state;

@end
