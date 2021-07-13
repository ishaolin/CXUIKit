//
//  CXVideoPlayer.m
//  Pods
//
//  Created by wshaolin on 2018/9/8.
//

#import "CXVideoPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import <CXFoundation/CXFoundation.h>
#import "CXImageUtils.h"
#import "UIColor+CXUIKit.h"
#import "CXVideoPlayControl.h"
#import "UIScreen+CXUIKit.h"
#import "CXSystemAdapter.h"

#define CX_KVO_KEYPATH_status @"status"
#define CX_KVO_KEYPATH_loadedTimeRanges @"loadedTimeRanges"

@interface CXVideoPlayer () <CXVideoPlayControlDelegate, UIGestureRecognizerDelegate> {
    AVPlayerLayer *_playerLayer;
    UIButton *_playButton;
    UIActivityIndicatorView *_indicatorView;
    CXVideoPlayControl *_playControl;
    
    id _playerTimeObserver;
    CMTime _seekTime;
}

@end

@implementation CXVideoPlayer

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        _snapshotView = [[UIImageView alloc] init];
        _snapshotView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_snapshotView];
        
        _playControl = [[CXVideoPlayControl alloc] init];
        _playControl.hidden = YES;
        _playControl.delegate = self;
        [self addSubview:_playControl];
        
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *playButtonIcon = CX_UIKIT_IMAGE(@"ui_video_play");
        [_playButton setImage:playButtonIcon forState:UIControlStateNormal];
        [_playButton addTarget:self action:@selector(handleActionForPlayButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_playButton];
        
        _indicatorView = [CXSystemAdapter largeActivityIndicatorView];
        _indicatorView.hidden = YES;
        [self addSubview:_indicatorView];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestureRecognizer:)];
        tapGestureRecognizer.delegate = self;
        [self addGestureRecognizer:tapGestureRecognizer];
    }
    
    return self;
}

- (void)handleTapGestureRecognizer:(UITapGestureRecognizer *)tapGestureRecognizer{
    _playControl.hidden = !_playControl.isHidden;
    
    if([self.delegate respondsToSelector:@selector(videoPlayer:didTapWithPlayStatus:playControlStatus:)]){
        [self.delegate videoPlayer:self
              didTapWithPlayStatus:_playControl.playStatus
                 playControlStatus:_playControl.isHidden];
    }
}

- (void)setAssetURL:(NSURL *)URL{
    _videoURL = URL;
    [self loadPlayerItem:[AVPlayerItem playerItemWithURL:_videoURL]];
}

- (void)setPlayerItem:(AVPlayerItem *)playerItem{
    _videoURL = nil;
    [self loadPlayerItem:playerItem];
}

- (void)loadPlayerItem:(AVPlayerItem *)item{
    [_playerLayer removeFromSuperlayer];
    if(_playerTimeObserver){
        [_playerLayer.player removeTimeObserver:_playerTimeObserver];
    }
    
    [_playerLayer.player.currentItem removeObserver:self forKeyPath:CX_KVO_KEYPATH_status];
    [_playerLayer.player.currentItem removeObserver:self forKeyPath:CX_KVO_KEYPATH_loadedTimeRanges];
    
    [item addObserver:self
           forKeyPath:CX_KVO_KEYPATH_status
              options:NSKeyValueObservingOptionNew
              context:nil];
    [item addObserver:self
           forKeyPath:CX_KVO_KEYPATH_loadedTimeRanges
              options:NSKeyValueObservingOptionNew
              context:nil];
    
    AVPlayer *player = [[AVPlayer alloc] initWithPlayerItem:item];
    @weakify(self);
    _playerTimeObserver = [player addPeriodicTimeObserverForInterval:CMTimeMake(1, 10) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        @strongify(self);
        [self playToTime:time];
    }];
    
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    _playerLayer.frame = self.bounds;
    _seekTime = CMTimeMake(0, 1);
    _playControl.playStatus = CXVideoPlayStatusLoading;
    
    [NSNotificationCenter addObserver:self
                               action:@selector(playerItemDidPlayToEndTimeNotification:)
                                 name:AVPlayerItemDidPlayToEndTimeNotification
                               object:item];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.layer insertSublayer:self->_playerLayer above:self->_snapshotView.layer];
    });
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if(![object isKindOfClass:[AVPlayerItem class]]){
        return;
    }
    
    AVPlayerItem *item = (AVPlayerItem *)object;
    if([keyPath isEqualToString:CX_KVO_KEYPATH_status]){
        if(item.status == AVPlayerStatusReadyToPlay){
            _playControl.totalTime = item.duration;
            _playControl.playTime = kCMTimeZero;
            _playControl.playStatus = CXVideoPlayStatusReadyToPlay;
            _playButton.hidden = NO;
            [self bringSubviewToFront:_playControl];
            
            if([self.delegate respondsToSelector:@selector(videoPlayerDidReadyToPlay:)]){
                [self.delegate videoPlayerDidReadyToPlay:self];
            }
        }
    }else if([keyPath isEqualToString:CX_KVO_KEYPATH_loadedTimeRanges]){
        // 网络缓存处理
    }
}

- (void)playToTime:(CMTime)time{
    _playControl.playTime = time;
    
    if([self.delegate respondsToSelector:@selector(videoPlayer:didPlayToTime:)]){
        [self.delegate videoPlayer:self didPlayToTime:time];
    }
}

- (void)play{
    [self seekToTime:_seekTime completion:^(BOOL finished) {
        if(!finished){
            return;
        }
        
        [CXDispatchHandler asyncOnMainQueue:^{
            [self->_playerLayer.player play];
            self->_playControl.playStatus = CXVideoPlayStatusPlaying;
            self->_playButton.hidden = YES;
            
            if([self.delegate respondsToSelector:@selector(videoPlayerDidStartPlay:)]){
                [self.delegate videoPlayerDidStartPlay:self];
            }
        }];
    }];
}

- (void)stop{
    [self pause];
    
    _playControl.playStatus = CXVideoPlayStatusEndOfPlay;
    [self seekToTime:CMTimeMake(0, 1) completion:nil];
}

- (void)pause{
    if(@available(iOS 10.0, *)){
        if(_playerLayer.player.timeControlStatus != AVPlayerTimeControlStatusPaused){
            [_playerLayer.player pause];
            _playControl.playStatus = CXVideoPlayStatusPaused;
            _playButton.hidden = NO;
        }
    }else{
        [_playerLayer.player pause];
        _playControl.playStatus = CXVideoPlayStatusPaused;
        _playButton.hidden = NO;
    }
}

- (void)resume{
    if(_playControl.playStatus == CXVideoPlayStatusReadyToPlay ||
       _playControl.playStatus == CXVideoPlayStatusEndOfPlay){
        [self play];
    }else{
        if(@available(iOS 10.0, *)){
            if(_playerLayer.player.timeControlStatus == AVPlayerTimeControlStatusPlaying){
                return;
            }
        }
        
        [self seekToTime:_seekTime completion:^(BOOL finished) {
            if(!finished){
                return;
            }
            
            [CXDispatchHandler asyncOnMainQueue:^{
                [self->_playerLayer.player play];
                self->_playControl.playStatus = CXVideoPlayStatusPlaying;
                self->_playButton.hidden = YES;
            }];
        }];
    }
}

- (void)handleActionForPlayButton:(UIButton *)playButton{
    [self resume];
}

- (void)showIndicator{
    _indicatorView.hidden = NO;
    [_indicatorView startAnimating];
    
    [self hidePlayControl];
}

- (void)hidePlayControl{
    _playButton.hidden = YES;
    _playControl.playStatus = CXVideoPlayStatusLoading;
    _playControl.hidden = YES;
}

- (void)removePlayControl{
    [_playButton removeFromSuperview];
    [_playControl removeFromSuperview];
}

- (void)hideIndicator{
    [_indicatorView stopAnimating];
}

- (void)playerItemDidPlayToEndTimeNotification:(NSNotification *)notification{
    [CXDispatchHandler asyncOnMainQueue:^{
        self->_playControl.playStatus = CXVideoPlayStatusEndOfPlay;
        self->_playControl.hidden = NO;
        self->_playButton.hidden = NO;
        [self seekToTime:CMTimeMake(0, 1) completion:nil];
        if([self.delegate respondsToSelector:@selector(videoPlayerDidPlayToEnd:)]){
            [self.delegate videoPlayerDidPlayToEnd:self];
        }
    }];
}

- (void)seekToTime:(CMTime)time completion:(void (^)(BOOL finished))completion{
    _seekTime = time;
    if(CMTIME_IS_VALID(time)){
        [_playerLayer.player seekToTime:time
                        toleranceBefore:kCMTimeZero
                         toleranceAfter:kCMTimeZero
                      completionHandler:completion];
    }else{
        !completion ?: completion(YES);
    }
}

- (void)videoPlayControlDidPlay:(CXVideoPlayControl *)playControl{
    [self resume];
}

- (void)videoPlayControlDidPause:(CXVideoPlayControl *)playControl{
    _seekTime = kCMTimeInvalid;
    
    [self pause];
}

- (void)videoPlayControl:(CXVideoPlayControl *)playControl didSeekToTime:(CMTime)time{
    [_playerLayer.player pause];
    _seekTime = time;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if(touch.view == _playControl){
        return NO;
    }
    
    if(touch.view.superview == _playControl){
        return NO;
    }
    
    if([touch.view isKindOfClass:[UIControl class]]){
        return NO;
    }
    
    return YES;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    _snapshotView.frame = self.bounds;
    _playerLayer.frame = self.bounds;
    _indicatorView.center = self.center;
    
    CGFloat playButton_W = 53.0;
    CGFloat playButton_H = playButton_W;
    CGFloat playButton_X = (CGRectGetWidth(self.bounds) - playButton_W) * 0.5;
    CGFloat playButton_Y = (CGRectGetHeight(self.bounds) - playButton_H) * 0.5;
    _playButton.frame = (CGRect){playButton_X, playButton_Y, playButton_W, playButton_H};
    
    CGFloat playControl_X = 15.0;
    CGFloat playControl_H = 30.0;
    CGFloat playControl_W = CGRectGetWidth(self.bounds) - playControl_X * 2;
    CGFloat playControl_Y = CGRectGetHeight(self.bounds) - playControl_H - 20.0;
    if([UIScreen mainScreen].cx_isBangs){
        playControl_Y -= 70.0;
    }
    _playControl.frame = (CGRect){playControl_X, playControl_Y, playControl_W, playControl_H};
}

- (void)dealloc{
    [NSNotificationCenter removeObserver:self];
    
    if(_playerTimeObserver){
        [_playerLayer.player removeTimeObserver:_playerTimeObserver];
    }
    
    [_playerLayer.player.currentItem removeObserver:self forKeyPath:CX_KVO_KEYPATH_status];
    [_playerLayer.player.currentItem removeObserver:self forKeyPath:CX_KVO_KEYPATH_loadedTimeRanges];
    [_playerLayer.player.currentItem cancelPendingSeeks];
    [_playerLayer.player.currentItem.asset cancelLoading];
    
    _playerLayer = nil;
    _playerTimeObserver = nil;
}

@end
