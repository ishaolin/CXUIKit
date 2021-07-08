//
//  CXScanCodeView.h
//  Pods
//
//  Created by wshaolin on 2019/1/31.
//

#import "CXCameraDisplayView.h"

@class CXScanCodeView;

@protocol CXScanCodeViewDelegate <CXCameraDisplayViewDelegate>

@optional

- (void)scanCodeView:(CXScanCodeView *)scanCodeView didFinishedWithQRCodeText:(NSString *)codeText;

@end

@interface CXScanCodeView : CXCameraDisplayView

@property (nonatomic, assign) CGRect rectOfInterest;

@property (nonatomic, weak) id<CXScanCodeViewDelegate> delegate;

@property (nonatomic, assign, getter = isOutputEnabled) BOOL outputEnabled;

- (void)setMetadataObjectTypes:(NSArray<AVMetadataObjectType> *)metadataObjectTypes;

@end
