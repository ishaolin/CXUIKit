//
//  CXSavedPhotosAlbumSupporter.m
//  Pods
//
//  Created by wshaolin on 2021/7/13.
//

#import "CXSavedPhotosAlbumSupporter.h"
#import "CXAlertControllerUtils.h"
#import "CXAppUtils.h"
#import "CXHUD.h"

@implementation UIImage (CXSavedPhotosAlbumSupporter)

- (void)cx_writeToSavedPhotosAlbum:(CXPhotosAlbumAccessAuthorizationBlock)authorization
                        completion:(CXWriteToSavedPhotosAlbumCompletionBlock)completion{
    CXPhotosAlbumAuthorizeResultBlock authorizeResultBlock = ^(BOOL isAuthorised){
        if(!isAuthorised){
            return;
        }
        
        SEL selector = @selector(cx_writeToSavedPhotosAlbum:didFinishSavingWithError:contextInfo:);
        UIImageWriteToSavedPhotosAlbum(self, self, selector, (__bridge void *)(completion));
    };
    
    if(authorization){
        authorization([PHPhotoLibrary authorizationStatus], authorizeResultBlock);
    }else{
        authorizeResultBlock(YES);
    }
}

- (void)cx_writeToSavedPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    CXWriteToSavedPhotosAlbumCompletionBlock completion = (__bridge CXWriteToSavedPhotosAlbumCompletionBlock)(contextInfo);
    if(completion){
        completion(error);
    }
}

@end

@implementation NSString (CXSavedPhotosAlbumSupporter)

- (void)cx_writeToSavedPhotosAlbum:(CXPhotosAlbumAccessAuthorizationBlock)authorization
                        completion:(CXWriteToSavedPhotosAlbumCompletionBlock)completion{
    CXPhotosAlbumAuthorizeResultBlock authorizeResultBlock = ^(BOOL isAuthorised){
        if(!isAuthorised){
            return;
        }
        
        SEL selector = @selector(cx_writeToSavedPhotosAlbum:didFinishSavingWithError:contextInfo:);
        UISaveVideoAtPathToSavedPhotosAlbum(self, self, selector, (__bridge void *)(completion));
    };
    
    if(authorization){
        authorization([PHPhotoLibrary authorizationStatus], authorizeResultBlock);
    }else{
        authorizeResultBlock(YES);
    }
}

- (void)cx_writeToSavedPhotosAlbum:(NSString *)path didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    CXWriteToSavedPhotosAlbumCompletionBlock completion = (__bridge CXWriteToSavedPhotosAlbumCompletionBlock)(contextInfo);
    if(completion){
        completion(error);
    }
}

@end

void _CXSavedPhotosAlbumAuthorization(PHAuthorizationStatus status, CXPhotosAlbumAuthorizeResultBlock authorizeResultBlock){
    if(status == PHAuthorizationStatusAuthorized){
        authorizeResultBlock(YES);
    }else if(status == PHAuthorizationStatusNotDetermined){
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if(status != PHAuthorizationStatusAuthorized){
                return;
            }
            
            [CXDispatchHandler asyncOnMainQueue:^{
                authorizeResultBlock(YES);
            }];
        }];
    }else{
        [CXAlertControllerUtils showAlertWithConfigBlock:^(CXAlertControllerConfigModel *config) {
            config.title = [NSString stringWithFormat:@"应用“%@”没有相册访问权限", [NSBundle mainBundle].cx_displayName];
            config.buttonTitles = @[@"取消", @"去授权"];
        } completion:^(NSUInteger buttonIndex) {
            if(buttonIndex == 1){
                [CXAppUtils openSettingsPage];
            }
        }];
        
        authorizeResultBlock(NO);
    }
}

void _CXSavedPhotosAlbumCompletion(NSString *type, NSString *error){
    if(error){
        [CXHUD showMsg:[NSString stringWithFormat:@"%@保存失败", type]];
    }else{
        [CXHUD showMsg:[NSString stringWithFormat:@"已保存至相册", type]];
    }
}

void CXImageWriteToSavedPhotosAlbum(UIImage *image){
    if(!image){
        return;
    }
    
    [image cx_writeToSavedPhotosAlbum:^(PHAuthorizationStatus status, CXPhotosAlbumAuthorizeResultBlock authorizeResultBlock) {
        _CXSavedPhotosAlbumAuthorization(status, authorizeResultBlock);
    } completion:^(NSError *error) {
        _CXSavedPhotosAlbumCompletion(@"图片", error);
    }];
}

void CXVideoWriteToSavedPhotosAlbum(NSString *path){
    if(CXStringIsEmpty(path)){
        return;
    }
    
    [path cx_writeToSavedPhotosAlbum:^(PHAuthorizationStatus status, CXPhotosAlbumAuthorizeResultBlock authorizeResultBlock) {
        _CXSavedPhotosAlbumAuthorization(status, authorizeResultBlock);
    } completion:^(NSError *error) {
        _CXSavedPhotosAlbumCompletion(@"视频", error);
    }];
}
