//
//  CXVideoPlayStatus.h
//  Pods
//
//  Created by wshaolin on 2019/1/22.
//

#ifndef CXVideoPlayStatus_h
#define CXVideoPlayStatus_h

typedef NS_ENUM(NSInteger, CXVideoPlayStatus){
    CXVideoPlayStatusLoading,               // 数据加载中
    CXVideoPlayStatusReadyToPlay,           // 等待播放
    CXVideoPlayStatusPlaying,               // 播放中
    CXVideoPlayStatusPaused,                // 暂停状态
    CXVideoPlayStatusEndOfPlay              // 播放结束
};

#endif /* CXVideoPlayStatus_h */
