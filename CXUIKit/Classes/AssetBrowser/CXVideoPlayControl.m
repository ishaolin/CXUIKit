//
//  CXVideoPlayControl.m
//  Pods
//
//  Created by wshaolin on 2018/9/9.
//

#import "CXVideoPlayControl.h"
#import "UIFont+CXExtensions.h"
#import "UIColor+CXExtensions.h"
#import "CXImageUtils.h"
#import <CXFoundation/CXFoundation.h>

@interface CXVideoPlayControl () {
    UIButton *_playButton;
    UILabel *_playTimeLabel;
    UILabel *_totalTimeLabel;
    CXVideoPlaySlider *_slider;
}

@end

@implementation CXVideoPlayControl

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playButton addTarget:self action:@selector(handleActionForPlayButton:) forControlEvents:UIControlEventTouchUpInside];
        
        _playTimeLabel = [[UILabel alloc] init];
        _playTimeLabel.font = CX_PingFangSC_RegularFont(10.0);
        _playTimeLabel.textAlignment = NSTextAlignmentCenter;
        _playTimeLabel.textColor = [UIColor whiteColor];
        
        _totalTimeLabel = [[UILabel alloc] init];
        _totalTimeLabel.font = _playTimeLabel.font;
        _totalTimeLabel.textAlignment = _playTimeLabel.textAlignment;
        _totalTimeLabel.textColor = _playTimeLabel.textColor;
        
        _slider = [[CXVideoPlaySlider alloc] init];
        [_slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [_slider addTarget:self action:@selector(handleActionForSlider:) forControlEvents:UIControlEventTouchCancel | UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
        
        [self addSubview:_playButton];
        [self addSubview:_playTimeLabel];
        [self addSubview:_totalTimeLabel];
        [self addSubview:_slider];
    }
    
    return self;
}

- (void)setTotalTime:(CMTime)totalTime{
    _totalTime = totalTime;
    _totalTimeLabel.text = [NSDate cx_mediaTimeString:(NSInteger)CMTimeGetSeconds(totalTime)];
    
    [self setNeedsLayout];
}

- (void)setPlayTime:(CMTime)playTime{
    _playTime = playTime;
    _playTimeLabel.text = [NSDate cx_mediaTimeString:(NSInteger)CMTimeGetSeconds(playTime)];
    
    double totalTime = CMTimeGetSeconds(_totalTime);
    if(totalTime > 0){
        _slider.value = CMTimeGetSeconds(playTime) / totalTime;
    }else{
        _slider.value = 0;
    }
}

- (void)setPlayStatus:(CXVideoPlayStatus)playStatus{
    _playStatus = playStatus;
    switch (_playStatus) {
        case CXVideoPlayStatusLoading:
        case CXVideoPlayStatusReadyToPlay:
        case CXVideoPlayStatusEndOfPlay:
        case CXVideoPlayStatusPaused:{
            [_playButton setImage:CX_UIKIT_IMAGE(@"ui_video_control_play") forState:UIControlStateNormal];
        }
            break;
        case CXVideoPlayStatusPlaying:{
            [_playButton setImage:CX_UIKIT_IMAGE(@"ui_video_control_pause") forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
}

- (void)sliderValueChanged:(UISlider *)slider{
    CMTime time = self.totalTime;
    time.value *= slider.value;
    _playTimeLabel.text = [NSDate cx_mediaTimeString:(NSInteger)CMTimeGetSeconds(time)];
    
    if([self.delegate respondsToSelector:@selector(videoPlayControl:didSeekToTime:)]){
        [self.delegate videoPlayControl:self didSeekToTime:time];
    }
}

- (void)handleActionForSlider:(UISlider *)slider{
    if(_playStatus == CXVideoPlayStatusPlaying){
        if([self.delegate respondsToSelector:@selector(videoPlayControlDidPlay:)]){
            [self.delegate videoPlayControlDidPlay:self];
        }
    }
}

- (void)handleActionForPlayButton:(UIButton *)playButton{
    if(_playStatus == CXVideoPlayStatusPlaying){
        if([self.delegate respondsToSelector:@selector(videoPlayControlDidPause:)]){
            [self.delegate videoPlayControlDidPause:self];
        }
    }else{
        if([self.delegate respondsToSelector:@selector(videoPlayControlDidPlay:)]){
            [self.delegate videoPlayControlDidPlay:self];
        }
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat playButton_X = 0;
    CGFloat playButton_W = 30.0;
    CGFloat playButton_H = playButton_W;
    CGFloat playButton_Y = (CGRectGetHeight(self.bounds) - playButton_H) * 0.5;
    _playButton.frame = (CGRect){playButton_X, playButton_Y, playButton_W, playButton_H};
    
    CGFloat totalTimeLabel_Y = playButton_Y;
    CGFloat totalTimeLabel_H = playButton_H;
    CGFloat totalTimeLabel_W = [_totalTimeLabel sizeThatFits:CGSizeMake(60.0, playButton_H)].width + 20.0;
    CGFloat totalTimeLabel_X = CGRectGetWidth(self.bounds) - totalTimeLabel_W;
    _totalTimeLabel.frame = (CGRect){totalTimeLabel_X, totalTimeLabel_Y, totalTimeLabel_W, totalTimeLabel_H};
    
    CGFloat playTimeLabel_X = CGRectGetMaxX(_playButton.frame);
    CGFloat playTimeLabel_Y = totalTimeLabel_Y;
    CGFloat playTimeLabel_H = totalTimeLabel_H;
    CGFloat playTimeLabel_W = totalTimeLabel_W;
    _playTimeLabel.frame = (CGRect){playTimeLabel_X, playTimeLabel_Y, playTimeLabel_W, playTimeLabel_H};
    
    CGFloat slider_X = CGRectGetMaxX(_playTimeLabel.frame);
    CGFloat slider_W = totalTimeLabel_X - slider_X;
    CGFloat slider_H = playTimeLabel_H;
    CGFloat slider_Y = playTimeLabel_Y;
    _slider.frame = (CGRect){slider_X, slider_Y, slider_W, slider_H};
}

@end

@implementation CXVideoPlaySlider

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        UIColor *tintColor = [UIColor whiteColor];
        self.minimumTrackTintColor = tintColor;
        self.maximumTrackTintColor = [tintColor colorWithAlphaComponent:0.4];
        
        UIImage *thumbImage = [UIImage cx_imageWithColor:tintColor
                                                    size:CGSizeMake(10.0, 10.0)];
        thumbImage = [thumbImage cx_roundImage];
        [self setThumbImage:thumbImage forState:UIControlStateNormal];
        [self setThumbImage:thumbImage forState:UIControlStateHighlighted];
    }
    
    return self;
}

@end
