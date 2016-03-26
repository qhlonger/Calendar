//
//  CalendarHeaderButton.h
//  Calendar
//
//  Created by 邱海龙 on 16/3/26.
//  Copyright © 2016年 qiuhailong. All rights reserved.
//

#import <UIKit/UIKit.h>

 typedef void(^DateButtonClickBlock)(void);
@interface CalendarHeaderButton : UIView

@property (nonatomic, strong)UIButton *leftArrowButton;
@property (nonatomic, strong)UIButton *midDateButton;
@property (nonatomic, strong)UIButton *rightArrowButton;

@property (nonatomic, copy)DateButtonClickBlock leftButtonClickBlock;
@property (nonatomic, copy)DateButtonClickBlock midButtonClickBlock;
@property (nonatomic, copy)DateButtonClickBlock rightButtonClickBlock;

@end
