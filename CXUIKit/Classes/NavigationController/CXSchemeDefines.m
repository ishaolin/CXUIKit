//
//  CXSchemeDefines.m
//  Pods
//
//  Created by wshaolin on 2019/1/29.
//

#import "CXSchemeDefines.h"

CXSchemeBusinessModule const CXSchemeBusinessModuleApplication = @"application";
CXSchemeBusinessPage const CXSchemeBusinessWebPage = @"webpage";
NSString * const CXSchemePageNotSupportedError = @"scheme_page_not_supported";

NSURL *CXSchemeURLMake(CXScheme scheme,
                       CXSchemeBusinessModule module,
                       CXSchemeBusinessPage page,
                       NSDictionary<NSString *, id> *params){
    if(CXStringIsEmpty(scheme) || CXStringIsEmpty(module) || CXStringIsEmpty(page)){
        return nil;
    }
    
    NSString *URL = [NSString stringWithFormat:@"%@://%@/%@", scheme, module, page];
    if(CXDictionaryIsEmpty(params)){
        return [NSURL URLWithString:URL];
    }
    
    NSURLComponents *URLComponents = [[NSURLComponents alloc] initWithString:URL];
    NSMutableArray<NSURLQueryItem *> *queryItems = [NSMutableArray array];
    [params enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSURLQueryItem *queryItem = [[NSURLQueryItem alloc] initWithName:key value:[NSString stringWithFormat:@"%@", obj].stringByRemovingPercentEncoding];
        [queryItems addObject:queryItem];
    }];
    URLComponents.queryItems = [queryItems copy];
    
    return URLComponents.URL;
}
