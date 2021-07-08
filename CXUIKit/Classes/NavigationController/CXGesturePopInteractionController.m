//
//  CXGesturePopInteractionController.m
//  Pods
//
//  Created by wshaolin on 2017/5/17.
//
//

#import "CXGesturePopInteractionController.h"

@implementation CXGesturePopInteractionController

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer{
    if(self.navigationController.viewControllers.count <= 1){
        return NO;
    }
    
    if([self.navigationController.topViewController conformsToProtocol:@protocol(CXGesturePopInteractionDelegate)]){
        if([self.navigationController.topViewController respondsToSelector:@selector(disableGesturePopInteraction)]){
            return ![((id<CXGesturePopInteractionDelegate>)(self.navigationController.topViewController)) disableGesturePopInteraction];
        }
    }
    
    return YES;
}

@end
