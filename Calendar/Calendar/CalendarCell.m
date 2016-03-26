//
//  CalendarCell.m
//  Calendar
//
//  Created by 邱海龙 on 16/3/26.
//  Copyright © 2016年 qiuhailong. All rights reserved.
//

#import "CalendarCell.h"

@implementation CalendarCell
- (UIImageView *)imageView{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc]init];
        CGFloat width = self.frame.size.width;
        CGFloat height = self.frame.size.height;
        //_imageView.contentMode = UIViewContentModeCenter;
        _imageView.frame = CGRectMake((width - height)/2, 0, height, height);
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}

- (UILabel *)dateLabel
{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] initWithFrame:self.bounds];
        [_dateLabel setTextAlignment:NSTextAlignmentCenter];
        [_dateLabel setFont:[UIFont systemFontOfSize:14]];
        [self.contentView addSubview:_dateLabel];
    }
    return _dateLabel;
}
@end
