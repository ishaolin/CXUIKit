//
//  CXWebViewProgressBar.m
//  Pods
//
//  Created by wshaolin on 2019/7/31.
//

#import "CXWebViewProgressBar.h"

@interface CXWebViewProgressBar () {
    UIView *_progressView;
}

@end

@implementation CXWebViewProgressBar

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.userInteractionEnabled = NO;
        _animationDuration = 0.27;
        _fadeAnimationDuration = _animationDuration;
        _fadeOutDelay = 0.1;
        
        _progressView = [[UIView alloc] init];
        [self addSubview:_progressView];
    }
    
    return self;
}

- (void)setProgress:(float)progress{
    [self setProgress:progress animated:YES];
}

- (void)setProgress:(float)progress animated:(BOOL)animated{
    if(self.isHidden){
        return;
    }
    
    [UIView animateWithDuration:(progress > 0.0 && animated) ? _animationDuration : 0.0
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CGRect frame = self->_progressView.frame;
                         frame.size.width = progress * self.bounds.size.width;
                         self->_progressView.frame = frame;
                     }
                     completion:nil];
    
    if(progress < 1.0){
        [UIView animateWithDuration:animated ? _fadeAnimationDuration : 0.0
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self->_progressView.alpha = 1.0;
                         } completion:nil];
    }else{
        [UIView animateWithDuration:animated ? _fadeAnimationDuration : 0.0
                              delay:_fadeOutDelay
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self->_progressView.alpha = 0.0;
                         }
                         completion:^(BOOL completed){
                             CGRect frame = self->_progressView.frame;
                             frame.size.width = 0;
                             self->_progressView.frame = frame;
                         }];
    }
}

- (void)setProgressColor:(UIColor *)progressColor{
    if(progressColor){
        _progressView.backgroundColor = progressColor;
    }
}

- (UIColor *)progressColor{
    return _progressView.backgroundColor;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if(CGRectGetHeight(_progressView.frame) == 0){
        CGRect frame = self.bounds;
        frame.size.width *= 0.1;
        _progressView.frame = frame;
    }
}

@end
