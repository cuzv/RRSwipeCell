//
//  RRSwipeActionsView.h
//  RRSwipeCell
//
//  Created by Roy Shaw on 7/23/17.
//  Copyright © 2017 RedRain. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RRSwipeAction;
@interface RRSwipeActionsView : UIView

- (instancetype)initWithMaxSize:(CGSize)size
                        actions:(NSArray<RRSwipeAction *> *)actions;
@property (nonatomic, assign) CGFloat actionsWidth;

@end
