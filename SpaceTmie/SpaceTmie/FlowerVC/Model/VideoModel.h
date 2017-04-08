//
//  VideoModel.h
//  视频
//
//  Created by CC on 2017/4/7.
//  Copyright © 2017年 CC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface VideoModel : NSObject

@property (nonatomic, copy) NSString *urlStr; // 播放链接
@property (nonatomic, copy) NSString *title;  // 标题
@property (nonatomic, copy) NSString *topicDesc;  // 描述
@property (nonatomic, copy) NSString *totalTime;  // 总时长
@property (nonatomic, copy) NSString *playCount;  // 播放次数
@property (nonatomic, copy) NSString *cover;  // 占位图

- (NSMutableArray *)vedioData:(NSDictionary *)dict;

- (NSString *)timeFormatter:(NSString *)totalSeconds;

@end
