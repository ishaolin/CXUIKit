//
//  CXTableView.h
//  Pods
//
//  Created by wshaolin on 2018/12/21.
//

#import <UIKit/UIKit.h>

@class CXTableView;

typedef UIView *(^CXTableViewHitTestBlock)(CXTableView *tableView,
                                           UIView *hitTestView,
                                           CGPoint point,
                                           UIEvent *event);

typedef void(^CXTableViewTouchesBlock)(CXTableView *tableView,
                                       NSSet<UITouch *> *touchs,
                                       UIEvent *event);

@interface CXTableView : UITableView

@property (nonatomic, copy) CXTableViewHitTestBlock hitTestBlock;
@property (nonatomic, copy) CXTableViewTouchesBlock touchesBeganBlock;
@property (nonatomic, copy) CXTableViewTouchesBlock touchesMovedBlock;
@property (nonatomic, copy) CXTableViewTouchesBlock touchesEndedBlock;
@property (nonatomic, copy) CXTableViewTouchesBlock touchesCancelledBlock;

@end
