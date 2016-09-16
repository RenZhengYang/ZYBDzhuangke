//
//  ZYSpeechViewController.m
//  BaiSIJie
//
//  Created by mac on 16/9/8.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "ZYSpeechViewController.h"

#import "JZCateModel.h"
#import "JZAllCourseCell.h"
#import "MJExtension.h"
#import "ZYCourseDetailViewController.h"

@interface ZYSpeechViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UILabel *_textLabel;

  NSMutableArray *_dataSourceArray;
}
@end

@implementation ZYSpeechViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNav];
    [self initViews];
    [self initData];
    [self initTableView];
    
    
//    [self getData];
}
-(void)initData{
    _dataSourceArray = [[NSMutableArray alloc] init];
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
    
    //收藏
    UIButton *collectBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    collectBtn.frame = CGRectMake(screen_width-60, 20, 40, 40);
    //    [collectBtn setImage:[UIImage imageNamed:@"course_info_bg_collect"] forState:UIControlStateNormal];
    //    [collectBtn setImage:[UIImage imageNamed:@"course_info_bg_collected"] forState:UIControlStateSelected];
    [collectBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [collectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [collectBtn addTarget:self action:@selector(OnTapCollectBtn:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:collectBtn];
}
-(void)OnTapBackBtn:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)OnTapCollectBtn:(UIButton *)sender{
    [self.view endEditing:YES];
    if ([self.textField.text isEqualToString:@""]) {
        UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入内容再搜索" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [alertV show];
        return;
    }
    [self getData];

}

-(void)initViews{
    //搜索框
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 64+10, screen_width-60, 30)];
    self.textField.delegate = self;
    self.textField.clearButtonMode = UITextFieldViewModeAlways;
    self.textField.placeholder = @"请 “尝试语音输入课程“";
    self.textField.text = @"";
    self.textField.backgroundColor = RGB(242, 242, 242);
    self.textField.font = [UIFont systemFontOfSize:14];
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
//    self.textField.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.textField];
    
    
    //语音按钮
    UIImageView *voiceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(screen_width-60, 64+6, 60, 36)];
    [voiceImageView setImage:[UIImage imageNamed:@"voice"]];
    [self.view addSubview:voiceImageView];
    UITapGestureRecognizer *voiceTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapVoice)];
    voiceImageView.userInteractionEnabled = YES;
    [voiceImageView addGestureRecognizer:voiceTap];
    
    
    
    //
    //    UIButton *beginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    beginBtn.frame = CGRectMake(10, 100, 80, 40);
    //    [beginBtn addTarget:self action:@selector(OnBeginBtn:) forControlEvents:UIControlEventTouchUpInside];
    //    [beginBtn setTitle:@"开始录音" forState:UIControlStateNormal];
    //    [beginBtn setTitleColor:navigationBarColor forState:UIControlStateNormal];
    //    [self.view addSubview:beginBtn];
    //
    //    UIButton *endBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    endBtn.frame = CGRectMake(100, 100, 80, 40);
    //    [endBtn addTarget:self action:@selector(OnEndBtn:) forControlEvents:UIControlEventTouchUpInside];
    //    [endBtn setTitle:@"结束录音" forState:UIControlStateNormal];
    //    [endBtn setTitleColor:navigationBarColor forState:UIControlStateNormal];
    //    [self.view addSubview:endBtn];
    
    //
    _textLabel.backgroundColor = [UIColor blueColor];
    _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 150, screen_width-10, 100)];
    _textLabel.numberOfLines = 0;
    _textLabel.text = @"";
    _textLabel.hidden = NO;
    _textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _textLabel.textColor = navigationBarColor;
    [self.view addSubview:_textLabel];
    
}
-(void)OnTapVoice{
    _textLabel.text = @"";
//    [self startBtn];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)getData{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getSearchData];
    });
}

-(void)getSearchData{
    __weak typeof(self) weakself = self;
    NSString *urlStr = [NSString stringWithFormat:@"http://pop.client.chuanke.com/?mod=search&act=mobile&page=1&limit=20&keyword=%@&cVersion=2.4.1.2&from=iPhone",self.textField.text];
    [[ZYNetTools sharedManager] getSearchResult:nil url:urlStr successBlock:^(id responseBody){
        NSLog(@"搜索查询成功");
        
        [_dataSourceArray removeAllObjects];
        NSMutableArray *ClassListArray = [responseBody objectForKey:@"ClassList"];
        for (int i = 0; i < ClassListArray.count; i++) {
            JZCateModel *jzCateM = [JZCateModel mj_objectWithKeyValues:ClassListArray[i]];
            [_dataSourceArray addObject:jzCateM];
        }
        
        
        [weakself.tableView reloadData];
        
        
    } failureBlock:^(NSString *error){
        NSLog(@"搜索查询失败:%@",error);
    }];
}



-(void)initTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+40, screen_width, screen_height-64-40-49) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}


#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSourceArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 74;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentifier = @"searchCell";
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

@end
