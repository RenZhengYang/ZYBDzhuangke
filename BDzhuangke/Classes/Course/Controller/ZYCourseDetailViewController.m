//
//  ZYCourseDetailViewController.m
//  BDzhuangke
//
//  Created by mac on 16/9/10.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "ZYCourseDetailViewController.h"
#import "ZYCourseInfoViewController.h"
#import "ZYCourseEvaluationViewController.h"
#import "JZCourseDetailModel.h"
#import "JZStepListModel.h"
#import "JZClassListModel.h"
#import "ZYCourseDetailInfoCell.h"
#import "ZYCourseClassCell.h"
#import "ZYSchoolViewController.h"

#import <MJExtension.h>
#import <MJRefresh.h>
#import <SVProgressHUD.h>
@interface ZYCourseDetailViewController ()<UITableViewDataSource,UITableViewDelegate,JZCourseDetailInfoDelegate>
{
    JZCourseDetailModel *_jzCourseDM;
    
    NSMutableArray *_dataSourceArray;/**< 课表数组 */
}

@end

@implementation ZYCourseDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self initData];
    [self setNav];
    [self initTableView];
    
    NSLog(@"------>%@",_dataSourceArray);
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

/*
 *设置Nav
 */
- (void)setNav
{
    UIView *backView = [[UIView alloc]initWithFrame:(CGRect){0, 0, screen_width, 64}];
    backView.backgroundColor = navigationBarColor;
    [self.view addSubview:backView];
    
    //  返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = (CGRect){0,20,40,40};
    [backBtn setImage:[UIImage imageNamed:@"file_tital_back_but"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(OnTapBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:backBtn];
    
    //  标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:(CGRect){screen_width/2-60, 20, 120, 40}];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"课程详情";
    [backView addSubview:titleLabel];
    
    //  收藏
    UIButton *collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    collectBtn.frame = (CGRect){screen_width-40, 20, 40, 40};
    [collectBtn setImage:[UIImage imageNamed:@"course_info_bg_collect"] forState:UIControlStateNormal];
    [collectBtn setImage:[UIImage imageNamed:@"course_info_bg_collected"] forState:UIControlStateSelected];
     [collectBtn addTarget:self action:@selector(OnTapCollectBtn:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:collectBtn];
}
- (void)OnTapBackBtn:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
  
}
- (void)OnTapCollectBtn:(UIButton *)sender
{
    NSLog(@"收藏");
    [self.tableView.mj_header endRefreshing];
}


-(void)OnTap1:(UITapGestureRecognizer *)sender{
    [self pushInfoVC];
}
-(void)OnTap11{
    [self pushInfoVC];
}
-(void)pushInfoVC{
    ZYCourseInfoViewController *jzCourseInfoVC = [[ZYCourseInfoViewController alloc] init];
    jzCourseInfoVC.Brief = _jzCourseDM.Brief;
    [self.navigationController pushViewController:jzCourseInfoVC animated:YES];
}

-(void)OnTap2{
    [self OnTap21];
}
-(void)OnTap21{
    ZYCourseEvaluationViewController *jzEvalVC = [[ZYCourseEvaluationViewController alloc] init];
    jzEvalVC.courseID = self.courseId;
    jzEvalVC.SID = self.SID;
    [self.navigationController pushViewController:jzEvalVC animated:YES];
}


-(void)initData{
    _dataSourceArray = [[NSMutableArray alloc] init];
}
/*
 *初始化tableView
 */
- (void)initTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:(CGRect){0, 64, screen_width, screen_height-64} style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];

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
       [self getClassListData];
    });
}

-(void)getClassListData
{
    
    NSString *urlStr = [NSString stringWithFormat:@"http://pop.client.chuanke.com/?mod=course&act=info&do=getClassList&sid=%@&courseid=%@&version=%@&uid=%@",self.SID,self.courseId,VERSION,UID];
      NSLog(@"urlStr:%@",urlStr);
    NSLog(@">>%@",self.SID);
    __weak typeof (self) weakSelf = self;
    [[ZYNetTools sharedManager] getClassListResult:nil url:urlStr successBlock:^(id responseBody) {
        NSLog(@"*****%@",responseBody);
           NSLog(@"获取课程列表成功");
        _jzCourseDM = [JZCourseDetailModel mj_objectWithKeyValues:responseBody];
         [_dataSourceArray removeAllObjects];
        
        for (int i = 0; i < _jzCourseDM.StepList.count; i++) {
            
        JZStepListModel *jzStepListM = [JZStepListModel mj_objectWithKeyValues:_jzCourseDM.StepList[i]];
            [_dataSourceArray addObject:jzStepListM];

            for (int j = 0; j < jzStepListM.ClassList.count; j++) {
                JZClassListModel *jzClassM = [JZClassListModel mj_objectWithKeyValues:jzStepListM.ClassList[j]];
                if (j == jzStepListM.ClassList.count-1) {
                    jzClassM.isLast = @"1";
                }else{
                    jzClassM.isLast = @"0";
                }
                jzClassM.index = [NSString stringWithFormat:@"%d",j+1];
                [_dataSourceArray addObject:jzClassM];
            }
}
        
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
         } failureBlock:^(NSString *error) {
             
             NSLog(@"获取课程列表失败：%@",error);
             [weakSelf.tableView.mj_header endRefreshing];

        
    }];
    
 
}
#pragma mark - UITableViewDataSource
/**返回组*/
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(_jzCourseDM != nil){
        return 2;
    }
     return 0;
}
/**返回行*/
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
        return _dataSourceArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.1;
    }else{
        return 55;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 110;
    }else{
        if ([_dataSourceArray[indexPath.row] isKindOfClass:[JZStepListModel class]]) {
            return 43;
        }else{
            return 64;
        }
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    }
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 55)];
    headerView.backgroundColor = selectColor;
    //图
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(screen_width/6-12, 5, 25, 25)];
    [imageView1 setImage:[UIImage imageNamed:@"course_catalog_icon"]];
    [headerView addSubview:imageView1];
    //文字
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView1.frame), screen_width/3, 20)];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.textColor = [UIColor whiteColor];
    label1.font = [UIFont systemFontOfSize:13];
    label1.text = @"目录";
    [headerView addSubview:label1];
    //图
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTap1:)];
    
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(screen_width/2-12, 5, 25, 25)];
    [imageView2 setImage:[UIImage imageNamed:@"course_info_icon"]];
    imageView2.userInteractionEnabled = YES;
    [imageView2 addGestureRecognizer:tap1];
    [headerView addSubview:imageView2];
    //文字
    UITapGestureRecognizer *tap11 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTap11)];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/3, CGRectGetMaxY(imageView1.frame), screen_width/3, 20)];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.textColor = [UIColor whiteColor];
    label2.font = [UIFont systemFontOfSize:13];
    label2.text = @"详情";
    label2.userInteractionEnabled = YES;
    [label2 addGestureRecognizer:tap11];
    [headerView addSubview:label2];
    //图
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTap2)];
    
    UIImageView *imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(screen_width*5/6-12, 5, 25, 25)];
    [imageView3 setImage:[UIImage imageNamed:@"course_catalog_icon"]];
    imageView3.userInteractionEnabled = YES;
    [imageView3 addGestureRecognizer:tap2];
    [headerView addSubview:imageView3];
    //文字
    UITapGestureRecognizer *tap21 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTap21)];
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(screen_width*2/3, CGRectGetMaxY(imageView1.frame), screen_width/3, 20)];
    label3.textAlignment = NSTextAlignmentCenter;
    label3.textColor = [UIColor whiteColor];
    label3.font = [UIFont systemFontOfSize:13];
    label3.text = @"评价";
    label3.userInteractionEnabled = YES;
    [label3 addGestureRecognizer:tap21];
    [headerView addSubview:label3];
    
    label3.text = [NSString stringWithFormat:@"评价(%@)",_jzCourseDM.TotalAppraise];
    
    
    return headerView;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString *cellIndentifier = @"detailCell0";
        ZYCourseDetailInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if (cell == nil) {
            cell = [[ZYCourseDetailInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        }
        if (_jzCourseDM != nil) {
            [cell setJzCourseDM:_jzCourseDM];
        }
        
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }else{
        if ([_dataSourceArray[indexPath.row] isKindOfClass:[JZStepListModel class]]) {//章
            static NSString *cellIndentifier = @"detailCell10";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
                //下划线
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 42.5, screen_width, 0.5)];
                lineView.backgroundColor = separaterColor;
                [cell addSubview:lineView];
            }
            JZStepListModel *jzStepM = _dataSourceArray[indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"第%@章:%@",jzStepM.StepIndex,jzStepM.StepName];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{//节
            static NSString *cellIndentifier = @"detailCell11";
          
            ZYCourseClassCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
            if (cell == nil) {
                cell = [[ZYCourseClassCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
                //下划线
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(40, 63.5, screen_width, 0.5)];
                lineView.tag = 10;
                lineView.backgroundColor = separaterColor;
                [cell addSubview:lineView];
            }
            
            JZClassListModel *jzClassM = _dataSourceArray[indexPath.row];
            if ([jzClassM.isLast isEqualToString:@"1"]) {
                UIView *lineView = (UIView *)[cell viewWithTag:10];
                lineView.frame = CGRectMake(0, 63.5, screen_width, 0.5);
            }
            [cell setJzClassM:jzClassM];
            
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    
    static NSString *cellIndentifier = @"detailCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - JZCourseDetailInfoDelegate
-(void)didSelectedSchool{
    ZYSchoolViewController *jzSchoolVC = [[ZYSchoolViewController alloc] init];
    jzSchoolVC.SID = _jzCourseDM.SID;
    [self.navigationController pushViewController:jzSchoolVC animated:YES];
}

    
    

@end
