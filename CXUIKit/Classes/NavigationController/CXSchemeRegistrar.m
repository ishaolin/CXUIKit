//
//  CXSchemeRegistrar.m
//  Pods
//
//  Created by wshaolin on 2019/1/29.
//

#import "CXSchemeRegistrar.h"

@interface CXSchemeRegistrar () {
    NSMutableDictionary<NSString *, Class> *_pages;
    NSHashTable<Class<CXSchemeModuleRegistrar>> *_moduleClasses;
}

@end

@implementation CXSchemeRegistrar

+ (instancetype)sharedRegistrar{
    static CXSchemeRegistrar *schemeRegistrar;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        schemeRegistrar = [[CXSchemeRegistrar alloc] init];
        schemeRegistrar->_pages = [NSMutableDictionary dictionary];
        schemeRegistrar->_moduleClasses = [NSHashTable weakObjectsHashTable];
    });
    
    return schemeRegistrar;
}

- (void)registerClass:(Class)clazz
         businessPage:(CXSchemeBusinessPage)page
               module:(CXSchemeBusinessModule)module{
    if(!clazz){
        return;
    }
    
    NSString *key = [self keyWithBusinessPage:page module:module];
    _pages[key] = clazz;
}

- (Class)classWithBusinessPage:(CXSchemeBusinessPage)page
                     forModule:(CXSchemeBusinessModule)module{
    NSString *key = [self keyWithBusinessPage:page module:module];
    return _pages[key];
}

- (CXSchemeBusinessPage)businessPageForModule:(CXSchemeBusinessModule)module class:(Class)clazz{
    if(!module || !clazz){
        return nil;
    }
    
    __block CXSchemeBusinessPage page = nil;
    [_pages enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, Class  _Nonnull obj, BOOL * _Nonnull stop) {
        if(obj == clazz && [key rangeOfString:module].location != NSNotFound){
            page = [key substringFromIndex:module.length + 1];
            *stop = YES;
        }
    }];
    
    return page;
}

- (NSString *)keyWithBusinessPage:(CXSchemeBusinessPage)page module:(CXSchemeBusinessModule)module{
    return [NSString stringWithFormat:@"%@/%@", module, page];
}

- (void)addModuleRegistrar:(Class<CXSchemeModuleRegistrar>)moduleRegistrar{
    if(moduleRegistrar){
        [_moduleClasses addObject:moduleRegistrar];
    }
}

- (void)registerModule{
    if(_moduleClasses.count == 0){
        return;
    }
    
    [_moduleClasses.allObjects enumerateObjectsUsingBlock:^(Class<CXSchemeModuleRegistrar>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj registerSchemeSupporterClass];
    }];
    
    [_moduleClasses removeAllObjects];
}

@end
