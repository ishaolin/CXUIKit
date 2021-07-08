//
//  CXSchemeDefines.h
//  Pods
//
//  Created by wshaolin on 2019/1/29.
//

#import <CXFoundation/CXFoundation.h>
#import "CXUIKitDefines.h"

typedef NSString *CXScheme;
typedef NSString *CXSchemeBusinessModule;
typedef NSString *CXSchemeBusinessPage;

typedef NS_ENUM(NSInteger, CXSchemePushType) {
    CXSchemePushFromCurrentVC,          // 从当前VC跳转
    CXSchemePushFromRootVC,             // 从根VC跳转
    CXSchemePushAfterDestroyCurrentVC   // 从当前VC跳转，跳转完成之后销毁当前VC，前提：当前VC不是根VC
};

typedef void(^CXSchemeHandleCompletionBlock)(CXSchemeBusinessModule module,
                                             CXSchemeBusinessPage page,
                                             NSString *error);

CX_UIKIT_EXTERN CXSchemeBusinessModule const CXSchemeBusinessModuleApplication;
CX_UIKIT_EXTERN CXSchemeBusinessPage const CXSchemeBusinessWebPage;
CX_UIKIT_EXTERN NSString * const CXSchemePageNotSupportedError;

CX_UIKIT_EXTERN NSURL *CXSchemeURLMake(CXScheme scheme,
                                       CXSchemeBusinessModule module,
                                       CXSchemeBusinessPage page,
                                       NSDictionary<NSString *, id> *params);

