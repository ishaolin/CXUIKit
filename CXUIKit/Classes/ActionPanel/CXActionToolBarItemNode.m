//
//  CXActionToolBarItemNode.m
//  Pods
//
//  Created by wshaolin on 2017/11/20.
//

#import "CXActionToolBarItemNode.h"

@interface CXActionToolBarItemNode (){
    CXActionToolBarItemActionHandler _actionHandler;
}

@end

@implementation CXActionToolBarItemNode

- (instancetype)initWithTitle:(NSString *)title{
    return [self initWithTitle:title actionHandler:nil];
}

- (instancetype)initWithTitle:(NSString *)title
                actionHandler:(CXActionToolBarItemActionHandler)actionHandler{
    if(self = [self init]){
        _enabled = YES;
        _title = title;
        
        if(actionHandler){
            _actionHandler = [actionHandler copy];
        }
        
        [self config];
    }
    
    return self;
}

- (void)config{
    
}

- (void)invokeActionForContext:(id)context{
    if(!_actionHandler){
        return;
    }
    
    _actionHandler(self, context);
}

@end
