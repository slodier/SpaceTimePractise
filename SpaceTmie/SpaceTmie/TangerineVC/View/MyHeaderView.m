//
//  MyHeaderView.m
//  SpaceTmie
//
//  Created by CC on 2017/3/16.
//  Copyright © 2017年 CC. All rights reserved.
//

#import "MyHeaderView.h"
#import "Masonry.h"

@implementation MyHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self layoutUI];
    }
    return self;
}

#pragma mark - 构建 UI
- (void)layoutUI {
    _avatarView = [[UIImageView alloc]initWithFrame:CGRectZero];
    [self addSubview:_avatarView];
    [_avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0.05 *KScreenWidth);
        make.top.equalTo(self).offset(0.05 *KScreenWidth);
        make.size.mas_equalTo(CGSizeMake(0.2 *KScreenWidth, 0.2 *KScreenWidth));
    }];
    
    _nameLabel = [[UILabel alloc]init];
    [self addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_avatarView).offset(0.3 *KScreenWidth);
        make.top.equalTo(_avatarView);
        make.size.mas_equalTo(CGSizeMake(0.6 *KScreenWidth, 0.04 *KScreenWidth));
    }];
    
    _descriLabel = [[UILabel alloc]init];
    [self addSubview:_descriLabel];
    [_descriLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel);
        make.top.equalTo(_nameLabel).offset(0.05 *KScreenWidth);
        make.size.mas_equalTo(CGSizeMake(0.6 *KScreenWidth, 0.04 *KScreenWidth));
    }];
    
}

@end
