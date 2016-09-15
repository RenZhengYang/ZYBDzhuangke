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
#import "ZYCourseDetailViewController.h"
#import "ZYCateViewController.h"

#import <MJExtension.h>
#import <MJRefresh.h>
#import <SVProgressHUD.h>

#import "ImageScrollView.h"
#import "ImageScrollCell.h"
#import "JZAlbumCell.h"
#import "JZCourseCell.h"

#import "JZFocusListModel.h"
#import "JZCourseListModel.h"
#import "JZAlbumListModel.h"

@interface ZYCateTableViewController ()<UITableViewDataSource,UITableViewDelegate,ImageScrollViewDelegate>

/**< 第一个轮播数据 */
@property(strong,nonatomic)NSMutableArray *focusListArray;
/**< 第一个轮播图片URL数据 */
@property(strong,nonatomic)NSMutableArray *focusImgurlArray;
/**< 列表数据 */
@property(strong,nonatomic)NSMutableArray *courseListArray;
/**< 第二个轮播数据 */
@property(strong,nonatomic)NSMutableArray *albumListArray;
/**< 第二个轮播图片URL数据 */
@property(strong,nonatomic)NSMutableArray *albumImgurlArray;
@property(strong,nonatomic)NSMutableArray *classCategoryArray;
@property(strong,nonatomic)NSMutableArray *CategoryListArray;
/**中间量*/
@property(assign,nonatomic)NSInteger type;
/**tableView*/
@property(strong,nonatomic)UITableView *tableView;

@property(strong,nonatomic)ZYCourseNavBarView *navBarView;

@end


@implementation ZYCateTableViewController
#pragma mark- ViewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
   
    [self initData];
    //    设置自定义navBar
    [self setNavBar];
    //    初始化tableView
    [self initTableView];

  }

#pragma mark- 设置自定义NavBar
- (void)setNavBar
{
    __weak typeof(self) weakSelf = self;
    _navBarView = [[ZYCourseNavBarView alloc]initWithFrame:CGRectMake(0, 0, screen_width, 98)];
    [self.view addSubview:_navBarView];
    
    //  登录
    [_navBarView setCallBackNameBtn:^{
        NSLog(@"左边按钮");
    }];
    //   搜索
    [_navBarView setCallBackSearchBtn:^{
         NSLog(@"搜索");
        ZYSpeechViewController *jzSpeechVC = [[ZYSpeechViewController alloc] init];
        [weakSelf.navigationController pushViewController:jzSpeechVC animated:YES];
    }];
    
        //    分段-左
        [_navBarView setLeftSegmentCtr:^() {
            NSLog(@"精选推荐");
            _type = self.navBarView.segmentCtr.selectedSegmentIndex;

            [weakSelf.tableView reloadData];
        }];

            [_navBarView setRightSegmentCtr:^() {
             NSLog(@"课程分类");
             _type = self.navBarView.segmentCtr.selectedSegmentIndex;

            [weakSelf.tableView reloadData];
        }];


    
}


-(void)initData{
    _focusListArray = [[NSMutableArray alloc] init];
    _courseListArray = [[NSMutableArray alloc] init];
    _albumListArray = [[NSMutableArray alloc] init];
    
    _focusImgurlArray = [[NSMutableArray alloc] init];
    _albumImgurlArray = [[NSMutableArray alloc] init];
    
    _type = self.navBarView.segmentCtr.selectedSegmentIndex;
    //读取plist文件
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"classCategory" ofType:@"plist"];
    _classCategoryArray = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    
    //课程类型
    NSString *iCategoryListPath = [[NSBundle mainBundle] pathForResource:@"iCategoryList" ofType:@"plist"];
    _CategoryListArray = [[NSMutableArray alloc] initWithContentsOfFile:iCategoryListPath];
}


#pragma mark- 初始化tableView
- (void)initTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 98, screen_width, screen_height-98-49) style:UITableViewStylePlain];
       _tableView.dataSource = self;
       _tableView.delegate = self;
        [self.view addSubview:_tableView];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
        [self setupTableview];
}
-(void)setupTableview{
    //添加下拉的动画图片
    //设置下拉刷新回调
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    //设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    UIImage *image = [UIImage imageNamed:@"icon_listheader_animation_1"];
     [idleImages addObject:image];
    [header setImages:idleImages forState:MJRefreshStateIdle];
    //设置即将刷新状态的动画图片
    NSMutableArray *refreshingImages = [NSMutableArray array];
    UIImage *image1 = [UIImage imageNamed:@"icon_listheader_animation_1"];
    [refreshingImages addObject:image1];
    UIImage *image2 = [UIImage imageNamed:@"icon_listheader_animation_2"];
    [refreshingImages addObject:image2];
   
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    [header setImages:refreshingImages forState:MJRefreshStatePulling];
    // 设置正在刷新状态的动画图片
    [header setImages:refreshingImages forState:MJRefreshStateRefreshing];
    
    // 设置文字
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"松开立即刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"正在刷新..." forState:MJRefreshStateRefreshing];
    
    // 设置字体
    header.stateLabel.font = [UIFont systemFontOfSize:15];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
    
    // 设置颜色
    header.stateLabel.textColor = [UIColor redColor];
    header.lastUpdatedTimeLabel.textColor = [UIColor blueColor];
    // 设置header
    self.tableView.mj_header = header;
    
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    
    [self.tableView.mj_header beginRefreshing];
}

-(void)loadNewData{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getRecommenData];
    });
}

#pragma mark- 处理网络请求数据
/**请求推荐课程数据*/
- (void)getRecommenData
{
    __weak typeof(self) weakSelf = self;
    NSString *urls = @"http://pop.client.chuanke.com/?mod=recommend&act=mobile&client=2&limit=20";
    [[ZYNetTools sharedManager] getRecommendCourseResult:nil url:urls successBlock:^(id responseBody) {
        NSLog(@"请求推荐课程数据成功");
       
        NSMutableArray *focusArray = [responseBody objectForKey:@"FocusList"];
        NSMutableArray *courseArray = [responseBody objectForKey:@"CourseList"];
        NSMutableArray *albumArray = [responseBody objectForKey:@"AlbumList"];
        
        [_focusListArray removeAllObjects];
        [_focusImgurlArray removeAllObjects];
        [_courseListArray removeAllObjects];
        [_albumListArray removeAllObjects];
        [_albumImgurlArray removeAllObjects];

        for (int i = 0; i < focusArray.count; ++i) {
            JZFocusListModel *jzFocusM = [JZFocusListModel mj_objectWithKeyValues:focusArray[i]];
            [_focusListArray addObject:jzFocusM];
            [_focusImgurlArray addObject:jzFocusM.PhotoURL];
        }
        for (int i = 0; i < courseArray.count; ++i) {
            JZCourseListModel *jzCourseM = [JZCourseListModel mj_objectWithKeyValues:courseArray[i]];
            [_courseListArray addObject:jzCourseM];
        }
        for (int i = 0; i < albumArray.count; ++i) {
            JZAlbumListModel *jzAlbumM = [JZAlbumListModel mj_objectWithKeyValues:albumArray[i]];
            [_albumListArray addObject:jzAlbumM];
            [_albumImgurlArray addObject:jzAlbumM.PhotoURL];
        }
             weakSelf.tableView.hidden = NO;
             [weakSelf.tableView reloadData];
             [weakSelf.tableView.mj_header endRefreshing];
        
    } failureBlock:^(NSString *error) {
        
        [SVProgressHUD showErrorWithStatus:error];
        
        NSLog(@"请求推荐课程数据失败：%@",error);
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}




#pragma mark-UITableViewDataSource
/**几行*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( _type == 0) {
        if (_courseListArray.count > 0) {
            return _courseListArray.count + 2;
        }else{
            return 0;
        }
        }else {
             return _classCategoryArray.count;
    }
             return 20;
    }
/**行高*/
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( _type == 0) {
        
        if (indexPath.row == 0) {
            return 155;
        }else if(indexPath.row == 1){
            return 90;
        }else{
            return 72;
        }
    }else{
            return 60;
    }
    
    return 30;
}
/**行的样式*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
  
    if (_type == 0){
        if (indexPath.row == 0) {
             static NSString *resuID = @"courseCell0";
            ImageScrollCell *cell = [tableView dequeueReusableCellWithIdentifier:resuID];
            if (!cell){
                cell = [[ImageScrollCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:resuID frame:CGRectMake(0, 0, screen_width, 155)];
     }
            
            cell.imageScrollView.delegate = self;
            [cell setImageArr:_focusImgurlArray];
            return cell;

        }else if(indexPath.row == 1){
         static NSString *resuID = @"courseCell1";
        
            JZAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:resuID];
                        if (cell == nil) {
                            cell = [[JZAlbumCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:resuID frame:CGRectMake(0, 0, screen_width, 90)];
                            //下划线
                            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 89.5, screen_width, 0.5)];
                            lineView.backgroundColor = separaterColor;
                            [cell addSubview:lineView];
                        }
            
                        cell.delegate = self;
                        [cell setImgurlArray:_albumImgurlArray];
                        
                        return cell;
            
        }else if (indexPath.row > 1){
                        static NSString * resuID = @"courseCell2";
                        JZCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:resuID];
                        if (cell == nil) {
                            cell = [[JZCourseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:resuID];
                            //            NSLog(@"%f/%f",cell.frame.size.width,cell.frame.size.height);
                            //下划线
                            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 71.5, screen_width, 0.5)];
                            lineView.backgroundColor = separaterColor;
                            [cell addSubview:lineView];
                        }
            
                        JZCourseListModel *jzCourseM = _courseListArray[indexPath.row-2];
                        [cell setJzCourseM:jzCourseM];
                        
                        return cell;
                    }
        
        
        static NSString * resuID = @"courseCell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:resuID];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:resuID];
                }
        return cell;
        

    }else{
       static NSString * resuID = @"courseClassCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:resuID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:resuID];
            //下划线
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 59.5, screen_width, 0.5)];
            lineView.backgroundColor = separaterColor;
            [cell addSubview:lineView];
            //图
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
            imageView.tag = 10;
            [cell addSubview:imageView];
            //标题
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 15, 100, 30)];
            titleLabel.tag = 11;
            [cell addSubview:titleLabel];
        }
        NSDictionary *dataDic = _classCategoryArray[indexPath.row];
        UIImageView *imageView = (UIImageView *)[cell viewWithTag:10];
        NSString *imageStr = [dataDic objectForKey:@"image"];
        [imageView setImage:[UIImage imageNamed:imageStr]];
        UILabel *titleLabel = (UILabel *)[cell viewWithTag:11];
        titleLabel.text = [dataDic objectForKey:@"title"];
       
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }

    
    
    }
    
    
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_type == 0) {
        JZCourseListModel *jzCourseM = _courseListArray[indexPath.row - 2];
        ZYCourseDetailViewController *zyCourseDVC = [[ZYCourseDetailViewController alloc]init];
        zyCourseDVC.SID = jzCourseM.SID;
        zyCourseDVC.courseId = jzCourseM.CourseID;
        [self.navigationController pushViewController:zyCourseDVC animated:YES];
        
    }else{
        ZYCateViewController *zyCateVc = [[ZYCateViewController alloc]init];
        if (indexPath.row == 0) {
            zyCateVc.cateType = @"zhibo";
        }else{
            
            NSDictionary *dic = _CategoryListArray[indexPath.row-1];
            zyCateVc.cateType = @"feizhibo";
            zyCateVc.cateNameArray = [dic objectForKey:@"categoryName"];
            zyCateVc.cateIDArray = [dic objectForKey:@"categoryID"];

}
        
               [self.navigationController pushViewController:zyCateVc animated:YES];
        
    }




}


#pragma mark - ImageScrollViewDelegate
-(void)didSelectImageAtIndex:(NSInteger)index{
    NSLog(@"图index:%ld",index);
    JZFocusListModel *jzFocusM = _focusListArray[index];
    
    ZYCourseDetailViewController *jzCourseDVC = [[ZYCourseDetailViewController alloc] init];
      jzCourseDVC.SID = jzFocusM.SID;
    jzCourseDVC.courseId = jzFocusM.CourseID;
    [self.navigationController pushViewController:jzCourseDVC animated:YES];
    //    [self presentViewController:jzCourseDVC animated:YES completion:nil];
    
}

#pragma mark - JZAlbumDelegate
-(void)didSelectedAlbumAtIndex:(NSInteger)index{
    NSLog(@"album index:%ld",index);
    if (index == 0) {
        NSURL *url = [NSURL URLWithString:@"openchuankekkiphone:"];
        BOOL isInstalled = [[UIApplication sharedApplication] openURL:url];
        if (isInstalled) {
            
        }else{
            //土豆    https://appsto.re/cn/c8oMx.i
            //找教练  https://appsto.re/cn/kRb26.i
            //百度传课 https://appsto.re/cn/78XAL.i
            //                NSURL *url1 = [NSURL URLWithString:@"https://appsto.re/cn/c8oMx.i"];
            //                NSURL *url1 = [NSURL URLWithString:@"https://appsto.re/cn/kRb26.i"];
            NSURL *url1 = [NSURL URLWithString:@"https://appsto.re/cn/78XAL.i"];
            [[UIApplication sharedApplication] openURL:url1];
            NSLog(@"没安装");
        }
    }else{
        ZYSpeechViewController *ZYSpeechVC = [[ZYSpeechViewController alloc] init];
        [self.navigationController pushViewController:ZYSpeechVC animated:YES];
    }
    
}


@end
