//
//  RRSwipeActionDelegate.h
//  RRSwipeCell
//
//  Created by Moch Xiao on 7/23/17.
//  Copyright © 2017 RedRain. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class RRSwipeAction;
@protocol RRSwipeActionDelegate <NSObject>

- (nullable NSArray<RRSwipeAction *> *)rr_collectionView:(UICollectionView *)collectionView swipeActionsForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
NS_ASSUME_NONNULL_END
