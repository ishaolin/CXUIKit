//
//  CXZoomingImageView.m
//  Pods
//
//  Created by wshaolin on 2018/9/7.
//

#import "CXZoomingView.h"

@interface CXZoomingView () <UIScrollViewDelegate> {
    UIScrollView *_scrollview;
}

@end

@implementation CXZoomingView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        _scrollview = [[UIScrollView alloc] init];
        _scrollview.delegate = self;
        _scrollview.clipsToBounds = YES;
        _scrollview.showsVerticalScrollIndicator = NO;
        _scrollview.showsHorizontalScrollIndicator = NO;
        [self addSubview:_scrollview];
        
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_scrollview addSubview:_imageView];
        
        UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGestureRecognizer:)];
        UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapGestureRecognizer:)];
        doubleTapGestureRecognizer.numberOfTapsRequired = 2;
        UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGestureRecognizer:)];
        [singleTapGestureRecognizer requireGestureRecognizerToFail:doubleTapGestureRecognizer];
        [self addGestureRecognizer:singleTapGestureRecognizer];
        [self addGestureRecognizer:doubleTapGestureRecognizer];
        [self addGestureRecognizer:longPressGestureRecognizer];
    }
    
    return self;
}

- (void)handleSingleTapGestureRecognizer:(UITapGestureRecognizer *)gestureRecognizer{
    if([self.delegate respondsToSelector:@selector(zoomingViewDidSingleTapEvent:)]){
        [self.delegate zoomingViewDidSingleTapEvent:self];
    }
}

- (void)handleDoubleTapGestureRecognizer:(UITapGestureRecognizer *)gestureRecognizer{
    if([self.delegate respondsToSelector:@selector(zoomingViewDidDoubleTapEvent:)]){
        [self.delegate zoomingViewDidDoubleTapEvent:self];
    }
    
    _scrollview.userInteractionEnabled = NO;
    
    if(_scrollview.zoomScale > _scrollview.minimumZoomScale){
        [_scrollview setZoomScale:_scrollview.minimumZoomScale animated:YES];
    }else{
        CGPoint point = [gestureRecognizer locationInView:gestureRecognizer.view];
        point.x += _scrollview.contentOffset.x;
        point.y += _scrollview.contentOffset.y;
        
        CGFloat rect_H = CGRectGetHeight(self.frame) / _scrollview.maximumZoomScale;
        CGFloat rect_W  = CGRectGetWidth(self.frame) / _scrollview.maximumZoomScale;
        CGFloat rect_X = point.x - rect_W * 0.5;
        CGFloat rect_Y = point.y - rect_H * 0.5;
        
        [_scrollview zoomToRect:CGRectMake(rect_X, rect_Y, rect_W, rect_H) animated:YES];
    }
}

- (void)handleLongPressGestureRecognizer:(UILongPressGestureRecognizer *)gestureRecognizer{
    if(gestureRecognizer.state != UIGestureRecognizerStateBegan){
        return;
    }
    
    if([self.delegate respondsToSelector:@selector(zoomingViewDidLongPressEvent:)]){
        [self.delegate zoomingViewDidLongPressEvent:self];
    }
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    CGSize boundsSize = scrollView.bounds.size;
    CGSize contentSize = scrollView.contentSize;
    CGFloat offsetX = MAX((boundsSize.width - contentSize.width) * 0.5, 0);
    CGFloat offsetY = MAX((boundsSize.height - contentSize.height) * 0.5, 0);
    _imageView.center = CGPointMake(contentSize.width * 0.5 + offsetX, contentSize.height * 0.5 + offsetY);
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _imageView;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view{
    _scrollview.scrollEnabled = YES;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    _scrollview.userInteractionEnabled = YES;
}

- (void)setImage:(UIImage *)image{
    _imageView.image = image;
    
    [self setNeedsLayout];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    _scrollview.frame = self.bounds;
    
    if(_imageView.image){
        CGFloat imageView_W = CGRectGetWidth(self.bounds);
        CGFloat imageView_H = (imageView_W / _imageView.image.size.width) * _imageView.image.size.height;
        CGFloat imageView_X = 0;
        CGFloat imageView_Y = MAX((CGRectGetHeight(self.bounds) - imageView_H) * 0.5, 0);
        
        _scrollview.scrollEnabled = (imageView_Y == 0);
        _scrollview.maximumZoomScale = MAX(CGRectGetHeight(self.bounds) / imageView_H, 3.0);
        _scrollview.minimumZoomScale = 1.0;
        _scrollview.zoomScale = 1.0;
        _scrollview.contentSize = CGSizeMake(imageView_W, imageView_H);
        
        // setFrame:需要放在setZoomScale:之后
        _imageView.frame = (CGRect){imageView_X, imageView_Y, imageView_W, imageView_H};
    }
}

@end
