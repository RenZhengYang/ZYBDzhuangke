//
//  ZYCateViewController.h
//  BDzhuangke
//
//  Created by mac on 16/9/10.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYCateViewController : UIViewController

@property(nonatomic, strong) UITableView *tableView;


//zhibo 和 feizhibo    时必须传的参数
@property(nonatomic, strong) NSString *cateType;/**< 课程类型 @"zhibo";@"feizhibo"*/

//feizhibo  时必须传的参数
@property(nonatomic, strong) NSMutableArray *cateNameArray;/**< 课程名数组 */
@property(nonatomic, strong) NSMutableArray *cateIDArray;/**< 课程ID数组 */
@end
