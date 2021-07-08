//
//  CXNavigationVCAnimation.h
//  Pods
//
//  Created by wshaolin on 2018/11/16.
//

#import <UIKit/UIKit.h>

@interface CXViewControllerAnimation : NSObject <UIViewControllerAnimatedTransitioning>

@end

@interface CXViewControllerPresentAnimation : CXViewControllerAnimation

@end

@interface CXViewControllerDismissAnimation : CXViewControllerAnimation

@end

@interface CXAnimatedTransitioningDelegate : NSObject<UIViewControllerTransitioningDelegate>

@property (nonatomic, strong, readonly) CXViewControllerAnimation *presentAnimation;
@property (nonatomic, strong, readonly) CXViewControllerAnimation *dismissAnimation;

@end
