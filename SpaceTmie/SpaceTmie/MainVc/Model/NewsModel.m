//
//  NewsModel.m
//  Video
//
//  Created by CC on 2017/3/25.
//  Copyright © 2017年 CC. All rights reserved.
//

#import "NewsModel.h"
#import "TrangerModel.h"
#import "StoreNews.h"

@implementation NewsModel

- (void)newsData:(NSDictionary *)dict
      dataSource:(NSMutableArray *)dataSource
{
    NSArray *array = dict[@"T1348647853363"];
    for (NSDictionary *dii in array) {
        NewsModel *newModel = [[NewsModel alloc]init];
        newModel.imgStr     = JsonStr(dii[@"imgsrc"]);
        newModel.titleStr   = JsonStr(dii[@"title"]);
        newModel.urlStr     = JsonStr(dii[@"url"]);
        newModel.sourceStr  = JsonStr(dii[@"source"]);
        newModel.replyCount = JsonStr(dii[@"replyCount"]);
        [dataSource addObject:newModel];
    }
    
    // 每次只执行一次,将数据存进数据库
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        StoreNews *storeNew = [[StoreNews alloc]init];
        [storeNew deleteSqlite];
        for (int i = 0; i < dataSource.count; i++) {
            NewsModel *newModel = dataSource[i];
            [storeNew insertNews:newModel];
        }
    });
}

@end
