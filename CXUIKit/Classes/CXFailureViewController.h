//
//  CXFailureViewController.h
//  Pods
//
//  Created by wshaolin on 2019/10/17.
//

#import "CXBaseViewController.h"
#import "CXFailureView.h"

@interface CXFailureViewController : CXBaseViewController<CXFailureViewDelegate>

- (void)hideFailureView;
- (void)showFailureViewWithError:(NSError *)error;
- (void)showFailureViewWithCode:(NSInteger)code;

- (void)addFailureView:(UIView<CXFailureViewDefinition> *)failureView toView:(UIView *)view;

- (void)failureViewDidNeedsReload:(UIView<CXFailureViewDefinition> *)failureView;
- (void)failureView:(UIView<CXFailureViewDefinition> *)failureView showWithPageTitle:(NSString *)pageTitle;

@end
