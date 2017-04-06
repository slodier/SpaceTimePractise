//
//  CycleImgModel.m
//  SpaceTmie
//
//  Created by CC on 2017/4/6.
//  Copyright © 2017年 CC. All rights reserved.
//

#import "CycleImgModel.h"

@interface CycleImgModel ()

@property (nonatomic, strong) FMDatabase *cycleDB;
@property (nonatomic, strong) NSFileManager *fileManager;

@end

@implementation CycleImgModel

- (instancetype)init {
    if (self = [super init]) {
        
        _fileManager = [NSFileManager defaultManager];
    }
    return self;
}

#pragma mark - 轮播图数据库路径
- (NSString *)filename {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
    return [path stringByAppendingString:@"cycleImg.db"];
}

#pragma mark - 检测本地文件是否存在
- (BOOL)isSqliteExist {
    
    if ([_fileManager fileExistsAtPath:[self filename]]) {
        NSLog(@"cycleImg.db is exist");
        return YES;
    }else{
        NSLog(@"cycleImg.db isn't exist, prepare to create");
        return NO;
    }
}

#pragma mark - 打开数据库
- (void)openDB
{
    _cycleDB = [FMDatabase databaseWithPath:[self filename]];
    NSLog(@"cycleDBPath:%@",[self filename]);
    
    if ([_cycleDB open]) {
        // 打开成功即建表
        BOOL result = [_cycleDB executeUpdate:@"CREATE TABLE IF NOT EXISTS ImageData(id integer PRIMARY KEY AUTOINCREMENT, imgsrc text NOT NULL, title text NOT NULL)"];
        
        if (result) {
            NSLog(@"create ImageData success");
        }else{
            NSLog(@"create ImageData failed");
            [_cycleDB  close];
        }
    }else{
        [_cycleDB close];
        NSLog(@"open cycleDB failed");
    }
}

#pragma mark - 没有打开数据库就打开数据库
- (void)judgeDBIsOpen {
    if (![_cycleDB open]) {
        [self openDB];
    }
}

#pragma mark - 数据插进表
- (void)insertImageData:(CyslePicture *)cyslePicture {
    [self judgeDBIsOpen];
    [_cycleDB executeUpdate:@"INSERT INTO ImageData(imgsrc, title)Values(?,?)", cyslePicture.imgSrc, cyslePicture.title];
}

#pragma mark - 查询轮播表
- (NSMutableArray *)selectImageData {
    [self judgeDBIsOpen];
    NSMutableArray *sqliteArray = [NSMutableArray array];
    NSMutableArray *imgsrcArray = [NSMutableArray array];
    NSMutableArray *titleArray  = [NSMutableArray array];
    
    FMResultSet *resultSet = [_cycleDB executeQuery:@"select *from ImageData;"];
    while ([resultSet next]) {
        
        NSString *imgSrc = [resultSet objectForColumnName:@"imgsrc"];
        NSString *title  = [resultSet objectForColumnName:@"title"];
        
        [imgsrcArray addObject:imgSrc];
        [titleArray addObject:title];
        
        [sqliteArray addObject:imgsrcArray];
        [sqliteArray addObject:titleArray];
    }
    [_cycleDB close];
    return sqliteArray;
}

#pragma mark - 删除数据库
- (BOOL)deleteCycleImg {
    if ([self isSqliteExist]) {
        
        NSError *removeError;
        [_fileManager removeItemAtPath:[self filename] error:&removeError];
        if (removeError) {
            NSLog(@"delete CycleImg failed:%@",removeError.localizedDescription);
        }else{
            NSLog(@"success delete CycleImg");
        }
        return YES;
        
    }else{
        NSLog(@"CycleImg isn't exist");
        return NO;
    }
}

@end
