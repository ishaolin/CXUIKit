//
//  CXActionPanelOverlayView.m
//  Pods
//
//  Created by wshaolin on 2018/5/21.
//

#import "CXActionPanelOverlayView.h"
#import "CXBaseActionPanel.h"

@interface CXActionPanelOverlayView () {
    UIVisualEffectView *_visualEffectView;
}

@end

@implementation CXActionPanelOverlayView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.opaque = NO;
    }
    
    return self;
}

- (instancetype)initWithBlurEnabled:(BOOL)blurEnabled{
    return [self initWithBlurEnabled:blurEnabled blurEffectStyle:UIBlurEffectStyleLight];
}

- (instancetype)initWithBlurEnabled:(BOOL)blurEnabled blurEffectStyle:(UIBlurEffectStyle)blurEffectStyle{
    if(self = [super initWithFrame:CGRectZero]){
        _isBlurEnabled = blurEnabled;
        
        if(_isBlurEnabled){
            _visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:blurEffectStyle]];
            
            [self addSubview:_visualEffectView];
        }else{
            self.opaque = NO;
        }
    }
    
    return self;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor{
    if(self.isBlurEnabled){
        return;
    }
    
    [super setBackgroundColor:backgroundColor];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CXBaseActionPanel *actionPanel = nil;
    
    if(touch.view == self || touch.view == _visualEffectView){
        for (UIView *view in self.subviews) {
            if([view isKindOfClass:[CXBaseActionPanel class]]){
                actionPanel = (CXBaseActionPanel *)view;
                break;
            }
        }
    }
    
    if(actionPanel && actionPanel.isDismissWhenTapOverlayView){
        [actionPanel dismissForTapOverlayView:touch];
    }else{
        [super touchesEnded:touches withEvent:event];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if(_visualEffectView){
        _visualEffectView.frame = self.bounds;
    }
}

@end
