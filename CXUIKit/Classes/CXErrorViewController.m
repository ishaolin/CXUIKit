//
//  CXErrorViewController.m
//  Pods
//
//  Created by wshaolin on 2019/10/17.
//

#import "CXErrorViewController.h"

@interface CXErrorViewController (){
    UIView<CXPageErrorViewDefinition> *_errorView;
}

@end

@implementation CXErrorViewController

- (void)hideErrorView{
    _errorView.hidden = YES;
}

- (void)showErrorViewWithError:(NSError *)error{
    [self loadErrorView];
    
    [_errorView showWithError:error];
}

- (void)showErrorViewWithCode:(NSInteger)errorCode{
    [self loadErrorView];
    
    [_errorView showWithErrorCode:errorCode];
}

- (void)loadErrorView{
    if(!_errorView){
        _errorView = [[CXPageErrorView alloc] init];
        _errorView.delegate = self;
        
        CGFloat errorView_X = 0;
        CGFloat errorView_Y = CGRectGetMaxY(self.navigationBar.frame);
        CGFloat errorView_W = CGRectGetWidth(self.view.bounds);
        CGFloat errorView_H = CGRectGetHeight(self.view.bounds) - errorView_Y;
        _errorView.frame = (CGRect){errorView_X, errorView_Y, errorView_W, errorView_H};
        [self addErrorView:_errorView toView:self.view];
    }else{
        [_errorView.superview bringSubviewToFront:_errorView];
    }
}

- (void)addErrorView:(UIView<CXPageErrorViewDefinition> *)errorView toView:(UIView *)view{
    [view addSubview:errorView];
}

- (void)pageErrorViewDidNeedsReload:(UIView<CXPageErrorViewDefinition> *)errorView{
    
}

- (void)pageErrorView:(UIView<CXPageErrorViewDefinition> *)errorView showErrorWithPageTitle:(NSString *)pageTitle{
    self.title = pageTitle;
    self.subtitle = nil;
}

@end
