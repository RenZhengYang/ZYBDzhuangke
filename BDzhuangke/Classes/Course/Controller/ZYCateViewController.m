//
//  ZYCateViewController.m
//  BDzhuangke
//
//  Created by mac on 16/9/10.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "ZYCateViewController.h"
#import <MJRefresh.h>
#import "MJExtension.h"
#import <SVProgressHUD.h>
#import "JZAllCourseCell.h"
#import "JZCateModel.h"
#import "ZYCourseDetailViewController.h"
@interface ZYCateViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSInteger _type;/**< segment */
    
    NSInteger _page;/**< 页数 */
    NSInteger _limit;/**< 每页的个数 */
    NSInteger _charge;/**< 1：免费；2：收费 */
    
    NSString *_cateid;/**< 课程分类ID */
    
    NSMutableArray *_dataSourceArray;
    
    UIView *_lineView;
    NSInteger _currentIndex;/**< 记录当前课程分类按钮的下标 */
}


@end

@implementation ZYCateViewController
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

     [self setNav];
     [self initData];
    [self initViews];

}

-(void)initData{
    _dataSourceArray = [[NSMutableArray alloc] init];
    _page = 1;
    _limit = 20;
    _charge = 1;
    _currentIndex = 0;
    if ([self.cateType isEqualToString:@"feizhibo"]) {
                NSLog(@"%@  IDArray:%@",self.cateNameArray,self.cateIDArray);
        _cateid = self.cateIDArray[0];
    }
}

-(void)setNav{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 64)];
    backView.backgroundColor = navigationBarColor;
    [self.view addSubview:backView];
    //返回按钮
    UIButton *backBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 20, 40, 40);
    //    backBtn.font = [UIFont systemFontOfSize:15];
    //    [backBtn setTitle:@"今日直播" forState:UIControlStateNormal];
    //    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"file_tital_back_but"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(OnTapBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:backBtn];
    //
    NSArray *segmentArray = [[NSArray alloc] initWithObjects:@"免费",@"收费", nil];
    UISegmentedControl *segmentCtr = [[UISegmentedControl alloc] initWithItems:segmentArray];
    segmentCtr.frame = CGRectMake(screen_width/2-80, 30, 160, 30);
    segmentCtr.selectedSegmentIndex = 0;
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:15],NSFontAttributeName,[UIColor whiteColor], NSForegroundColorAttributeName, nil];
    [segmentCtr setTitleTextAttributes:attributes forState:UIControlStateNormal];
    NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [segmentCtr setTitleTextAttributes:highlightedAttributes forState:UIControlStateHighlighted];
    
    segmentCtr.tintColor = RGB(46, 158, 138);
    [segmentCtr addTarget:self action:@selector(OnTapSegmentCtr:) forControlEvents:UIControlEventValueChanged];
    [backView addSubview:segmentCtr];
}
-(void)initViews{
    if ([self.cateType isEqualToString:@"zhibo"]) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, screen_width, screen_height-64) style:UITableViewStylePlain];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:self.tableView];
    }else{
        //
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, screen_width, 40)];
        scrollView.pagingEnabled = NO;
        scrollView.alwaysBounceHorizontal = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.backgroundColor = RGB(246, 246, 246);
        [self.view addSubview:scrollView];
        
        float btnWidth = 60;
        
        for (int i = 0; i < self.cateNameArray.count; i++) {
            UIButton *nameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            nameBtn.frame = CGRectMake(btnWidth*i, 0, btnWidth, 40);
            nameBtn.tag = 10+i;
            nameBtn.font = [UIFont systemFontOfSize:13];
            [nameBtn setTitle:self.cateNameArray[i] forState:UIControlStateNormal];
            [nameBtn setTitleColor:navigationBarColor forState:UIControlStateSelected];
            [nameBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [nameBtn addTarget:self action:@selector(OnTapNameBtn:) forControlEvents:UIControlEventTouchUpInside];
            [scrollView addSubview:nameBtn];
            if (i == 0) {
                //                nameBtn.selected = YES;
                _lineView = [[UIView alloc] initWithFrame:CGRectMake(nameBtn.center.x-20, 38, 40, 2)];
                _lineView.backgroundColor = navigationBarColor;
                [scrollView addSubview:_lineView];
            }
        }
        scrollView.contentSize = CGSizeMake(self.cateNameArray.count*btnWidth, 0);
        
        
        
        
        
        //
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+40, screen_width, screen_height-64-40) style:UITableViewStylePlain];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:self.tableView];
    }
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


//请求数据
//非直播：http://pop.client.chuanke.com/?mod=search&act=mobile&from=iPhone&page=1&limit=20&cateid=72351176527446016&charge=1
//直播：http://pop.client.chuanke.com/?mod=search&act=mobile&from=iPhone&page=1&limit=20&today=1&charge=1
-(void)getAllCourseData{
    NSString *urlStr = @"";
    if ([self.cateType isEqualToString:@"zhibo"]) {
        urlStr = [NSString stringWithFormat:@"http://pop.client.chuanke.com/?mod=search&act=mobile&from=iPhone&page=%ld&limit=%ld&today=1&charge=%ld",_page,_limit,_charge];
    }else{
        urlStr = [NSString stringWithFormat:@"http://pop.client.chuanke.com/?mod=search&act=mobile&from=iPhone&page=%ld&limit=%ld&cateid=%@&charge=%ld",_page,_limit,_cateid,_charge];
    }
    NSLog(@"urlStr:%@",urlStr);
    __weak typeof(self) weakself = self;
    [[ZYNetTools sharedManager] getDataResult:nil url:urlStr successBlock:^(id responseBody){
        NSLog(@"课程分类查询成功");
        
        if (_page == 1) {
            [_dataSourceArray removeAllObjects];
        }
        
        NSMutableArray *ClassListArray = [responseBody objectForKey:@"ClassList"];
        for (int i = 0; i < ClassListArray.count; i++) {
            JZCateModel *jzCateM = [JZCateModel mj_objectWithKeyValues:ClassListArray[i]];
            [_dataSourceArray addObject:jzCateM];
        }
        
        
        [weakself.tableView reloadData];
        [weakself.tableView.mj_header endRefreshing];
        [weakself.tableView.mj_footer endRefreshing];
    } failureBlock:^(NSString *error){
        NSLog(@"课程分类查询失败：%@",error);
        [weakself.tableView.mj_header endRefreshing];
        [weakself.tableView.mj_footer endRefreshing];
    }];
}


-(void)loadNewData{
    _page = 1;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getAllCourseData];
    });
}

-(void)loadMoreData{
    _page++;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getAllCourseData];
    });
}

///响应事件
-(void)OnTapBackBtn:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)OnTapSegmentCtr:(UISegmentedControl *)seg{
    NSInteger index = seg.selectedSegmentIndex;
    if (index == 0) {
        _page = 1;
        _charge = 1;
        NSLog(@"免费");
    }else{
        _page = 1;
        _charge = 2;
         NSLog(@"收费");
    }
    [self.tableView.mj_header beginRefreshing];
}
- (void)OnTapNameBtn:(UIButton *)sender{
    NSInteger index = sender.tag - 10;
    if (index == _currentIndex) {
        return;
    }
    _currentIndex = index;
    _cateid = _cateIDArray[index];
    _page = 1;
    [UIView animateWithDuration:0.5 animations:^{
        _lineView.center = CGPointMake(sender.center.x, 39);
    }];
    //刷新数据
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSourceArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 74;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentifier = @"allcourseCell";
    JZAllCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil) {
        cell = [[JZAllCourseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        //下划线
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 73.5, screen_width, 0.5)];
        lineView.backgroundColor = separaterColor;
        [cell addSubview:lineView];
    }
    
    JZCateModel *jzCateM = _dataSourceArray[indexPath.row];
    [cell setJzCateM:jzCateM];
    
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JZCateModel *jzCateM = _dataSourceArray[indexPath.row];
   ZYCourseDetailViewController *jzCourseDVC = [[ZYCourseDetailViewController alloc] init];
    jzCourseDVC.SID = jzCateM.SID;
    jzCourseDVC.courseId = jzCateM.CourseID;
    [self.navigationController pushViewController:jzCourseDVC animated:YES];
}


@end
