//
//  CXActionToolBarItemNode.h
//  Pods
//
//  Created by wshaolin on 2017/11/20.
//

#import <UIKit/UIKit.h>

@class CXActionToolBarItemNode;

typedef void(^CXActionToolBarItemActionHandler)(CXActionToolBarItemNode *itemNode, id context);

@interface CXActionToolBarItemNode : NSObject

@property (nonatomic, assign) NSInteger tag;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *imageURL;

@property (nonatomic, assign, getter = isEnabled) BOOL enabled;
@property (nonatomic, strong) id userInfo;

- (instancetype)initWithTitle:(NSString *)title;

- (instancetype)initWithTitle:(NSString *)title
                actionHandler:(CXActionToolBarItemActionHandler)actionHandler;

- (void)invokeActionForContext:(id)context;

@end
