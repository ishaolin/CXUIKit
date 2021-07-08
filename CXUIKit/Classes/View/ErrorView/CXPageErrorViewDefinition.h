//
//  CXPageErrorViewDefinition.h
//  Pods
//
//  Created by wshaolin on 2019/4/17.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CXPageErrorCode){
    CXPageErrorCodeTimedOut              = 0, // 超时
    CXPageErrorCodeInternetUnavailable   = 1, // 网络不可用
    CXPageErrorCodeBadURL                = 2, // 404错误
    CXPageErrorCodeNoData                = 3  // 暂无数据
};

@protocol CXPageErrorViewDefinition;

@protocol CXPageErrorViewDelegate <NSObject>

@optional

- (void)pageErrorViewDidNeedsReload:(UIView<CXPageErrorViewDefinition> *)errorView;
- (void)pageErrorView:(UIView<CXPageErrorViewDefinition> *)errorView showErrorWithPageTitle:(NSString *)pageTitle;

@end

@protocol CXPageErrorViewDefinition <NSObject>

@property (nonatomic, weak) id<CXPageErrorViewDelegate> delegate;

- (void)showWithError:(NSError *)error;

- (void)showWithErrorCode:(CXPageErrorCode)errorCode;

@end
