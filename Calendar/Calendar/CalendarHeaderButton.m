//
//  CalendarHeaderButton.m
//  Calendar
//
//  Created by 邱海龙 on 16/3/26.
//  Copyright © 2016年 qiuhailong. All rights reserved.
//

#import "CalendarHeaderButton.h"

@implementation CalendarHeaderButton
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit{
    [self addSubview:self.leftArrowButton];
    [self addSubview:self.midDateButton];
    [self addSubview:self.rightArrowButton];
}
- (void)layoutSubviews{
    self.midDateButton.frame = CGRectMake(0,0, self.frame.size.width * 0.6, self.frame.size.height);
    self.midDateButton.center = self.center;
    
    self.leftArrowButton.frame = CGRectMake(CGRectGetMinX(_midDateButton.frame)-30, 0, 30, self.frame.size.height);
    self.rightArrowButton.frame = CGRectMake(CGRectGetMaxX(_midDateButton.frame) , 0, 30, self.frame.size.height);
}
- (UIButton *)leftArrowButton{
    if (_leftArrowButton == nil) {
        UIButton *btn = [[UIButton alloc]init];
        [btn setImage:[UIImage imageNamed:@"left_arrow"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _leftArrowButton = btn;
    }
    return _leftArrowButton;
}
- (UIButton *)midDateButton{
    if (_midDateButton == nil) {
        UIButton *btn = [[UIButton alloc]init];
        btn.titleLabel.font = [UIFont systemFontOfSize:18];
        [btn setTitle:@"----年--月" forState:UIControlStateNormal];
        //[btn setTitle:[NSString getTimeBySeparator:@"-"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _midDateButton = btn;
    }
    return _midDateButton;
}
- (UIButton *)rightArrowButton{
    if (_rightArrowButton == nil) {
        UIButton *btn = [[UIButton alloc]init];
        [btn setImage:[UIImage imageNamed:@"right_arrow"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _rightArrowButton = btn;
    }
    return _rightArrowButton;
}
- (void)buttonClick:(UIButton *)sender{
    if ([sender isEqual:self.leftArrowButton]) {
        if (_leftButtonClickBlock) {
            _leftButtonClickBlock();
        }
        return;
    }else if ([sender isEqual:self.rightArrowButton]){
        if (_rightButtonClickBlock) {
            _rightButtonClickBlock();
        }
        return;
    }else{
        if (_midButtonClickBlock) {
            _midButtonClickBlock();
        }
    }
    
}

- (void)setLeftButtonClickBlock:(DateButtonClickBlock)leftButtonClickBlock{
    _leftButtonClickBlock = leftButtonClickBlock;
}
- (void)setRightButtonClickBlock:(DateButtonClickBlock)rightButtonClickBlock{
    _rightButtonClickBlock = rightButtonClickBlock;
}
- (void)setMidButtonClickBlock:(DateButtonClickBlock)midButtonClickBlock{
    _midButtonClickBlock = midButtonClickBlock;
}
@end
