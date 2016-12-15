//
//  CCTabView.m
//  SpaceTime
//
//  Created by CC on 2016/12/13.
//  Copyright © 2016年 CC. All rights reserved.
//

#import "CCTabView.h"
#import "UIView+Animations.h"

typedef void(^ReturnBlock)(void);

@interface CCTabView ()

@property (nonatomic, strong) UIButton *mainBtn;

@end

@implementation CCTabView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addMainBtn];
        self.userInteractionEnabled = YES;
    }
    return self;
}

#pragma mark - 主按钮点击事件
- (void)mainClick:(UIButton *)sender {
    sender.userInteractionEnabled = YES;

    [self delayRun:^{
        sender.userInteractionEnabled = YES;
    }];
    
    sender.selected =! sender.selected;
    if (sender.selected) {

        [self addSubview:_flowerBtn];
        [self addSubview:_chipBtn];
        [self addSubview:_tangerineBtn];
        
        [UIView animateWithDuration:0.5 animations:^{
            self.frame = CGRectMake(0, 0.8863 *KScreenHeight, KScreenWidth, 0.158 *KScreenHeight);
        }];
        
        [UIView moveAndGain:_flowerBtn destination:CGPointMake(0.2915 *KScreenWidth - 0.039 *KScreenHeight, 0.068 *KScreenHeight)];
        [UIView moveAndGain:_chipBtn destination:CGPointMake(0.5 *KScreenWidth, 0)];
        [UIView moveAndGain:_tangerineBtn destination:CGPointMake(0.7085 *KScreenWidth + 0.039 *KScreenHeight, 0.068 *KScreenHeight)];
        
    }else{

        [UIView animateWithDuration:0.5 animations:^{
            self.frame = CGRectMake(0, 0.922 *KScreenHeight, KScreenWidth, 0.158 *KScreenHeight);
            [_flowerBtn removeFromSuperview];
            [_chipBtn removeFromSuperview];
            [_tangerineBtn removeFromSuperview];
        }];
    }
}

- (void)click2 {
    NSLog(@"123");
}

#pragma mark - 延迟执行
- (void)delayRun:(ReturnBlock)block {
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0.8 *NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        block();
    });
}

#pragma mark - 动画
- (void)moveAnimation:(UIView *)view {
    CABasicAnimation *moveAnimation = [CABasicAnimation animationWithKeyPath:@""];
    moveAnimation.duration = 1;
    moveAnimation.removedOnCompletion = NO;
    moveAnimation.fillMode = kCAFillModeForwards;
}

#pragma mark - 添加主按钮
- (void)addMainBtn {
    _mainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _mainBtn.frame = CGRectMake(0.361 *KScreenWidth, 0.039 *KScreenHeight, 0.278 *KScreenWidth, 0.078 *KScreenHeight);
    [_mainBtn setImage:[UIImage imageNamed:Img_path(@"main_click")] forState:UIControlStateNormal];
    [self addSubview:_mainBtn];
    [_mainBtn addTarget:self action:@selector(mainClick:) forControlEvents:UIControlEventTouchUpInside];

    _flowerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _chipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _tangerineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _flowerBtn.frame = CGRectMake(0.222 *KScreenWidth - 0.039 *KScreenHeight, 0.068 *KScreenHeight, 0.139 *KScreenWidth, 0.076 *KScreenHeight);
    _chipBtn.frame = CGRectMake(0.4305 *KScreenWidth, 0, 0.139 *KScreenWidth, 0.039 *KScreenHeight);
    _tangerineBtn.frame = CGRectMake(0.639 *KScreenWidth + 0.039 *KScreenHeight, 0.068 *KScreenHeight, 0.139 *KScreenWidth, 0.076 *KScreenHeight);
    
    [_flowerBtn setImage:[UIImage imageNamed:Img_path(@"flower@2x")] forState:UIControlStateNormal];
    [_chipBtn setImage:[UIImage imageNamed:Img_path(@"chip@2x")] forState:UIControlStateNormal];
    [_tangerineBtn setImage:[UIImage imageNamed:Img_path(@"tangerine@2x")] forState:UIControlStateNormal];
    
    [_chipBtn addTarget:self action:@selector(click2) forControlEvents:UIControlEventTouchUpInside];
}

@end
