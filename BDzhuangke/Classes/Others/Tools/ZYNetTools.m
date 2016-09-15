//
//  ZYNetTools.m
//  BDzhuangke
//
//  Created by mac on 16/9/9.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "ZYNetTools.h"

// 请求超时
#define TIMEOUT 30


@implementation ZYNetTools
/**网络工具类*/
+ (ZYNetTools *)sharedManager
{
    static ZYNetTools *token = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        token = [[self alloc]init];
    });
    return token;
}
/**基本请求*/
- (AFHTTPSessionManager *)baseHttpsResquest
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;  //   设置超时时间（请求参数设置）
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"text/html", @"application/json", nil];  //   请求的类型

    return manager;
}
#pragma mark - 获取推荐课程内容
-(void)getRecommendCourseResult:(NSDictionary *)userInfo url:(NSString *)url successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock
{
   AFHTTPSessionManager *manager = [self baseHttpsResquest];
    NSString *urlStr  = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]; //  url编码
    [manager GET:urlStr parameters:userInfo progress:nil
        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //  成功回调
            successBlock(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           //  失败回调
            NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];  //  打印错误信息
            failureBlock(errorStr);
        }];
}

#pragma mark - 获取课程详情
-(void)getClassListResult:(NSDictionary *)userInfo url:(NSString *)url successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock
{

    AFHTTPSessionManager *manager = [self baseHttpsResquest];
    NSString *urlStr  = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]; //  url编码
    [manager GET:urlStr parameters:userInfo progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             //  成功回调
             successBlock(responseObject);
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             //  失败回调
             NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];  //  打印错误信息
             failureBlock(errorStr);
         }];
}

#pragma mark - 获取课程评价
-(void)getClassEvalResult:(NSDictionary *)userInfo url:(NSString *)url successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock
{
    AFHTTPSessionManager *manager = [self baseHttpsResquest];
    NSString *urlStr  = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]; //  url编码
    [manager GET:urlStr parameters:userInfo progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             //  成功回调
             successBlock(responseObject);
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             //  失败回调
             NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];  //  打印错误信息
             failureBlock(errorStr);
         }];

}

#pragma mark - Get
-(void)getDataResult:(NSDictionary *)userInfo url:(NSString *)url successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{

    AFHTTPSessionManager *manager = [self baseHttpsResquest];
    NSString *urlStr  = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]; //  url编码
    [manager GET:urlStr parameters:userInfo progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             //  成功回调
             successBlock(responseObject);
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             //  失败回调
             NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];  //  打印错误信息
             failureBlock(errorStr);
         }];

    }

#pragma mark - 获取搜索课程信息
-(void)getSearchResult:(NSDictionary *)userInfo url:(NSString *)url successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock
{
    AFHTTPSessionManager *manager = [self baseHttpsResquest];
    NSString *urlStr  = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]; //  url编码
    [manager GET:urlStr parameters:userInfo progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             //  成功回调
             successBlock(responseObject);
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             //  失败回调
             NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];  //  打印错误信息
             failureBlock(errorStr);
         }];
    



}

@end
