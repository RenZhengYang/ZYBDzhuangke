//
//  AppDelegate.m
//  BDzhuangke
//
//  Created by mac on 16/9/8.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "AppDelegate.h"
#import "ZYTabBarVc.h"
#import "JSRegisterManager.h"

#import "iflyMSC/iflyMSC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    ZYTabBarVc *tabBarVc = [[ZYTabBarVc alloc]init];
    
   self.window.rootViewController = tabBarVc;
    
    [self.window makeKeyAndVisible];
    
    
    
    JSRegisterManager *registerManager = [[JSRegisterManager alloc] init];
    [registerManager finishLaunchOption:launchOptions];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //科大讯飞语音初始化
        //创建语音配置,appid必须要传入，仅执行一次则可
        NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",@" 57dc01e8"];
        
        //所有服务启动前，需要确保执行createUtility
        [IFlySpeechUtility createUtility:initString];
    });


    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
