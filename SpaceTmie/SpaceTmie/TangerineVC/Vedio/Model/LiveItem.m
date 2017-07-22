//
//  LiveItem.m
//  SpaceTmie
//
//  Created by CC on 2017/7/21.
//  Copyright © 2017年 CC. All rights reserved.
//

#import "LiveItem.h"

@implementation LiveItem

+ (void)getDataFrom:(id)response into:(NSMutableArray *)dataSource
{
    NSMutableArray *liveArray = response[@"lives"];
    for (NSDictionary *dii in liveArray) {
        LiveItem *liveItem = [[LiveItem alloc]init];
        liveItem.city = JsonStr(dii[@"city"]);
        liveItem.stream_addr = JsonStr(dii[@"stream_addr"]);
        liveItem.online_users = JsonStr(dii[@"online_users"]);
        liveItem.creatorIcon = JsonStr(dii[@"creator"][@"portrait"]);
        liveItem.creatorNick = JsonStr(dii[@"creator"][@"nick"]);
        // 判断图片 url 是否有误
        if (![liveItem.creatorIcon containsString:@"img2.inke.cn"]) {
            liveItem.creatorIcon = [NSString stringWithFormat:@"http://img2.inke.cn/%@", liveItem.creatorIcon];
        }
        
        [dataSource addObject:liveItem];
        if(dataSource.count >= 20){
            break;
        }
    }
}

// 加载后二十条数据
+ (void)addDataFrom:(id)response into:(NSMutableArray *)dataSource from:(int)from end:(int)end
{
    if (end >= 200) {
        return;
    }
    NSMutableArray *liveArray = response[@"lives"];
    NSMutableArray *tempArray = [[NSMutableArray alloc]init];
    for (int i = from; i < end; i++) {
        id obj = liveArray[i];
        [tempArray addObject:obj];
    }
    for (NSDictionary *dii in tempArray) {
        LiveItem *liveItem = [[LiveItem alloc]init];
        liveItem.city = JsonStr(dii[@"city"]);
        liveItem.stream_addr = JsonStr(dii[@"stream_addr"]);
        liveItem.online_users = JsonStr(dii[@"online_users"]);
        liveItem.creatorIcon = JsonStr(dii[@"creator"][@"portrait"]);
        liveItem.creatorNick = JsonStr(dii[@"creator"][@"nick"]);
        // 判断图片 url 是否有误
        if (![liveItem.creatorIcon containsString:@"img2.inke.cn"]) {
            liveItem.creatorIcon = [NSString stringWithFormat:@"http://img2.inke.cn/%@", liveItem.creatorIcon];
        }
        
        [dataSource addObject:liveItem];
        if(dataSource.count >= end){
            break;
        }
    }
    
}

@end
