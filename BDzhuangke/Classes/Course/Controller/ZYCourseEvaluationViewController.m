//
//  ZYCourseEvaluationViewController.m
//  BDzhuangke
//
//  Created by mac on 16/9/10.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "ZYCourseEvaluationViewController.h"
#import "JZEvalModel.h"
#import "ZYNetTools.h"
#import "JZEvalCell.h"
#import "MJExtension.h"
#define MARGIN 5
@interface ZYCourseEvaluationViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(assign,nonatomic)NSInteger page;
@property(assign,nonatomic)NSInteger pageLimit;
@property(strong,nonatomic)NSMutableArray *dataSourceArray;
@end

@implementation ZYCourseEvaluationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:YES];
    
    _page = 1;
    _pageLimit = 10;
    _dataSourceArray = [[NSMutableArray alloc]init];
    
    [self setNav];
    [self initTableView];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getEvalData];
    });
}
-(void)setNav{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 64)];
    backView.backgroundColor = navigationBarColor;
    [self.view addSubview:backView];
    //返回按钮
    UIButton *backBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 20, 40, 40);
    [backBtn setImage:[UIImage imageNamed:@"file_tital_back_but"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(OnTapBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:backBtn];
    
    //标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/2-60, 20, 120, 40)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"课程详情";
    [backView addSubview:titleLabel];
    
    //评价
    UIButton *collectBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    collectBtn.frame = CGRectMake(screen_width-50, 20, 40, 40);
    [collectBtn setTitle:@"评价" forState:UIControlStateNormal];
    //    [collectBtn setImage:[UIImage imageNamed:@"course_info_bg_collect"] forState:UIControlStateNormal];
    //    [collectBtn setImage:[UIImage imageNamed:@"course_info_bg_collected"] forState:UIControlStateSelected];
    [collectBtn addTarget:self action:@selector(OnTapCollectBtn:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:collectBtn];
}

- (void)initTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, screen_width, screen_height-64) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = RGB(230, 230, 230);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];


}

-(void)getEvalData{
    NSString *urlStr = [NSString stringWithFormat:@"http://pop.client.chuanke.com/?mod=course&act=vote&do=list&uid=%@&courseid=%@&sid=%@&limit=%ld&page=%ld",UID,self.courseID,self.SID,(long)_pageLimit,(long)_page];
    NSLog(@"urlStr:%@",urlStr);
    __weak typeof(self) weakself = self;
    [[ZYNetTools sharedManager] getClassEvalResult:nil url:urlStr successBlock:^(id responseBody){
        NSLog(@"评价查询成功");
        NSMutableArray *DataListArray = [responseBody objectForKey:@"DataList"];
        
        if (_page == 1) {
            [_dataSourceArray removeAllObjects];
        }
        
        for (int i = 0; i < DataListArray.count; i++) {
            JZEvalModel *jzEvalM = [JZEvalModel mj_objectWithKeyValues:DataListArray[i]];
            [_dataSourceArray addObject:jzEvalM];
        }
        
        
        [weakself.tableView reloadData];
        
    } failureBlock:^(NSString *error){
        NSLog(@"评价查询失败：%@",error);
    }];

}


-(void)OnTapBackBtn:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)OnTapCollectBtn:(UIButton *)sender{
    NSLog(@"评价");
}
#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSourceArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    JZEvalModel *jzEvalM = _dataSourceArray[indexPath.row];
    return 10+20+ MARGIN+jzEvalM.voteTextHeight +MARGIN+20+MARGIN;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
            static NSString *cellIndentifier = @"evaluationCell";
    JZEvalCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil) {
        cell = [[JZEvalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    
    if (_dataSourceArray.count >0) {
        JZEvalModel *jzEvalM = _dataSourceArray[indexPath.row];
        [cell setJzEvalM:jzEvalM];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;


}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //1. Setup the CATransform3D structure
    CATransform3D rotation;
    rotation                = CATransform3DMakeRotation( (90.0*M_PI)/180, 0.0, 0.7, 0.4);
    rotation.m34            = 1.0/ -600;
    
    
    //2. Define the initial state (Before the animation)
    cell.layer.shadowColor  = [[UIColor blackColor]CGColor];
    cell.layer.shadowOffset = CGSizeMake(10, 10);
    cell.alpha              = 0;
    
    cell.layer.transform    = rotation;
    cell.layer.anchorPoint  = CGPointMake(0, 0.5);
    
    
    //3. Define the final state (After the animation) and commit the animation
    [UIView beginAnimations:@"rotation" context:NULL];
    [UIView setAnimationDuration:0.8];
    cell.layer.transform    = CATransform3DIdentity;
    cell.alpha              = 1;
    cell.layer.shadowOffset = CGSizeMake(0, 0);
    [UIView commitAnimations];
    
}

@end
