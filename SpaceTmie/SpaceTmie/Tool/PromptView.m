//
//  PromptView.m
//  SpaceTmie
//
//  Created by CC on 2017/4/14.
//  Copyright © 2017年 CC. All rights reserved.
//

#import "PromptView.h"
#import "AttentionView.h"

@interface PromptView ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIButton *cancelBtn; // 取消按钮

@end

@implementation PromptView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [self layoutUI];
        self.userInteractionEnabled = YES;
    }
    return self;
}

#pragma mark - 关闭视图
- (void)closeView {
    [UIView animateWithDuration:0.5 animations:^{
        [self removeFromSuperview];
    }];
}

#pragma mark - 构建 UI
- (void)layoutUI {
    
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(KScreenWidth /12, KScreenHeight /6, KScreenWidth *5/6, 0.474 *KScreenHeight)];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_bgView];
    _bgView.userInteractionEnabled = YES;
    
    AttentionView *attenTionView = [[AttentionView alloc]init];
    
    [attenTionView createCornerInView:_bgView corners:UIRectCornerAllCorners  cgsize:CGSizeMake(20, 20)];
    
    _attenLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.026 *KScreenWidth, 0, KScreenWidth *5/6 - 0.052 *KScreenWidth, KScreenHeight /3)];
    [_bgView addSubview:_attenLabel];
    _attenLabel.textAlignment = NSTextAlignmentCenter;
    _attenLabel.numberOfLines = 0;
    
    _cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.301 *KScreenWidth, KScreenHeight *1/3, 0.2304 *KScreenWidth, 0.0696 *KScreenHeight)];
    [_bgView addSubview:_cancelBtn];
    [_cancelBtn setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [_cancelBtn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
}


@end
