//
//  CXAssetBrowserCollectionView.h
//  Pods
//
//  Created by wshaolin on 2018/9/6.
//

#import <UIKit/UIKit.h>

@interface CXAssetBrowserCollectionView : UICollectionView

+ (instancetype)collectionView;

- (void)scrollToPageAtIndexPath:(NSIndexPath *)indexPath;

@end
