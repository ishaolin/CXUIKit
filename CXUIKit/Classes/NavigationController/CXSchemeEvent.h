//
//  CXSchemeEvent.h
//  Pods
//
//  Created by wshaolin on 2019/1/29.
//

#import "CXSchemeDefines.h"

@interface CXSchemeEvent : NSObject

@property (nonatomic, copy, readonly) CXSchemeBusinessModule module;
@property (nonatomic, strong, readonly) NSDictionary<NSString *, id> *params;
@property (nonatomic, copy, readonly) NSString *HTTPURL;
@property (nonatomic, copy, readonly) CXSchemeHandleCompletionBlock completion;

@property (nonatomic, copy) CXSchemeBusinessPage page;
@property (nonatomic, assign) CXSchemePushType pushType;

- (instancetype)initWithOpenURL:(NSURL *)URL
                     completion:(CXSchemeHandleCompletionBlock)completion;

- (instancetype)initWithModule:(CXSchemeBusinessModule)module
                          page:(CXSchemeBusinessPage)page
                    completion:(CXSchemeHandleCompletionBlock)completion;

- (void)addParam:(id)param forKey:(NSString *)key;
- (void)addParams:(NSDictionary<NSString *, id> *)params;
- (void)removeParamForKey:(NSString *)key;

- (void)finishEventWithError:(NSString *)error;

@end
