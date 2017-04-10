//
//  UIView+Animations.m
//  动画组
//
//  Created by CC on 2016/12/12.
//  Copyright © 2016年 CC. All rights reserved.
//

#import "UIView+Animations.h"

@implementation UIView (Animations)

#pragma mark - 移动和缩放动画
+ (void)moveAndGain:(UIView *)view
        destination:(CGPoint)point
{
    CABasicAnimation *posiAnimation = [CABasicAnimation animation];
    posiAnimation.keyPath = @"position";
    posiAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(KScreenWidth / 2, KScreenHeight)];
    posiAnimation.toValue  = [NSValue valueWithCGPoint:point];
    posiAnimation.duration = 0.3;
    posiAnimation.removedOnCompletion = NO;
    posiAnimation.fillMode = kCAFillModeForwards;
    [view.layer addAnimation:posiAnimation forKey:@""];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSNumber numberWithInt:1];
    scaleAnimation.toValue   = [NSNumber numberWithFloat:1.3];
    scaleAnimation.duration  = 0.3;
    scaleAnimation.beginTime = CACurrentMediaTime() + 0.3;
    [view.layer addAnimation:scaleAnimation forKey:@""];
}

+ (void)removeAndGain:(UIView *)view
{
    CABasicAnimation *posiAnimation = [CABasicAnimation animation];
    posiAnimation.keyPath = @"position";
    posiAnimation.toValue  = [NSValue valueWithCGPoint:CGPointMake(KScreenWidth /2, KScreenHeight)];
    //posiAnimation.removedOnCompletion = YES;
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.toValue  = [NSNumber numberWithFloat:0];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = 0.6;
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    group.animations = @[posiAnimation,scaleAnimation];
    //NSString *animaStr = [NSString stringWithFormat:@"%@",view];
    if (view) {
        [view.layer addAnimation:group forKey:nil];
    }
}

@end
