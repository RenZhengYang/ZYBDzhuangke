//
//  ZYCourseDetailViewController.h
//  BDzhuangke
//
//  Created by mac on 16/9/10.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYCourseDetailViewController : UIViewController

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSString    *SID;/**< 接收传参 */
@property (nonatomic, strong) NSString    *courseId;/**< 接收传参 */
@end
