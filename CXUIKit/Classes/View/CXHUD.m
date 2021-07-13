//
//  CXHUD.m
//  Pods
//
//  Created by wshaolin on 2017/11/24.
//

#import "CXHUD.h"
#import "UIColor+CXUIKit.h"
#import "UIFont+CXUIKit.h"
#import "UIView+CXUIKit.h"
#import "UIApplication+CXUIKit.h"
#import "CXSystemAdapter.h"

static CXHUDBackgroundStyle _HUDBackgroundStyle = CXHUDBackgroundStyleClear;

void CXSetHUDBackgroundStyle(CXHUDBackgroundStyle style){
    _HUDBackgroundStyle = style;
}

CXHUDBackgroundStyle CXGetHUDBackgroundStyle(void){
    return _HUDBackgroundStyle;
}

@interface CXHUD (){
    UIView *_contentView;
    UIActivityIndicatorView *_activityIndicatorView;
    UILabel *_msgLabel;
    
    UIVisualEffectView *_visualEffectView;
    NSValue *_centerPoint;
}

@property (nonatomic, assign, getter = isIndicatorEnabled) BOOL indicatorEnabled;

@property (nonatomic, assign, getter = isAutoDismiss) BOOL autoDismiss;

- (void)setIndicatorEnabled:(BOOL)indicatorEnabled msg:(NSString *)msg;

@end

@implementation CXHUD

+ (CXHUD *)showHUD{
    return [self showHUDAddedTo:nil];
}

+ (CXHUD *)showHUD:(NSString *)msg{
    return [self showHUDAddedTo:nil msg:msg animated:YES];
}

+ (CXHUD *)showHUDAddedTo:(UIView *)view{
    return [self showHUDAddedTo:view animated:YES];
}

+ (CXHUD *)showHUDAddedTo:(UIView *)view animated:(BOOL)animated{
    return [self showHUDAddedTo:view msg:@"加载中，请稍候..." animated:animated];
}

+ (CXHUD *)showHUDAddedTo:(UIView *)view msg:(NSString *)msg animated:(BOOL)animated{
    UIView *superview = view ?: [[UIApplication sharedApplication] cx_activeWindow];
    CXHUD *HUD = [self HUDForView:superview];
    if(!HUD || HUD.isAutoDismiss){
        [HUD removeFromSuperview];
        
        HUD = [[CXHUD alloc] init];
        [superview addSubview:HUD];
        HUD.frame = superview.bounds;
        HUD.autoDismiss = NO;
    }
    
    [HUD setIndicatorEnabled:YES msg:msg];
    
    return HUD;
}

+ (CXHUD *)HUDForView:(UIView *)view{
    if(!view){
        return nil;
    }
    
    __block CXHUD *HUD = nil;
    [view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isKindOfClass:[CXHUD class]]){
            HUD = (CXHUD *)obj;
            *stop = YES;
        }
    }];
    
    return HUD;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        CXHUDBackgroundStyle style = CXGetHUDBackgroundStyle();
        switch (style) {
            case CXHUDBackgroundStyleClear:{
                [super setBackgroundColor:[UIColor clearColor]];
            }
                break;
            case CXHUDBackgroundStyleDark:{
                [super setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.75]];
            }
                break;
            case CXHUDBackgroundStyleBlur:{
                _visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
                [self addSubview:_visualEffectView];
            }
                break;
            default:
                break;
        }
        
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = CXHexIColor(0x4a4c5b);
        [self addSubview:_contentView];
        
        _activityIndicatorView = [CXSystemAdapter whiteActivityIndicatorView];
        [_contentView addSubview:_activityIndicatorView];
        
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.font = CX_PingFangSC_RegularFont(14.0);
        _msgLabel.textColor = [UIColor whiteColor];
        _msgLabel.numberOfLines = 2;
        
        [_contentView addSubview:_msgLabel];
    }
    
    return self;
}

- (void)setIndicatorEnabled:(BOOL)indicatorEnabled msg:(NSString *)msg{
    _msgLabel.text = msg;
    [self setIndicatorEnabled:indicatorEnabled needsLayout:NO];
    
    [self setNeedsLayout];
}

- (void)setIndicatorEnabled:(BOOL)indicatorEnabled{
    [self setIndicatorEnabled:indicatorEnabled needsLayout:YES];
}

- (void)setIndicatorEnabled:(BOOL)indicatorEnabled needsLayout:(BOOL)needsLayout{
    if(_indicatorEnabled != indicatorEnabled){
        _indicatorEnabled = indicatorEnabled;
        
        _activityIndicatorView.hidden = !_indicatorEnabled;
        if(_indicatorEnabled){
            [_activityIndicatorView startAnimating];
        }else{
            [_activityIndicatorView stopAnimating];
        }
        
        self.userInteractionEnabled = _indicatorEnabled;
        
        if(needsLayout){
            [self setNeedsLayout];
        }
    }
}

- (void)setBackgroundColor:(UIColor *)backgroundColor{
    
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    if(self.isUserInteractionEnabled){
        return self;
    }
    
    return nil;
}

- (void)setHUDCenterPoint:(CGPoint)centerPoint{
    _centerPoint = [NSValue valueWithCGPoint:centerPoint];
    
    [self setNeedsLayout];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    _visualEffectView.frame = self.bounds;
    
    CGSize msgLabel_S = [_msgLabel sizeThatFits:CGSizeMake(self.bounds.size.width - 100.0, 80.0)];
    CGFloat msgLabel_Y = 13.0;
    CGFloat msgLabel_H = msgLabel_S.height;
    CGFloat msgLabel_W = msgLabel_S.width;
    if(self.isIndicatorEnabled){
        CGFloat activityIndicatorView_X = 15.0;
        CGFloat activityIndicatorView_H = _activityIndicatorView.bounds.size.height;
        CGFloat activityIndicatorView_W = _activityIndicatorView.bounds.size.width;
        
        CGFloat contentView_W = activityIndicatorView_X * 3 + activityIndicatorView_W + msgLabel_W;
        CGFloat contentView_H = msgLabel_Y * 2 + msgLabel_H;
        CGFloat contentView_X = (self.bounds.size.width - contentView_W) * 0.5;
        CGFloat contentView_Y = (self.bounds.size.height - contentView_H) * 0.5;
        _contentView.frame = (CGRect){contentView_X, contentView_Y, contentView_W, contentView_H};
        
        CGFloat activityIndicatorView_Y = (contentView_H - activityIndicatorView_H) * 0.5;
        _activityIndicatorView.frame = (CGRect){activityIndicatorView_X, activityIndicatorView_Y, activityIndicatorView_W, activityIndicatorView_H};
        
        CGFloat msgLabel_X = CGRectGetMaxX(_activityIndicatorView.frame) + activityIndicatorView_X;
        _msgLabel.frame = (CGRect){msgLabel_X, msgLabel_Y, msgLabel_W, msgLabel_H};
    }else{
        CGFloat contentView_H = msgLabel_Y * 2 + msgLabel_H;
        CGFloat contentView_W = MAX(msgLabel_W + 30.0, contentView_H * 2);
        CGFloat contentView_X = (self.bounds.size.width - contentView_W) * 0.5;
        CGFloat contentView_Y = (self.bounds.size.height - contentView_H) * 0.5;
        _contentView.frame = (CGRect){contentView_X, contentView_Y, contentView_W, contentView_H};
        
        CGFloat msgLabel_X = (contentView_W - msgLabel_W) * 0.5;
        _msgLabel.frame = (CGRect){msgLabel_X, msgLabel_Y, msgLabel_W, msgLabel_H};
    }
    
    if(_centerPoint){
        _contentView.center = _centerPoint.CGPointValue;
    }
    [_contentView cx_roundedCornerRadii:2.0];
}

+ (BOOL)dismiss{
    return [self dismissForView:nil];
}

+ (BOOL)dismissForView:(UIView *)view{
    return [self dismissForView:view completion:NULL];
}

+ (BOOL)dismissForView:(UIView *)view completion:(void (^)(void))completion{
    return [self dismissForView:view animated:YES completion:completion];
}

+ (BOOL)dismissForView:(UIView *)view animated:(BOOL)animated completion:(void (^)(void))completion{
    return [self dismissAllForView:view ?: [[UIApplication sharedApplication] cx_activeWindow]
                          animated:animated
                        completion:completion];
}

+ (BOOL)dismissAllForView:(UIView *)view animated:(BOOL)animated completion:(void (^)(void))completion{
    __block NSMutableArray<CXHUD *> *huds = nil;
    [view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isKindOfClass:[CXHUD class]]){
            if(!huds){
                huds = [NSMutableArray array];
            }
            
            [huds addObject:(CXHUD *)obj];
        }
    }];
    
    if(!huds){
        return NO;
    }
    
    void (^_completion)(BOOL) = ^(BOOL finished){
        [huds enumerateObjectsUsingBlock:^(CXHUD * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        
        if(completion){
            completion();
        }
    };
    
    if(animated){
        [UIView animateWithDuration:0.25 animations:^{
            [huds enumerateObjectsUsingBlock:^(CXHUD * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.alpha = 0;
            }];
        } completion:_completion];
    }else{
        _completion(YES);
    }
    
    return YES;
}

+ (CXHUD *)showMsg:(NSString *)msg{
    return [self showMsg:msg completion:NULL];
}

+ (CXHUD *)showMsg:(NSString *)msg completion:(void(^)(void))completion{
    return [self showMsg:msg HUDAddedTo:nil completion:completion];
}

+ (CXHUD *)showMsg:(NSString *)msg HUDAddedTo:(UIView *)view completion:(void(^)(void))completion{
    return [self showMsg:msg HUDAddedTo:view delay:2.0 completion:completion];
}

+ (CXHUD *)showMsg:(NSString *)msg HUDAddedTo:(UIView *)view delay:(NSTimeInterval)delay completion:(void(^)(void))completion{
    CXHUD *HUD = [self showHUDAddedTo:view msg:msg animated:YES];
    HUD.indicatorEnabled = NO;
    HUD.autoDismiss = YES;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissForView:view completion:completion];
    });
    
    return HUD;
}

- (void)dismiss{
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
