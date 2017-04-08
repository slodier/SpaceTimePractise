//
//  VideoModel.m
//  视频
//
//  Created by CC on 2017/4/7.
//  Copyright © 2017年 CC. All rights reserved.
//

#import "VideoModel.h"
#import "TrangerModel.h"

#define JsonStr(value) [TrangerModel toStringValue:(value)]

@implementation VideoModel

- (NSMutableArray *)vedioData:(NSDictionary *)dict {
    
    NSMutableArray *tempArray = [NSMutableArray array];
    
    NSArray *vedioArray = dict[@"videoList"];
    for (NSDictionary *dii in vedioArray) {
        VideoModel *videoModel = [[VideoModel alloc]init];
        videoModel.urlStr = JsonStr(dii[@"mp4_url"]);
        videoModel.topicDesc = JsonStr(dii[@"topicDesc"]);
        videoModel.cover = JsonStr(dii[@"cover"]);
        videoModel.title = JsonStr(dii[@"title"]);
        videoModel.totalTime = [self timeFormatter:JsonStr(dii[@"length"])];
        videoModel.playCount = JsonStr(dii[@"playCount"]);
        [tempArray addObject:videoModel];
    }
    NSLog(@"dataSource:%@",tempArray);
    return tempArray;
}

- (NSString *)timeFormatter:(NSString *)time {

    int totalSeconds = time.intValue;
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
    if (minutes == 0 && hours == 0) {
        return [NSString stringWithFormat:@"%02d秒", seconds];
    }else if (hours == 0 && minutes > 0){
        return [NSString stringWithFormat:@"%01d:%02d", minutes, seconds];
    }else{
        return [NSString stringWithFormat:@"%01d:%02d:%02d",hours, minutes, seconds];
    }
}

@end
