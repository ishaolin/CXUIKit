//
//  CXActionSheetPanel.h
//  Pods
//
//  Created by wshaolin on 2018/8/30.
//

#import "CXAlertActionPanel.h"

@interface CXActionSheetPanel : CXAlertActionPanel

@property (nonatomic, strong) CXAlertActionItemModel *cancelItemModel;
@property (nonatomic, copy) NSString *title;

@end

@interface CXActionSheetItemButton : CXAlertActionItemButton

@property (nonatomic, strong, readonly) UIView *lineView;

@end
