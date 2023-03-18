//
//  CXFailureView.h
//  Pods
//
//  Created by wshaolin on 2019/4/17.
//

#import "CXFailureViewDefinition.h"

@interface CXFailureView : UIView<CXFailureViewDefinition>

@property (nonatomic, strong, readonly) UIImageView *imageView;
@property (nonatomic, strong, readonly) UILabel *textLabel;
@property (nonatomic, strong, readonly) UIButton *refreshButton;

@property (nonatomic, weak) id<CXFailureViewDelegate> delegate;

@end
