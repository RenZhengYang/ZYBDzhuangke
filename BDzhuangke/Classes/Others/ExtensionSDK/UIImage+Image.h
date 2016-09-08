//
//  UIImage+Image.h
//  BaiSIJie
//
//  Created by mac on 16/8/12.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Image)
/**传进一个图片名称，返回一个去掉渲染的图片*/
+ (UIImage *)imageOriginalWith:(NSString *)imageName;
@end
