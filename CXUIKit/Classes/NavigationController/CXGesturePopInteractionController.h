//
//  CXGesturePopInteractionController.h
//  Pods
//
//  Created by wshaolin on 2017/5/17.
//
//

#import <UIKit/UIKit.h>

@protocol CXGesturePopInteractionDelegate <NSObject>

@optional

- (BOOL)disableGesturePopInteraction;

@end

@interface CXGesturePopInteractionController : NSObject<UIGestureRecognizerDelegate>

@property (nonatomic, weak) UINavigationController *navigationController;

@end
