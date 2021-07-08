//
//  CXAssetBrowser.h
//  Pods
//
//  Created by wshaolin on 2018/9/6.
//

#import "CXBaseActionPanel.h"
#import "CXAssetModel.h"

@class CXAssetBrowser;

@protocol CXAssetBrowserDelegate <CXActionPanelDelegate>

@optional

- (void)browser:(CXAssetBrowser *)browser downloadImage:(CXAssetModel *)assetModel completion:(CXAssetImageDownloadCompletionBlock)completion;

- (void)browser:(CXAssetBrowser *)browser downloadVideo:(CXAssetModel *)assetModel snapshot:(CXAssetImageDownloadCompletionBlock)snapshot completion:(CXAssetVideoDownloadCompletionBlock)completion;

- (void)browser:(CXAssetBrowser *)browser saveAssetToPhotosAlbum:(id)asset;

- (void)browser:(CXAssetBrowser *)browser didStartPlayVideo:(NSURL *)videoURL;

- (void)browser:(CXAssetBrowser *)browser didStopPlayVideo:(NSURL *)videoURL;

@end

@interface CXAssetBrowser : CXBaseActionPanel

@property (nonatomic, weak) id<CXAssetBrowserDelegate> delegate;

@property (nonatomic, weak) UIView *currentAssetView;
@property (nonatomic, strong) NSDictionary<NSNumber *, UIView *> *assetViews;
@property (nonatomic, strong) NSArray<CXAssetModel *> *assetModels;
@property (nonatomic, strong) NSArray<NSString *> *imageURLs;
@property (nonatomic, assign, getter = isLongPressEnabled) BOOL longPressEnabled; // 默认NO
@property (nonatomic, assign, getter = isSaveButtonEnabled) BOOL saveButtonEnabled; // 默认NO

@property (nonatomic, assign, readonly) NSUInteger currentIndex;
@property (nonatomic, strong, readonly) UIImage *currentImage;

- (void)showWithImage:(UIImage *)image currentIndex:(NSUInteger)currentIndex;

- (void)showWithImageView:(UIImageView *)imageView assetModel:(CXAssetModel *)assetModel;

@end
