//
//  RRSwipeAction.h
//  RRSwipeCell
//
//  Created by Roy Shaw on 7/23/17.
//  Copyright © 2017 RedRain. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface RRSwipeAction : NSObject

@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, strong, readonly) UIColor *titleColor;
@property (nonatomic, strong, readonly) UIColor *backgroundColor;
@property (nonatomic, copy, readonly) void (^handler)();
- (instancetype)initWithTitle:(NSString *)title
                   titleColor:(UIColor *)titleColor
              backgroundColor:(UIColor *)backgroundColor
                      handler:(void(^)())handler;

@property (nonatomic, strong, readonly) UIFont *font;
@property (nonatomic, assign, readonly) CGFloat width;

@end
NS_ASSUME_NONNULL_END
