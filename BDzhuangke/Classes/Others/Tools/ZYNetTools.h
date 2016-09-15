//
//  ZYNetTools.h
//  BDzhuangke
//
//  Created by mac on 16/9/9.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SuccessBlock)(id responseBody);
typedef void (^FailureBlock)(NSString *error);

@interface ZYNetTools : NSObject
/**网络工具类*/
+ (ZYNetTools *)sharedManager;
/**基本请求*/
- (AFHTTPSessionManager *)baseHttpsResquest;

#pragma mark - 推荐课程

#pragma mark- 获取推荐课程内容
- (void)getRecommendCourseResult:(NSDictionary *)userInfo url:(NSString *)url successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

#pragma mark - 获取课程详情
-(void)getClassListResult:(NSDictionary *)userInfo url:(NSString *)url successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

#pragma mark - 获取课程评价
-(void)getClassEvalResult:(NSDictionary *)userInfo url:(NSString *)url successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

#pragma mark - Get
-(void)getDataResult:(NSDictionary *)userInfo url:(NSString *)url successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

#pragma mark - 获取搜索课程信息
-(void)getSearchResult:(NSDictionary *)userInfo url:(NSString *)url successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

@end
