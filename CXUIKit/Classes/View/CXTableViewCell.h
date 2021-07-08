//
//  CXTableViewCell.h
//  Pods
//
//  Created by wshaolin on 2019/3/25.
//

#import <UIKit/UIKit.h>

@interface CXTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (instancetype)cellWithTableView:(UITableView *)tableView reuseIdentifier:(NSString *)reuseIdentifier;

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;

+ (UIColor *)highlightedColour;

@end
