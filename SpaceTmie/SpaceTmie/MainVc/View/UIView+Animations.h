//
//  UIView+Animations.h
//  动画组
//
//  Created by CC on 2016/12/12.
//  Copyright © 2016年 CC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Animations)

+ (void)moveAndGain:(UIView *)view
        destination:(CGPoint)point;

+ (void)removeAndGain:(UIView *)view;

@end
