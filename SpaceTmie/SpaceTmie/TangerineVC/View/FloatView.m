//
//  FloatView.m
//  SpaceTmie
//
//  Created by CC on 2016/12/22.
//  Copyright © 2016年 CC. All rights reserved.
//

#import "FloatView.h"

@implementation FloatView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _contextLabel = [[UILabel alloc]initWithFrame:self.bounds];
        _contextLabel.backgroundColor = [UIColor blueColor];
        _contextLabel.textColor = [UIColor whiteColor];
        _contextLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_contextLabel];
    }
    return self;
}

- (void)floatAniamtion {
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:1.5 animations:^{
        _contextLabel.frame = CGRectMake(0, 0, KScreenWidth, 64);
    }completion:^(BOOL finished) {
        [weakSelf hideView];
    }];
}

- (void)hideView {
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:2.5 animations:^{
        _contextLabel.frame = CGRectMake(0, 0, KScreenWidth, -64);
    }completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

@end
