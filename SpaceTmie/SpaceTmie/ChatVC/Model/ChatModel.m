//
//  ChatModel.m
//  图灵 Test
//
//  Created by CC on 2017/4/15.
//  Copyright © 2017年 CC. All rights reserved.
//

#import "ChatModel.h"
#import "Calculation.h"

@interface ChatModel ()

@property (nonatomic, strong) Calculation *calculation;

@end

@implementation ChatModel

- (instancetype)init {
    if (self = [super init]) {
        _calculation = [[Calculation alloc]init];
    }
    return self;
}

- (void)newData:(NSString *)content
            isFromSelf:(BOOL)isFromSelf
     dataSource:(NSMutableArray *)dataSource
{
    ChatModel *chatModel = [[ChatModel alloc]init];
    chatModel.time = [self dateNow];
    chatModel.content = content;
    chatModel.isFromSelf = isFromSelf;
    chatModel.labelSize = [_calculation calculationSize:content];
    [dataSource addObject:chatModel];
}

- (NSString *)dateNow {
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    //24小时制
    [formatter setDateFormat:@"HH:mm"];
    NSString *str = [formatter stringFromDate:date];
    return str;
}

@end
