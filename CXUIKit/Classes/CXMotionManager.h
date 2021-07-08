//
//  CXMotionManager.h
//  Pods
//
//  Created by wshaolin on 2019/3/26.
//

#import <UIKit/UIKit.h>
#import "CXUIKitDefines.h"
#import <CoreMotion/CoreMotion.h>

@interface CXMotionManager : NSObject

@property (nonatomic, strong, readonly) CMDeviceMotion *motion;

+ (CXMotionManager *)sharedManager;

- (void)startMotionUpdates:(NSTimeInterval)updateInterval;

- (void)stopMotionUpdates;

@end

CX_UIKIT_EXTERN UIDeviceOrientation CXDeviceOrientationFromDeviceMotion(CMDeviceMotion *motion);
