//
//  CXAssetModel.h
//  Pods
//
//  Created by wshaolin on 2018/9/7.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSInteger, CXAssetType) {
    CXAssetTypeImage = 0, // 图片
    CXAssetTypeVideo = 1  // 视频
};

@class CXAssetModel;

typedef void(^CXAssetImageDownloadCompletionBlock)(CXAssetModel *assetModel, UIImage *image);
typedef void(^CXAssetVideoDownloadCompletionBlock)(CXAssetModel *assetModel, NSURL *videoURL);

@interface CXAssetModel : NSObject

@property (nonatomic, assign, readonly) CXAssetType assetType;
@property (nonatomic, strong, readonly) NSURL *videoSnapshotURL;
@property (nonatomic, strong) NSURL *URL;

@property (nonatomic, strong) id userInfo;

- (instancetype)initWithAssetType:(CXAssetType)assetType;
- (instancetype)initWithImageURL:(NSURL *)imageURL;
- (instancetype)initWithVideoURL:(NSURL *)videoURL videoSnapshotURL:(NSURL *)videoSnapshotURL;

@end
