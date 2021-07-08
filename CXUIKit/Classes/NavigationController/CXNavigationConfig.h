//
//  CXNavigationConfig.h
//  Pods
//
//  Created by wshaolin on 2017/5/28.
//
//

#import <UIKit/UIKit.h>
#import "CXUIKitDefines.h"

@interface CXNavigationConfig : NSObject

@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIFont *subtitleFont;
@property (nonatomic, strong) UIFont *itemTitleFont;

@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIColor *backgroundColor;

- (void)setItemTitleColor:(UIColor *)color forState:(UIControlState)state;

- (UIColor *)itemTitleColorForState:(UIControlState)state;

@end

CX_UIKIT_EXTERN void CXSetNavigationConfigForStyle(CXNavigationConfig *config, UIStatusBarStyle style);
CX_UIKIT_EXTERN CXNavigationConfig *CXNavigationConfigForStyle(UIStatusBarStyle style);
CX_UIKIT_EXTERN CXNavigationConfig *CXNavigationConfigDefault(void);

CX_UIKIT_EXTERN void CXSetNavigationBarDefaultStyle(UIStatusBarStyle style);
CX_UIKIT_EXTERN UIStatusBarStyle CXNavigationBarDefaultStyle(void);

CX_UIKIT_EXTERN void CXSetNavigationBarDefaultBackIcon(UIImage *backIcon);
CX_UIKIT_EXTERN UIImage *CXGetNavigationBarDefaultBackIcon(void);
