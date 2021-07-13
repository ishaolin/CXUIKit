//
//  CXSchemeHandler.m
//  Pods
//
//  Created by wshaolin on 2019/1/29.
//

#import "CXSchemeHandler.h"
#import "CXSchemeEvent.h"
#import "CXSchemeRegistrar.h"
#import "UIViewController+CXUIKit.h"

@implementation CXSchemeHandler

+ (void)handleOpenURL:(NSURL *)URL{
    [self handleOpenURL:URL
             completion:nil];
}

+ (void)handleOpenURL:(NSURL *)URL
           completion:(CXSchemeHandleCompletionBlock)completion{
    [self handleOpenURL:URL
               pushType:CXSchemePushFromCurrentVC
             completion:completion];
}

+ (void)handleOpenURL:(NSURL *)URL
             pushType:(CXSchemePushType)pushType{
    [self handleOpenURL:URL
               pushType:pushType
             completion:nil];
}

+ (void)handleOpenURL:(NSURL *)URL
             pushType:(CXSchemePushType)pushType
           completion:(CXSchemeHandleCompletionBlock)completion{
    [self handleOpenURL:URL
                 params:nil
               pushType:pushType
             completion:completion];
}

+ (void)handleOpenURL:(NSURL *)URL
               params:(NSDictionary<NSString *, id> *)params{
    [self handleOpenURL:URL
                 params:params
             completion:nil];
}

+ (void)handleOpenURL:(NSURL *)URL
               params:(NSDictionary<NSString *, id> *)params
           completion:(CXSchemeHandleCompletionBlock)completion{
    [self handleOpenURL:URL
                 params:params
               pushType:CXSchemePushFromCurrentVC
             completion:completion];
}

+ (void)handleOpenURL:(NSURL *)URL
               params:(NSDictionary<NSString *, id> *)params
             pushType:(CXSchemePushType)pushType
           completion:(CXSchemeHandleCompletionBlock)completion{
    if(URL){
        CXSchemeEvent *event = [[CXSchemeEvent alloc] initWithOpenURL:URL completion:completion];
        event.pushType = pushType;
        [event addParams:params];
        [self handleSchemeEvent:event];
    }
}

+ (void)handleSchemeEvent:(CXSchemeEvent *)event{
    [self handleSchemeEvent: event
       navigationController:[self navigationController]
                pushVCBlock:nil];
}

+ (void)handleSchemeEvent:(CXSchemeEvent *)event
     navigationController:(UINavigationController *)navigationController
              pushVCBlock:(CXSchemePushVCBlock)pushVCBlock{
    if(!event || !navigationController){
        return;
    }
    
    Class clazz = [[CXSchemeRegistrar sharedRegistrar] classWithBusinessPage:event.page forModule:event.module];
    if(![clazz isSubclassOfClass:[UIViewController class]] ||
       ![clazz conformsToProtocol:@protocol(CXSchemeSupporter)]){
        [event finishEventWithError:CXSchemePageNotSupportedError];
        return;
    }
    
    void(^pushViewControllerBlock)(UIViewController *) = ^(UIViewController *VC){
        if(pushVCBlock){
            pushVCBlock(event, navigationController, VC);
        }else{
            [navigationController cx_pushViewController:VC pushType:event.pushType animated:YES];
        }
        
        [event finishEventWithError:nil];
    };
    
    __block UIViewController *VC = nil;
    SEL selector = @selector(initWithURL:params:);
    if([clazz instancesRespondToSelector:selector]){
        VC = [[clazz alloc] performSelector:selector
                                 withObject:event.HTTPURL
                                 withObject:event.params];
        pushViewControllerBlock(VC);
        return;
    }
    
    [navigationController.viewControllers enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isMemberOfClass:clazz]){
            VC = obj;
            *stop = YES;
        }
    }];
    
    if(VC && event.pushType != CXSchemePushFromRootVC){
        if(navigationController.topViewController != VC){
            [navigationController popToViewController:VC animated:YES];
        }
        
        if([VC respondsToSelector:@selector(setNeedsUpdateWithParams:)]){
            [(id<CXSchemeSupporter>)VC setNeedsUpdateWithParams:event.params];
        }
        
        [event finishEventWithError:nil];
    }else{
        if([clazz instancesRespondToSelector:@selector(initWithParams:)]){
            if([clazz respondsToSelector:@selector(preloadRequest:completion:)]){
                [clazz preloadRequest:event.params completion:^(BOOL success, NSDictionary<NSString *, id> *dictionary){
                    [event addParams:dictionary];
                    if(success){
                        VC = [[clazz alloc] initWithParams:event.params];
                        pushViewControllerBlock(VC);
                    }else{
                        [event finishEventWithError:nil];
                    }
                }];
            }else{
                VC = [[clazz alloc] initWithParams:event.params];
                pushViewControllerBlock(VC);
            }
        }else{
            VC = [[clazz alloc] init];
            pushViewControllerBlock(VC);
        }
    }
}

+ (UINavigationController *)navigationController{
    return nil;
}

@end

@implementation CXSchemeHandler (CXURLStringSupported)

+ (void)handleOpenURLString:(NSString *)URLString{
    [self handleOpenURL:[NSURL URLWithString:URLString]];
}

+ (void)handleOpenURLString:(NSString *)URLString
                 completion:(CXSchemeHandleCompletionBlock)completion{
    [self handleOpenURL:[NSURL URLWithString:URLString]
             completion:completion];
}

+ (void)handleOpenURLString:(NSString *)URLString
                   pushType:(CXSchemePushType)pushType{
    [self handleOpenURL:[NSURL URLWithString:URLString]
               pushType:pushType];
}

+ (void)handleOpenURLString:(NSString *)URLString
                   pushType:(CXSchemePushType)pushType
                 completion:(CXSchemeHandleCompletionBlock)completion{
    [self handleOpenURL:[NSURL URLWithString:URLString]
               pushType:pushType
             completion:completion];
}

+ (void)handleOpenURLString:(NSString *)URLString
                     params:(NSDictionary<NSString *, id> *)params{
    [self handleOpenURL:[NSURL URLWithString:URLString]
                 params:params];
}

+ (void)handleOpenURLString:(NSString *)URLString
                     params:(NSDictionary<NSString *, id> *)params
                 completion:(CXSchemeHandleCompletionBlock)completion{
    [self handleOpenURL:[NSURL URLWithString:URLString]
                 params:params
             completion:completion];
}

+ (void)handleOpenURLString:(NSString *)URLString
                     params:(NSDictionary<NSString *, id> *)params
                   pushType:(CXSchemePushType)pushType
                 completion:(CXSchemeHandleCompletionBlock)completion{
    [self handleOpenURL:[NSURL URLWithString:URLString]
                 params:params
               pushType:pushType
             completion:completion];
}

@end
