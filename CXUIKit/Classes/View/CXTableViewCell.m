//
//  CXTableViewCell.m
//  Pods
//
//  Created by wshaolin on 2019/3/25.
//

#import "CXTableViewCell.h"
#import "UIColor+CXUIKit.h"

@implementation CXTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *reuseIdentifier = @"CXTableViewCell";
    return [self cellWithTableView:tableView reuseIdentifier:reuseIdentifier];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView reuseIdentifier:(NSString *)reuseIdentifier{
    CXTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if(!cell){
        cell = [[self alloc] initWithReuseIdentifier:reuseIdentifier];
    }
    
    return cell;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]){
        UIColor *highlightedColour = [self.class highlightedColour];
        if(highlightedColour){
            self.selectionStyle = UITableViewCellSelectionStyleDefault;
            self.selectedBackgroundView = [[UIView alloc] init];
            self.selectedBackgroundView.backgroundColor = highlightedColour;
        }else{
            self.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        self.backgroundView = [[UIView alloc] init];
        self.backgroundView.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = nil;
    }
    
    return self;
}

+ (UIColor *)highlightedColour{
    return [CXHexIColor(0x9B9B9B) colorWithAlphaComponent:0.1];
}

@end
