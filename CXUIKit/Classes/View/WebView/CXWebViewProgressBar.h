//
//  CXWebViewProgressBar.h
//  Pods
//
//  Created by wshaolin on 2019/7/31.
//

#import <UIKit/UIKit.h>

@interface CXWebViewProgressBar : UIView

@property (nonatomic, assign) NSTimeInterval animationDuration;     // Default 0.27
@property (nonatomic, assign) NSTimeInterval fadeAnimationDuration; // Default 0.27
@property (nonatomic, assign) NSTimeInterval fadeOutDelay;          // Default 0.10
@property (nonatomic, strong) UIColor *progressColor;

- (void)setProgress:(float)progress;

- (void)setProgress:(float)progress animated:(BOOL)animated;

@end
