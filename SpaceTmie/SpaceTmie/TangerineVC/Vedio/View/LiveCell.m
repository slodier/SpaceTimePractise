//
//  LiveCell.m
//  SpaceTmie
//
//  Created by CC on 2017/7/21.
//  Copyright © 2017年 CC. All rights reserved.
//

#import "LiveCell.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"

@interface LiveCell ()

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) UILabel *nameLaebel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *numpeoLabel;
@property (nonatomic, strong) UILabel *liveLabel;

@end

@implementation LiveCell

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]){
        [self layoutUI];
    }
    return self;
}

#pragma mark - 处理
- (void)setLiveItem:(LiveItem *)liveItem
{
    _liveItem = liveItem;
    //NSString *imageStr = [NSString stringWithFormat:@"http://img.meelive.cn%@", liveItem.creatorIcon];
    NSString *imageStr = liveItem.creatorIcon;
    NSURL *imageUrl = [NSURL URLWithString:imageStr];
    [_headImageView sd_setImageWithURL:imageUrl placeholderImage:nil options:SDWebImageProgressiveDownload];
    
    if(liveItem.city.length == 0){
        _addressLabel.text = @"寻找城市中";
    }else{
        _addressLabel.text = liveItem.city;
    }
    
    _nameLaebel.text = liveItem.creatorNick;
    [_bgImageView sd_setImageWithURL:imageUrl];
    
    // 设置当前观众数量
    NSString *fullWatchor = [NSString stringWithFormat:@"当前观众数量:%@", liveItem.online_users];
    NSRange range = {7, fullWatchor.length - 7};
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:fullWatchor];
    [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range: range];
    [attr addAttribute:NSForegroundColorAttributeName value:KColorWithRGB(216, 41, 116) range:range];
    self.numpeoLabel.attributedText = attr;
}

#pragma mark - UI
- (void)layoutUI {
    _headImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    [self addSubview:_headImageView];
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0.013 *KScreenWidth);
        make.top.equalTo(self).offset(0.013 *KScreenWidth);
        make.size.mas_equalTo(CGSizeMake(0.1 *KScreenWidth, 0.1 *KScreenWidth));
    }];
    
    _nameLaebel = [[UILabel alloc]initWithFrame:CGRectZero];
    [self addSubview:_nameLaebel];
    [_nameLaebel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headImageView);
        make.left.equalTo(_headImageView).offset(0.11 *KScreenWidth);
        make.size.mas_equalTo(CGSizeMake(0.42 *KScreenWidth, 0.03 *KScreenHeight));
    }];
    
    _addressLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    [self addSubview:_addressLabel];
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameLaebel).offset(0.031 *KScreenHeight);
        make.left.equalTo(_nameLaebel);
        make.size.equalTo(_nameLaebel);
    }];
    
    _numpeoLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    [self addSubview:_numpeoLabel];
    [_numpeoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_addressLabel).offset(0.031 *KScreenHeight);
        make.left.equalTo(_headImageView);
        make.size.equalTo(_nameLaebel);
    }];
    
    _bgImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    [self addSubview:_bgImageView];
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_numpeoLabel).offset(0.031 *KScreenHeight);
        make.left.equalTo(_headImageView);
        make.size.mas_equalTo(CGSizeMake(KScreenWidth *0.37, 0.37 *KScreenWidth));
    }];
    
    _headImageView.layer.cornerRadius = 5;
    _headImageView.layer.masksToBounds = YES;
    
    _liveLabel.layer.cornerRadius = 5;
    _liveLabel.layer.masksToBounds = YES;
    
    _nameLaebel.font = [UIFont systemFontOfSize:12];
    _addressLabel.font = _numpeoLabel.font = _nameLaebel.font;
    
}

@end
