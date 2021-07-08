//
//  CXTableHeaderFooterView.m
//  Pods
//
//  Created by wshaolin on 2019/4/16.
//

#import "CXTableHeaderFooterView.h"

@implementation CXTableHeaderFooterView

+ (instancetype)viewWithTableView:(UITableView *)tableView{
    static NSString *reuseIdentifier = @"CXTableHeaderFooterView";
    return [self viewWithTableView:tableView reuseIdentifier:reuseIdentifier];
}

+ (instancetype)viewWithTableView:(UITableView *)tableView reuseIdentifier:(NSString *)reuseIdentifier{
    CXTableHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseIdentifier];
    if(!view){
        view = [[self alloc] initWithReuseIdentifier:reuseIdentifier];
    }
    
    return view;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithReuseIdentifier:reuseIdentifier]){
        self.backgroundView = [[UIView alloc] init];
        self.backgroundView.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = nil;
    }
    
    return self;
}

@end
