//
//  CXPopActionPanel.h
//  Pods
//
//  Created by wshaolin on 2018/10/11.
//

#import "CXBaseActionPanel.h"

@class CXPopActionItem;

@interface CXPopActionPanel : CXBaseActionPanel

// Default UIControlContentHorizontalAlignmentLeft
@property (nonatomic, assign) UIControlContentHorizontalAlignment itemContentHorizontalAlignment;
@property (nonatomic, assign) CGFloat rowHeight;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIColor *titleHighlightedColor;

@property (nonatomic, assign) CGFloat arrowSize; // 默认10.0
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) UIEdgeInsets contentEdgeInsets;
@property (nonatomic, assign) CGFloat itemImageTitleMargin; // 图标和文字之前的间距，默认5.0

@property (nonatomic, strong) UIColor *backgroundColor1; // 支持两种颜色的渐变
@property (nonatomic, strong) UIColor *backgroundColor2; // 支持两种颜色的渐变
@property (nonatomic, strong) UIColor *separatorColor;

@property (nonatomic, strong) id context;

@property (nonatomic, assign, getter = isHideSeparator) BOOL hideSeparator;

- (void)showInView:(UIView *)view forRect:(CGRect)rect;

- (void)showWithItems:(NSArray<CXPopActionItem *> *)items forRect:(CGRect)rect;

@end

typedef void(^CXPopItemActionBlock)(CXPopActionItem *item, id context);

@interface CXPopActionItem : NSObject

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign, getter = isEnabled) BOOL enabled;
@property (nonatomic, strong) id userInfo;

- (instancetype)initWithActionBlock:(CXPopItemActionBlock)actionBlock;

- (void)invokeAction:(id)context;

@end
