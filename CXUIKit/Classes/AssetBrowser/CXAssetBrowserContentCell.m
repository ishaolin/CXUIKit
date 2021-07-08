//
//  CXAssetBrowserContentCell.m
//  Pods
//
//  Created by wshaolin on 2018/9/6.
//

#import "CXAssetBrowserContentCell.h"
#import <SDWebImage/SDWebImageManager.h>

@interface CXAssetBrowserContentCell () {
    
}

@end

@implementation CXAssetBrowserContentCell

+ (NSString *)reuseIdentifier{
    static NSString *identifier = @"CXAssetBrowserContentCell";
    return identifier;
}

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath{
    return [collectionView dequeueReusableCellWithReuseIdentifier:[self reuseIdentifier]
                                                     forIndexPath:indexPath];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        _containerView = [[UIView alloc] init];
        [self.contentView addSubview:_containerView];
    }
    
    return self;
}

- (void)setAssetModel:(CXAssetModel *)assetModel{
    _assetModel = assetModel;
    
    if([assetModel.userInfo isKindOfClass:[UIImage class]]){
        self.thumbnailImage = (UIImage *)assetModel.userInfo;
    }else{
        self.thumbnailImage = nil;
    }
}

- (void)downloadImage:(CXAssetImageDownloadCompletionBlock)completion{
    if([self.delegate respondsToSelector:@selector(browserCell:downloadImage:completion:)]){
        [self.delegate browserCell:self
                     downloadImage:self.assetModel
                        completion:completion];
    }
}

- (void)downloadVideo:(CXAssetImageDownloadCompletionBlock)snapshot completion:(CXAssetVideoDownloadCompletionBlock)completion{
    if([self.delegate respondsToSelector:@selector(browserCell:downloadVideo:snapshot:completion:)]){
        [self.delegate browserCell:self
                     downloadVideo:self.assetModel
                          snapshot:snapshot
                        completion:completion];
    }
}

- (void)saveAssetToPhotosAlbum:(id)asset{
    if(!asset){
        return;
    }
    
    if([self.delegate respondsToSelector:@selector(browserCell:saveAssetToPhotosAlbum:)]){
        [self.delegate browserCell:self saveAssetToPhotosAlbum:asset];
    }
}

- (void)finishAssetDownload:(id)asset{
    if([self.delegate respondsToSelector:@selector(browserCell:downloadFinishedWithAsset:)]){
        [self.delegate browserCell:self downloadFinishedWithAsset:asset];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGRect frame = self.bounds;
    frame.size.width -= CXAssetBrowserCellIntervalSpacing;
    _containerView.frame = frame;
}

@end
