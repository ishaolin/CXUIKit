//
//  CXBarButtonItem.m
//  Pods
//
//  Created by wshaolin on 2017/5/17.
//
//

#import "CXBarButtonItem.h"
#import "CXNavigationConfig.h"
#import "CXWebImage.h"
#import "UIImage+CXUIKit.h"

static const CGFloat CXBarButtonItemDefaultWidth = 30.0;

@interface CXBarButtonItem(){
    CXInvocation *_invocation;
}

@end

@implementation CXBarButtonItem

- (instancetype)initWithTitle:(NSString *)title target:(id)target action:(SEL)action{
    if(self = [super init]){
        _width = CXBarButtonItemDefaultWidth;
        _view = [self buttonWithTitle:title image:nil highlightedImage:nil target:target action:action];
        
        [self setBarButtonItemStyleWithConfig:CXNavigationConfigDefault()];
        _style = CXNavigationBarDefaultStyle();
        self.enabled = YES;
    }
    
    return self;
}

- (instancetype)initWithImage:(UIImage *)normalImage highlightedImage:(UIImage *)highlightedImage target:(id)target action:(SEL)action{
    if(self = [super init]){
        _width = CXBarButtonItemDefaultWidth;
        _view = [self buttonWithTitle:nil image:normalImage highlightedImage:highlightedImage target:target action:action];
        
        [self setBarButtonItemStyleWithConfig:CXNavigationConfigDefault()];
        _style = CXNavigationBarDefaultStyle();
        self.enabled = YES;
    }
    
    return self;
}

- (instancetype)initWithCustomView:(UIView *)customView{
    if(self = [super init]){
        _view = customView;
        _width = CGRectGetWidth(customView.frame);
        _isCustomed = YES;
        
        [self setBarButtonItemStyleWithConfig:CXNavigationConfigDefault()];
        _style = CXNavigationBarDefaultStyle();
        self.enabled = YES;
    }
    
    return self;
}

- (void)setEnabled:(BOOL)enabled{
    if([_view isKindOfClass:[UIControl class]]){
        ((UIControl *)_view).enabled = enabled;
    }else{
        _view.userInteractionEnabled = enabled;
    }
}

- (BOOL)isEnabled{
    if([_view isKindOfClass:[UIControl class]]){
        return ((UIControl *)_view).isEnabled;
    }else{
        return _view.isUserInteractionEnabled;
    }
}

- (void)setTag:(NSInteger)tag{
    _view.tag = tag;
}

- (NSInteger)tag{
    return _view.tag;
}

- (void)setHidden:(BOOL)hidden{
    _view.hidden = hidden;
}

- (BOOL)isHidden{
    return _view.isHidden;
}

- (void)setTitle:(NSString *)title{
    if([_view isKindOfClass:[UIButton class]]){
        [((UIButton *)_view) setTitle:title forState:UIControlStateNormal];
    }
}

- (NSString *)title{
    if([_view isKindOfClass:[UIButton class]]){
        return [((UIButton *)_view) titleForState:UIControlStateNormal];
    }
    
    return nil;
}

- (UIButton *)buttonWithTitle:(NSString *)title image:(UIImage *)normalImage highlightedImage:(UIImage *)highlightedImage target:(id)target action:(SEL)action{
    _invocation = [CXInvocation invocationWithTarget:target action:action];
    _invocation.invoker = self;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.imageView.contentMode = UIViewContentModeCenter;
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:normalImage forState:UIControlStateNormal];
    [button setImage:highlightedImage forState:UIControlStateHighlighted];
    [button addTarget:_invocation action:@selector(invoke) forControlEvents:UIControlEventTouchUpInside];
    
    if(normalImage != nil){
        _width = normalImage.size.width;
    }else if (title && title.length > 0){
        _width = [button.titleLabel sizeThatFits:CGSizeMake(200.0, MAXFLOAT)].width;
    }
    
    _width = MAX(_width, CXBarButtonItemDefaultWidth);
    return button;
}

- (void)setStyle:(UIStatusBarStyle)style{
    if(_style == style){
        return;
    }
    
    _style = style;
    [self setBarButtonItemStyleWithConfig:CXNavigationConfigForStyle(_style)];
}

- (void)setBarButtonItemStyleWithConfig:(CXNavigationConfig *)config{
    if(!config || self.isCustomed){
        return;
    }
    
    UIButton *actionButton = (UIButton *)self.view;
    if(![actionButton isKindOfClass:[UIButton class]]){
        return;
    }
    
    actionButton.titleLabel.font = config.itemTitleFont;
    
    UIImage *image = [actionButton imageForState:UIControlStateNormal];
    
    UIColor *color1 = [config itemTitleColorForState:UIControlStateNormal];
    [actionButton setTitleColor:color1 forState:UIControlStateNormal];
    [actionButton setImage:[image cx_imageForTintColor:color1] forState:UIControlStateNormal];
    
    UIColor *color2 = [config itemTitleColorForState:UIControlStateHighlighted];
    [actionButton setTitleColor:color2 forState:UIControlStateHighlighted];
    [actionButton setImage:[image cx_imageForTintColor:color2] forState:UIControlStateHighlighted];
    
    UIColor *color3 = [config itemTitleColorForState:UIControlStateDisabled];
    [actionButton setTitleColor:color3 forState:UIControlStateDisabled];
    [actionButton setImage:[image cx_imageForTintColor:color3] forState:UIControlStateDisabled];
}

- (void)dealloc{
    _invocation = nil;
}

@end

@implementation CXBarButtonItem (CXUIKit)

+ (instancetype)buttonItemWithTarget:(id)target action:(SEL)action{
    return [[self alloc] initWithTitle:nil target:target action:action];
}

- (void)setImageWithURL:(NSString *)url{
    [self setImageWithURL:url forState:UIControlStateNormal];
}

- (void)setImageWithURL:(NSString *)url forState:(UIControlState)state{
    if(![self.view isKindOfClass:[UIButton class]]){
        return;
    }
    
    void (^barButtonItemImageSettingBlock)(UIImage *) = ^(UIImage *image){
        UIButton *button = (UIButton *)self.view;
        [button setImage:image forState:state];
        if(image){
            button.titleEdgeInsets = UIEdgeInsetsMake(0, 5.0, 0, 0);
            self.width = [button.titleLabel sizeThatFits:CGSizeZero].width + MIN(image.size.width, 44.0) + 5.0;
        }else{
            button.titleEdgeInsets = UIEdgeInsetsZero;
        }
    };
    
    [CXWebImage downloadImageWithURL:url completion:^(UIImage *image, NSData *data) {
        if(data){
            barButtonItemImageSettingBlock([UIImage imageWithData:data scale:MAX(image.scale, 2.0)]);
        }else{
            barButtonItemImageSettingBlock(nil);
        }
    }];
}

@end
