//
//  CXScanCodeView.m
//  Pods
//
//  Created by wshaolin on 2019/1/31.
//

#import "CXScanCodeView.h"

@interface CXScanCodeView () <AVCaptureMetadataOutputObjectsDelegate> {
    AVCaptureMetadataOutput *_captureMetadataOutput;
    NSArray<AVMetadataObjectType> *_metadataObjectTypes;
    BOOL _outputEnabled;
}

@property (nonatomic, weak, readonly) AVCaptureConnection *connection;

@end

@implementation CXScanCodeView

@synthesize delegate;

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        /* AVMetadataObjectTypeEAN13Code
         AVMetadataObjectTypeEAN8Code
         AVMetadataObjectTypeUPCECode
         AVMetadataObjectTypeCode39Code
         AVMetadataObjectTypeCode39Mod43Code
         AVMetadataObjectTypeCode93Code
         AVMetadataObjectTypeCode128Code
         AVMetadataObjectTypePDF417Code */
        
        _metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
        self.outputEnabled = YES;
    }
    
    return self;
}

- (AVCaptureConnection *)connection{
    if(!_captureMetadataOutput){
        return nil;
    }
    
    return [_captureMetadataOutput connectionWithMediaType:self.mediaType];
}

- (void)setMetadataObjectTypes:(NSArray<AVMetadataObjectType> *)metadataObjectTypes{
    _metadataObjectTypes = [metadataObjectTypes copy];
    _captureMetadataOutput.metadataObjectTypes = _metadataObjectTypes;
}

- (void)setOutputEnabled:(BOOL)outputEnabled{
    AVCaptureConnection *connection = self.connection;
    if(connection){
        connection.enabled = outputEnabled;
    }else{
        _outputEnabled = outputEnabled;
    }
}

- (BOOL)isOutputEnabled{
    AVCaptureConnection *connection = self.connection;
    return connection ? connection.isEnabled : _outputEnabled;
}

- (void)videoCaptureSessionDidLoad{
    _captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [self addCaptureVideoOutput:_captureMetadataOutput];
    
    self.connection.enabled = _outputEnabled;
    _captureMetadataOutput.metadataObjectTypes = _metadataObjectTypes;
    [_captureMetadataOutput setMetadataObjectsDelegate:self queue:self.operationQueue];
}

- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    [CXDispatchHandler asyncOnMainQueue:^{
        if(!self.outputEnabled || CXArrayIsEmpty(metadataObjects)){
            return;
        }
        
        AVMetadataMachineReadableCodeObject *codeObject = metadataObjects.firstObject;
        if([self.delegate respondsToSelector:@selector(scanCodeView:didFinishedWithQRCodeText:)]){
            [self.delegate scanCodeView:self didFinishedWithQRCodeText:codeObject.stringValue];
        }
    }];
}

- (void)setUpdateOutputRectOfInterestIfNeed:(CGRect)rectOfInterest{
    if(CGRectGetWidth(self.bounds) <= 0 || CGRectGetHeight(self.bounds) <= 0){
        return;
    }
    
    if(CGRectGetWidth(rectOfInterest) <= 0 || CGRectGetHeight(rectOfInterest) <= 0){
        return;
    }
    
    CGFloat y = CGRectGetMinY(rectOfInterest) / CGRectGetHeight(self.bounds);
    CGFloat x = CGRectGetMinX(rectOfInterest) / CGRectGetWidth(self.bounds);
    CGFloat width = CGRectGetWidth(rectOfInterest) / CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(rectOfInterest) / CGRectGetHeight(self.bounds);
    // 必须在子线程处理，否则会阻塞主线程，出现卡顿的现象
    dispatch_async(self.operationQueue, ^{
        self->_captureMetadataOutput.rectOfInterest = (CGRect){y, x, height, width};
    });
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self setUpdateOutputRectOfInterestIfNeed:self.rectOfInterest];
}

@end
