//
//  CXActionItemButton.h
//  Pods
//
//  Created by wshaolin on 2017/11/20.
//

#import <UIKit/UIKit.h>

@interface CXActionItemButton : UIButton

@property (nonatomic, assign, getter = isEnableHighlighted) BOOL enableHighlighted;

@property (nonatomic, assign) CGFloat cornerRadii;

- (void)setTitleFont:(UIFont *)titleFont forState:(UIControlState)state;

@end
