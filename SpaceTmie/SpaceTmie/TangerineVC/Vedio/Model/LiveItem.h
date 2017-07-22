//
//  LiveItem.h
//  SpaceTmie
//
//  Created by CC on 2017/7/21.
//  Copyright © 2017年 CC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LiveItem : NSObject

@property (nonatomic, copy) NSString *stream_addr;  // 直播流地址
@property (nonatomic, copy) NSString *online_users;  // 在线用户
@property (nonatomic, copy) NSString *city;  // 城市
@property (nonatomic, copy) NSString *creatorIcon;  // 主播头像
@property (nonatomic, copy) NSString *creatorNick;  // 主播昵称

@property (nonatomic, assign) int dataLength;

+ (void)getDataFrom:(id)response into:(NSMutableArray *)dataSource;

// 加载数据
+ (void)addDataFrom:(id)response into:(NSMutableArray *)dataSource from:(int)from end:(int)end;

@end
