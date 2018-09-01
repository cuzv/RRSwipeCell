//
//  UICollectionView+RRSwipeCell_Internal.h
//  RRSwipeCell
//
//  Created by Shaw on 7/24/17.
//  Copyright © 2017 Shaw. All rights reserved.
//

@class RRSwipeCollectionViewCell;
@interface UICollectionView (RRSwipeCell_Internal)
@property (nonatomic, strong, readonly, nullable) NSArray<__kindof RRSwipeCollectionViewCell *> *_rr_swipeCells;
@end
