//
//  CXFailureViewController.m
//  Pods
//
//  Created by wshaolin on 2019/10/17.
//

#import "CXFailureViewController.h"

@interface CXFailureViewController (){
    UIView<CXFailureViewDefinition> *_failureView;
}

@end

@implementation CXFailureViewController

- (void)hideFailureView {
    _failureView.hidden = YES;
}

- (void)showFailureViewWithError:(NSError *)error {
    [self loadFailureView];
    
    [_failureView showWithError:error];
}

- (void)showFailureViewWithCode:(NSInteger)code{
    [self loadFailureView];
    
    [_failureView showWithFailureCode:code];
}

- (void)loadFailureView{
    if(_failureView){
        [_failureView.superview bringSubviewToFront:_failureView];
    }else {
        _failureView = [[CXFailureView alloc] init];
        _failureView.delegate = self;
        
        CGFloat failureView_X = 0;
        CGFloat failureView_Y = CGRectGetMaxY(self.navigationBar.frame);
        CGFloat failureView_W = CGRectGetWidth(self.view.bounds);
        CGFloat failureView_H = CGRectGetHeight(self.view.bounds) - failureView_Y;
        _failureView.frame = (CGRect){failureView_X, failureView_Y, failureView_W, failureView_H};
        [self addFailureView:_failureView toView:self.view];
    }
}

- (void)addFailureView:(UIView<CXFailureViewDefinition> *)failureView toView:(UIView *)view{
    [view addSubview:failureView];
}

- (void)failureViewDidNeedsReload:(UIView<CXFailureViewDefinition> *)failureView{
    
}

- (void)failureView:(UIView<CXFailureViewDefinition> *)failureView showWithPageTitle:(NSString *)pageTitle{
    self.title = pageTitle;
    self.subtitle = nil;
}

@end
