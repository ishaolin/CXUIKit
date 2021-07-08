//
//  CXAlertPanel.h
//  Pods
//
//  Created by wshaolin on 2018/8/29.
//

#import "CXAlertActionPanel.h"

@class CXAlertPanelItemModel;

@interface CXAlertPanel : CXAlertActionPanel

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;

- (void)setPanelItemEnabled:(BOOL)enabled atIndex:(NSUInteger)index;
- (void)setPanelItem:(CXAlertPanelItemModel *)panelItem enabled:(BOOL)enabled;

@end

@interface CXAlertPanelItemModel : CXAlertActionItemModel

@property (nonatomic, assign, getter = isEnabled) BOOL enabled;

@end
