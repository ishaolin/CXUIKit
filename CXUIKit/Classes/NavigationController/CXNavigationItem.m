//
//  CXNavigationItem.m
//  Pods
//
//  Created by wshaolin on 2017/5/17.
//
//

#import "CXNavigationItem.h"
#import "CXNavigationConfig.h"
#import "CXImageUtil.h"

@interface CXNavigationItem() {
    CXNavigationConfig *_config;
}

@end

@implementation CXNavigationItem

+ (instancetype)navigationItem{
    return [[self alloc] init];
}

- (instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle{
    if(self = [super init]){
        [self setupTitleViewWithTitle:title subtitle:subtitle];
    }
    
    return self;
}

- (instancetype)init{
    if(self = [super init]){
        [self setupTitleViewWithTitle:nil subtitle:nil];
    }
    
    return self;
}

- (void)setupTitleViewWithTitle:(NSString *)title subtitle:(NSString *)subtitle{
    _titleView = [[CXNavigationTitleView alloc] init];
    _titleView.title = title;
    _titleView.subtitle = subtitle;
    
    UIImage *image = CXGetNavigationBarDefaultBackIcon() ?: CX_UIKIT_IMAGE(@"ui_navigation_bar_back");
    CXNavigationConfig *config = CXNavigationConfigDefault();
    UIImage *normalImage = [image cx_imageForTintColor:[config itemTitleColorForState:UIControlStateNormal]];
    UIImage *highlightedImage = [image cx_imageForTintColor:[config itemTitleColorForState:UIControlStateHighlighted]];
    _backBarButtonItem = [[CXBarButtonItem alloc] initWithImage:normalImage highlightedImage:highlightedImage target:self action:@selector(didClickBackBarButtonItem:)];
    _backBarButtonItem.width = 40.0;
    
    [self addObserverForKeyPathsWithObject:_backBarButtonItem];
}

- (void)addObserverForKeyPathsWithObject:(NSObject *)object{
    if(object != nil){
        NSArray<NSString *> *keyPaths = @[@"width", @"hidden"];
        for(NSString *keyPath in keyPaths){
            [object addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:nil];
        }
    }
}

- (void)removeObserverForKeyPathsWithObject:(NSObject *)object{
    if(object != nil){
        NSArray<NSString *> *keyPaths = @[@"width", @"hidden"];
        for(NSString *keyPath in keyPaths){
            [object removeObserver:self forKeyPath:keyPath];
        }
    }
}

- (void)addObserverForKeyPathsWithObjects:(NSArray *)objects{
    for(NSObject *object in objects){
        [self addObserverForKeyPathsWithObject:object];
    }
}

- (void)removeObserverForKeyPathsWithObjects:(NSArray *)objects{
    for(NSObject *object in objects){
        [self removeObserverForKeyPathsWithObject:object];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    [self didSendNoticeToLayoutNavigationBar];
}

- (void)didClickBackBarButtonItem:(CXBarButtonItem *)backBarButtonItem{
    if(self.delegate && [self.delegate respondsToSelector:@selector(navigationItem:didClickBackBarButtonItem:)]){
        [self.delegate navigationItem:self didClickBackBarButtonItem:backBarButtonItem];
    }
}

- (void)setLeftBarButtonItem:(CXBarButtonItem *)leftBarButtonItem{
    if(!CXArrayIsEmpty(self.leftBarButtonItems) || _leftBarButtonItem == leftBarButtonItem){
        return;
    }
    
    [self removeObserverForKeyPathsWithObject:_leftBarButtonItem];
    
    _leftBarButtonItem = leftBarButtonItem;
    
    [self addObserverForKeyPathsWithObject:_leftBarButtonItem];
    
    [self didSendNoticeToLayoutNavigationBar];
}

- (void)setRightBarButtonItem:(CXBarButtonItem *)rightBarButtonItem{
    if(!CXArrayIsEmpty(self.rightBarButtonItems) || _rightBarButtonItem == rightBarButtonItem){
        return;
    }
    
    [self removeObserverForKeyPathsWithObject:_rightBarButtonItem];
    
    _rightBarButtonItem = rightBarButtonItem;
    
    [self addObserverForKeyPathsWithObject:_rightBarButtonItem];
    
    [self didSendNoticeToLayoutNavigationBar];
}

- (void)setLeftBarButtonItems:(NSArray<CXBarButtonItem *> *)leftBarButtonItems{
    if(_leftBarButtonItems == leftBarButtonItems){
        return;
    }
    
    if(leftBarButtonItems.count > 0 && leftBarButtonItems.count <= 2){
        self.leftBarButtonItem = nil;
    }
    
    [self removeObserverForKeyPathsWithObjects:_leftBarButtonItems];
    
    _leftBarButtonItems = leftBarButtonItems;
    
    [self addObserverForKeyPathsWithObjects:_leftBarButtonItems];
    
    [self didSendNoticeToLayoutNavigationBar];
}

- (void)setRightBarButtonItems:(NSArray<CXBarButtonItem *> *)rightBarButtonItems{
    if(_rightBarButtonItems == rightBarButtonItems){
        return;
    }
    
    if(rightBarButtonItems.count > 0 && rightBarButtonItems.count <= 2){
        self.rightBarButtonItem = nil;
    }
    
    [self removeObserverForKeyPathsWithObjects:_rightBarButtonItems];
    
    _rightBarButtonItems = rightBarButtonItems;
    
    [self addObserverForKeyPathsWithObjects:_rightBarButtonItems];
    
    [self didSendNoticeToLayoutNavigationBar];
}

- (void)setCustomTitleView:(UIView *)customTitleView{
    if(_customTitleView != customTitleView){
        _customTitleView = customTitleView;
        _titleView.hidden = (_customTitleView != nil);
        
        [self didSendNoticeToLayoutNavigationBar];
    }
}

- (void)didSendNoticeToLayoutNavigationBar{
    if(self.delegate && [self.delegate respondsToSelector:@selector(navigationItemNoticeNavigationBarLayout:)]){
        [self.delegate navigationItemNoticeNavigationBarLayout:self];
    }
}

- (void)setUpdateStyleIfNeed:(UIStatusBarStyle)style{
    if(_config){
        [self setUpdateStyleWithConfig:_config];
    }else{
        [self setUpdateStyleWithConfig:CXNavigationConfigForStyle(style)];
    }
}

- (void)setUpdateStyleWithConfig:(CXNavigationConfig *)config{
    if(!config){
        return;
    }
    
    if(_config != config){
        _config = config;
    }
    
    [_titleView setTitleColor:_config.titleColor];
    [_titleView setTitleFont:_config.titleFont];
    [_titleView setSubtitleFont:_config.subtitleFont];
    
    [_backBarButtonItem setBarButtonItemStyleWithConfig:_config];
    [_leftBarButtonItem setBarButtonItemStyleWithConfig:_config];
    [_rightBarButtonItem setBarButtonItemStyleWithConfig:_config];
    
    [_leftBarButtonItems enumerateObjectsUsingBlock:^(CXBarButtonItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setBarButtonItemStyleWithConfig:self->_config];
    }];
    
    [_rightBarButtonItems enumerateObjectsUsingBlock:^(CXBarButtonItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setBarButtonItemStyleWithConfig:self->_config];
    }];
}

- (void)dealloc{
    [self removeObserverForKeyPathsWithObject:_backBarButtonItem];
    [self removeObserverForKeyPathsWithObject:_leftBarButtonItem];
    [self removeObserverForKeyPathsWithObject:_rightBarButtonItem];
    [self removeObserverForKeyPathsWithObjects:_leftBarButtonItems];
    [self removeObserverForKeyPathsWithObjects:_rightBarButtonItems];
}

@end
