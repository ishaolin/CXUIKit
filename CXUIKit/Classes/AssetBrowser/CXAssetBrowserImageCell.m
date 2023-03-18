//
//  CXAssetBrowserImageCell.m
//  Pods
//
//  Created by wshaolin on 2018/9/6.
//

#import "CXAssetBrowserImageCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CXZoomingView.h"
#import "CXAlertControllerUtils.h"
#import "UIActivityIndicatorView+CXUIKit.h"

@interface CXAssetBrowserImageCell () <CXZoomingViewDelegate> {
    UIScrollView *_contentView;
    CXZoomingView *_zoomingView;
    UIActivityIndicatorView *_indicatorView;
}

@end

@implementation CXAssetBrowserImageCell

+ (NSString *)reuseIdentifier{
    static NSString *identifier = @"CXAssetBrowserImageCell";
    return identifier;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        _zoomingView = [[CXZoomingView alloc] init];
        _zoomingView.delegate = self;
        [self.containerView addSubview:_zoomingView];
        
        _indicatorView = [UIActivityIndicatorView largeIndicatorView];
        [self addSubview:_indicatorView];
    }
    
    return self;
}

- (void)setAssetModel:(CXAssetModel *)assetModel{
    [super setAssetModel:assetModel];
    
    [_indicatorView startAnimating];
    if(assetModel.URL){
        [_zoomingView.imageView sd_setImageWithURL:assetModel.URL placeholderImage:self.thumbnailImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            [self->_indicatorView stopAnimating];
            [self->_zoomingView setImage:image];
            [self finishAssetDownload:image];
        }];
    }else{
        [_zoomingView setImage:self.thumbnailImage];
        [self downloadImage:^(CXAssetModel *assetModel, UIImage *image) {
            [self->_indicatorView stopAnimating];
            
            if(self.assetModel == assetModel){
                [self->_zoomingView setImage:image];
            }
            
            [self finishAssetDownload:image];
        }];
    }
}

- (void)zoomingViewDidSingleTapEvent:(CXZoomingView *)zoomingView{
    if([self.delegate respondsToSelector:@selector(browserCellDidClosed:)]){
        [self.delegate browserCellDidClosed:self];
    }
}

- (void)zoomingViewDidLongPressEvent:(CXZoomingView *)zoomingView{
    if(!_zoomingView.imageView.image || !self.isLongPressEnabled){
        return;
    }
    
    [CXActionSheetUtils showActionSheetWithConfigBlock:^(CXActionSheetControllerConfigModel *config) {
        config.buttonTitles = @[@"保存图片"];
    } completion:^(NSInteger buttonIndex) {
        if(buttonIndex == 0){
            [self saveAssetToPhotosAlbum:self->_zoomingView.imageView.image];
        }
    }];
}

- (UIImage *)image{
    return _zoomingView.imageView.image;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    _zoomingView.frame = self.containerView.bounds;
    _indicatorView.center = _zoomingView.center;
}

@end
