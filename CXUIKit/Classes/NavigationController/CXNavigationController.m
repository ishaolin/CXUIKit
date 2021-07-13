//
//  CXNavigationController.m
//  Pods
//
//  Created by wshaolin on 2017/5/17.
//
//

#import "CXNavigationController.h"
#import "CXGesturePopInteractionController.h"
#import "CXBaseViewController.h"
#import "CXViewControllerAnimation.h"

@interface CXNavigationController () <UINavigationControllerDelegate> {
    CXGesturePopInteractionController *_gesturePopInteractionController;
}

@property (nonatomic, strong) CXAnimatedTransitioningDelegate *animatedTransitioningDelegate;
@property (nonatomic, weak) UIViewController *animationViewController;

@end

@implementation CXNavigationController

- (CXAnimatedTransitioningDelegate *)animatedTransitioningDelegate{
    if(!_animatedTransitioningDelegate){
        _animatedTransitioningDelegate = [[CXAnimatedTransitioningDelegate alloc] init];
    }
    
    return _animatedTransitioningDelegate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBarHidden = YES;
    self.delegate = self;
    
    _gesturePopInteractionController = [[CXGesturePopInteractionController alloc] init];
    _gesturePopInteractionController.navigationController = self;
    self.interactivePopGestureRecognizer.delegate = _gesturePopInteractionController;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if(self.viewControllers.count == 0){
        if([viewController isKindOfClass:[CXBaseViewController class]]){
            ((CXBaseViewController *)viewController).navigationBar.navigationItem.backBarButtonItem.hidden = YES;
        }
    }else{
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [super pushViewController:viewController animated:animated];
}

- (NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated{
    __block NSUInteger index = 0;
    [self.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(obj == viewController){
            index = idx;
            *stop = YES;
        }
    }];
    
    if(index < self.viewControllers.count - 1){
        self.animationViewController = self.viewControllers[index + 1];
    }
    
    return [super popToViewController:viewController animated:animated];
}

- (NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated{
    if(self.viewControllers.count > 1){
        self.animationViewController = self.viewControllers[1];
    }
    
    return [super popToRootViewControllerAnimated:animated];
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC{
    switch (operation) {
        case UINavigationControllerOperationPush:{
            CXAnimatedTransitioningStyle transitioningStyle = [self animatedTransitioningStyleForViewController:toVC];
            if(transitioningStyle != CXAnimatedTransitioningStyleCoverVertical){
                return nil;
            }
            
            return self.animatedTransitioningDelegate.presentAnimation;
        }
        case UINavigationControllerOperationPop:{
            // 优先执行present动画
            CXAnimatedTransitioningStyle transitioningStyle = MAX([self animatedTransitioningStyleForViewController:self.animationViewController], [self animatedTransitioningStyleForViewController:fromVC]);
            self.animationViewController = nil;
            if(transitioningStyle != CXAnimatedTransitioningStyleCoverVertical){
                return nil;
            }
            
            return self.animatedTransitioningDelegate.dismissAnimation;
        }
        default:
            return nil;
    }
}

- (CXAnimatedTransitioningStyle)animatedTransitioningStyleForViewController:(UIViewController *)viewController{
    if([viewController conformsToProtocol:@protocol(CXAnimatedTransitioningSupporter)]){
        return [((id<CXAnimatedTransitioningSupporter>)viewController) animatedTransitioningStyle];
    }
    
    return CXAnimatedTransitioningStyleCoverHorizontal;
}

- (BOOL)shouldAutorotate{
    return [self.visibleViewController shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return [self.visibleViewController supportedInterfaceOrientations];
}

@end
