//
//  CXSchemeSupporter.h
//  Pods
//
//  Created by wshaolin on 2019/1/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * 网络请求的预加载回调
 *
 * @param success 是否成功，YES: 成功，NO：失败
 * @param dictionary 数据
 */
typedef void(^CXSchemePreloadCompletionBlock)(BOOL success, NSDictionary<NSString *, id> * _Nullable dictionary);

/**
 * 页面VC支持scheme跳转的相关方法定义
 *
 */
@protocol CXSchemeSupporter <NSObject>

@required
/**
 * 注册scheme支持
 *
 */
+ (void)registerSchemeSupporter;

@optional
/**
 * 处理网络请求。部分页面需要根据数据做初始化
 *
 * @param params 参数
 * @param completion 回调
 *
 */
+ (void)preloadRequest:(NSDictionary<NSString *, id> *)params completion:(CXSchemePreloadCompletionBlock)completion;

/**
 * scheme方式初始化页面
 *
 * @param params 初始化需要的参数
 * @return 页面实例
 *
 */
- (instancetype)initWithParams:(nullable NSDictionary<NSString *, id> *)params;

/**
 * 通过scheme方式重新回到页面，调用此方法刷新页面。主要处理页面数据变化的情况
 *
 * @param params 新的参数
 *
 */
- (void)setNeedsUpdateWithParams:(nullable NSDictionary<NSString *, id> *)params;

@end

@protocol CXSchemeModuleRegistrar <NSObject>

@required
/**
 * scheme模块注册器，在此方法中完成真正的scheme页面注册。避免影响启动速度
 *
 */
+ (void)registerSchemeSupporterClass;

@end

NS_ASSUME_NONNULL_END
