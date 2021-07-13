//
//  CXVideoPlayer.h
//  Pods
//
//  Created by wshaolin on 2018/9/8.
//

#import <UIKit/UIKit.h>
#import <CoreMedia/CoreMedia.h>
#import "CXVideoPlayStatus.h"

@class CXVideoPlayer;
@class AVAsset;
@class AVPlayerItem;

@protocol CXVideoPlayerDelegate <NSObject>

@optional

- (void)videoPlayerDidReadyToPlay:(CXVideoPlayer *)videoPlayer;
- (void)videoPlayerDidStartPlay:(CXVideoPlayer *)videoPlayer;
- (void)videoPlayerDidPlayToEnd:(CXVideoPlayer *)videoPlayer;

- (void)videoPlayer:(CXVideoPlayer *)videoPlayer didPlayToTime:(CMTime)time;

- (void)videoPlayer:(CXVideoPlayer *)videoPlayer didTapWithPlayStatus:(CXVideoPlayStatus)playStatus playControlStatus:(BOOL)hidden;

@end

@interface CXVideoPlayer : UIView

@property (nonatomic, weak) id<CXVideoPlayerDelegate> delegate;
@property (nonatomic, strong, readonly) UIImageView *snapshotView;
@property (nonatomic, strong, readonly) NSURL *videoURL;
@property (nonatomic, assign, readonly) NSInteger totalTime;

- (void)setAssetURL:(NSURL *)URL;
- (void)setPlayerItem:(AVPlayerItem *)playerItem;

- (void)play;
- (void)stop;

- (void)pause;
- (void)resume;

- (void)hidePlayControl;
- (void)removePlayControl;

- (void)showIndicator;
- (void)hideIndicator;

@end
