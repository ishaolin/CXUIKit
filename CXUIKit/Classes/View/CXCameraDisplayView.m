//
//  CXCameraDisplayView.m
//  Pods
//
//  Created by wshaolin on 2019/1/31.
//

#import "CXCameraDisplayView.h"
#import "CXSystemAdapter.h"

@interface CXCameraDisplayView () <AVCaptureVideoDataOutputSampleBufferDelegate> {
    AVCaptureDevice *_captureDevice;
    AVCaptureSession *_captureSession;
    AVCaptureVideoPreviewLayer *_previewLayer;
    UIActivityIndicatorView *_indicatorView;
    
    CGPoint _indicatorViewCenterPoint; // 指示视图中心
}

@end

@implementation CXCameraDisplayView

- (instancetype)initWithFrame:(CGRect)frame{
    return [self initWithFrame:frame allowsBrightnessDetecting:NO];
}

- (instancetype)initWithBrightnessDetecting:(BOOL)allowsBrightnessDetecting{
    return [self initWithFrame:CGRectZero allowsBrightnessDetecting:allowsBrightnessDetecting];
}

- (instancetype)initWithFrame:(CGRect)frame allowsBrightnessDetecting:(BOOL)allowsBrightnessDetecting{
    if(self = [super initWithFrame:frame]){
        _allowsBrightnessDetecting = allowsBrightnessDetecting;
        _indicatorViewCenterPoint = CGPointZero;
        _mediaType = AVMediaTypeVideo;
        _operationQueue = dispatch_queue_create("com.capture.session.operation.queue", NULL);
        _authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:_mediaType];
    }
    
    return self;
}

- (void)addCaptureVideoOutput:(AVCaptureOutput *)captureOutput{
    if([_captureSession canAddOutput:captureOutput]){
        [_captureSession addOutput:captureOutput];
    }
}

- (void)setTorchMode:(AVCaptureTorchMode)torchMode{
    if(!_captureDevice.hasTorch){
        return;
    }
    
    if(![_captureDevice isTorchModeSupported:torchMode]){
        return;
    }
    
    if([_captureDevice lockForConfiguration:nil]){
        _captureDevice.torchMode = torchMode;
        [_captureDevice unlockForConfiguration];
    }
}

- (AVCaptureTorchMode)torchMode{
    if(_captureDevice.hasTorch){
        return _captureDevice.torchMode;
    }
    
    return AVCaptureTorchModeOff;
}

- (void)setFocusMode:(AVCaptureFocusMode)focusMode{
    if(![_captureDevice isFocusModeSupported:focusMode]){
        return;
    }
    
    if([_captureDevice lockForConfiguration:nil]){
        _captureDevice.focusMode = focusMode;
        [_captureDevice unlockForConfiguration];
    }
}

- (AVCaptureFocusMode)focusMode{
    if(_captureDevice){
        return _captureDevice.focusMode;
    }
    
    return AVCaptureFocusModeLocked;
}

- (void)setExposureMode:(AVCaptureExposureMode)exposureMode{
    if(![_captureDevice isExposureModeSupported:exposureMode]){
        return;
    }
    
    if([_captureDevice lockForConfiguration:nil]){
        _captureDevice.exposureMode = exposureMode;
        [_captureDevice unlockForConfiguration];
    }
}

- (AVCaptureExposureMode)exposureMode{
    if(_captureDevice){
        return _captureDevice.exposureMode;
    }
    
    return AVCaptureExposureModeLocked;
}

- (void)setWhiteBalanceMode:(AVCaptureWhiteBalanceMode)whiteBalanceMode{
    if(![_captureDevice isWhiteBalanceModeSupported:whiteBalanceMode]){
        return;
    }
    
    if([_captureDevice lockForConfiguration:nil]){
        _captureDevice.whiteBalanceMode = whiteBalanceMode;
        [_captureDevice unlockForConfiguration];
    }
}

- (AVCaptureWhiteBalanceMode)whiteBalanceMode{
    if(_captureDevice){
        return _captureDevice.whiteBalanceMode;
    }
    
    return AVCaptureWhiteBalanceModeLocked;
}

- (BOOL)isRunning{
    __block BOOL running = NO;
    [CXDispatchHandler asyncOnMainQueue:^{
        running = self->_captureSession.isRunning;
    }];
    
    return running;
}

- (void)startRunning{
    if(_captureSession){
        if(self.isRunning){
            return;
        }
        
        [_indicatorView startAnimating];
        dispatch_async(self.operationQueue, ^{
            [self->_captureSession startRunning];
        });
        
        return;
    }
    
    switch (self.authorizationStatus) {
        case AVAuthorizationStatusAuthorized:{
            [self setupCaptureSession];
        }
            break;
        case AVAuthorizationStatusNotDetermined:{
            [AVCaptureDevice requestAccessForMediaType:_mediaType completionHandler:^(BOOL granted) {
                [CXDispatchHandler asyncOnMainQueue:^{
                    self->_authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:self->_mediaType];
                    if(!granted){
                        return;
                    }
                    
                    [self setupCaptureSession];
                }];
            }];
        }
            break;
        case AVAuthorizationStatusRestricted:
        case AVAuthorizationStatusDenied:{
            if([self.delegate respondsToSelector:@selector(cameraDisplayViewAuthDidRestrictOrDeny:)]){
                [self.delegate cameraDisplayViewAuthDidRestrictOrDeny:self];
            }
            
            !self.authRestrictOrDenyBlock ?: self.authRestrictOrDenyBlock(self);
            
            [self handleRestrictedOrDeniedAuthStatus];
        }
            break;
        default:
            break;
    }
}

- (void)stopRunning{
    dispatch_async(self.operationQueue, ^{
        if(self->_captureSession.isRunning){
            [self->_captureSession stopRunning];
        }
    });
}

- (void)setUpdateIndicatorViewCenter:(CGPoint)centerPoint{
    _indicatorViewCenterPoint = centerPoint;
    if(!_indicatorView){
        return;
    }
    
    _indicatorView.center = centerPoint;
}

- (void)setupCaptureSession{
    [NSNotificationCenter addObserver:self
                               action:@selector(captureSessionDidStartRunningNotification:)
                                 name:AVCaptureSessionDidStartRunningNotification];
    
    [NSNotificationCenter addObserver:self
                               action:@selector(captureSessionDidStopRunningNotification:)
                                 name:AVCaptureSessionDidStopRunningNotification];
    
    [NSNotificationCenter addObserver:self
                               action:@selector(captureSessionRuntimeErrorNotification:)
                                 name:AVCaptureSessionRuntimeErrorNotification];
    
    _captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:_mediaType];
    AVCaptureDeviceInput *captureDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:_captureDevice error:nil];
    
    _captureSession = [[AVCaptureSession alloc] init];
    [_captureSession setSessionPreset:AVCaptureSessionPresetHigh];
    
    if(![_captureSession canAddInput:captureDeviceInput]){
        return;
    }
    [_captureSession addInput:captureDeviceInput];
    
    if(self.allowsBrightnessDetecting){
        AVCaptureVideoDataOutput *dataOutput = [[AVCaptureVideoDataOutput alloc] init];
        [dataOutput setSampleBufferDelegate:self queue:self.operationQueue];
        [self addCaptureVideoOutput:dataOutput];
    }
    
    [self _videoCaptureSessionDidLoad];
    
    _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_captureSession];
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.layer addSublayer:_previewLayer];
    
    _indicatorView = [CXSystemAdapter largeActivityIndicatorView];
    _indicatorView.center = _indicatorViewCenterPoint;
    [_indicatorView startAnimating];
    [self addSubview:_indicatorView];
    
    [self setNeedsLayout];
    
    dispatch_async(self.operationQueue, ^{
        [self->_captureSession startRunning];
    });
}

- (void)_videoCaptureSessionDidLoad{
    self.torchMode = AVCaptureTorchModeOff;
    self.exposureMode = AVCaptureExposureModeContinuousAutoExposure;
    self.focusMode = AVCaptureFocusModeContinuousAutoFocus;
    self.whiteBalanceMode = AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance;
    
    if([self.delegate respondsToSelector:@selector(cameraDisplayView:didLoadInputCaptureDevice:)]){
        [self.delegate cameraDisplayView:self didLoadInputCaptureDevice:_captureDevice];
    }
    
    [self videoCaptureSessionDidLoad];
}

- (void)videoCaptureSessionDidLoad{
    
}

- (void)handleRestrictedOrDeniedAuthStatus{
    
}

- (void)captureSessionDidStartRunningNotification:(NSNotification *)notification{
    [CXDispatchHandler asyncOnMainQueue:^{
        [self->_indicatorView stopAnimating];
        
        if([self.delegate respondsToSelector:@selector(cameraDisplayViewDidStartCamera:)]){
            [self.delegate cameraDisplayViewDidStartCamera:self];
        }
    }];
}

- (void)captureSessionDidStopRunningNotification:(NSNotification *)notification{
    [CXDispatchHandler asyncOnMainQueue:^{
        if([self.delegate respondsToSelector:@selector(cameraDisplayViewDidStopCamera:)]){
            [self.delegate cameraDisplayViewDidStopCamera:self];
        }
    }];
}

- (void)captureSessionRuntimeErrorNotification:(NSNotification *)notification{
    [CXDispatchHandler asyncOnMainQueue:^{
        [self->_indicatorView stopAnimating];
        
        NSError *error = notification.userInfo[AVCaptureSessionErrorKey];
        if([self.delegate respondsToSelector:@selector(cameraDisplayView:didFailedWithError:)]){
            [self.delegate cameraDisplayView:self didFailedWithError:error];
        }
    }];
}

- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    CFDictionaryRef dictionaryRef = CMCopyDictionaryOfAttachments(NULL, sampleBuffer,  kCMAttachmentMode_ShouldPropagate);
    NSDictionary<NSString *, id> *dictionary = (NSDictionary<NSString *, id> *)CFBridgingRelease(dictionaryRef);
    if(!dictionary){
        return;
    }
    
    NSDictionary<NSString *, id> *exifDictionary = [dictionary cx_dictionaryForKey:(NSString *)kCGImagePropertyExifDictionary];
    if(!exifDictionary){
        return;
    }
    
    [CXDispatchHandler asyncOnMainQueue:^{
        CGFloat brightnessValue = [exifDictionary cx_numberForKey:(NSString *)kCGImagePropertyExifBrightnessValue].doubleValue;
        if(self->_brightnessValue == brightnessValue){
            return;
        }
        
        self->_brightnessValue = brightnessValue;
        if([self.delegate respondsToSelector:@selector(cameraDisplayViewDidChangeBrightnessValue:)]){
            [self.delegate cameraDisplayViewDidChangeBrightnessValue:self];
        }
    }];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    _previewLayer.frame = self.bounds;
    
    if(CGPointEqualToPoint(_indicatorViewCenterPoint, CGPointZero)){
        CGFloat indicatorView_W = _indicatorView.bounds.size.width;
        CGFloat indicatorView_H = _indicatorView.bounds.size.height;
        CGFloat indicatorView_X = (self.bounds.size.width - indicatorView_W) * 0.5;
        CGFloat indicatorView_Y = self.bounds.size.height * 0.3;
        _indicatorView.frame = (CGRect){indicatorView_X, indicatorView_Y, indicatorView_W, indicatorView_H};
    }
}

- (void)dealloc{
    [NSNotificationCenter removeObserver:self];
}

@end
