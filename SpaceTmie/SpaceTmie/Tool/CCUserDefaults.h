//
//  CCUserDefaults.h
//  打开手机相册
//
//  Created by CC on 2017/3/19.
//  Copyright © 2017年 CC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CCUserDefaults : NSObject

#pragma mark - 保存图片到本地
+ (void)saveImage:(UIImage *)image;

#pragma mark - 读取本地图片
+ (UIImage *)loadLocalData;

#pragma maek - 判断本地有无数据
+ (BOOL)isLocalExistImage;

@end
