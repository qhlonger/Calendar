//
//  Calendar.h
//  Calendar
//
//  Created by 邱海龙 on 16/3/26.
//  Copyright © 2016年 qiuhailong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Calendar : UIView<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong)NSDate *date;
@property (nonatomic, strong) NSDate *today;
@end
