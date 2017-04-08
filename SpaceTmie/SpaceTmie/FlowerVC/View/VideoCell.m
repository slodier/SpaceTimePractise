
//
//  VideoCell.m
//  SpaceTmie
//
//  Created by CC on 2017/4/7.
//  Copyright © 2017年 CC. All rights reserved.
//

#import "VideoCell.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"

@implementation VideoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self layoutUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark - 赋值
- (void)para:(VideoModel *)videoModel {
    NSURL *url = [NSURL URLWithString:videoModel.cover];
    [_bgView sd_setImageWithURL:url];
    _titleLabel.text = videoModel.title;
    _descLabel.text = videoModel.topicDesc;
    _lengthLabel.text = videoModel.totalTime;
    _playCountLabel.text = videoModel.playCount;
    
    CGFloat labelW = [self reSizeLabel:_lengthLabel];
    [_lengthLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0.058 *KScreenWidth);
        make.top.equalTo(_timeImgView).offset(0.005 *KScreenHeight);
        make.size.mas_equalTo(CGSizeMake(labelW + 10, 0.015 *KScreenHeight));
    }];
 
    [_countImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0.063 *KScreenWidth + labelW);
        make.top.equalTo(_timeImgView);
        make.size.equalTo(_timeImgView);
    }];
    
    [_playCountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_countImgView).offset(0.05 *KScreenWidth);
        make.top.equalTo(_lengthLabel);
        make.size.mas_equalTo(CGSizeMake(0.068 *KScreenWidth, 0.026 *KScreenWidth));
    }];
}

#pragma mark - 计算文字宽度
- (CGFloat)reSizeLabel:(UILabel *)label {
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:label.text];
    NSRange range = {0,[attrStr length]};
    [attrStr addAttribute:NSFontAttributeName value:label.font range:range];
    CGSize attrSize = [attrStr boundingRectWithSize:CGSizeMake(MAXFLOAT, 200) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    return attrSize.width + 10;
}

#pragma mark - 构建 UI
- (void)layoutUI {
    _bgView = [[UIImageView alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self).offset(0.064 *KScreenHeight);
        make.size.mas_equalTo(CGSizeMake(KScreenHeight, 0.247 *KScreenHeight));
    }];
    _bgView.userInteractionEnabled = YES;
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0.013 *KScreenWidth);
        make.top.equalTo(self).offset(0.015 *KScreenWidth);
        make.right.equalTo(self).offset(0.013 *KScreenWidth);
        make.height.equalTo(@(0.015 *KScreenHeight));
    }];
    
    _descLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:_descLabel];
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel);
        make.top.equalTo(_titleLabel).offset(0.05 *KScreenWidth);
        make.right.equalTo(_titleLabel);
        make.height.equalTo(_titleLabel);
    }];
    _descLabel.font = [UIFont systemFontOfSize:13];
    
    _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_playBtn];
    [_playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0.414 *KScreenWidth);
        make.top.equalTo(self).offset(0.138 *KScreenHeight);
        make.size.mas_equalTo(CGSizeMake(0.171 *KScreenWidth, 0.096 *KScreenHeight));
    }];
    [_playBtn setImage:[UIImage imageNamed:@"video_play_btn_bg@2x"] forState:UIControlStateNormal];
    
    _timeImgView = [[UIImageView alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:_timeImgView];
    [_timeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0.01 *KScreenWidth);
        make.top.equalTo(self).offset(0.33 *KScreenHeight);
        make.size.mas_equalTo(CGSizeMake(0.0425 *KScreenWidth, 0.0425 *KScreenWidth));
    }];
    _timeImgView.image = [UIImage imageNamed:@"time"];
    
    _lengthLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:_lengthLabel];
    [_lengthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0.048 *KScreenWidth);
        make.top.equalTo(_timeImgView);
        make.size.mas_equalTo(CGSizeMake(0.056 *KScreenWidth, 0.015 *KScreenHeight));
    }];
    _lengthLabel.font = [UIFont systemFontOfSize:14];
    
    _countImgView = [[UIImageView alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:_countImgView];
    _countImgView.image = [UIImage imageNamed:@"playcount"];
    
    _playCountLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:_playCountLabel];
    _playCountLabel.font = _lengthLabel.font;
}

@end
