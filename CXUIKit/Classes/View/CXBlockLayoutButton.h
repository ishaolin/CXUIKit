//
//  CXBlockLayoutButton.h
//  Pods
//
//  Created by wshaolin on 2019/4/12.
//

#import "CXActionItemButton.h"
#import "CXUIKitDefines.h"

typedef struct{
    CGRect imageRect;
    CGRect titleRect;
} CXButtonCombinedRect;

@class CXBlockLayoutButton;

typedef CXButtonCombinedRect(^CXButtonCombinedRectBlock)(CXBlockLayoutButton *button, CGRect contentRect);

@interface CXBlockLayoutButton : CXActionItemButton

@property (nonatomic, copy) CXButtonCombinedRectBlock combinedRectBlock;

@end

CX_UIKIT_EXTERN CXButtonCombinedRect CXButtonCombinedRectMake(CGRect imageRect, CGRect titleRect);
CX_UIKIT_EXTERN BOOL CXButtonCombinedRectIsEmpty(CXButtonCombinedRect combinedRect);
