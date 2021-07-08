//
//  CXAssetModel.m
//  Pods
//
//  Created by wshaolin on 2018/9/7.
//

#import "CXAssetModel.h"

@implementation CXAssetModel

- (instancetype)initWithAssetType:(CXAssetType)assetType{
    if(self = [super init]){
        _assetType = assetType;
    }
    
    return self;
}

- (instancetype)initWithImageURL:(NSURL *)imageURL{
    if(self = [super init]){
        _assetType = CXAssetTypeImage;
        _URL = imageURL;
    }
    
    return self;
}

- (instancetype)initWithVideoURL:(NSURL *)videoURL videoSnapshotURL:(NSURL *)videoSnapshotURL{
    if(self = [super init]){
        _assetType = CXAssetTypeVideo;
        _URL = videoURL;
        _videoSnapshotURL = videoSnapshotURL;
    }
    
    return self;
}

@end
