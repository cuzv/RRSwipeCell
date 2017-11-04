//
//  RRSwipeAction.m
//  RRSwipeCell
//
//  Created by Roy Shaw on 7/23/17.
//  Copyright © 2017 RedRain. All rights reserved.
//

#import "RRSwipeAction.h"

@implementation RRSwipeAction

- (instancetype)initWithTitle:(NSString *)title
                   titleColor:(UIColor *)titleColor
              backgroundColor:(UIColor *)backgroundColor
                      handler:(void(^)())handler
{
    self = [super init];
    if (!self) {
        return nil;
    }
    _title = title;
    _titleColor = titleColor;
    _backgroundColor = backgroundColor;
    _handler = handler;
    _font = [UIFont systemFontOfSize:14];
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine;
    _width = [title boundingRectWithSize:CGSizeMake(UIScreen.mainScreen.bounds.size.width, CGFLOAT_MAX) options:options attributes:@{NSFontAttributeName: _font} context:nil].size.width + 20;
    return self;
}


@end
