//
//  RRSwipeCollectionViewCell.h
//  RRSwipeCell
//
//  Created by Roy Shaw on 7/23/17.
//  Copyright © 2017 RedRain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RRSwipeCollectionViewCell : UICollectionViewCell

@property (nonatomic, assign, readonly) BOOL rr_isActive;
- (void)rr_hideSwipeActionsAnimated:(BOOL)animated completion:(void (^__nullable)())completion;

@end
