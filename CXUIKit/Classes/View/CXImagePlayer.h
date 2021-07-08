//
//  CXImagePlayer.h
//  Pods
//
//  Created by wshaolin on 2019/1/3.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CXImagePlayerPageControlPosition){
    CXImagePlayerPageControlPositionNone,
    CXImagePlayerPageControlPositionLeft,
    CXImagePlayerPageControlPositionCenter,
    CXImagePlayerPageControlPositionRight
};

@class CXImagePlayer;

@protocol CXImagePlayerDataSource <NSObject>

@required

- (NSUInteger)numberOfImagesInImagePlayer:(CXImagePlayer *)imagePlayer;

- (void)imagePlayer:(CXImagePlayer *)imagePlayer loadImageView:(UIImageView *)imageView atIndex:(NSUInteger)index;

@optional

- (void)imagePlayer:(CXImagePlayer *)imagePlayer loadPlaceholderImageView:(UIImageView *)imageView;

@end

@protocol CXImagePlayerDelegate <NSObject>

@optional

- (void)imagePlayer:(CXImagePlayer *)imagePlayer didSelectImageAtIndex:(NSUInteger)index;

- (void)imagePlayer:(CXImagePlayer *)imagePlayer willDisplayImageAtIndex:(NSUInteger)index;

@end

@interface CXImagePlayer : UIView

@property (nonatomic, weak) id<CXImagePlayerDataSource> dataSource;
@property (nonatomic, weak) id<CXImagePlayerDelegate> delegate;

@property (nonatomic, assign) NSTimeInterval timeInterval;
@property (nonatomic, assign) UIViewContentMode imageContentMode;

@property (nonatomic, strong, readonly) UIPageControl *pageControl;
@property (nonatomic, strong) UIColor *pageIndicatorTintColor;
@property (nonatomic, strong) UIColor *currentPageIndicatorTintColor;

@property (nonatomic, assign, readonly) CXImagePlayerPageControlPosition pageControlPosition;
@property (nonatomic, assign, readonly) NSUInteger currentIndex;

- (instancetype)initWithPageControlPosition:(CXImagePlayerPageControlPosition)position;

- (instancetype)initWithPageControlPosition:(CXImagePlayerPageControlPosition)position
                             imageViewClass:(Class)imageViewClass;

- (void)reloadData;

- (void)startAutoPlay;

- (void)stopAutoPlay;

@end
