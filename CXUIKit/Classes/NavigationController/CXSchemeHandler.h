//
//  CXSchemeHandler.h
//  Pods
//
//  Created by wshaolin on 2019/1/29.
//

#import "CXSchemeDefines.h"

@class CXSchemeEvent, UINavigationController, UIViewController;

typedef void(^CXSchemePushVCBlock)(CXSchemeEvent *event,
                                   UINavigationController *navigationVC,
                                   UIViewController *targetVC);

@interface CXSchemeHandler : NSObject

+ (void)handleOpenURL:(NSURL *)URL;
+ (void)handleOpenURL:(NSURL *)URL
           completion:(CXSchemeHandleCompletionBlock)completion;

+ (void)handleOpenURL:(NSURL *)URL
             pushType:(CXSchemePushType)pushType;
+ (void)handleOpenURL:(NSURL *)URL
             pushType:(CXSchemePushType)pushType
           completion:(CXSchemeHandleCompletionBlock)completion;

+ (void)handleOpenURL:(NSURL *)URL
               params:(NSDictionary<NSString *, id> *)params;
+ (void)handleOpenURL:(NSURL *)URL
               params:(NSDictionary<NSString *, id> *)params
           completion:(CXSchemeHandleCompletionBlock)completion;

+ (void)handleOpenURL:(NSURL *)URL
               params:(NSDictionary<NSString *, id> *)params
             pushType:(CXSchemePushType)pushType
           completion:(CXSchemeHandleCompletionBlock)completion;

+ (void)handleSchemeEvent:(CXSchemeEvent *)event;

+ (void)handleSchemeEvent:(CXSchemeEvent *)event
     navigationController:(UINavigationController *)navigationController
              pushVCBlock:(CXSchemePushVCBlock)pushVCBlock;

+ (UINavigationController *)navigationController; // 需要子类实现，父类方法返回nil

@end

@interface CXSchemeHandler (CXURLStringSupported)

+ (void)handleOpenURLString:(NSString *)URLString;
+ (void)handleOpenURLString:(NSString *)URLString
                 completion:(CXSchemeHandleCompletionBlock)completion;

+ (void)handleOpenURLString:(NSString *)URLString
                   pushType:(CXSchemePushType)pushType;
+ (void)handleOpenURLString:(NSString *)URLString
                   pushType:(CXSchemePushType)pushType
                 completion:(CXSchemeHandleCompletionBlock)completion;

+ (void)handleOpenURLString:(NSString *)URLString
                     params:(NSDictionary<NSString *, id> *)params;
+ (void)handleOpenURLString:(NSString *)URLString
                     params:(NSDictionary<NSString *, id> *)params
                 completion:(CXSchemeHandleCompletionBlock)completion;

+ (void)handleOpenURLString:(NSString *)URLString
                     params:(NSDictionary<NSString *, id> *)params
                   pushType:(CXSchemePushType)pushType
                 completion:(CXSchemeHandleCompletionBlock)completion;

@end
