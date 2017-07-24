//
//  RRSwipeCollectionViewCell.m
//  RRSwipeCell
//
//  Created by Moch Xiao on 7/23/17.
//  Copyright © 2017 RedRain. All rights reserved.
//

#import "RRSwipeCollectionViewCell.h"
#import "RRSwipeActionDelegate.h"
#import "RRSwipeActionsView.h"
#import "UICollectionView+RRSwipeCell.h"
#import "UICollectionView+RRSwipeCell_Internal.h"

@interface RRSwipeCollectionViewCell () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIPanGestureRecognizer *rr_panGestureRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer *rr_tapGestureRecognizer;
@property (nonatomic, weak) UICollectionView *rr_collectionView;
@property (nonatomic, weak) RRSwipeActionsView *rr_swipeActionsView;
@property (nonatomic, assign, readwrite) BOOL rr_isActive;
@end

@implementation RRSwipeCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    [self _rr_commitInit];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (!self) {
        return nil;
    }
    [self _rr_commitInit];
    return self;
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
    UIView *view = self;
    UIView *superview;
    while ((superview = view.superview)) {
        view = superview;
        if ([view isKindOfClass:UICollectionView.class]) {
            self.rr_collectionView = (UICollectionView *)view;
            [self.rr_collectionView.panGestureRecognizer removeTarget:self action:nil];
            [self.rr_collectionView.panGestureRecognizer addTarget:self action:@selector(_rr_handleCollectionPan:)];
            return;
        }
    }
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self _rr_reset];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (!self.superview) {
        return NO;
    }

    CGPoint newPoint = [self convertPoint:point toView:self.superview];
    if (!UIAccessibilityIsVoiceOverRunning()) {
        for (RRSwipeCollectionViewCell *cell in self.rr_collectionView._rr_swipeCells) {
            if (cell.rr_isActive && !CGRectContainsPoint(cell.frame, newPoint)) {
                [self.rr_collectionView rr_hideSwipeActions];
                return NO;
            }
        }
    }
    
    return CGRectContainsPoint(self.frame, newPoint);
}

- (BOOL)_rr_containsPoint:(CGPoint)point {
    CGRect newFrame = [self convertRect:self.frame toView:self.superview];
    return CGRectContainsPoint(newFrame, point);
}

#pragma mark - Private methods

- (void)_rr_commitInit {
    _rr_tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_rr_handleTap:)];
    _rr_tapGestureRecognizer.numberOfTapsRequired = 1;
    _rr_tapGestureRecognizer.delegate = self;
    [self addGestureRecognizer:_rr_tapGestureRecognizer];
    
    _rr_panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_rr_handlePan:)];
    _rr_panGestureRecognizer.maximumNumberOfTouches = 1;
    _rr_panGestureRecognizer.delegate = self;
    [self addGestureRecognizer:_rr_panGestureRecognizer];
    
    [_rr_tapGestureRecognizer requireGestureRecognizerToFail:_rr_panGestureRecognizer];
    
    self.exclusiveTouch = YES;
    self.contentView.exclusiveTouch = YES;
}

- (void)_rr_handleTap:(UITapGestureRecognizer *)sender {
    [self _rr_hideSwipeActionsAnimated:YES];
}

- (void)_rr_handlePan:(UIPanGestureRecognizer *)sender {
    CGFloat translationX = [sender translationInView:self].x;
    translationX = translationX > 15 ? 15 : translationX;
    // 禁止右滑
    if (translationX > 0) {
        return;
    }
    CGFloat totalWidth = self.rr_swipeActionsView.actionsWidth;
    CGFloat contentViewMove = translationX;
    if (fabs(translationX) > 30 + totalWidth) {
        contentViewMove = -(totalWidth + 30);
    }

    switch (sender.state) {
        case UIGestureRecognizerStateBegan: {
            if (!self.rr_collectionView) {
                return;
            }
            NSIndexPath *indexPath = [self.rr_collectionView indexPathForCell:self];
            if (!indexPath) {
                return;
            }
            if (![self.rr_collectionView.rr_swipeActionDelegate conformsToProtocol:@protocol(RRSwipeActionDelegate)] ||
                ![self.rr_collectionView.rr_swipeActionDelegate respondsToSelector:@selector(rr_collectionView:swipeActionsForRowAtIndexPath:)]) {
                return;
            }
            NSArray<RRSwipeAction *> *actions = [self.rr_collectionView.rr_swipeActionDelegate rr_collectionView:self.rr_collectionView swipeActionsForRowAtIndexPath:indexPath];
            if (!actions || !actions.count) {
                return;
            }
            RRSwipeActionsView *actionsView = [[RRSwipeActionsView alloc] initWithMaxSize:self.bounds.size actions:actions];
            [self addSubview:actionsView];
            [self sendSubviewToBack:actionsView];
            [self.rr_swipeActionsView removeFromSuperview];
            self.rr_swipeActionsView = nil;
            self.rr_swipeActionsView = actionsView;
            self.rr_isActive = YES;
        } break;
        case UIGestureRecognizerStateChanged: {
            if (!self.rr_isActive) {
                return;
            }
            CGRect frame = self.contentView.frame;
            frame.origin.x = contentViewMove;
            self.contentView.frame = frame;
            self.backgroundView.frame = frame;
        } break;
        case UIGestureRecognizerStateEnded: {
            // 如果滑动过半，到位，否则 recover
            CGFloat x = fabs(translationX) * 2 > totalWidth ? -totalWidth : 0;
            [UIView animateWithDuration:0.25f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                CGRect frame = self.contentView.frame;
                frame.origin.x = x;
                self.contentView.frame = frame;
                self.backgroundView.frame = frame;
            } completion:^(BOOL finished) {
                self.rr_isActive = x != 0;
            }];
        } break;
        default: break;
    }
}

- (void)_rr_handleCollectionPan:(UIPanGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self _rr_hideSwipeActionsAnimated:NO];
    }
}

- (void)_rr_hideSwipeActionsAnimated:(BOOL)animated {
    [self rr_hideSwipeActionsAnimated:YES completion:nil];
}

- (void)_rr_reset {
    [self _rr_hideSwipeActionsAnimated:NO];
    [self.rr_swipeActionsView removeFromSuperview];
    self.rr_swipeActionsView = nil;
}

- (void)rr_hideSwipeActionsAnimated:(BOOL)animated completion:(void (^__nullable)())completion {
    CGRect frame = self.contentView.frame;
    frame.origin.x = 0;
    [UIView animateWithDuration:animated ? 0.25f : 0 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.contentView.frame = frame;
        self.backgroundView.frame = frame;
    } completion:^(BOOL finished) {
        self.rr_isActive = NO;
        if (completion) {
            completion();
        }
    }];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isEqual:self.rr_tapGestureRecognizer]) {
        if (UIAccessibilityIsVoiceOverRunning()) {
            [self.rr_collectionView rr_hideSwipeActions];
        }
        for (RRSwipeCollectionViewCell *cell in self.rr_collectionView._rr_swipeCells) {
            if (cell.rr_isActive) {
                return YES;
            }
        }
        return NO;
    }
    if ([gestureRecognizer isEqual:self.rr_panGestureRecognizer]) {
        CGPoint translation = [((UIPanGestureRecognizer *)gestureRecognizer) translationInView:gestureRecognizer.view];
        return fabs(translation.x) >= fabs(translation.y);
    }
    return [super gestureRecognizerShouldBegin:gestureRecognizer];
}

@end
