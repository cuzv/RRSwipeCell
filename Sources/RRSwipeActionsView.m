//
//  RRSwipeActionsView.m
//  RRSwipeCell
//
//  Created by Roy Shaw on 7/23/17.
//  Copyright © 2017 RedRain. All rights reserved.
//

#import "RRSwipeActionsView.h"
#import "RRSwipeAction.h"

@interface RRSwipeActionsView ()

@property (nonatomic, assign) CGSize maxSize;
@property (nonatomic, strong) NSArray<RRSwipeAction *> *actions;

@end

@implementation RRSwipeActionsView

- (instancetype)initWithMaxSize:(CGSize)size
                        actions:(NSArray<RRSwipeAction *> *)actions
{
    self = [super init];
    if (!self) {
        return nil;
    }
    _maxSize = size;
    _actions = actions;
    self.frame = CGRectMake(0, 0, size.width, size.height);
    [self commitInit];
    return self;
}

- (void)commitInit {
    NSInteger index = 0;
    CGFloat lastMinX = self.maxSize.width;
    for (RRSwipeAction *action in self.actions) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.backgroundColor = action.backgroundColor;
        [button setTitle:action.title forState:UIControlStateNormal];
        [button setTitleColor:action.titleColor forState:UIControlStateNormal];
        button.titleLabel.font = action.font;
        button.tag = index;
        button.frame = CGRectMake(lastMinX - action.width, 0, action.width, self.maxSize.height);
        [button addTarget:self action:@selector(_rr_handleClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        lastMinX = button.frame.origin.x;
        _actionsWidth = self.maxSize.width - lastMinX;
        ++index;
    }
}

- (void)_rr_handleClickAction:(UIButton *)sender {
    self.actions[sender.tag].handler();
}

@end
