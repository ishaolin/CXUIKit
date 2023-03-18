//
//  CXFailureViewDefinition.h
//  Pods
//
//  Created by wshaolin on 2019/4/17.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CXFailureCode){
    CXFailureCodeTimedOut              = 0, // 超时
    CXFailureCodeInternetUnavailable   = 1, // 网络不可用
    CXFailureCodeBadURL                = 2, // 404错误
    CXFailureCodeNoData                = 3  // 暂无数据
};

@protocol CXFailureViewDefinition;

@protocol CXFailureViewDelegate <NSObject>

@optional

- (void)failureViewDidNeedsReload:(UIView<CXFailureViewDefinition> *)failureView;
- (void)failureView:(UIView<CXFailureViewDefinition> *)failureView showWithPageTitle:(NSString *)pageTitle;

@end

@protocol CXFailureViewDefinition <NSObject>

@property (nonatomic, weak) id<CXFailureViewDelegate> delegate;

- (void)showWithError:(NSError *)error;

- (void)showWithFailureCode:(CXFailureCode)code;

@end
