
//
//  Calendar.m
//  Calendar
//
//  Created by 邱海龙 on 16/3/26.
//  Copyright © 2016年 qiuhailong. All rights reserved.
//
#define ITEM_W self.frame.size.width / 7
#define ITEM_H self.frame.size.height / 8
#import "Calendar.h"
#import "CalendarCell.h"
#import "CalendarHeaderButton.h"
@interface Calendar ()
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic , strong) NSDate *lastMonthDate;
@property (nonatomic , strong) NSDate *nextMonthDate;
@property (nonatomic, weak) CalendarHeaderButton *headerButton;
@property (nonatomic, strong)NSDate *midMonthDate;

@end
@implementation Calendar
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addViews];
        
        
        //self.today = _date;
    }
    return self;
}

- (void)addViews{
    
    //头部按钮
    CalendarHeaderButton *headerButton = [[CalendarHeaderButton alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, ITEM_H)];
    headerButton.backgroundColor = [UIColor whiteColor];
    __weak __typeof__(self) weakSelf = self;
    headerButton.leftButtonClickBlock = ^{
        [weakSelf.collectionView setContentOffset:CGPointMake(0.4 * weakSelf.frame.size.width, 0) animated:YES];
    };
    headerButton.rightButtonClickBlock = ^{
        [weakSelf.collectionView setContentOffset:CGPointMake(1.6 * weakSelf.frame.size.width, 0) animated:YES];
    };
    headerButton.midButtonClickBlock = ^{
        [weakSelf setDate:weakSelf.today];
        weakSelf.midMonthDate = weakSelf.today;
        [weakSelf.collectionView reloadData];
    };
    [self addSubview:headerButton];
    self.headerButton = headerButton;
    //头部文字 (周几)
    NSArray *weekTitleArray = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    for (int i = 0; i < 7; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(i * ITEM_W, ITEM_H, ITEM_W, ITEM_H)];
        label.text = weekTitleArray[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.borderWidth = 2;
        label.layer.borderColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.8 alpha:1].CGColor;
        label.textColor = [UIColor grayColor];
        [self addSubview:label];
    }
    
    
    //日历主体
    //布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.itemSize = CGSizeMake(ITEM_W, ITEM_H);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //日历
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, ITEM_H*2, self.frame.size.width, ITEM_H*6) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.bounces = NO;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.pagingEnabled = YES;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.contentOffset = CGPointMake(self.frame.size.width, 0);
    [self addSubview:collectionView];
    self.collectionView = collectionView;
    
    
    self.layer.borderColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.8 alpha:1].CGColor;
    self.layer.borderWidth = 2;
    
}
- (void)lastMonth{
    [self setDate:[self lastMonth:self.date]];
    [self.collectionView reloadData];
}
- (void)nextMonth{
    [self setDate:[self nextMonth:self.date]];
    [self.collectionView reloadData];
}
- (void)setDate:(NSDate *)date
{
    _date = date;
    if (!_today) {
        _today = date;
    }
    _midMonthDate = _date;
    NSString *theMonth = [NSString stringWithFormat:@"%li年%.2ld月",(long)[self year:date],(long)[self month:date]];
    [_headerButton.midDateButton setTitle:theMonth forState:UIControlStateNormal];
}


#pragma -mark collectionView delegate  ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;//日历有三组 一组前(上个月),一组后(下个月),\
    永远显示中间的,滑动后将 contenOffSet 设置回中间.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 42;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *reuseID = @"LBSCalendarID";
    [collectionView registerClass:[CalendarCell class] forCellWithReuseIdentifier:reuseID];
    CalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseID forIndexPath:indexPath];
    
    
    //将竖向排列的数字  转为横向     (indexPath.row - 6 * i) * 7 + i - lastMonthDay;
    //cell.dateLabel.text = [NSString stringWithFormat:@"%d",indexPath.row];
    //cell.dateLabel.text = [NSString stringWithFormat:@"%d",(indexPath.row - 6 * 0) * 7 + 0];
    //cell.dateLabel.text = [NSString stringWithFormat:@"%d",(indexPath.row - 6 * 1) * 7 + 1];
    //cell.dateLabel.text = [NSString stringWithFormat:@"%d",(indexPath.row - 6 * 2) * 7 + 2];
    
    
    NSInteger totaldaysInMonth    = 0;
    NSInteger shouldDisplayNumber = 0;
    NSInteger lastMonthTotalDay   = 0;
    NSInteger i = indexPath.row   / 6;
    switch (indexPath.section) {
        case 0:{//前一组
            self.lastMonthDate = [self lastMonth:_date];
            totaldaysInMonth = [self totaldaysInMonth:_lastMonthDate];
            shouldDisplayNumber = (indexPath.row - 6 * i) * 7 + i - [self firstWeekdayInThisMonth:_lastMonthDate] + 1;
            lastMonthTotalDay = [self totaldaysInMonth:[self lastMonth:_lastMonthDate]];
        }
            break;
        case 1:{//中间一组
            totaldaysInMonth = [self totaldaysInMonth:_date];
            if ([self.today isEqualToDate: self.date]) {
                self.midMonthDate = self.today;
            }
            shouldDisplayNumber = (indexPath.row - 6 * i) * 7 + i - [self firstWeekdayInThisMonth:_date] + 1;
            lastMonthTotalDay = [self totaldaysInMonth:[self lastMonth:_date]];
        }
            break;
        case 2:{//后一组
            self.nextMonthDate = [self nextMonth:_date];
            totaldaysInMonth = [self totaldaysInMonth:_nextMonthDate];
            shouldDisplayNumber = (indexPath.row - 6 * i) * 7 + i - [self firstWeekdayInThisMonth:_nextMonthDate] + 1;
            lastMonthTotalDay = [self totaldaysInMonth:_date];
        }
            break;
    }
    if (shouldDisplayNumber <= 0){//上个月的后几天                                        //shouldDispaly偏移后有负数,转为正数
        cell.dateLabel.text = [NSString stringWithFormat:@"%ld",lastMonthTotalDay - labs(shouldDisplayNumber)];
        cell.dateLabel.textColor = [UIColor lightGrayColor];
    }else if (shouldDisplayNumber > totaldaysInMonth){//下个月的前几天
        cell.dateLabel.text = [NSString stringWithFormat:@"%ld",shouldDisplayNumber - totaldaysInMonth];
        cell.dateLabel.textColor = [UIColor lightGrayColor];
    }else{//这个月
        cell.dateLabel.text = [NSString stringWithFormat:@"%ld",shouldDisplayNumber];
        [cell.dateLabel setTextColor:[UIColor blackColor]];
    }
    if ([self.midMonthDate isEqualToDate: self.today]) {
        if (shouldDisplayNumber == [self day:_today]) {
            [UIView animateWithDuration:1 animations:^{//今天显示颜色
                cell.backgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.8 alpha:1];
            }];
            return cell;
        }
    }
    cell.backgroundColor = [UIColor whiteColor];
    
    
    return cell;
}

#pragma mark scrollView Delegate  ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    _midMonthDate = nil;
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self scrollViewDidEndDecelerating:scrollView];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (self.collectionView.contentOffset.x < self.frame.size.width * 0.5) {
        [self  lastMonth];
    }else if (self.collectionView.contentOffset.x > self.frame.size.width * 1.5) {
        [self nextMonth];
    }
    if ([self month:self.date] == [self month:self.today]) {
        
        _midMonthDate = self.today;
    }
    //跳转到中间
    self.collectionView.contentOffset = CGPointMake(self.frame.size.width, 0);
}











#pragma mark - something to get date ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
- (NSInteger)day:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components day];
}
- (NSInteger)month:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components month];
}

- (NSInteger)year:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components year];
}
- (NSInteger)firstWeekdayInThisMonth:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar setFirstWeekday:1];//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [comp setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    return firstWeekday - 1;
}

- (NSInteger)totaldaysInThisMonth:(NSDate *)date{
    NSRange totaldaysInMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return totaldaysInMonth.length;
}

- (NSInteger)totaldaysInMonth:(NSDate *)date{
    NSRange daysInLastMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return daysInLastMonth.length;
}

- (NSDate *)lastMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

- (NSDate*)nextMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = +1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}
@end
