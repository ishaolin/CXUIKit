//
//  CXNavigationTitleView.h
//  Pods
//
//  Created by wshaolin on 2017/5/17.
//
//

#import <UIKit/UIKit.h>

@interface CXNavigationTitleView : UIView

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

- (void)setTitleFont:(UIFont *)font;
- (void)setSubtitleFont:(UIFont *)font;

- (void)setTitleColor:(UIColor *)color;
- (void)setSubtitleColor:(UIColor *)color;

- (void)setTitleLineBreakMode:(NSLineBreakMode)lineBreakMode;
- (void)setSubtitleLineBreakMode:(NSLineBreakMode)lineBreakMode;

@end
