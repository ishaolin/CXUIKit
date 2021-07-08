//
//  CXActionPanelOverlayView.h
//  Pods
//
//  Created by wshaolin on 2018/5/21.
//

#import <UIKit/UIKit.h>

@interface CXActionPanelOverlayView : UIView

@property (nonatomic, assign, readonly) BOOL isBlurEnabled;

- (instancetype)initWithBlurEnabled:(BOOL)blurEnabled;

- (instancetype)initWithBlurEnabled:(BOOL)blurEnabled
                    blurEffectStyle:(UIBlurEffectStyle)blurEffectStyle;

@end
