//
//  CXGradientView.m
//  Pods
//
//  Created by wshaolin on 2019/1/24.
//

#import "CXGradientView.h"
#import <CXFoundation/CXFoundation.h>

@implementation CXGradientView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        _gradientLayer = [[CAGradientLayer alloc] init];
        [self.layer addSublayer:_gradientLayer];
    }
    
    return self;
}

- (void)setColors:(NSArray<UIColor *> *)colors startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint{
    if(CXArrayIsEmpty(colors)){
        return;
    }
    
    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:colors.count];
    [colors enumerateObjectsUsingBlock:^(UIColor * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [mutableArray addObject:(id)obj.CGColor];
    }];
    
    _gradientLayer.colors = mutableArray;
    _gradientLayer.startPoint = startPoint;
    _gradientLayer.endPoint = endPoint;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    _gradientLayer.frame = self.bounds;
}

@end
