//
//  CXErrorViewController.h
//  Pods
//
//  Created by wshaolin on 2019/10/17.
//

#import "CXBaseViewController.h"
#import "CXPageErrorView.h"

@interface CXErrorViewController : CXBaseViewController<CXPageErrorViewDelegate>

- (void)hideErrorView;
- (void)showErrorViewWithError:(NSError *)error;
- (void)showErrorViewWithCode:(NSInteger)errorCode;

- (void)addErrorView:(UIView<CXPageErrorViewDefinition> *)errorView toView:(UIView *)view;

- (void)pageErrorViewDidNeedsReload:(UIView<CXPageErrorViewDefinition> *)errorView;
- (void)pageErrorView:(UIView<CXPageErrorViewDefinition> *)errorView showErrorWithPageTitle:(NSString *)pageTitle;

@end
