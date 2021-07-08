//
//  CXVideoPlayControl.h
//  Pods
//
//  Created by wshaolin on 2018/9/9.
//

#import <UIKit/UIKit.h>
#import <CoreMedia/CoreMedia.h>
#import "CXVideoPlayStatus.h"

@class CXVideoPlayControl;

@protocol CXVideoPlayControlDelegate <NSObject>

@optional

- (void)videoPlayControl:(CXVideoPlayControl *)playControl didSeekToTime:(CMTime)time;

- (void)videoPlayControlDidPlay:(CXVideoPlayControl *)playControl;

- (void)videoPlayControlDidPause:(CXVideoPlayControl *)playControl;

@end

@interface CXVideoPlayControl : UIView

@property (nonatomic, weak) id<CXVideoPlayControlDelegate> delegate;
@property (nonatomic, assign) CMTime totalTime;
@property (nonatomic, assign) CMTime playTime;

@property (nonatomic, assign) CXVideoPlayStatus playStatus;

@end

@interface CXVideoPlaySlider : UISlider

@end
