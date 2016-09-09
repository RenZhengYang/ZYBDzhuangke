//
//  ZYCateTableViewController.m
//  BDzhuangke
//
//  Created by mac on 16/9/8.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "ZYCateTableViewController.h"
#import "ZYCourseNavBarView.h"
#import "ZYSpeechViewController.h"
 static NSString *resuID = @"cell";
@interface ZYCateTableViewController ()<UITableViewDataSource,UITableViewDelegate>
/**tableView*/
@property(strong,nonatomic)UITableView *tableView;
@end

@implementation ZYCateTableViewController

/**设置课程推荐的主页面 navBar*/

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    设置自定义navBar
    [self setNavBar];
    //    初始化tableView
    [self initTableView];
    //     隐藏NavBar
    self.navigationController.navigationBar.hidden = YES;
       }

/**设置自定义NavBar*/
- (void)setNavBar
{

    ZYCourseNavBarView *navBarView = [[ZYCourseNavBarView alloc]initWithFrame:CGRectMake(0, 0, screen_width, 98)];
    [self.view addSubview:navBarView];
    
    [navBarView setCallBackNameBtn:^{
        
        NSLog(@"左边按钮");
        
    }];
    //   搜索
    [navBarView setCallBackSearchBtn:^{
         NSLog(@"搜索");
        ZYSpeechViewController *jzSpeechVC = [[ZYSpeechViewController alloc] init];
        [self.navigationController pushViewController:jzSpeechVC animated:YES];
    }];
    
    //    分段-左
    [navBarView setLeftSegmentCtr:^{
          NSLog(@"精选推荐");
        self.tableView.backgroundColor  = [UIColor redColor];
        [self.tableView reloadData];
    
    
    }];
    //    分段-右
    [navBarView setRightSegmentCtr:^{
          NSLog(@"课程分类");
        
        self.tableView.backgroundColor  = [UIColor blueColor];
        [self.tableView reloadData];

    }];
  
}

#pragma mark- 初始化tableView
- (void)initTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 98, screen_width, screen_height-98-49) style:UITableViewStylePlain];
       _tableView.dataSource = self;
       _tableView.delegate = self;
        [self.view addSubview:_tableView];
    //   注册
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:resuID];

}
#pragma mark-UITableViewDataSource
/**几行*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}
/**行高*/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 20;
}
/**行的样式*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
      UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:resuID forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:resuID];
        
    }
    
    return cell;
}

@end
