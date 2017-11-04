//
//  UICollectionView+RRSwipeCell.m
//  RRSwipeCell
//
//  Created by Roy Shaw on 7/23/17.
//  Copyright © 2017 RedRain. All rights reserved.
//

#import "UICollectionView+RRSwipeCell.h"
#import <objc/runtime.h>
#import "RRSwipeCollectionViewCell.h"
#import "RRSwipeActionDelegate.h"

@interface _RRWeakObjectBox : NSObject
@property (nonatomic, weak) id object;
@end

@implementation _RRWeakObjectBox

- (instancetype)initWithObject:(id)object {
    self = [super init];
    if (!self) {
        return nil;
    }
    _object = object;
    return self;
}

@end

@implementation UICollectionView (RRSwipeCell)

- (id<RRSwipeActionDelegate>)rr_swipeActionDelegate {
    return ((_RRWeakObjectBox *)objc_getAssociatedObject(self, _cmd)).object;
}

- (void)setRr_swipeActionDelegate:(id<RRSwipeActionDelegate>)rr_swipeActionDelegate {
    _RRWeakObjectBox *value = [[_RRWeakObjectBox alloc] initWithObject:rr_swipeActionDelegate];
    objc_setAssociatedObject(self, @selector(rr_swipeActionDelegate), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)rr_hideSwipeActions {
    for (__kindof UICollectionViewCell *cell in self.visibleCells) {
        if ([cell isKindOfClass:RRSwipeCollectionViewCell.class]) {
            [((RRSwipeCollectionViewCell *)cell) rr_hideSwipeActionsAnimated:YES completion:nil];
        }
    }
}

- (BOOL)rr_isActive {
    for (__kindof UICollectionViewCell *cell in self.visibleCells) {
        if ([cell isKindOfClass:RRSwipeCollectionViewCell.class]) {
            RRSwipeCollectionViewCell *swipeCell = (RRSwipeCollectionViewCell *)cell;
            if (swipeCell.rr_isActive) {
                return YES;
            }
        }
    }
    return NO;
}

- (NSArray<RRSwipeCollectionViewCell *> *)_rr_swipeCells {
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
