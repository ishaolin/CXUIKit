//
//  CXCameraStillImageView.h
//  Pods
//
//  Created by wshaolin on 2019/1/31.
//

#import "CXCameraDisplayView.h"

@interface CXCameraStillImageView : CXCameraDisplayView

- (void)captureStillImage:(void(^)(UIImage *image))block;

@end
