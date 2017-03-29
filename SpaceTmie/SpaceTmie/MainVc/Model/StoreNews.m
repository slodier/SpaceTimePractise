//
//  StoreNews.m
//  离线数据
//
//  Created by CC on 2017/3/28.
//  Copyright © 2017年 CC. All rights reserved.
//

#import "StoreNews.h"

@interface StoreNews ()

@property (nonatomic, strong) FMDatabase *db;
@property (nonatomic, strong) NSFileManager *fileManager;

@end

@implementation StoreNews

- (instancetype)init {
    if (self = [super init]) {
        
        _fileManager = [NSFileManager defaultManager];
    }
    return self;
}

#pragma mark - 数据库路径
- (NSString *)filename {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
    return [path stringByAppendingString:@"news.db"];
}

#pragma mark - 检测本地文件是否存在
- (BOOL)isSqliteExist {

    if ([_fileManager fileExistsAtPath:[self filename]]) {
        NSLog(@"sqlite is exist");
        return YES;
    }else{
        NSLog(@"sqlite isn't exist, prepare to create");
        return NO;
    }
}

#pragma mark - 打开数据库
- (void)openDB
{
    _db = [FMDatabase databaseWithPath:[self filename]];
    NSLog(@"path:%@",[self filename]);
    
    if ([_db open]) {
        // 打开成功即建表
        BOOL result = [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS NewsInfo(id integer PRIMARY KEY AUTOINCREMENT, imgsrc text NOT NULL, title text NOT NULL, url text NOT NULL,source text NOT NULL, replyCount text NOT NULL)"];
        
        if (result) {
            NSLog(@"create table success");
        }else{
            NSLog(@"create table failed");
            [_db  close];
        }
    }else{
        [_db close];
        NSLog(@"open db failed");
    }
}

#pragma mark - 没有打开数据库就打开数据库
- (void)judgeDBIsOpen {
    if (![_db open]) {
        [self openDB];
    }
}

#pragma mark - 数据插进表
- (void)insertNews:(NewsModel *)newModel {
    [self judgeDBIsOpen];
    [_db executeUpdate:@"INSERT INTO NewsInfo(imgsrc, title, url, source, replyCount)Values(?,?,?,?,?)",newModel.imgStr, newModel.titleStr, newModel.urlStr, newModel.sourceStr, newModel.replyCount];
}

#pragma mark - 查询数据库
- (NSMutableArray *)selectTable {
    
    [self judgeDBIsOpen];
    NSMutableArray *sqliteArray = [NSMutableArray array];
    FMResultSet *resultSet = [_db executeQuery:@"select *from NewsInfo;"];
    while ([resultSet next]) {
        NewsModel *newsModel = [[NewsModel alloc]init];
        newsModel.imgStr     = [resultSet objectForColumnName:@"imgsrc"];
        newsModel.titleStr   = [resultSet objectForColumnName:@"title"];
        newsModel.urlStr     = [resultSet objectForColumnName:@"url"];
        newsModel.sourceStr  = [resultSet objectForColumnName:@"source"];
        newsModel.replyCount = [resultSet objectForColumnName:@"replyCount"];
        [sqliteArray addObject:newsModel];
    }
    [_db close];
    return sqliteArray;
}

#pragma mark - 删除数据库
- (BOOL)deleteSqlite {
    if ([self isSqliteExist]) {
        
        NSError *removeError;
        [_fileManager removeItemAtPath:[self filename] error:&removeError];
        if (removeError) {
            NSLog(@"delete sqlite failed");
        }else{
            NSLog(@"success delete sqlite");
        }
        return YES;
        
    }else{
        NSLog(@"sqlite isn't exist");
        return NO;
    }
}

@end
