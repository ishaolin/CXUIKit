//
//  CXTableHeaderFooterView.h
//  Pods
//
//  Created by wshaolin on 2019/4/16.
//

#import <UIKit/UIKit.h>

@interface CXTableHeaderFooterView : UITableViewHeaderFooterView

+ (instancetype)viewWithTableView:(UITableView *)tableView;

+ (instancetype)viewWithTableView:(UITableView *)tableView
                  reuseIdentifier:(NSString *)reuseIdentifier;

@end
