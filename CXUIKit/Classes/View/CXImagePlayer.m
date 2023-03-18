//
//  CXImagePlayer.m
//  Pods
//
//  Created by wshaolin on 2019/1/3.
//

#import "CXImagePlayer.h"
#import <CXFoundation/CXFoundation.h>

typedef NS_ENUM(NSInteger, CXImagePlayerScrollOrietation){
    CXImagePlayerScrollOrietationLeft,
    CXImagePlayerScrollOrietationRight
};

@interface CXImagePlayer() <UIScrollViewDelegate> {
    UIScrollView *_scrollView;
    UIImageView *_imageView1; // 左
    UIImageView *_imageView2; // 中
    UIImageView *_imageView3; // 右
    
    CXTimer *_autoPlayTimer;
    
    CGPoint _contentOffset;
    NSUInteger _numberOfImages;
    CXImagePlayerScrollOrietation _scrollOrietation;
}

@end

@implementation CXImagePlayer

- (instancetype)initWithPageControlPosition:(CXImagePlayerPageControlPosition)position{
    return [self initWithPageControlPosition:position imageViewClass:UIImageView.class];
}

- (instancetype)initWithPageControlPosition:(CXImagePlayerPageControlPosition)position imageViewClass:(Class)imageViewClass{
    if(self = [super initWithFrame:CGRectZero]){
        _pageControlPosition = position;
        
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
        [self addSubview:_scrollView];
        
        _pageControl = [[UIPageControl alloc] init];
        [self addSubview:_pageControl];
        
        _imageView1 = [[imageViewClass alloc] init];
        _imageView1.userInteractionEnabled = YES;
        [_imageView1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleImageViewTapGestureRecognizer:)]];
        
        _imageView2 = [[imageViewClass alloc] init];
        _imageView2.userInteractionEnabled = YES;
        [_imageView2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleImageViewTapGestureRecognizer:)]];
        
        _imageView3 = [[imageViewClass alloc] init];
        _imageView3.userInteractionEnabled = YES;
        [_imageView3 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleImageViewTapGestureRecognizer:)]];
        
        [_scrollView addSubview:_imageView1];
        [_scrollView addSubview:_imageView2];
        [_scrollView addSubview:_imageView3];
        
        self.currentPageIndicatorTintColor = [UIColor whiteColor];
        self.pageIndicatorTintColor = [self.currentPageIndicatorTintColor colorWithAlphaComponent:0.5];
    }
    
    return self;
}

- (void)setImageContentMode:(UIViewContentMode)imageContentMode{
    _imageContentMode = imageContentMode;
    _imageView1.contentMode = imageContentMode;
    _imageView2.contentMode = imageContentMode;
    _imageView3.contentMode = imageContentMode;
}

- (void)handleImageViewTapGestureRecognizer:(UITapGestureRecognizer *)tapGestureRecognizer{
    if(_numberOfImages == 0){
        return;
    }
    
    if([self.delegate respondsToSelector:@selector(imagePlayer:didSelectImageAtIndex:)]){
        [self.delegate imagePlayer:self didSelectImageAtIndex:tapGestureRecognizer.view.tag];
    }
}

- (void)setDataSource:(id<CXImagePlayerDataSource>)dataSource{
    if(_dataSource != dataSource){
        _dataSource = dataSource;
        
        [self reloadData];
    }
}

- (void)reloadData{
    _numberOfImages = [self.dataSource numberOfImagesInImagePlayer:self];
    _pageControl.numberOfPages = _numberOfImages;
    _pageControl.hidden = _numberOfImages <= 1 || _pageControlPosition == CXImagePlayerPageControlPositionNone;
    _scrollView.scrollEnabled = _numberOfImages > 1;
    _currentIndex = 0;
    
    if(_numberOfImages == 0){
        _imageView1.hidden = YES;
        _imageView2.hidden = NO;
        _imageView3.hidden = YES;
        
        if([self.dataSource respondsToSelector:@selector(imagePlayer:loadPlaceholderImageView:)]){
            [self.dataSource imagePlayer:self loadPlaceholderImageView:_imageView2];
        }
    }else{
        _imageView1.hidden = NO;
        _imageView2.hidden = NO;
        _imageView3.hidden = NO;
        
        [self notifyDataSourceLoadImage];
        [self startAutoPlay];
    }
    
    [self setNeedsLayout];
}

- (void)setTimeInterval:(NSTimeInterval)timeInterval{
    if(_timeInterval != timeInterval){
        _timeInterval = timeInterval;
        
        [self stopAutoPlay];
        [self startAutoPlay];
    }
}

- (void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor{
    if(_pageIndicatorTintColor != pageIndicatorTintColor){
        _pageIndicatorTintColor = pageIndicatorTintColor;
        
        _pageControl.pageIndicatorTintColor = _pageIndicatorTintColor;
    }
}

- (void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor{
    if(_currentPageIndicatorTintColor != currentPageIndicatorTintColor){
        _currentPageIndicatorTintColor = currentPageIndicatorTintColor;
        
        _pageControl.currentPageIndicatorTintColor = _currentPageIndicatorTintColor;
    }
}

- (void)startAutoPlay{
    if(_timeInterval <= 0 || _autoPlayTimer || _numberOfImages <= 1){
        return;
    }
    
    _autoPlayTimer = [CXTimer taskTimerWithConfig:^(CXTimerConfig *config) {
        config.target = self;
        config.action = @selector(autoPlayAction:);
        config.interval = _timeInterval;
        config.repeats = YES;
    }];
}

- (void)stopAutoPlay{
    if(_autoPlayTimer.isValid){
        [_autoPlayTimer invalidate];
    }
    
    _autoPlayTimer = nil;
}

- (void)autoPlayAction:(CXTimer *)timer{
    [UIView animateWithDuration:0.5 animations:^{
        self->_scrollView.contentOffset = CGPointMake(CGRectGetWidth(self->_scrollView.bounds) + self->_scrollView.contentOffset.x, 0);
    } completion:^(BOOL finished) {
        self->_scrollView.contentOffset = CGPointMake(CGRectGetWidth(self->_scrollView.bounds), 0);
        [self loadImageWithScrollOrietation:CXImagePlayerScrollOrietationRight];
    }];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self stopAutoPlay];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(_contentOffset.x - scrollView.contentOffset.x > 0){
        _scrollOrietation = CXImagePlayerScrollOrietationRight;
    }else if(_contentOffset.x - scrollView.contentOffset.x < 0){
        _scrollOrietation = CXImagePlayerScrollOrietationLeft;
    }
    
    _contentOffset = scrollView.contentOffset;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if(scrollView.contentOffset.x != CGRectGetWidth(scrollView.bounds)){
        scrollView.contentOffset = (CGPoint){CGRectGetWidth(scrollView.bounds), 0};
        [self loadImageWithScrollOrietation:_scrollOrietation];
    }
    
    [self startAutoPlay];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(decelerate){
        [self startAutoPlay];
    }else{
        [self scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)loadImageWithScrollOrietation:(CXImagePlayerScrollOrietation)scrollOrietation{
    if(_numberOfImages == 0){
        return;
    }
    
    if(scrollOrietation == CXImagePlayerScrollOrietationLeft){
        _currentIndex = (_currentIndex + _numberOfImages - 1) % _numberOfImages;
    }else{
        _currentIndex = (_currentIndex + _numberOfImages + 1) % _numberOfImages;
    }
    
    [self notifyDataSourceLoadImage];
}

- (void)notifyDataSourceLoadImage{
    if(_numberOfImages > 1){
        NSUInteger index1 = (_currentIndex + _numberOfImages - 1) % _numberOfImages;
        NSUInteger index3 = (_currentIndex + _numberOfImages + 1) % _numberOfImages;
        
        [self loadImageView:_imageView1 forIndex:index1];
        [self loadImageView:_imageView3 forIndex:index3];
    }
    
    _pageControl.currentPage = _currentIndex;
    [self loadImageView:_imageView2 forIndex:_currentIndex];
    
    if([self.delegate respondsToSelector:@selector(imagePlayer:willDisplayImageAtIndex:)]){
        [self.delegate imagePlayer:self willDisplayImageAtIndex:_currentIndex];
    }
}

- (void)loadImageView:(UIImageView *)imageView forIndex:(NSUInteger)index{
    imageView.tag = index;
    
    [self.dataSource imagePlayer:self loadImageView:imageView atIndex:index];
}

- (CGFloat)pageControlFrameXWithWidth:(CGFloat)width{
    switch (self.pageControlPosition) {
        case CXImagePlayerPageControlPositionCenter:
            return (CGRectGetWidth(self.bounds) - width) * 0.5;
        case CXImagePlayerPageControlPositionRight:
            return CGRectGetWidth(self.bounds) - width - 10.0;
        case CXImagePlayerPageControlPositionNone:
        case CXImagePlayerPageControlPositionLeft:
        default:
            return 10.0;
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    _scrollView.frame = self.bounds;
    _imageView1.frame = _scrollView.bounds;
    _imageView2.frame = CGRectOffset(_imageView1.frame, CGRectGetWidth(_scrollView.frame), 0);
    _imageView3.frame = CGRectOffset(_imageView2.frame, CGRectGetWidth(_scrollView.frame), 0);
    
    CGFloat pageControl_H = 20.0;
    CGFloat pageControl_W = MIN(CGRectGetWidth(self.bounds) - 20.0, [_pageControl sizeForNumberOfPages:_pageControl.numberOfPages].width);
    CGFloat pageControl_X = [self pageControlFrameXWithWidth:pageControl_W];
    CGFloat pageControl_Y = CGRectGetHeight(self.bounds) - pageControl_H - 10.0;
    _pageControl.frame = (CGRect){pageControl_X, pageControl_Y, pageControl_W, pageControl_H};
    
    _scrollView.contentSize = (CGSize){CGRectGetWidth(self.bounds) * 3, 0};
    _scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.bounds), 0);
}

@end
