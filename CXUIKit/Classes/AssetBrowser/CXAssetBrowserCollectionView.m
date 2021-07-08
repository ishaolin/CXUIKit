//
//  CXAssetBrowserCollectionView.m
//  Pods
//
//  Created by wshaolin on 2018/9/6.
//

#import "CXAssetBrowserCollectionView.h"
#import "CXVideoPlayControl.h"

@interface CXAssetBrowserCollectionView () {
    NSIndexPath *_scrollToIndexPath;
}

@end

@implementation CXAssetBrowserCollectionView

+ (instancetype)collectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.sectionInset = UIEdgeInsetsZero;
    layout.minimumInteritemSpacing = 0.0;
    layout.minimumLineSpacing = 0.0;
    layout.headerReferenceSize = CGSizeZero;
    layout.footerReferenceSize = CGSizeZero;
    
    return [[self alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    if(self = [super initWithFrame:frame collectionViewLayout:layout]){
        self.pagingEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.autoresizesSubviews = YES;
        self.alwaysBounceHorizontal = YES;
    }
    
    return self;
}

- (void)scrollToPageAtIndexPath:(NSIndexPath *)indexPath{
    _scrollToIndexPath = indexPath;
}

- (void)setContentSize:(CGSize)contentSize{
    if(CGSizeEqualToSize(contentSize, self.contentSize)){
        return;
    }
    
    [super setContentSize:contentSize];
    
    if(_scrollToIndexPath){
        [self scrollToItemAtIndexPath:_scrollToIndexPath
                     atScrollPosition:UICollectionViewScrollPositionRight
                             animated:NO];
    }
    
    _scrollToIndexPath = nil;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if([touch.view isKindOfClass:[CXVideoPlayControl class]]){
        return NO;
    }
    
    if([touch.view.superview isKindOfClass:[CXVideoPlayControl class]]){
        return NO;
    }
    
    return YES;
}

@end
