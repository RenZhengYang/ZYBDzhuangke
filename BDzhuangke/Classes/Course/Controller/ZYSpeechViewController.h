//
//  ZYSpeechViewController.h
//  BaiSIJie
//
//  Created by mac on 16/9/8.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iflyMSC/iflyMSC.h"
@interface ZYSpeechViewController : UIViewController<IFlyRecognizerViewDelegate>
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UITableView *tableView;


@property (nonatomic, strong) IFlyRecognizerView *iflyRecognizerView;//带界面的识别对象
@end
