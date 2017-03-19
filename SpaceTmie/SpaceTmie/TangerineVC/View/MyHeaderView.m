//
//  MyHeaderView.m
//  SpaceTmie
//
//  Created by CC on 2017/3/16.
//  Copyright © 2017年 CC. All rights reserved.
//

#import "MyHeaderView.h"
#import "Masonry.h"

@interface MyHeaderView ()

{
    UIImageView *_arrowImageView;  // 右箭头图层
}

@end

@implementation MyHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        [self layoutUI];
        [self getValue];
    }
    return self;
}

#pragma mark - 赋值
- (void)getValue {
    _nameLabel.text = @"onevcat";
    _descriLabel.text = @"该用户很懒,什么都没有留下.";
    _avatarView.image = [UIImage imageNamed:Img_path(@"water@2x")];
    _arrowImageView.image = [UIImage imageNamed:@"19858PICScJ_1024.jpg"];

}

#pragma mark - 构建 UI
- (void)layoutUI {
    _avatarView = [[UIImageView alloc]initWithFrame:CGRectZero];
    [self addSubview:_avatarView];
    [_avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0.04 *KScreenWidth);
        make.top.equalTo(self).offset(0.04 *KScreenWidth);
        make.size.mas_equalTo(CGSizeMake(0.2 *KScreenWidth, 0.2 *KScreenWidth));
    }];
    
    _iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_iconButton];
    [_iconButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_avatarView);
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
        make.top.equalTo(_nameLabel).offset(0.07 *KScreenWidth);
        make.size.mas_equalTo(CGSizeMake(0.5 *KScreenWidth, 0.14 *KScreenWidth));
    }];
    _descriLabel.font = [UIFont systemFontOfSize:12];

    _arrowImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    [self addSubview:_arrowImageView];
    _arrowImageView.backgroundColor = [UIColor redColor];
    [_arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_descriLabel).offset(0.6 *KScreenWidth);
        make.top.equalTo(self).offset((self.frame.size.height - 0.1 *KScreenWidth)/2);
        make.size.mas_equalTo(CGSizeMake(0.04 *KScreenWidth, 0.1 *KScreenWidth));
    }];
}

@end
