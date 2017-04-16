//
//  ChatCell.m
//  图灵 Test
//
//  Created by CC on 2017/4/14.
//  Copyright © 2017年 CC. All rights reserved.
//

#import "ChatCell.h"
#import "Masonry.h"
#import "Calculation.h"

@interface ChatCell ()

@property (nonatomic, strong) Calculation *calculation;

@end

@implementation ChatCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self layoutUI];
        _calculation = [[Calculation alloc]init];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark - 自己和机器人的 cell 样式不同
- (void)para:(ChatModel *)chatModel {
    if (chatModel.isFromSelf) {
        _autoView.hidden = YES;
        _avatarView.hidden = NO;
        _robotLabel.hidden = YES;
        _contentLabel.hidden = NO;
        
        _contentLabel.text = chatModel.content;
        _timeLabel.text = chatModel.time;
        [_contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_avatarView);
            make.right.equalTo(_avatarView).offset(- 0.09 *KScreenHeight);
            make.size.mas_equalTo(CGSizeMake(chatModel.labelSize.width + 1, chatModel.labelSize.height));
        }];
    }else{
        _autoView.hidden = NO;
        _avatarView.hidden = YES;
        _contentLabel.hidden = YES;
        _robotLabel.hidden = NO;
        
        _robotLabel.text = chatModel.content;
        _timeLabel.text = chatModel.time;
        [_robotLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_autoView);
            make.left.equalTo(_autoView).offset(0.09 *KScreenHeight);
            make.size.mas_equalTo(CGSizeMake(chatModel.labelSize.width + 1, chatModel.labelSize.height + 17));
        }];
    }
}

#pragma mark - 构建 UI 
- (void)layoutUI {

    _timeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    [self addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0.45 *KScreenWidth);
        make.top.equalTo(self).offset(0.015 *KScreenHeight);
        make.size.mas_equalTo(CGSizeMake(0.1 *KScreenWidth, 0.015 *KScreenHeight));
    }];
    _timeLabel.font = [UIFont systemFontOfSize:10];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    
    _avatarView = [[UIImageView alloc]initWithFrame:CGRectZero];
    [self addSubview:_avatarView];
    [_avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(- 0.02 *KScreenWidth);
        make.top.equalTo(_timeLabel).offset(0.03 *KScreenHeight);
        make.size.mas_equalTo(CGSizeMake(0.06 *KScreenHeight, 0.06 *KScreenHeight));
    }];
    _avatarView.image = [UIImage imageNamed:@"mario.jpeg"];
    
    _autoView = [[UIImageView alloc]initWithFrame:CGRectZero];
    [self addSubview:_autoView];
    [_autoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0.02 *KScreenWidth);
        make.top.equalTo(_avatarView);
        make.size.mas_equalTo(_avatarView);
    }];
    _autoView.image = [UIImage imageNamed:@"robot"];
    
    _contentLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    [self addSubview:_contentLabel];
    _contentLabel.backgroundColor = [UIColor cyanColor];
    _contentLabel.numberOfLines = 0;
    _contentLabel.font = [UIFont systemFontOfSize:13];
    
    _robotLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    [self addSubview:_robotLabel];
    _robotLabel.backgroundColor = [UIColor cyanColor];
    _robotLabel.numberOfLines = 0;
    _robotLabel.font = [UIFont systemFontOfSize:13];
}

@end
