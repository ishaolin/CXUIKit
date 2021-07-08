//
//  CXSchemeRegistrar.h
//  Pods
//
//  Created by wshaolin on 2019/1/29.
//

#import "CXSchemeSupporter.h"
#import "CXSchemeDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface CXSchemeRegistrar : NSObject

+ (instancetype)sharedRegistrar;

/**
 * 注册scheme页面
 *
 * @param clazz VC class
 * @param page scheme页面标记
 * @param module 业务线
 *
 */
- (void)registerClass:(Class)clazz
         businessPage:(CXSchemeBusinessPage)page
               module:(CXSchemeBusinessModule)module;

/**
 * 根据scheme页面标记和业务线查找VC class
 *
 * @param page scheme页面标记
 * @param module 业务线
 * @return VC class
 *
 */
- (Class)classWithBusinessPage:(CXSchemeBusinessPage)page
                     forModule:(CXSchemeBusinessModule)module;

/**
 * 根据业务线和VC class查找scheme页面标记
 *
 * @param module 业务线
 * @param clazz VC class
 * @return scheme页面标记
 *
 */
- (CXSchemeBusinessPage)businessPageForModule:(CXSchemeBusinessModule)module
                                        class:(Class)clazz;

/**
 * 添加scheme模块注册器
 *
 * @param moduleRegistrar 模块注册器
 *
 */
- (void)addModuleRegistrar:(Class<CXSchemeModuleRegistrar>)moduleRegistrar;

/**
 * 支持模块注册
 *
 */
- (void)registerModule;

@end

NS_ASSUME_NONNULL_END
