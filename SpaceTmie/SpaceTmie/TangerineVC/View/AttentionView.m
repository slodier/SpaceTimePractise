//
//  AttentionView.m
//  SpaceTmie
//
//  Created by CC on 2016/12/16.
//  Copyright © 2016年 CC. All rights reserved.
//

#import "AttentionView.h"
#import "Masonry.h"

@interface AttentionView ()

@property (nonatomic, strong) UIButton *closeBtn;  //关闭按钮

@end

@implementation AttentionView

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
    [self createCornerInView:bgView corners:UIRectCornerTopLeft|UIRectCornerTopRight cgsize:CGSizeMake(50, 50)];
    
    _tipLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    [bgView addSubview:_tipLabel];
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(0.05 *KScreenWidth);
        make.top.equalTo(bgView).offset(0.05 *KScreenWidth);
        make.size.mas_equalTo(CGSizeMake(0.56 *KScreenWidth, 0.2 *KScreenHeight));
    }];
    _tipLabel.textColor = [UIColor whiteColor];
    _tipLabel.font = [UIFont systemFontOfSize:15];
    _tipLabel.numberOfLines = 0;
    
    _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bgView addSubview:_closeBtn];
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(0.193 *KScreenWidth);
        make.top.equalTo(_tipLabel).offset(0.23 *KScreenHeight);
        make.size.mas_equalTo(CGSizeMake(0.28 *KScreenWidth, 0.1 *KScreenWidth));
    }];
    [_closeBtn setImage:[UIImage imageNamed:@"define"] forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(closeTipView) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 自定义圆角
- (void)createCornerInView:(UIView *)view corners:(UIRectCorner)corner cgsize:(CGSize)size
{
    /*
     typedef NS_OPTIONS(NSUInteger, UIRectCorner) {
     UIRectCornerTopLeft     = 1 << 0,  - 左上角
     UIRectCornerTopRight    = 1 << 1,  - 右上角
     UIRectCornerBottomLeft  = 1 << 2,  - 左下角
     UIRectCornerBottomRight = 1 << 3,  - 右下角
     UIRectCornerAllCorners  = ~0UL     - 四只角
     };
     */
    //贝塞尔曲线
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corner cornerRadii:size];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = view.bounds;
    maskLayer.path = bezierPath.CGPath;
    view.layer.mask = maskLayer;
}

@end

