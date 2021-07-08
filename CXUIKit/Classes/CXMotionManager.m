//
//  CXMotionManager.m
//  Pods
//
//  Created by wshaolin on 2019/3/26.
//

#import "CXMotionManager.h"

@interface CXMotionManager () {
    CMMotionManager *_motionManager;
}

@end

@implementation CXMotionManager

+ (CXMotionManager *)sharedManager{
    static CXMotionManager *_motionManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _motionManager = [[CXMotionManager alloc] init];
    });
    
    return _motionManager;
}

- (instancetype)init{
    if(self = [super init]){
        _motionManager = [[CMMotionManager alloc] init];
    }
    
    return self;
}

- (void)startMotionUpdates:(NSTimeInterval)updateInterval{
    if(_motionManager.isDeviceMotionActive){
        return;
    }
    
    _motionManager.deviceMotionUpdateInterval = updateInterval;
    [_motionManager startDeviceMotionUpdates];
}

- (void)stopMotionUpdates{
    if(_motionManager.isDeviceMotionActive){
        [_motionManager stopDeviceMotionUpdates];
    }
}

- (CMDeviceMotion *)motion{
    return _motionManager.deviceMotion;
}

@end

UIDeviceOrientation CXDeviceOrientationFromDeviceMotion(CMDeviceMotion *motion){
    double gravityX = motion.gravity.x;
    double gravityY = motion.gravity.y;
    
    if(gravityX > 0 && gravityY < 0 && gravityX <= fabs(gravityY)){
        return UIDeviceOrientationPortrait;
    }else if(gravityX < 0 && gravityY < 0 && gravityX < gravityY){
        return UIDeviceOrientationLandscapeLeft;
    }else if(gravityX > 0 && gravityY < 0 && gravityX > fabs(gravityY)){
        return UIDeviceOrientationLandscapeRight;
    }else if(gravityX > 0 && gravityY > 0 && gravityX <= gravityY){
        return UIDeviceOrientationPortraitUpsideDown;
    }
    
    return UIDeviceOrientationUnknown;
}
