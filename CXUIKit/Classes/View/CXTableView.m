//
//  CXTableView.m
//  Pods
//
//  Created by wshaolin on 2018/12/21.
//

#import "CXTableView.h"

@implementation CXTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if(self = [super initWithFrame:frame style:style]){
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.estimatedRowHeight = 0;
        self.estimatedSectionHeaderHeight = 0;
        self.estimatedSectionFooterHeight = 0;
        
        if(@available(iOS 11.0, *)){
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    
    return self;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor{
    if(!backgroundColor){
        return;
    }
    
    self.backgroundView = nil;
    [super setBackgroundColor:backgroundColor];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *view = [super hitTest:point withEvent:event];
    if(self.hitTestBlock){
        return self.hitTestBlock(self, view, point, event);
    }
    
    return view;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    
    !self.touchesBeganBlock ?: self.touchesBeganBlock(self, touches, event);
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
    
    !self.touchesMovedBlock ?: self.touchesMovedBlock(self, touches, event);
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    
    !self.touchesEndedBlock ?: self.touchesEndedBlock(self, touches, event);
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event{
    [super touchesCancelled:touches withEvent:event];
    
    !self.touchesCancelledBlock ?: self.touchesCancelledBlock(self, touches, event);
}

@end
