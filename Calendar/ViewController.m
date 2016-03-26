//
//  ViewController.m
//  Calendar
//
//  Created by 邱海龙 on 16/3/26.
//  Copyright © 2016年 qiuhailong. All rights reserved.
//

#import "ViewController.h"
#import "Calendar.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addCalendar];
}
- (void)addCalendar{
    //只需设置 frame 和 时间
    Calendar *calendar = [[Calendar alloc]initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 40*8) ];
    calendar.date = [NSDate date];
    [self.view addSubview:calendar];
}








@end
