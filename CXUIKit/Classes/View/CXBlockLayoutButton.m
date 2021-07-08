//
//  CXBlockLayoutButton.m
//  Pods
//
//  Created by wshaolin on 2019/4/12.
//

#import "CXBlockLayoutButton.h"

@interface CXBlockLayoutButton () {
    CXButtonCombinedRect _combinedRect;
}

@end

@implementation CXBlockLayoutButton

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    if(self.combinedRectBlock){
        if(CXButtonCombinedRectIsEmpty(_combinedRect)){
            _combinedRect = self.combinedRectBlock(self, contentRect);
        }
        
        return _combinedRect.titleRect;
    }
    
    return [super titleRectForContentRect:contentRect];
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    if(self.combinedRectBlock){
        if(CXButtonCombinedRectIsEmpty(_combinedRect)){
            _combinedRect = self.combinedRectBlock(self, contentRect);
        }
        
        return _combinedRect.imageRect;
    }
    
    return [super titleRectForContentRect:contentRect];
}

@end

CXButtonCombinedRect CXButtonCombinedRectMake(CGRect imageRect, CGRect titleRect){
    CXButtonCombinedRect combinedRect;
    combinedRect.imageRect = imageRect;
    combinedRect.titleRect = titleRect;
    return combinedRect;
}

BOOL CXButtonCombinedRectIsEmpty(CXButtonCombinedRect combinedRect){
    if(CGRectGetHeight(combinedRect.imageRect) > 0){
        return NO;
    }
    
    if(CGRectGetWidth(combinedRect.imageRect) > 0){
        return NO;
    }
    
    if(CGRectGetHeight(combinedRect.titleRect) > 0){
        return NO;
    }
    
    if(CGRectGetWidth(combinedRect.titleRect) > 0){
        return NO;
    }
    
    return YES;
}
