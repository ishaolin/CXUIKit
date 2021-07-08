//
//  CXGradientView.h
//  Pods
//
//  Created by wshaolin on 2019/1/24.
//

#import <UIKit/UIKit.h>

@interface CXGradientView : UIView

@property (nonatomic, strong, readonly) CAGradientLayer *gradientLayer;

- (void)setColors:(NSArray<UIColor *> *)colors
       startPoint:(CGPoint)startPoint
         endPoint:(CGPoint)endPoint;

@end
