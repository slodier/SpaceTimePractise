//
//  DownloadModel.m
//  SpaceTmie
//
//  Created by CC on 2016/12/16.
//  Copyright © 2016年 CC. All rights reserved.
//

#import "DownloadModel.h"

@interface DownloadModel ()


@end

@implementation DownloadModel

- (NSString *)fileName {
    NSString *str = @"http://dldir1.qq.com/qqfile/qq/QQ7.6/15742/QQ7.6.exe";
    return [str lastPathComponent];
}

- (NSString *)downloadFile {
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
    NSString *savePath = [cachePath stringByAppendingPathComponent:[self fileName]];
    NSLog(@"savaPath:%@",savePath);
    return savePath;
}

- (BOOL)isExistFile {
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:[self downloadFile]]) {
        return YES;
    }else{
        return NO;
    }
    return NO;
}

- (BOOL)deleteDownloadFile {
    if ([self isExistFile]) {
        NSFileManager *manager = [NSFileManager defaultManager];

        NSError *error;
        [manager removeItemAtPath:[self downloadFile] error:&error];
        if (error) {
            NSLog(@"remove download file failed");
            return NO;
        }else{
            NSLog(@"success remove download file");
            return YES;
        }
    }
    return NO;
}

@end
