//
//  CXAssetBrowser.m
//  Pods
//
//  Created by wshaolin on 2018/9/6.
//

#import "CXAssetBrowser.h"
#import "CXAssetBrowserCollectionView.h"
#import "CXAssetBrowserImageCell.h"
#import "CXAssetBrowserVideoCell.h"
#import <CXFoundation/CXFoundation.h>
#import "CXImageUtils.h"
#import "UIScreen+CXExtensions.h"
#import "CXBaseViewController.h"
#import "UIView+CXExtensions.h"

@interface CXAssetBrowser () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, CXAssetBrowserContentCellDelegate>{
    CXAssetBrowserCollectionView *_contentView;
    UIButton *_saveImageButton;
    BOOL _oldStatusBarHidden;
}

@property (nonatomic, weak, readonly) CXBaseViewController *viewController;
@property (nonatomic, strong, readonly) UIImageView *imageView;

@end

@implementation CXAssetBrowser

@dynamic delegate;

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.animationType = CXActionPanelAnimationCustom;
        self.dismissWhenTapOverlayView = NO;
        self.backgroundColor = [UIColor blackColor];
        self.animationDuration = 0.4;
        
        _contentView = [CXAssetBrowserCollectionView collectionView];
        _contentView.dataSource = self;
        _contentView.delegate = self;
        [_contentView registerClass:[CXAssetBrowserImageCell class]
         forCellWithReuseIdentifier:[CXAssetBrowserImageCell reuseIdentifier]];
        [_contentView registerClass:[CXAssetBrowserVideoCell class]
         forCellWithReuseIdentifier:[CXAssetBrowserVideoCell reuseIdentifier]];
        [self addSubview:_contentView];
        
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imageView];
        
        UIImage *image = CX_UIKIT_IMAGE(@"ui_asset_browser_save_image");
        _saveImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveImageButton setImage:image forState:UIControlStateNormal];
        [_saveImageButton addTarget:self action:@selector(handleActionForSaveImageButton:) forControlEvents:UIControlEventTouchUpInside];
        _saveImageButton.hidden = !self.isSaveButtonEnabled;
        [self addSubview:_saveImageButton];
    }
    
    return self;
}

- (void)handleActionForSaveImageButton:(UIButton *)saveImageButton{
    if([self.delegate respondsToSelector:@selector(browser:saveAssetToPhotosAlbum:)]){
        [self.delegate browser:self saveAssetToPhotosAlbum:self.currentImage];
    }
}

- (UIImage *)currentImage{
    CXAssetBrowserContentCell *cell = (CXAssetBrowserContentCell *)_contentView.visibleCells.firstObject;
    return cell.image;
}

- (void)setImageURLs:(NSArray<NSString *> *)imageURLs{
    _imageURLs = imageURLs;
    
    NSMutableArray<CXAssetModel *> *assetModels = [NSMutableArray array];
    [_imageURLs enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSURL *imageURL = [NSURL URLWithString:obj];
        if(imageURL){
            CXAssetModel *assetModel = [[CXAssetModel alloc] initWithImageURL:imageURL];
            [assetModels addObject:assetModel];
        }
    }];
    
    self.assetModels = [assetModels copy];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.assetModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CXAssetBrowserContentCell *contentCell = nil;
    if(self.assetModels[indexPath.item].assetType == CXAssetTypeImage){
        contentCell = [CXAssetBrowserImageCell cellWithCollectionView:collectionView forIndexPath:indexPath];
        if(self.saveButtonEnabled && indexPath.item == _currentIndex){
            _saveImageButton.hidden = NO;
        }
    }else{
        contentCell = [CXAssetBrowserVideoCell cellWithCollectionView:collectionView forIndexPath:indexPath];
    }
    
    contentCell.longPressEnabled = self.isLongPressEnabled;
    contentCell.delegate = self;
    return contentCell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    CXAssetBrowserContentCell *contentCell = (CXAssetBrowserContentCell *)cell;
    if(!_imageView.isHidden){
        contentCell.thumbnailImage = _imageView.image;
    }
    
    contentCell.assetModel = self.assetModels[indexPath.item];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return collectionView.bounds.size;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(!self.isSaveButtonEnabled){
        return;
    }
    
    CGFloat width = CGRectGetWidth(scrollView.frame);
    if(width <= 0){
        return;
    }
    
    NSUInteger index = floor((scrollView.contentOffset.x - width * 0.5) / width) + 1;
    if(index >= self.assetModels.count){
        return;
    }
    
    if(self.assetModels[index].assetType == CXAssetTypeImage){
        _saveImageButton.hidden = NO;
    }else{
        _saveImageButton.hidden = YES;
    }
}

- (void)browserCell:(CXAssetBrowserContentCell *)cell downloadImage:(CXAssetModel *)assetModel completion:(CXAssetImageDownloadCompletionBlock)completion{
    if([self.delegate respondsToSelector:@selector(browser:downloadImage:completion:)]){
        [self.delegate browser:self
                 downloadImage:assetModel
                    completion:completion];
    }
}

- (void)browserCell:(CXAssetBrowserContentCell *)cell downloadVideo:(CXAssetModel *)assetModel snapshot:(CXAssetImageDownloadCompletionBlock)snapshot completion:(CXAssetVideoDownloadCompletionBlock)completion{
    if([self.delegate respondsToSelector:@selector(browser:downloadVideo:snapshot:completion:)]){
        [self.delegate browser:self
                 downloadVideo:assetModel
                      snapshot:snapshot
                    completion:completion];
    }
}

- (void)browserCellDidClosed:(CXAssetBrowserContentCell *)cell{
    [self dismissWithAnimated:YES];
}

- (void)browserCell:(CXAssetBrowserContentCell *)cell saveAssetToPhotosAlbum:(id)asset{
    if([self.delegate respondsToSelector:@selector(browser:saveAssetToPhotosAlbum:)]){
        [self.delegate browser:self saveAssetToPhotosAlbum:asset];
    }
}

- (void)browserCell:(CXAssetBrowserContentCell *)cell downloadFinishedWithAsset:(id)asset{
    
}

- (void)browserCell:(CXAssetBrowserContentCell *)cell didStartPlayVideo:(NSURL *)videoURL{
    if([self.delegate respondsToSelector:@selector(browser:didStartPlayVideo:)]){
        [self.delegate browser:self didStartPlayVideo:videoURL];
    }
}

- (void)browserCell:(CXAssetBrowserContentCell *)cell didStopPlayVideo:(NSURL *)videoURL{
    if([self.delegate respondsToSelector:@selector(browser:didStopPlayVideo:)]){
        [self.delegate browser:self didStopPlayVideo:videoURL];
    }
}

- (CXActionAnimationBlock)showAnimationWithSuperView:(UIView *)superView{
    self.frame = superView.bounds;
    _imageView.frame = [self viewConvertRect:self.currentAssetView];
    
    return ^{
        self->_imageView.frame = superView.bounds;
    };
}

- (CXActionAnimationBlock)dismissAnimationWithSuperView:(UIView *)superView{
    CXAssetBrowserContentCell *contentCell = _contentView.visibleCells.firstObject;
    _imageView.image = contentCell.image;
    [superView addSubview:_imageView];
    
    if(_imageView.image){
        CGFloat imageView_W = 0;
        CGFloat imageView_H = 0;
        if(_imageView.image.size.height >= CGRectGetHeight(superView.bounds)){
            imageView_H = CGRectGetHeight(superView.bounds);
            imageView_W = MIN(_imageView.image.size.height / imageView_H * _imageView.image.size.width, CGRectGetWidth(superView.bounds));
        }else{
            imageView_W = CGRectGetWidth(superView.bounds);
            imageView_H = _imageView.image.size.width / imageView_W * CGRectGetHeight(superView.bounds);
        }
        
        CGFloat imageView_X = (CGRectGetWidth(superView.bounds) - imageView_W) * 0.5;
        CGFloat imageView_Y = (CGRectGetHeight(superView.bounds) - imageView_H) * 0.5;
        _imageView.frame = (CGRect){imageView_X, imageView_Y, imageView_W, imageView_H};
    }
    
    NSIndexPath *indexPath = [_contentView indexPathForCell:contentCell];
    CGRect frame = [self hiddenFrameWithIndexPath:indexPath];
    return ^{
        self.alpha = 0;
        self->_imageView.frame = frame;
    };
}

- (CGRect)hiddenFrameWithIndexPath:(NSIndexPath *)indexPath{
    CGRect frame = (CGRect){self.center, CGSizeZero};
    if(!indexPath){
        return frame;
    }
    
    if(indexPath.item == self.currentIndex){
        if(self.currentAssetView){
            return [self viewConvertRect:self.currentAssetView];
        }
        
        return frame;
    }
    
    UIView *assetView = self.assetViews[@(indexPath.item)];
    if(assetView){
        CGRect rect = [self viewConvertRect:assetView];
        CGPoint point1 = CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect));
        CGPoint point2 = CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect));
        CGPoint point3 = CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect));
        CGPoint point4 = CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect));
        if(CGRectContainsPoint(self.bounds, point1) ||
           CGRectContainsPoint(self.bounds, point2) ||
           CGRectContainsPoint(self.bounds, point3) ||
           CGRectContainsPoint(self.bounds, point4)){
            return rect;
        }
        
        return frame;
    }
    
    if(self.currentAssetView){
        frame = [self viewConvertRect:self.currentAssetView];
        frame.origin.x += frame.size.width * 0.5;
        frame.origin.y += frame.size.height * 0.5;
        frame.size = CGSizeZero;
        return frame;
    }
    
    return frame;
}

- (CGRect)viewConvertRect:(UIView *)view{
    return [view.superview convertRect:view.frame toView:self];
}

- (void)showWithImage:(UIImage *)image currentIndex:(NSUInteger)currentIndex{
    _imageView.image = image;
    _currentIndex = currentIndex;
    
    [self showInView:nil];
}

- (void)showWithImageView:(UIImageView *)imageView assetModel:(CXAssetModel *)assetModel{
    self.currentAssetView = imageView;
    _imageView.image = imageView.image;
    
    if(assetModel){
        self.assetModels = @[assetModel];
    }
    
    [self showInView:nil];
}

- (void)willPresent{
    _contentView.hidden = YES;
    _imageView.hidden = NO;
    
    UIViewController *viewController = self.currentAssetView.cx_viewController;
    if([viewController isKindOfClass:[CXBaseViewController class]]){
        _viewController = (CXBaseViewController *)viewController;
        _oldStatusBarHidden = _viewController.isStatusBarHidden;
        _viewController.statusBarHidden = YES;
    }
    
    if(self.currentIndex < self.assetModels.count){
        [_contentView scrollToPageAtIndexPath:[NSIndexPath indexPathForItem:_currentIndex inSection:0]];
    }
}

- (void)didPresent{
    _contentView.hidden = NO;
    _imageView.hidden = YES;
}

- (void)willDismiss{
    _contentView.hidden = YES;
    _imageView.hidden = NO;
    
    _viewController.statusBarHidden = _oldStatusBarHidden;
}

- (void)didDismiss{
    [_imageView removeFromSuperview];
}

- (UIView *)overlayView{
    return nil;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGRect frame = self.bounds;
    frame.size.width += CXAssetBrowserCellIntervalSpacing;
    _contentView.frame = frame;
    
    CGFloat saveImageButton_W = 30.0;
    CGFloat saveImageButton_H = saveImageButton_W;
    CGFloat saveImageButton_X = CGRectGetWidth(self.bounds) - saveImageButton_W - 20.0;
    CGFloat saveImageButton_Y = CGRectGetHeight(self.bounds) - saveImageButton_H - 20.0;
    if([UIScreen mainScreen].cx_isBangs){
        saveImageButton_Y -= 70.0;
    }
    _saveImageButton.frame = (CGRect){saveImageButton_X, saveImageButton_Y, saveImageButton_W, saveImageButton_H};
}

@end
