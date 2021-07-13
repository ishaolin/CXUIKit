//
//  CXBaseActionPanel.m
//  Pods
//
//  Created by wshaolin on 2018/5/21.
//

#import "CXBaseActionPanel.h"
#import "CXActionPanelOverlayView.h"
#import "CXAlertActionPanel.h"
#import <CXFoundation/CXFoundation.h>
#import "UIApplication+CXUIKit.h"

@interface CXBaseActionPanel () {
    UIView *_overlayView;
    BOOL _isDismissing;
}

@end

@implementation CXBaseActionPanel

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.dismissWhenTapOverlayView = YES;
        _animationDuration = CXActionAnimationDuration;
        self.overlayStyle = CXActionPanelOverlayStyleDark;
        self.animationType = CXActionPanelAnimationUp;
        
        [NSNotificationCenter addObserver:self
                                   action:@selector(applicationWillChangeOrientationNotification:)
                                     name:UIApplicationWillChangeStatusBarOrientationNotification];
    }
    
    return self;
}

- (void)applicationWillChangeOrientationNotification:(NSNotification *)notification{
    [self dismissForRotateScreen];
}

- (void)dismissForRotateScreen{
    [self dismissWithAnimated:YES];
}

- (void)dismissForTapOverlayView:(UITouch *)touch{
    [self dismissWithAnimated:YES];
}

- (void)showInView:(UIView *)view{
    [self showInView:view animated:YES];
}

- (void)showInView:(UIView *)view animated:(BOOL)animated{
    [self removeFromSuperview];
    [self _showInView:view animated:animated];
}

- (void)showInViewController:(UIViewController *)viewController{
    [self showInViewController:viewController animated:YES];
}

- (void)showInViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [self removeFromSuperview];
    [self _showInView:viewController.view animated:animated];
}

- (void)showInWindow:(UIWindow *)window{
    [self showInWindow:window animated:YES];
}

- (void)showInWindow:(UIWindow *)window animated:(BOOL)animated{
    [self removeFromSuperview];
    [self _showInView:window animated:animated];
}

- (void)_showInView:(UIView *)view animated:(BOOL)animated{
    if(!view){
        view = [self.class overlayWindow];
    }
    
    UIView *superView = view;
    _overlayView = [self overlayView];
    if(_overlayView){
        if(self.overlayStyle == CXActionPanelOverlayStyleClear){
            _overlayView.backgroundColor = [UIColor clearColor];
        }else if(self.overlayStyle == CXActionPanelOverlayStyleDark){
            _overlayView.backgroundColor = self.overlayBackgroundColor ?: [UIColor colorWithWhite:0 alpha:0.5];
        }
        
        _overlayView.frame = view.bounds;
        [view addSubview:_overlayView];
        superView = _overlayView;
    }
    
    [superView addSubview:self];
    [self didAddToSuperView:superView];
    
    CXActionAnimationBlock animations = [self showAnimationWithSuperView:superView];
    CXActionCompletionBlock completion = ^(BOOL finished){
        [self _didPresent];
    };
    
    [self _willPresent];
    
    if(animated && animations){
        [UIView animateWithDuration:self.animationDuration animations:animations completion:completion];
    }else{
        if(animations){
            animations();
        }
        
        completion(YES);
    }
}

- (void)_willPresent{
    [_overlayView.superview.subviews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop1) {
        [obj1.subviews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj2, NSUInteger idx2, BOOL * _Nonnull stop2) {
            if([obj2 isKindOfClass:[CXAlertActionPanel class]]){
                [obj1.superview bringSubviewToFront:obj1];
            }
        }];
    }];
    
    if([self.delegate respondsToSelector:@selector(actionPanelWillPresent:)]){
        [self.delegate actionPanelWillPresent:self];
    }
    
    if(self.willPresentHandler){
        self.willPresentHandler(self);
    }
    
    [self willPresent];
}

- (void)_didPresent{
    if([self.delegate respondsToSelector:@selector(actionPanelDidPresent:)]){
        [self.delegate actionPanelDidPresent:self];
    }
    
    if(self.didPresentHandler){
        self.didPresentHandler(self);
    }
    
    [self didPresent];
}

- (void)willPresent{
    
}

- (void)didPresent{
    
}

- (void)dismissWithAnimated:(BOOL)animated{
    if(_isDismissing){
        return;
    }
    
    CXActionCompletionBlock completion = ^(BOOL finished){
        if(self->_overlayView){
            [self->_overlayView removeFromSuperview];
            self->_overlayView = nil;
        }
        
        [self removeFromSuperview];
        [self _didDismiss];
    };
    
    CXActionAnimationBlock animations = [self dismissAnimationWithSuperView:self.superview];
    [self _willDismiss];
    
    if(animated && animations){
        [UIView animateWithDuration:self.animationDuration animations:animations completion:completion];
    }else{
        if(animations){
            animations();
        }
        
        completion(YES);
    }
}

- (void)setPanelSize:(CGSize)panelSize animated:(BOOL)animated{
    _panelSize = panelSize;
    if(!self.superview){
        return;
    }
    
    CGFloat width = _panelSize.width > 0 ? _panelSize.width : self.superview.bounds.size.width;
    CGFloat height = _panelSize.height;
    CGFloat x = (self.superview.bounds.size.width - width) * 0.5;
    CGFloat y = self.superview.bounds.size.height - height;
    if(self.animationType == CXActionPanelAnimationDown){
        y = 0;
    }else if(self.animationType == CXActionPanelAnimationCustom ||
             self.animationType == CXActionPanelAnimationCenter){
        y *= 0.5;
    }
    
    CXActionAnimationBlock animations = ^{
        self.frame = CGRectMake(x, y, width, height);
    };
    
    if(animated){
        [UIView animateWithDuration:self.animationDuration animations:animations];
    }else{
        animations();
    }
}

- (void)_willDismiss{
    _isDismissing = YES;
    
    if([self.delegate respondsToSelector:@selector(actionPanelWillDismiss:)]){
        [self.delegate actionPanelWillDismiss:self];
    }
    
    if(self.willDismissHandler){
        self.willDismissHandler(self);
    }
    
    [self willDismiss];
}

- (void)_didDismiss{
    _isDismissing = NO;
    
    if([self.delegate respondsToSelector:@selector(actionPanelDidDismiss:)]){
        [self.delegate actionPanelDidDismiss:self];
    }
    
    if(self.didDismissHandler){
        self.didDismissHandler(self);
    }
    
    [self didDismiss];
}

- (void)willDismiss{
    
}

- (void)didDismiss{
    
}

- (void)didAddToSuperView:(UIView *)superView{
    
}

- (CXActionAnimationBlock)showAnimationWithSuperView:(UIView *)superView{
    if(self.animationType == CXActionPanelAnimationCustom){
        LOG_BREAKPOINT(@"%@", @"子类必须重写此方法，如果返回NULL可能达不到预期效果。");
        return NULL;
    }
    
    CGFloat width = self.panelSize.width > 0 ? self.panelSize.width : superView.bounds.size.width;
    CGFloat height = self.panelSize.height;
    CGFloat x = (superView.bounds.size.width - width) * 0.5;
    CGFloat y = superView.bounds.size.height;
    if(self.animationType == CXActionPanelAnimationDown){
        y = -self.panelSize.height;
    }else if(self.animationType == CXActionPanelAnimationCenter){
        y = (superView.bounds.size.height - height) * 0.5;
    }
    
    self.frame = (CGRect){x, y, width, height};
    
    return ^{
        if([superView isKindOfClass:[CXActionPanelOverlayView class]]){
            CXActionPanelOverlayView *overlayView = (CXActionPanelOverlayView *)superView;
            if(overlayView.isBlurEnabled){
                overlayView.alpha = 1.0;
            }
        }
        
        if(self.animationType != CXActionPanelAnimationCenter){
            CGRect frame = self.frame;
            if(self.animationType == CXActionPanelAnimationDown){
                frame.origin.y = frame.origin.y + frame.size.height;
            }else{
                frame.origin.y = frame.origin.y - frame.size.height;
            }
            
            self.frame = frame;
        }
    };
}

- (CXActionAnimationBlock)dismissAnimationWithSuperView:(UIView *)superView{
    if(self.animationType == CXActionPanelAnimationCustom){
        LOG_BREAKPOINT(@"%@", @"子类必须重写此方法，如果返回NULL可能达不到预期效果。");
        return NULL;
    }
    
    if(self.animationType == CXActionPanelAnimationCenter){
        return NULL;
    }
    
    return ^{
        if([superView isKindOfClass:[CXActionPanelOverlayView class]]){
            CXActionPanelOverlayView *overlayView = (CXActionPanelOverlayView *)superView;
            if(overlayView.isBlurEnabled){
                overlayView.alpha = 0;
            }else{
                overlayView.backgroundColor = [UIColor clearColor];
            }
        }
        
        CGRect frame = self.frame;
        frame.origin.y = self.superview.bounds.size.height;
        if(self.animationType == CXActionPanelAnimationDown){
            frame.origin.y = -self.panelSize.height;
        }
        
        self.frame = frame;
    };
}

- (UIView *)overlayView{
    BOOL blurEnabled = NO;
    UIBlurEffectStyle effectStyle = 0;
    
    switch (self.overlayStyle) {
        case CXActionPanelOverlayStyleBlurExtraLight:
            effectStyle = UIBlurEffectStyleExtraLight;
            blurEnabled = YES;
            break;
        case CXActionPanelOverlayStyleBlurLight:
            effectStyle = UIBlurEffectStyleLight;
            blurEnabled = YES;
            break;
        case CXActionPanelOverlayStyleBlurDark:
            effectStyle = UIBlurEffectStyleDark;
            blurEnabled = YES;
            break;
        default:
            break;
    }
    
    return [[CXActionPanelOverlayView alloc] initWithBlurEnabled:blurEnabled blurEffectStyle:effectStyle];
}

- (void)setHidden:(BOOL)hidden{
    
}

- (void)dealloc{
    [NSNotificationCenter removeObserver:self];
}

+ (UIWindow *)overlayWindow{
    return [[UIApplication sharedApplication] cx_activeWindow];
}

@end
