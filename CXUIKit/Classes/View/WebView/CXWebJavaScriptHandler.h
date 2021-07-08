//
//  CXWebJavaScriptHandler.h
//  Pods
//
//  Created by wshaolin on 2019/1/23.
//

#import <Foundation/Foundation.h>

@class WKUserContentController;

@protocol CXWebJavaScriptMessageHandler <NSObject>

@optional

- (void)webJavaScriptHandler:(NSString *)handlerName
        didMessageWithParams:(NSDictionary<NSString *, id> *)params
                      callId:(NSString *)callId;

@end

@interface CXWebJavaScriptHandler : NSObject

@property (nonatomic, weak) id<CXWebJavaScriptMessageHandler> delegate;

- (instancetype)initWithUserController:(WKUserContentController *)userController;

- (void)registerHandler:(NSString *)handlerName;

@end
