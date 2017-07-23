//
//  CollectionViewCell.m
//  RRSwipeCell
//
//  Created by Moch Xiao on 7/23/17.
//  Copyright © 2017 RedRain. All rights reserved.
//

#import "CollectionViewCell.h"

@interface CollectionViewCell ()
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *textLael;
@end

@implementation CollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    [self commitInit];
    return self;
}

- (void)commitInit {
    self.layoutMargins = UIEdgeInsetsZero;
    self.backgroundColor = UIColor.whiteColor;
    self.backgroundView = ({
        UIView *view = [UIView new];
        view.backgroundColor = UIColor.whiteColor;
        view;
    });
    self.selectedBackgroundView = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor colorWithRed:217/255.0f green:217/255.0f blue:217/255.0f alpha:1];
        view;
    });

    [self.contentView addSubview:self.textLael];
    [self addSubview:self.lineView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textLael.frame = self.contentView.bounds;
    self.lineView.frame = CGRectMake(0, CGRectGetHeight(self.contentView.bounds) - 0.5f, CGRectGetWidth(self.contentView.bounds), 0.5f);
}

- (UILabel *)textLael {
    if (!_textLael) {
        UILabel *label = [UILabel new];
        label.textColor = UIColor.blackColor;
        label.textAlignment = NSTextAlignmentLeft;
        label.lineBreakMode = NSLineBreakByTruncatingTail;
        label.adjustsFontSizeToFitWidth = NO;
        label.numberOfLines = 0;
        _textLael = label;
    }
    return _textLael;
}

- (UIView *)lineView {
    if (!_lineView) {
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.25];
        _lineView = view;
    }
    return _lineView;
}

@end
