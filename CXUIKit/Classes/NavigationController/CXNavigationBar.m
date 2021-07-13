//
//  CXNavigationBar.m
//  Pods
//
//  Created by wshaolin on 2017/5/17.
//
//

#import "CXNavigationBar.h"
#import "CXNavigationConfig.h"
#import "UIScreen+CXUIKit.h"

@interface CXNavigationBar()<CXNavigationItemDelegate>{
    CALayer *_horizontalLine;
    UIToolbar *_contentView;
    NSMutableArray<UIView *> *_contentSubviews;
    UIStatusBarStyle _style;
}

@end

@implementation CXNavigationBar

+ (instancetype)navigationBar{
    return [[self alloc] initWithNavigationItem:[CXNavigationItem navigationItem]];
}

- (instancetype)initWithNavigationItem:(CXNavigationItem *)navigationItem{
    if(self = [super initWithFrame:CGRectZero]){
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.autoresizesSubviews = NO;
        self.backgroundColor = CXNavigationConfigDefault().backgroundColor;
        
        _style = CXNavigationBarDefaultStyle();
        _contentSubviews = [NSMutableArray array];
        
        _navigationItem = navigationItem;
        _navigationItem.delegate = self;
        _contentView = [[UIToolbar alloc] init];
        
        _horizontalLine = [CALayer layer];
        _horizontalLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2].CGColor;
        _horizontalLine.zPosition = 10;
        [self.layer addSublayer:_horizontalLine];
        
        [self addSubview:_contentView];
        [self navigationItemNoticeNavigationBarLayout:_navigationItem];
        
        [_contentView layoutIfNeeded];
        [_contentView addObserver:self forKeyPath:@"translucent" options:NSKeyValueObservingOptionNew context:nil];
        
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 2.0);
        self.layer.shadowRadius = 2.0;
        self.layer.shadowOpacity = 0;
        
        _contentInset = UIEdgeInsetsMake(0, 0, 0, 10.0);
    }
    
    return self;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor{
    [super setBackgroundColor:backgroundColor];
    
    _contentView.barTintColor = backgroundColor;
}

- (void)setContentInset:(UIEdgeInsets)contentInset{
    if(UIEdgeInsetsEqualToEdgeInsets(_contentInset, contentInset)){
        return;
    }
    
    _contentInset = contentInset;
    [self setNeedsLayout];
}

- (void)setShadowEnabled:(BOOL)shadowEnabled{
    if(_shadowEnabled == shadowEnabled){
        return;
    }
    
    _shadowEnabled = shadowEnabled;
    if(_shadowEnabled){
        self.hiddenBottomHorizontalLine = YES;
    }
    
    self.layer.shadowOpacity = _shadowEnabled ? 0.1 : 0;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *, id> *)change context:(void *)context{
    if([keyPath isEqualToString:@"translucent"]){
        if(self.delegate && [self.delegate respondsToSelector:@selector(navigationBar:didChangeTranslucent:)]){
            [self.delegate navigationBar:self didChangeTranslucent:self.isTranslucent];
        }
    }
}

- (void)navigationItem:(CXNavigationItem *)navigationItem didClickBackBarButtonItem:(CXBarButtonItem *)backBarButtonItem{
    if(_delegate && [_delegate respondsToSelector:@selector(navigationBar:didClickBackBarButtonItem:)]){
        [_delegate navigationBar:self didClickBackBarButtonItem:backBarButtonItem];
    }
}

- (void)navigationItemNoticeNavigationBarLayout:(CXNavigationItem *)navigationItem{
    [navigationItem setUpdateStyleIfNeed:_style];
    
    // 移除原有的子控件
    for(UIView *view in _contentSubviews){
        [view removeFromSuperview];
    }
    
    // 添加返回按钮
    [self addContentSubview:_navigationItem.backBarButtonItem.view];
    
    // 添加返回按钮后面的第一个按钮（关闭按钮）
    [self addContentSubview:_navigationItem.leftBarButtonItem.view];
    
    // 添加最右边的按钮
    [self addContentSubview:_navigationItem.rightBarButtonItem.view];
    
    for(CXBarButtonItem *barButtonItem in _navigationItem.leftBarButtonItems){
        [self addContentSubview:barButtonItem.view];
    }
    
    for(CXBarButtonItem *barButtonItem in _navigationItem.rightBarButtonItems){
        [self addContentSubview:barButtonItem.view];
    }
    
    // 添加自定义的titleView
    if(_navigationItem.customTitleView){
        [self addContentSubview:_navigationItem.customTitleView];
    }else{
        [self addContentSubview:_navigationItem.titleView];
    }
    
    // 重新布局
    [self setNeedsLayout];
}

- (void)addContentSubview:(UIView *)view{
    if(view != nil){
        [self addSubview:view];
        [_contentSubviews addObject:view];
    }
}

- (void)setHiddenBottomHorizontalLine:(BOOL)hiddenBottomHorizontalLine{
    if(_hiddenBottomHorizontalLine != hiddenBottomHorizontalLine){
        _hiddenBottomHorizontalLine = hiddenBottomHorizontalLine;
        
        _horizontalLine.hidden = _hiddenBottomHorizontalLine;
    }
}

- (void)setTranslucent:(BOOL)translucent{
    _contentView.translucent = translucent;
    _contentView.hidden = !translucent;
}

- (BOOL)isTranslucent{
    return _contentView.isTranslucent;
}

- (void)setFrame:(CGRect)frame{
    frame = [UIScreen mainScreen].bounds;
    frame.size.height = 64.0 + [UIScreen mainScreen].cx_safeAreaInsets.top;
    [super setFrame:frame];
}

- (void)setBackgroundView:(UIView *)backgroundView{
    [_backgroundView removeFromSuperview];
    _backgroundView = backgroundView;
    
    if(_backgroundView){
        [self insertSubview:_backgroundView belowSubview:_contentView];
    }
    
    [self setNeedsLayout];
}

- (void)setHidden:(BOOL)hidden animated:(BOOL)animated{
    if(self.isHidden == hidden){
        return;
    }
    
    CGRect frame = self.frame;
    if(hidden){
        frame.origin.y = -(CGRectGetHeight(frame));
    }else{
        frame.origin.y = 0;
        self.hidden = NO;
    }
    
    [UIView animateWithDuration:animated ? 0.25 : 0 animations:^{
        [super setFrame:frame];
    } completion:^(BOOL finished) {
        self.hidden = hidden;
    }];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    _contentView.frame = self.bounds;
    _backgroundView.frame = self.bounds;
    
    // 底部水平线布局
    CGFloat horizontalLine_X = 0;
    CGFloat horizontalLine_W = self.bounds.size.width;
    CGFloat horizontalLine_H = 0.33;
    CGFloat horizontalLine_Y = self.bounds.size.height - horizontalLine_H;
    _horizontalLine.frame = CGRectMake(horizontalLine_X, horizontalLine_Y, horizontalLine_W, horizontalLine_H);
    
    // item之间的间隔
    CGFloat barButtonItemMargin = 5.0;
    
    // 返回按钮布局
    CGFloat backBarButtonItem_X = _contentInset.left;
    CGFloat backBarButtonItem_H = 44.0 - horizontalLine_H; // 高度43.5
    CGFloat backBarButtonItem_W = _navigationItem.backBarButtonItem.width;
    CGFloat backBarButtonItem_Y = self.bounds.size.height - backBarButtonItem_H - horizontalLine_H;
    _navigationItem.backBarButtonItem.view.frame = CGRectMake(backBarButtonItem_X, backBarButtonItem_Y, backBarButtonItem_W, backBarButtonItem_H);
    
    CGFloat leftBarButtonItem_X = backBarButtonItem_W;
    if(_navigationItem.backBarButtonItem.isHidden){
        leftBarButtonItem_X = barButtonItemMargin * 2;
    }
    
    // 左侧按钮布局，非数组
    CGFloat leftBarButtonItem_Y = backBarButtonItem_Y;
    CGFloat leftBarButtonItem_W = _navigationItem.leftBarButtonItem.width;
    CGFloat leftBarButtonItem_H = backBarButtonItem_H;
    if(_navigationItem.leftBarButtonItem.isCustomed){
        leftBarButtonItem_H = CGRectGetHeight(_navigationItem.leftBarButtonItem.view.bounds);
        leftBarButtonItem_Y = backBarButtonItem_Y + (backBarButtonItem_H - leftBarButtonItem_H) * 0.5;
    }
    _navigationItem.leftBarButtonItem.view.frame = CGRectMake(leftBarButtonItem_X, leftBarButtonItem_Y, leftBarButtonItem_W, leftBarButtonItem_H);
    CGFloat leftBarButtonItem_max_X = backBarButtonItem_X + backBarButtonItem_W;
    if(_navigationItem.leftBarButtonItem != nil){
        leftBarButtonItem_max_X = leftBarButtonItem_X + leftBarButtonItem_W;
    }
    
    // 左侧按钮布局，数组
    for(CXBarButtonItem *leftBarButtonItem in _navigationItem.leftBarButtonItems){
        leftBarButtonItem_W = leftBarButtonItem.width;
        leftBarButtonItem_X = leftBarButtonItem_max_X + barButtonItemMargin;
        if(leftBarButtonItem.isCustomed){
            leftBarButtonItem_H = CGRectGetHeight(leftBarButtonItem.view.bounds);
            leftBarButtonItem_Y = backBarButtonItem_Y + (backBarButtonItem_H - leftBarButtonItem_H) * 0.5;
        }
        leftBarButtonItem.view.frame = CGRectMake(leftBarButtonItem_X, leftBarButtonItem_Y, leftBarButtonItem_W, leftBarButtonItem_H);
        leftBarButtonItem_max_X = leftBarButtonItem_X + leftBarButtonItem_W;
    }
    
    // 右侧按钮布局，非数组
    CGFloat rightBarButtonItem_W = _navigationItem.rightBarButtonItem.width;
    CGFloat rightBarButtonItem_X = self.bounds.size.width - rightBarButtonItem_W - _contentInset.right;
    CGFloat rightBarButtonItem_H = backBarButtonItem_H;
    CGFloat rightBarButtonItem_Y = backBarButtonItem_Y;
    if(_navigationItem.rightBarButtonItem.isCustomed){
        rightBarButtonItem_H = CGRectGetHeight(_navigationItem.rightBarButtonItem.view.bounds);
        rightBarButtonItem_Y = backBarButtonItem_Y + (backBarButtonItem_H - rightBarButtonItem_H) * 0.5;
    }
    _navigationItem.rightBarButtonItem.view.frame = CGRectMake(rightBarButtonItem_X, rightBarButtonItem_Y, rightBarButtonItem_W, rightBarButtonItem_H);
    
    CGFloat rightBarButtonItem_min_X = self.bounds.size.width;
    if(_navigationItem.rightBarButtonItem != nil){
        rightBarButtonItem_min_X = rightBarButtonItem_X;
    }
    
    // 右侧按钮布局，数组
    for(CXBarButtonItem *rightBarButtonItem in _navigationItem.rightBarButtonItems){
        rightBarButtonItem_W = rightBarButtonItem.width;
        rightBarButtonItem_X = rightBarButtonItem_min_X - rightBarButtonItem_W - _contentInset.right;
        if(rightBarButtonItem.isCustomed){
            rightBarButtonItem_H = CGRectGetHeight(rightBarButtonItem.view.bounds);
            rightBarButtonItem_Y = backBarButtonItem_Y + (backBarButtonItem_H - rightBarButtonItem_H) * 0.5;
        }
        rightBarButtonItem.view.frame = CGRectMake(rightBarButtonItem_X, rightBarButtonItem_Y, rightBarButtonItem_W, rightBarButtonItem_H);
        rightBarButtonItem_min_X = rightBarButtonItem_X;
    }
    
    CGFloat titleView_H = rightBarButtonItem_H;
    CGFloat titleView_Y = rightBarButtonItem_Y;
    CGFloat titleView_X = MAX(leftBarButtonItem_max_X, self.bounds.size.width - rightBarButtonItem_min_X);
    CGFloat titleView_W = self.bounds.size.width - titleView_X * 2;
    _navigationItem.titleView.frame = CGRectMake(titleView_X, titleView_Y, titleView_W, titleView_H);
    
    CGFloat customTitleView_W = MIN(_navigationItem.customTitleView.frame.size.width, titleView_W);
    CGFloat customTitleView_H = MIN(_navigationItem.customTitleView.frame.size.height, titleView_H);
    if(_navigationItem.isAutoSetCustomTitleViewFrame){
        customTitleView_W = titleView_W;
        customTitleView_H = titleView_H;
    }
    
    CGFloat customTitleView_X = (self.bounds.size.width - customTitleView_W) * 0.5;
    CGFloat customTitleView_Y = self.bounds.size.height - (backBarButtonItem_H + customTitleView_H) * 0.5 - horizontalLine_H;
    
    _navigationItem.customTitleView.frame = CGRectMake(customTitleView_X, customTitleView_Y, customTitleView_W, customTitleView_H);
}

- (void)setUpdateStyle:(UIStatusBarStyle)style{
    if(_style == style){
        return;
    }
    
    _style = style;
    [self setUpdateStyleWithConfig:CXNavigationConfigForStyle(_style)];
}

- (void)setUpdateStyleWithConfig:(CXNavigationConfig *)config{
    if(!config){
        return;
    }
    
    if(config.backgroundColor){
        self.backgroundColor = config.backgroundColor;
    }
    
    [_navigationItem setUpdateStyleWithConfig:config];
}

- (void)dealloc{
    _navigationItem = nil;
    [_contentView removeObserver:self forKeyPath:@"translucent"];
    _contentView = nil;
}

@end
