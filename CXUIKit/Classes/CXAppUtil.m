//
//  CXAppUtil.m
//  Pods
//
//  Created by wshaolin on 2019/1/28.
//

#import "CXAppUtil.h"
#import <UIKit/UIKit.h>

@implementation CXAppUtil

+ (void)openOSSettingPage{
    [self openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

+ (void)openURL:(NSURL *)URL{
    [self openURL:URL completion:nil];
}

+ (void)openURL:(NSURL *)URL completion:(void (^)(BOOL success))completion{
    if(!URL){
        !completion ?: completion(NO);
        return;
    }
    
    if([[UIApplication sharedApplication] canOpenURL:URL]){
        if(@available(iOS 10.0, *)){
            [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:completion];
        }else{
            [[UIApplication sharedApplication] openURL:URL];
            !completion ?: completion(YES);
        }
    }else{
        !completion ?: completion(NO);
    }
}

@end
