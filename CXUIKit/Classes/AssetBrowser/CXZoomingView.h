//
//  CXZoomingView.h
//  Pods
//
//  Created by wshaolin on 2018/9/7.
//

#import <UIKit/UIKit.h>

@class CXZoomingView;

@protocol CXZoomingViewDelegate <NSObject>

@optional

- (void)zoomingViewDidSingleTapEvent:(CXZoomingView *)zoomingView;
- (void)zoomingViewDidDoubleTapEvent:(CXZoomingView *)zoomingView;
- (void)zoomingViewDidLongPressEvent:(CXZoomingView *)zoomingView;

@end

@interface CXZoomingView : UIView

@property (nonatomic, weak) id<CXZoomingViewDelegate> delegate;
@property (nonatomic, strong, readonly) UIImageView *imageView;

- (void)setImage:(UIImage *)image;

@end
