//
//  StoreNews.h
//  离线数据
//
//  Created by CC on 2017/3/28.
//  Copyright © 2017年 CC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "NewsModel.h"

@interface StoreNews : NSObject

#pragma mark - 数据插进表
- (void)insertNews:(NewsModel *)newModel;

#pragma mark - 查询数据库
- (NSMutableArray *)selectTable;

#pragma mark - 删除数据库
- (BOOL)deleteSqlite;

@end
