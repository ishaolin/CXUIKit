//
//  CXNumberKeyboardPanel.h
//  Pods
//
//  Created by wshaolin on 2018/12/24.
//

#import <UIKit/UIKit.h>

@class CXNumberKeyboardPanel;

@protocol CXNumberKeyboardPanelDelegate <NSObject>

@required

- (void)numberKeyboardPanel:(CXNumberKeyboardPanel *)keyboard didInputCharacter:(NSString *)character;
- (void)numberKeyboardPanelDidDelete:(CXNumberKeyboardPanel *)keyboard;

@end

@interface CXNumberKeyboardPanel : UIView

@property (nonatomic, weak) id<CXNumberKeyboardPanelDelegate> delegate;

@end
