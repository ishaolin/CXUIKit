//
//  CXNavigationVCAnimation.m
//  Pods
//
//  Created by wshaolin on 2018/11/16.
//

#import "CXViewControllerAnimation.h"

@implementation CXViewControllerAnimation

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.35;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    
}

@end

@implementation CXViewControllerPresentAnimation

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CGRect frame = [transitionContext finalFrameForViewController:toVC];
    toVC.view.frame = CGRectOffset(frame, 0, CGRectGetHeight(frame));
    [transitionContext.containerView addSubview:toVC.view];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        toVC.view.frame = frame;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:finished];
    }];
}

@end

@implementation CXViewControllerDismissAnimation

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    [transitionContext.containerView insertSubview:toVC.view belowSubview:fromVC.view];
    
    CGRect frame = [transitionContext initialFrameForViewController:fromVC];
    frame.origin.y = CGRectGetHeight(frame);
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromVC.view.frame = frame;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

@end

@interface CXAnimatedTransitioningDelegate () {
    CXViewControllerAnimation *_presentAnimation;
    CXViewControllerAnimation *_dismissAnimation;
}

@end

@implementation CXAnimatedTransitioningDelegate

- (CXViewControllerAnimation *)presentAnimation{
    if(!_presentAnimation){
        _presentAnimation = [[CXViewControllerPresentAnimation alloc] init];
    }
    
    return _presentAnimation;
}

- (CXViewControllerAnimation *)dismissAnimation{
    if(!_dismissAnimation){
        _dismissAnimation = [[CXViewControllerDismissAnimation alloc] init];
    }
    
    return _dismissAnimation;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return self.presentAnimation;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return self.dismissAnimation;
}

@end
