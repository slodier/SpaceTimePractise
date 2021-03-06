//
//  CCUserDefaults.m
//  打开手机相册
//
//  Created by CC on 2017/3/19.
//  Copyright © 2017年 CC. All rights reserved.
//

#import "CCUserDefaults.h"

@implementation CCUserDefaults

static NSString *userIcon = @"userIcon";
static NSString *pushed = @"pushed";

+ (NSUserDefaults *)defaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return defaults;
}

#pragma mark - 判断是否 push
+ (void)saveValueWhenPush {
    [[self defaults]setObject:@"1" forKey:pushed];
    [[self defaults]synchronize];
}

+ (BOOL)isPush {
    NSString *pushStr = [[self defaults]objectForKey:pushed];
    if (pushStr.intValue == 1) {
        return YES;
    }
    return NO;
}

#pragma mark - 保存图片到本地
+ (void)saveImage:(UIImage *)image {
    NSData *imageData = UIImageJPEGRepresentation( image , 100);
    [[self defaults]setObject:imageData forKey:userIcon];
    [[self defaults]synchronize];
}

#pragma mark - 加载本地数据
+ (UIImage *)loadLocalData {
    NSData *imageData = [[self defaults]objectForKey:userIcon];
    UIImage *image = [UIImage imageWithData:imageData];
    return image;
}

#pragma mark - 判断本地有无数据
+ (BOOL)isLocalExistImage {
    NSData *imageData = [[self defaults]objectForKey:userIcon];
    if (!imageData) {
        return NO;
    }
    UIImage *image = [UIImage imageWithData:imageData];
    if (!image) {
        return NO;
    }
    return YES;
}

@end
