//
//  TipsView.m
//  SpaceTmie
//
//  Created by CC on 2017/4/13.
//  Copyright © 2017年 CC. All rights reserved.
//

#import "TipsView.h"
#import "Masonry.h"
#import "UIView+Animations.h"

@interface TipsView ()

@property (nonatomic, strong) UIView *bgView;

@end

@implementation TipsView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self layoutUI];
    }
    return self;
}

#pragma mark - 动画
- (void)addAnimations {
    [UIView moveAndGain:_tipsLabel destination:CGPointMake(KScreenWidth /2, 0.4 *KScreenHeight)];
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 1.7 *NSEC_PER_SEC);
    __weak typeof(self)weakSelf = self;
    dispatch_after(time, dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf)strongSelf = weakSelf;
        [UIView animateWithDuration:2 animations:^{
            [_tipsLabel.layer removeAllAnimations];
        }completion:^(BOOL finished) {
            [strongSelf removeFromSuperview];
        }];
    });
}

#pragma mark - 构建 UI
- (void)layoutUI {
    
    _bgView = [[UIView alloc]initWithFrame:self.bounds];
    [self addSubview:_bgView];
    _bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    _tipsLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    [_bgView addSubview:_tipsLabel];
    _tipsLabel.frame = CGRectMake(0, 0.45 *KScreenHeight, KScreenWidth, 0.1 *KScreenHeight);
    _tipsLabel.numberOfLines = 0;
    _tipsLabel.backgroundColor = [UIColor whiteColor];
    _tipsLabel.textAlignment = NSTextAlignmentCenter;
    _tipsLabel.layer.borderColor = [UIColor blackColor].CGColor;
    _tipsLabel.layer.borderWidth = 1;
    
}

@end
