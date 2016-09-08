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
/**分段按钮的左边---精彩推荐*/
@property(copy,nonatomic)void(^leftSegmentCtr)();
/**分段按钮的右边---课程分类*/
@property(copy,nonatomic)void(^rightSegmentCtr)();
@end
