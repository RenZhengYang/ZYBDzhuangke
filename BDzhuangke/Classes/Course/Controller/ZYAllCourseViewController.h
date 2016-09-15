//
//  ZYAllCourseViewController.h
//  BDzhuangke
//
//  Created by mac on 16/9/12.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYAllCourseViewController : UIViewController
@property(nonatomic, strong) NSString *DO;/**< 用来表示查询的是直播课程(prelectList)，或者是所有非直播课程(courseList) */
@property(nonatomic, strong) NSString *SID;/**< 学校ID */

@property(nonatomic, strong) UITableView *tableView;

@end
