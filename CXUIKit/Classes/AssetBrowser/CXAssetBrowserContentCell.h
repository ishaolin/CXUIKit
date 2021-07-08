//
//  CXAssetBrowserContentCell.h
//  Pods
//
//  Created by wshaolin on 2018/9/6.
//

#import <UIKit/UIKit.h>
#import "CXAssetModel.h"

#define CXAssetBrowserCellIntervalSpacing 20.0

@class CXAssetBrowserContentCell;

@protocol CXAssetBrowserContentCellDelegate <NSObject>

@optional

- (void)browserCell:(CXAssetBrowserContentCell *)cell
      downloadImage:(CXAssetModel *)assetModel
         completion:(CXAssetImageDownloadCompletionBlock)completion;

- (void)browserCell:(CXAssetBrowserContentCell *)cell
      downloadVideo:(CXAssetModel *)assetModel
           snapshot:(CXAssetImageDownloadCompletionBlock)snapshot
         completion:(CXAssetVideoDownloadCompletionBlock)completion;

- (void)browserCellDidClosed:(CXAssetBrowserContentCell *)cell;

- (void)browserCell:(CXAssetBrowserContentCell *)cell saveAssetToPhotosAlbum:(id)asset;

- (void)browserCell:(CXAssetBrowserContentCell *)cell downloadFinishedWithAsset:(id)asset;

- (void)browserCell:(CXAssetBrowserContentCell *)cell didStartPlayVideo:(NSURL *)videoURL;

- (void)browserCell:(CXAssetBrowserContentCell *)cell didStopPlayVideo:(NSURL *)videoURL;

@end

@interface CXAssetBrowserContentCell : UICollectionViewCell

@property (nonatomic, weak) id<CXAssetBrowserContentCellDelegate> delegate;
@property (nonatomic, strong, readonly) UIView *containerView;
@property (nonatomic, strong) CXAssetModel *assetModel;
@property (nonatomic, strong) UIImage *thumbnailImage;

@property (nonatomic, weak, readonly) UIImage *image;
@property (nonatomic, assign, getter = isLongPressEnabled) BOOL longPressEnabled;

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView
                          forIndexPath:(NSIndexPath *)indexPath;

- (void)downloadImage:(CXAssetImageDownloadCompletionBlock)completion;

- (void)downloadVideo:(CXAssetImageDownloadCompletionBlock)snapshot
           completion:(CXAssetVideoDownloadCompletionBlock)completion;

- (void)saveAssetToPhotosAlbum:(id)asset;

- (void)finishAssetDownload:(id)asset;

+ (NSString *)reuseIdentifier;

@end
