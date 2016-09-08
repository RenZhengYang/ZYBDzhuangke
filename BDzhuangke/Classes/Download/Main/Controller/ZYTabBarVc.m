//
//  ZYTabBarVc.m
//  BDzhuangke
//
//  Created by mac on 16/9/8.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "ZYTabBarVc.h"
#import "ZYNavigationController.h"

#import "ZYMineViewController.h"
#import "ZYCateTableViewController.h"
#import "ZYDownLoadViewController.h"

#import "UIImage+Image.h"
@interface ZYTabBarVc ()

@end

@implementation ZYTabBarVc
#pragma mark- load加载
/**利用富文本设置tabbar的标题颜色和尺寸*/
+ (void)load
{
    //  获取哪个类中UITabBarItem
    UITabBarItem *item = [UITabBarItem appearanceWhenContainedIn:self, nil];
    
    //  设置按钮选中标题的颜色
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = navigationBarColor;
    [item setTitleTextAttributes:attrs forState:UIControlStateSelected];
    
    //   设置字体尺寸--只能设置正常状态下
    NSMutableDictionary *attrsNor = [[NSMutableDictionary alloc]init];
    attrsNor[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    [item setTitleTextAttributes:attrsNor forState:UIControlStateNormal];
    
}

/**封装添加子控制器*/
- (void)setUpOneChildViewController:(UIViewController *)vc image:(NSString *)image selectedImage:(NSString *)selectedImage title:(NSString *)title isHasNav:(BOOL)isHasNav
{
    vc.tabBarItem.image = [UIImage imageNamed:image];
    vc.tabBarItem.selectedImage = [UIImage imageOriginalWith:selectedImage];
    
    if (isHasNav == YES) {
        vc.title = title;
        ZYNavigationController *nav = [[ZYNavigationController alloc]initWithRootViewController:vc];
        [self addChildViewController:nav];
    }else{
        vc.tabBarItem.image = [UIImage imageOriginalWith:image];
        vc.title = title;
        [self addChildViewController:vc];
    }
    
}

#pragma mark- 添加所有子控制器
- (void)setupAllChildViewController
{
    
    //   课程
    [self setUpOneChildViewController:[[ZYCateTableViewController alloc]init] image:@"bottom_tab1_unpre" selectedImage:@"bottom_tab1_pre" title:@"课程推荐" isHasNav:NO];
    
    //  我的
    [self setUpOneChildViewController: [[ZYMineViewController alloc]init] image:@"bottom_tab2_unpre" selectedImage:@"bottom_tab2_pre" title:@"我的推荐" isHasNav:YES];
    
    //  下载
    [self setUpOneChildViewController:[[ZYDownLoadViewController alloc]init] image:@"bottom_tab3_unpre" selectedImage:@"bottom_tab3_pre" title:@"离线下载" isHasNav:YES];
    
}

#pragma mark - 生命周期
- (void)viewDidLoad
{  [super viewDidLoad];
    
    //  设置子控制器并添加按钮的内容
    [self setupAllChildViewController];
    
    
}



@end
