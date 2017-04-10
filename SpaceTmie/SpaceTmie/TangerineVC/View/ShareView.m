//
//  ShareView.m
//  SpaceTmie
//
//  Created by CC on 2017/3/20.
//  Copyright © 2017年 CC. All rights reserved.
//

#import "ShareView.h"
#import "Masonry.h"
#import "ShareModel.h"
#import "UIView+Animations.h"

@interface ShareView ()

@property (nonatomic, strong) UIView *bgView;  // 背景视图

@property (nonatomic, strong) UIButton *wxFriendBtn;  // WX 好友分享
@property (nonatomic, strong) UIButton *wxZoneBtn;    // WX 朋友圈分享
@property (nonatomic, strong) UIButton *qqShareBtn;   // QQ 分享

@property (nonatomic, strong) ShareModel *shareModel;

@end

@implementation ShareView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _shareModel = [[ShareModel alloc]init];
        _shareModel.thumbImageStr = @"share_thumb";
        [self layoutUI];
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    }
    return self;
}

#pragma mark - 按钮点击事件
- (void)wxFriendClick {
    [_shareModel textWXShare:0];
}

- (void)wxZoneClick {
    [_shareModel textWXShare:1];
}

- (void)qqClick {
    [_shareModel qqShare:YES];
}

#pragma mark - 构建 UI
- (void)layoutUI {
    
    _bgView = [[UIView alloc]initWithFrame:CGRectZero];
    [self addSubview:_bgView];
    _bgView.backgroundColor = [UIColor whiteColor];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self).offset(2 *KScreenHeight / 3);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
    }];

    _wxFriendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bgView addSubview:_wxFriendBtn];
    [_wxFriendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bgView).offset(0.145 *KScreenWidth);
        make.top.equalTo(_bgView).offset(0.1 *KScreenWidth);
        make.size.mas_equalTo(CGSizeMake(0.14 *KScreenWidth, 0.14 *KScreenWidth));
    }];
    [_wxFriendBtn setImage:[UIImage imageNamed:@"wechat_friend"] forState:UIControlStateNormal];
    
    _wxZoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bgView addSubview:_wxZoneBtn];
    [_wxZoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_wxFriendBtn).offset(0.285 *KScreenWidth);
        make.top.equalTo(_wxFriendBtn);
        make.size.mas_equalTo(_wxFriendBtn);
    }];
    [_wxZoneBtn setImage:[UIImage imageNamed:@"wechat_zone"] forState:UIControlStateNormal];
    
    _qqShareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bgView addSubview:_qqShareBtn];
    [_qqShareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_wxZoneBtn).offset(0.285 *KScreenWidth);
        make.top.equalTo(_wxZoneBtn);
        make.size.mas_equalTo(_wxFriendBtn);
    }];
    [_qqShareBtn setImage:[UIImage imageNamed:@"qq"] forState:UIControlStateNormal];
    
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bgView addSubview:_cancelBtn];
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bgView).offset(0.43 *KScreenWidth);
        make.bottom.equalTo(_bgView).offset(- 0.06 *KScreenHeight);
        make.size.mas_equalTo(CGSizeMake(0.2 *KScreenWidth, 0.2 *KScreenWidth));
    }];
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [_wxFriendBtn addTarget:self action:@selector(wxFriendClick) forControlEvents:UIControlEventTouchUpInside];
    [_wxZoneBtn addTarget:self action:@selector(wxZoneClick) forControlEvents:UIControlEventTouchUpInside];
    [_qqShareBtn addTarget:self action:@selector(qqClick) forControlEvents:UIControlEventTouchUpInside];
}

@end
