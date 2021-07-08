//
//  CXDataRecord.h
//  Pods
//
//  Created by wshaolin on 2019/2/12.
//

#ifndef CXDataRecord_h
#define CXDataRecord_h

#if __has_include(<CXDataSDK/CXDataSDK.h>)
#import <CXDataSDK/CXDataSDK.h>
#define CXDataRecordX(e, x) [CXDataSDK record:e params:x]
#else
#define CXDataRecordX(e, x) do { } while(0)
#endif

#define CXDataRecord(e) CXDataRecordX(e, nil)

#endif /* CXDataRecord_h */
