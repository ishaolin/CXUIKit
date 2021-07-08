//
//  CXWebViewBridgeDefines.h
//  Pods
//
//  Created by wshaolin on 2017/11/15.
//

#ifndef CXWebViewBridgeDefines_h
#define CXWebViewBridgeDefines_h

#import <Foundation/Foundation.h>

typedef void(^CXWebViewBridgeCallback)(NSDictionary<NSString *, id> *data);
typedef void(^CXWebViewBridgeHandler)(NSDictionary<NSString *, id> *data, CXWebViewBridgeCallback callback);

#endif /* CXWebViewBridgeDefines_h */
