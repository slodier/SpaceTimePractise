//
//  ChatCell.h
//  图灵 Test
//
//  Created by CC on 2017/4/14.
//  Copyright © 2017年 CC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatModel.h"

@interface ChatCell : UITableViewCell

@property (nonatomic, strong) UILabel *timeLabel;     // 时间
@property (nonatomic, strong) UILabel *contentLabel;  // 聊天内容
@property (nonatomic, strong) UILabel *robotLabel;    // 机器人回复的内容

@property (nonatomic, strong) UIImageView *chatView;    // 聊天内容
@property (nonatomic, strong) UIImageView *avatarView;  // 用户头像
@property (nonatomic, strong) UIImageView *autoView;    // 机器人头像

- (void)para:(ChatModel *)chatModel;

@end
