//
//  CXAppUtils.h
//  Pods
//
//  Created by wshaolin on 2019/1/28.
//

#import <Foundation/Foundation.h>

@interface CXAppUtils : NSObject

+ (void)openSettingsPage;

+ (void)openSettingsPageWithCompletion:(void (^)(BOOL success))completion;

+ (void)openURL:(NSURL *)URL;

+ (void)openURL:(NSURL *)URL completion:(void (^)(BOOL success))completion;

@end
