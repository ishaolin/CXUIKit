//
//  CXAppUtil.h
//  Pods
//
//  Created by wshaolin on 2019/1/28.
//

#import <Foundation/Foundation.h>

@interface CXAppUtil : NSObject

+ (void)openOSSettingPage;

+ (void)openURL:(NSURL *)URL;

+ (void)openURL:(NSURL *)URL completion:(void (^)(BOOL success))completion;

@end
