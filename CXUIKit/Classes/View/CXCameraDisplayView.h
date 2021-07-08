//
//  CXCameraDisplayView.h
//  Pods
//
//  Created by wshaolin on 2019/1/31.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CXFoundation/CXFoundation.h>

@class CXCameraDisplayView;

@protocol CXCameraDisplayViewDelegate <NSObject>

@optional

- (void)cameraDisplayView:(CXCameraDisplayView *)cameraView didLoadInputCaptureDevice:(AVCaptureDevice *)captureDevice;

- (void)cameraDisplayViewDidStartCamera:(CXCameraDisplayView *)cameraView;

- (void)cameraDisplayViewDidStopCamera:(CXCameraDisplayView *)cameraView;

- (void)cameraDisplayView:(CXCameraDisplayView *)cameraView didFailedWithError:(NSError *)error;

- (void)cameraDisplayViewDidChangeBrightnessValue:(CXCameraDisplayView *)cameraView;

- (void)cameraDisplayViewAuthDidRestrictOrDeny:(CXCameraDisplayView *)cameraView;

@end

typedef void(^CXCameraAuthRestrictOrDenyBlock)(CXCameraDisplayView *cameraView);

@interface CXCameraDisplayView : UIView

@property (nonatomic, weak) id<CXCameraDisplayViewDelegate> delegate;

@property (nonatomic, assign, readonly) AVAuthorizationStatus authorizationStatus;
@property (nonatomic, copy, readonly) AVMediaType mediaType;
@property (nonatomic, assign, readonly) BOOL isRunning;
@property (nonatomic, assign, readonly) BOOL allowsBrightnessDetecting; // 亮度检测
@property (nonatomic, strong, readonly) dispatch_queue_t operationQueue;
@property (nonatomic, assign, readonly) CGFloat brightnessValue;

@property (nonatomic, copy) CXCameraAuthRestrictOrDenyBlock authRestrictOrDenyBlock;

- (instancetype)initWithBrightnessDetecting:(BOOL)allowsBrightnessDetecting;

- (void)addCaptureVideoOutput:(AVCaptureOutput *)captureOutput;

- (void)videoCaptureSessionDidLoad;
- (void)handleRestrictedOrDeniedAuthStatus;
- (void)startRunning;
- (void)stopRunning;

// 以下4个属性请在[delegate scanVideoDisplayView:didLoadInputCaptureDevice:]或者videoCaptureSessionDidLoad之后设置，否则不生效
@property (nonatomic, assign) AVCaptureTorchMode torchMode; // 闪光灯
@property (nonatomic, assign) AVCaptureFocusMode focusMode; // 焦距
@property (nonatomic, assign) AVCaptureExposureMode exposureMode; // 曝光量
@property (nonatomic, assign) AVCaptureWhiteBalanceMode whiteBalanceMode; // 白平衡

- (void)setUpdateIndicatorViewCenter:(CGPoint)centerPoint;

@end
