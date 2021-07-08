//
//  CXCameraStillImageView.m
//  Pods
//
//  Created by wshaolin on 2019/1/31.
//

#import "CXCameraStillImageView.h"

@interface CXCameraStillImageView () {
    AVCaptureStillImageOutput *_stillImageOutput;
}

@end

@implementation CXCameraStillImageView

- (void)videoCaptureSessionDidLoad{
    _stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    if(@available(iOS 11.0, *)){
        _stillImageOutput.outputSettings = @{AVVideoCodecKey : AVVideoCodecTypeJPEG};
    }else{
        _stillImageOutput.outputSettings = @{AVVideoCodecKey : AVVideoCodecJPEG};
    }
    
    [self addCaptureVideoOutput:_stillImageOutput];
}

- (void)captureStillImage:(void(^)(UIImage *image))block{
    if(!block || !self.isRunning){
        return;
    }
    
    AVCaptureConnection *connection = [_stillImageOutput connectionWithMediaType:self.mediaType];
    [_stillImageOutput captureStillImageAsynchronouslyFromConnection:connection completionHandler:^(CMSampleBufferRef  _Nullable imageDataSampleBuffer, NSError * _Nullable error) {
        if(imageDataSampleBuffer){
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            UIImage *image = [UIImage imageWithData:imageData];
            [CXDispatchHandler asyncOnMainQueue:^{
                block(image);
            }];
        }else{
            [CXDispatchHandler asyncOnMainQueue:^{
                block(nil);
            }];
        }
    }];
}

@end
