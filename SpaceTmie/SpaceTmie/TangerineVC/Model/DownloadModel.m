//
//  DownloadModel.m
//  SpaceTmie
//
//  Created by CC on 2016/12/16.
//  Copyright © 2016年 CC. All rights reserved.
//

#import "DownloadModel.h"
#import "ConstStr.h"

@interface DownloadModel ()

@property (nonatomic, strong) NSFileManager *manager;

@end

@implementation DownloadModel

- (instancetype)init {
    if (self = [super init]) {
        _manager = [NSFileManager defaultManager];
    }
    return self;
}

- (NSString *)fileName {

    return [downloadStr lastPathComponent];
}

- (NSString *)downloadFile {
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
    NSString *savePath = [cachePath stringByAppendingPathComponent:[self fileName]];
    NSLog(@"savaPath:%@",savePath);
    return savePath;
}

#pragma mark - 目录是否存在
- (BOOL)isExistFile {
    if ([_manager fileExistsAtPath:[self downloadFile]]) {
        return YES;
    }else{
        return NO;
    }
    return NO;
}

#pragma mark - 删除下载文件
- (BOOL)deleteDownloadFile {
    if ([self isExistFile]) {
        NSError *error;
        [_manager removeItemAtPath:[self downloadFile] error:&error];
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

- (NSData *)seleteTempData {
    NSString *tempPath = NSTemporaryDirectory();
    NSArray *array = [_manager contentsOfDirectoryAtPath:tempPath error:nil];
    if (array.count > 0) {
        for (int i = 0; i < array.count; i++) {
            if ([array[i] hasSuffix:@"tmp"]) {
                NSString *filename = [tempPath stringByAppendingPathComponent:array[i]];
                NSData *tempData = [NSData dataWithContentsOfFile:filename];
                //NSLog(@"临时 Data%@",tempData);
                return tempData;
            }
        }
    }
    return nil;
}

#pragma mark - 删除下载的临时目录
- (BOOL)removeTempFile:(NSURL *)tempUrl {
    NSString *tempStr = [tempUrl absoluteString];
    BOOL isTempFile = [_manager fileExistsAtPath:tempStr];
    if (isTempFile) {
        NSError *removeError;
        [_manager removeItemAtPath:tempStr error:&removeError];
        if (removeError) {
            NSLog(@"temp removed failed");
            return  NO;
        }else{
            NSLog(@"temp removed successed");
            return YES;
        }
    }else{
        NSLog(@"temp isn't exists");
        return NO;
    }
    return NO;
}

@end
