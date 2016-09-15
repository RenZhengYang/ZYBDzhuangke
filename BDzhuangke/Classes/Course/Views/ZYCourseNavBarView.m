//
//  ZYCourseNavBarView.m
//  BDzhuangke
//
//  Created by mac on 16/9/8.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "ZYCourseNavBarView.h"

@interface ZYCourseNavBarView ()
/**标题*/
@property(strong,nonatomic)UILabel *titleLab;
/**nameBtn*/
@property(strong,nonatomic)UIButton *nameBtn;
/**搜索按钮*/
@property(strong,nonatomic)UIButton *searchBtn;
@property(assign,nonatomic)NSInteger type;
@end

@implementation ZYCourseNavBarView

/**初始化--添加控件*/
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
     // 注意：该处不要给子控件设置frame与数据，可以在这里初始化子控件的属性
        //  设置UI
        [self setupUI];
        
    }

    return self;
}




#pragma 设置UI
- (void)setupUI
{

    //   背景颜色
    self.backgroundColor = navigationBarColor;
//    self.frame = CGRectMake(0, 0, screen_width, 98);
    
    //   标注
    self.nameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _nameBtn.font = [UIFont systemFontOfSize:15];
    [_nameBtn setTitle:@"登录" forState:UIControlStateNormal];
    [_nameBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_nameBtn addTarget:self action:@selector(OnNameBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_nameBtn];
    
    
    // 搜索
    self.searchBtn = [[UIButton alloc]init];
    [_searchBtn setImage:[UIImage imageNamed:@"search_btn_unpre_bg"] forState:UIControlStateNormal];
    [_searchBtn addTarget:self action:@selector(OnSearchBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_searchBtn];
    
    
    
    //    标题
    self.titleLab = [[UILabel alloc]init];
    //  设置子控件属性
    _titleLab.textColor = [UIColor whiteColor];
    _titleLab.text = @"百度传课";
    _titleLab.font = [UIFont systemFontOfSize:19];
    _titleLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLab];


    //    左右选择的分段按钮
    NSArray *segmentArray = @[@"精选推荐",@"课程分类",];
    self.segmentCtr = [[UISegmentedControl alloc] initWithItems:segmentArray];
    _segmentCtr.selectedSegmentIndex = 0;   //   设置默认选项为 0
    
    //   利用富文本设置字体
    //    正常情况下
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:15],NSFontAttributeName,[UIColor whiteColor],NSForegroundColorAttributeName,nil];
    [_segmentCtr setTitleTextAttributes:attributes forState:UIControlStateNormal];
    //     高亮状态下--选中状态下
    NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [_segmentCtr setTitleTextAttributes:highlightedAttributes forState:UIControlStateSelected];
    
    _segmentCtr.tintColor = RGB(46, 158, 138);
    _segmentCtr.frame = CGRectMake(36, 64, screen_width-36*2, 30);
    [_segmentCtr addTarget:self action:@selector(OnTapSegmentCtr:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_segmentCtr];
    

    
}

- (void)layoutSubviews
{
    
    _nameBtn.frame = CGRectMake(10, 20, 60, 40);
    _titleLab.frame = CGRectMake(screen_width/2-80, 20, 160, 30);
    _searchBtn.frame = CGRectMake(screen_width-10-40, 20, 40, 40);
    
    
}
#pragma 按钮的点击事件
- (void)OnNameBtn:(UIButton *)sender;
{
    _CallBackNameBtn();
}

- (void)OnSearchBtn:(UIButton *)sender;
{

    _CallBackSearchBtn();

}

#pragma mark- _segmentCtr的响应事件
- (void)OnTapSegmentCtr:(UISegmentedControl *)seg
{     NSInteger index = seg.selectedSegmentIndex;
    if(index == 0){
        _leftSegmentCtr();
        
    }else{
        _rightSegmentCtr();
    }
   
}


@end
