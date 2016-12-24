//
//  ActionView.m
//  SpaceTmie
//
//  Created by CC on 2016/12/22.
//  Copyright © 2016年 CC. All rights reserved.
//

#import "ActionView.h"
#import "Masonry.h"
#import "AttentionView.h"

@interface ActionView ()

@property (nonatomic, strong) UIButton *closeBtn;  //关闭按钮

@end

@implementation ActionView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self layoutUI];
    }
    return self;
}

#pragma mark - 按钮点击方法
- (void)closeTipView {
    [UIView animateWithDuration:2 animations:^{
        [self removeFromSuperview];
    }];
}

#pragma mark - 构建 UI
- (void)layoutUI {
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:blur];
    effectView.frame = self.bounds;
    effectView.tag = 2;
    [self addSubview:effectView];
    effectView.userInteractionEnabled = YES;
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectZero];
    [effectView addSubview:bgView];
    bgView.frame = CGRectMake(KScreenWidth /6, KScreenHeight /3, KScreenWidth *2/3, KScreenHeight /3);
    bgView.userInteractionEnabled = YES;
    bgView.backgroundColor = KColorWithRGB(0, 128, 128);
    
    AttentionView *attentionView = [[AttentionView alloc]initWithFrame:CGRectZero];
    [attentionView createCornerInView:bgView corners:UIRectCornerTopLeft|UIRectCornerTopRight cgsize:CGSizeMake(50, 50)];
    
    _tipLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    [bgView addSubview:_tipLabel];
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(0.05 *KScreenWidth);
        make.top.equalTo(bgView).offset(0.05 *KScreenWidth);
        make.size.mas_equalTo(CGSizeMake(0.56 *KScreenWidth, 0.2 *KScreenHeight));
    }];
    _tipLabel.textColor = [UIColor whiteColor];
    _tipLabel.font = [UIFont systemFontOfSize:17];
    _tipLabel.textAlignment = NSTextAlignmentCenter;
    _tipLabel.numberOfLines = 0;
    
    //新的下载
    _downloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_downloadBtn setTitle:@"重新下载" forState:UIControlStateNormal];
    [bgView addSubview:_downloadBtn];
    [_downloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(0.035 *KScreenWidth);
        make.top.equalTo(_tipLabel).offset(0.23 *KScreenHeight);
        make.size.mas_equalTo(CGSizeMake(0.28 *KScreenWidth, 0.1 *KScreenWidth));
    }];

    _resumeDownBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_resumeDownBtn setTitle:@"继续下载" forState:UIControlStateNormal];
    [bgView addSubview:_resumeDownBtn];
    [_resumeDownBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_downloadBtn).offset(0.315 *KScreenWidth);
        make.top.equalTo(_downloadBtn);
        make.size.mas_equalTo(_downloadBtn);
    }];
}

@end
