//
//  VideoCell.h
//  SpaceTmie
//
//  Created by CC on 2017/4/7.
//  Copyright © 2017年 CC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoModel.h"

@interface VideoCell : UITableViewCell

@property (nonatomic, strong) UIButton *playBtn; // 播放按钮

@property (nonatomic, strong) UIImageView *bgView; // 背景图层
@property (nonatomic, strong) UIImageView *timeImgView; // 时长
@property (nonatomic, strong) UIImageView *countImgView; // 播放次数图片

@property (nonatomic, strong) UILabel *titleLabel; // 标题
@property (nonatomic, strong) UILabel *descLabel;  // 描述
@property (nonatomic, strong) UILabel *lengthLabel; // 长度
@property (nonatomic, strong) UILabel *playCountLabel; // 播放次数

- (void)para:(VideoModel *)videoModel;

@end
