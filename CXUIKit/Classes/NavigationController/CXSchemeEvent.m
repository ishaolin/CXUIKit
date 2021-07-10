//
//  CXSchemeEvent.m
//  Pods
//
//  Created by wshaolin on 2019/1/29.
//

#import "CXSchemeEvent.h"

@interface CXSchemeEvent () {
    NSMutableDictionary<NSString *, id> *_params;
}

@end

@implementation CXSchemeEvent

- (instancetype)initWithOpenURL:(NSURL *)URL completion:(CXSchemeHandleCompletionBlock)completion{
    if(self = [super init]){
        _completion = [completion copy];
        _params = [NSMutableDictionary dictionary];
        
        if([CXStringUtils isHTTPURL:URL.absoluteString]){
            _module = CXSchemeBusinessModuleApplication;
            _page = CXSchemeBusinessWebPage;
            _HTTPURL = URL.absoluteString;
        }else{
            _module = URL.host;
            _page = URL.path.lastPathComponent;
            
            [self addParams:[URL cx_params]];
            
            if([_page isEqualToString:CXSchemeBusinessWebPage]){
                _HTTPURL = [_params cx_stringForKey:@"url"] ?: [_params cx_stringForKey:@"page"];
            }
        }
    }
    
    return self;
}

- (instancetype)initWithModule:(CXSchemeBusinessModule)module
                          page:(CXSchemeBusinessPage)page
                    completion:(CXSchemeHandleCompletionBlock)completion{
    if(self = [super init]){
        _completion = [completion copy];
        _params = [NSMutableDictionary dictionary];
        _module = module;
        _page = page;
    }
    
    return self;
}

- (NSDictionary<NSString *,id> *)params{
    return [_params copy];
}

- (void)addParam:(id)param forKey:(NSString *)key{
    [_params cx_setObject:param forKey:key];
}

- (void)addParams:(NSDictionary<NSString *, id> *)params{
    if(params){
        [_params addEntriesFromDictionary:params];
    }
}

- (void)removeParamForKey:(NSString *)key{
    if(!key){
        return;
    }
    
    [_params removeObjectForKey:key];
}

- (void)finishEventWithError:(NSString *)error{
    if(self.completion){
        self.completion(self.module, self.page, error);
        _completion = nil;
    }
}

@end
