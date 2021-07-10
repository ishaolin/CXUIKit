//
//  CXAssetBrowserVideoCell.m
//  Pods
//
//  Created by wshaolin on 2018/9/6.
//

#import "CXAssetBrowserVideoCell.h"
#import "CXVideoPlayer.h"
#import "CXImageUtils.h"
#import "UIScreen+CXExtensions.h"
#import "UIColor+CXExtensions.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface CXAssetBrowserVideoCell () <CXVideoPlayerDelegate> {
    CXVideoPlayer *_videoPlayer;
    UIButton *_closeButton;
}

@end

@implementation CXAssetBrowserVideoCell

+ (NSString *)reuseIdentifier{
    static NSString *identifier = @"CXAssetBrowserVideoCell";
    return identifier;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        _videoPlayer = [[CXVideoPlayer alloc] init];
        _videoPlayer.delegate = self;
        [self.containerView addSubview:_videoPlayer];
        
        UIImage *closeButtonIcon = CX_UIKIT_IMAGE(@"ui_page_close");
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:closeButtonIcon forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(handleActionForCloseButton:) forControlEvents:UIControlEventTouchUpInside];
        _closeButton.hidden = YES;
        [self.containerView addSubview:_closeButton];
    }
    
    return self;
}

- (void)setAssetModel:(CXAssetModel *)assetModel{
    [super setAssetModel:assetModel];
    
    if(assetModel.URL){
        [_videoPlayer.snapshotView sd_setImageWithURL:assetModel.videoSnapshotURL placeholderImage:self.thumbnailImage];
        [_videoPlayer setAssetURL:assetModel.URL];
    }else{
        _videoPlayer.snapshotView.image = self.thumbnailImage;
        [_videoPlayer showIndicator];
        [self downloadVideo:^(CXAssetModel *assetModel, UIImage *image) {
            if(self.assetModel == assetModel){
                self->_videoPlayer.snapshotView.image = image;
            }
        } completion:^(CXAssetModel *assetModel, NSURL *videoURL) {
            if(self.assetModel == assetModel && videoURL){
                [self->_videoPlayer setAssetURL:videoURL];
            }
            
            [self->_videoPlayer hideIndicator];
            [self finishAssetDownload:videoURL];
        }];
    }
}

- (UIImage *)image{
    return _videoPlayer.snapshotView.image;
}

- (void)handleActionForCloseButton:(UIButton *)closeButton{
    [_videoPlayer pause];
    [self videoPlayerDidPlayToEnd:_videoPlayer];
    
    if([self.delegate respondsToSelector:@selector(browserCellDidClosed:)]){
        [self.delegate browserCellDidClosed:self];
    }
}

- (void)videoPlayer:(CXVideoPlayer *)videoPlayer didTapWithPlayStatus:(CXVideoPlayStatus)playStatus playControlStatus:(BOOL)hidden{
    if(playStatus == CXVideoPlayStatusLoading){
        _closeButton.hidden = !_closeButton.isHidden;
    }else{
        _closeButton.hidden = hidden;
    }
}

- (void)videoPlayerDidStartPlay:(CXVideoPlayer *)videoPlayer{
    if([self.delegate respondsToSelector:@selector(browserCell:didStartPlayVideo:)]){
        [self.delegate browserCell:self didStartPlayVideo:videoPlayer.videoURL];
    }
}

- (void)videoPlayerDidPlayToEnd:(CXVideoPlayer *)videoPlayer{
    if([self.delegate respondsToSelector:@selector(browserCell:didStopPlayVideo:)]){
        [self.delegate browserCell:self didStopPlayVideo:videoPlayer.videoURL];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    _videoPlayer.frame = self.containerView.bounds;
    
    CGFloat closeButton_W = 40.0;
    CGFloat closeButton_H = closeButton_W;
    CGFloat closeButton_X = 5.0;
    CGFloat closeButton_Y = [UIScreen mainScreen].cx_isBangs ? 85.0 : 10.0;
    _closeButton.frame = (CGRect){closeButton_X, closeButton_Y, closeButton_W, closeButton_H};
}

@end
