//
//  ZYCourseDetailInfoCell.h
//  BDzhuangke
//
//  Created by mac on 16/9/10.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JZCourseDetailModel.h"
@protocol JZCourseDetailInfoDelegate <NSObject>

@optional
-(void)didSelectedSchool;

@end

@interface ZYCourseDetailInfoCell : UITableViewCell

@property(nonatomic, strong) JZCourseDetailModel *jzCourseDM;/**< 数据 */

@property(nonatomic, assign) id<JZCourseDetailInfoDelegate> delegate;

@end
