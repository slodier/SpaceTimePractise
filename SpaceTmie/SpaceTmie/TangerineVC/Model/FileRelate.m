//
//  FileRelate.m
//  SpaceTmie
//
//  Created by CC on 2017/3/29.
//  Copyright © 2017年 CC. All rights reserved.
//

#import "FileRelate.h"

@interface FileRelate ()

@property (nonatomic, strong) NSString *folderPath;

@property (nonatomic, strong) NSFileManager* manager;

@end

@implementation FileRelate

- (instancetype)init {
    if (self = [super init]) {
        _folderPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
        
        _manager = [NSFileManager defaultManager];

    }
    return self;
}

//通常用于删除缓存的时，计算缓存大小
//单个文件的大小
- (long long)fileSizeAtPath:(NSString*)filePath {
    if ([_manager fileExistsAtPath:filePath]){
        return [[_manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

//遍历文件夹获得文件夹大小，返回多少M
- (NSString *)folderSizeAtPath {

    if (![_manager fileExistsAtPath:_folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[_manager subpathsAtPath:_folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [_folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    NSLog(@"文件夹大小:%f M",folderSize/(1024.0*1024.0));
    NSString *fileSize = [NSString stringWithFormat:@"%.2f 兆",folderSize/(1024.0*1024.0)];
    return fileSize;
}

//
- (BOOL)deleteCacheFile {
    if ([_manager fileExistsAtPath:_folderPath]) {
        NSError *removeError;
        [_manager removeItemAtPath:_folderPath error:&removeError];
        if (removeError) {
            NSLog(@"cache remove failed:%@",removeError.localizedDescription);
            return NO;
        }else{
            NSLog(@"success remove cache");
            return YES;
        }
    }
    NSLog(@"isn't exist cache");
    return NO;
}
@end
