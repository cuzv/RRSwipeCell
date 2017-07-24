//
//  UICollectionView+RRSwipeCell.m
//  RRSwipeCell
//
//  Created by Moch Xiao on 7/23/17.
//  Copyright © 2017 RedRain. All rights reserved.
//

#import "UICollectionView+RRSwipeCell.h"
#import <objc/runtime.h>
#import "RRSwipeCollectionViewCell.h"
#import "RRSwipeCollectionViewCell+Internal.h"

@implementation UICollectionView (RRSwipeCell)

- (id<RRSwipeActionDelegate>)rr_swipeActionDelegate {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setRr_swipeActionDelegate:(id<RRSwipeActionDelegate>)rr_swipeActionDelegate {
    objc_setAssociatedObject(self, @selector(rr_swipeActionDelegate), rr_swipeActionDelegate, OBJC_ASSOCIATION_ASSIGN);
}

- (void)rr_hideSwipeActions {
    for (__kindof UICollectionViewCell *cell in self.visibleCells) {
        if ([cell isKindOfClass:RRSwipeCollectionViewCell.class]) {
            [((RRSwipeCollectionViewCell *)cell) _rr_hideSwipeActionsAnimated:YES];
        }
    }
}

- (NSArray<RRSwipeCollectionViewCell *> *)rr_swipeCells {
    NSMutableArray *arr = [NSMutableArray new];
    for (__kindof UICollectionViewCell *cell in self.visibleCells) {
        if ([cell isKindOfClass:RRSwipeCollectionViewCell.class]) {
            [arr addObject:cell];
        }
    }
    if (!arr.count) {
        return nil;
    }
    return arr;
}

@end
