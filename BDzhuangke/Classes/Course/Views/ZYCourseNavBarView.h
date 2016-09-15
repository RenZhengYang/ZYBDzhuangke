//
//  ZYCourseNavBarView.h
//  BDzhuangke
//
//  Created by mac on 16/9/8.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYCourseNavBarView : UIView

/**登录Btn*/
@property(copy,nonatomic)void(^CallBackNameBtn)();
/**搜索Btn*/
@property(copy,nonatomic)void(^CallBackSearchBtn)();
@property(copy,nonatomic)void(^leftSegmentCtr)();
@property(copy,nonatomic)void(^rightSegmentCtr)();

/**分段按钮*/
@property(strong,nonatomic)UISegmentedControl *segmentCtr;

@end
