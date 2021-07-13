//
//  CXSavedPhotosAlbumSupporter.h
//  Pods
//
//  Created by wshaolin on 2021/7/13.
//

#include "CXUIKitDefines.h"
#import <Photos/Photos.h>
#import <UIKit/UIKit.h>

typedef void(^CXPhotosAlbumAuthorizeResultBlock)(BOOL isAuthorised);

typedef void(^CXPhotosAlbumAccessAuthorizationBlock)(PHAuthorizationStatus status, CXPhotosAlbumAuthorizeResultBlock authorizeResultBlock);

typedef void(^CXWriteToSavedPhotosAlbumCompletionBlock)(NSError *error);

@interface UIImage (CXSavedPhotosAlbumSupporter)

- (void)cx_writeToSavedPhotosAlbum:(CXPhotosAlbumAccessAuthorizationBlock)authorization
                        completion:(CXWriteToSavedPhotosAlbumCompletionBlock)completion;

@end

@interface NSString (CXSavedPhotosAlbumSupporter)

- (void)cx_writeToSavedPhotosAlbum:(CXPhotosAlbumAccessAuthorizationBlock)authorization
                        completion:(CXWriteToSavedPhotosAlbumCompletionBlock)completion;

@end

CX_UIKIT_EXTERN void CXImageWriteToSavedPhotosAlbum(UIImage *image);
CX_UIKIT_EXTERN void CXVideoWriteToSavedPhotosAlbum(NSString *path);
