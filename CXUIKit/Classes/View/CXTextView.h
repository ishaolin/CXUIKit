//
//  CXTextView.h
//  Pods
//
//  Created by wshaolin on 2019/2/20.
//

#import <UIKit/UIKit.h>

@interface CXTextView : UITextView

@property (nonatomic, strong) UIColor *placeholderColor;
@property (nonatomic, copy) NSString *placeholder;

- (void)textDidChange:(NSString *)text; // 内部调用，子类可重写

@end
