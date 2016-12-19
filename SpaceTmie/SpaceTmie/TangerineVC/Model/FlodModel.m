//
//  FlodModel.m
//  SpaceTmie
//
//  Created by CC on 2016/12/15.
//  Copyright © 2016年 CC. All rights reserved.
//

#import "FlodModel.h"

@interface FlodModel ()

@property (nonatomic) NSUInteger folds;

@end

@implementation FlodModel

- (instancetype)init {
    if (self = [super init]) {
        self.folds = 2;
    }
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = toVC.view;
    UIView *fromView = fromVC.view;
    
    [self animateTransition:transitionContext fromVC:fromVC toVC:toVC fromView:fromView toView:toView];
}

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return _folds;
}

#pragma mark -
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView {
    
    // Add the toView to the container
    UIView* containerView = [transitionContext containerView];
    
    // 移动屏幕
    toView.frame = [transitionContext finalFrameForViewController:toVC];
    toView.frame = CGRectOffset(toView.frame, toView.frame.size.width, 0);
    [containerView addSubview:toView];
    
    // 添加透视转换
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -0.005;
    containerView.layer.sublayerTransform = transform;
    
    CGSize size = toView.frame.size;
    
    float foldWidth = size.width * 0.5 / (float)self.folds ;
    
    // 保存屏幕快照的数组
    NSMutableArray* fromViewFolds = [NSMutableArray new];
    NSMutableArray* toViewFolds = [NSMutableArray new];
    
    // 折叠
    for (int i=0 ;i<self.folds; i++){
        float offset = (float)i * foldWidth * 2;
        
        // 左侧和右侧的折叠,交换且透明度为 0
        // 在阴影,每个视图在其初始位置
        UIView *leftFromViewFold = [self createSnapshotFromView:fromView afterUpdates:NO location:offset left:YES];
        leftFromViewFold.layer.position = CGPointMake(offset, size.height/2);
        [fromViewFolds addObject:leftFromViewFold];
        [leftFromViewFold.subviews[1] setAlpha:0.0];
        
        UIView *rightFromViewFold = [self createSnapshotFromView:fromView afterUpdates:NO location:offset + foldWidth left:NO];
        rightFromViewFold.layer.position = CGPointMake(offset + foldWidth * 2, size.height/2);
        [fromViewFolds addObject:rightFromViewFold];
        [rightFromViewFold.subviews[1] setAlpha:0.0];
        
        // 左侧和右侧的折叠,转 90°且透明度为 1
        // 在阴影,每个视图在屏幕边缘
        UIView *leftToViewFold = [self createSnapshotFromView:toView afterUpdates:YES location:offset left:YES];
        leftToViewFold.layer.position = CGPointMake(self.reverse ? size.width : 0.0, size.height/2);
        leftToViewFold.layer.transform = CATransform3DMakeRotation(M_PI_2, 0.0, 1.0, 0.0);
        [toViewFolds addObject:leftToViewFold];
        
        UIView *rightToViewFold = [self createSnapshotFromView:toView afterUpdates:YES location:offset + foldWidth left:NO];
        rightToViewFold.layer.position = CGPointMake(self.reverse ? size.width : 0.0, size.height/2);
        rightToViewFold.layer.transform = CATransform3DMakeRotation(-M_PI_2, 0.0, 1.0, 0.0);
        [toViewFolds addObject:rightToViewFold];
    }
    
    // 视图从屏幕移走
    fromView.frame = CGRectOffset(fromView.frame, fromView.frame.size.width, 0);
    
    // 动画
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration animations:^{
        // 设置每个折叠的最终状态
        for (int i=0; i<self.folds; i++){
            
            float offset = (float)i * foldWidth * 2;
            
            // 左侧和右侧的折叠,转 90°且透明度为 1
            // 在阴影,每个视图在屏幕边缘
            UIView* leftFromView = fromViewFolds[i*2];
            leftFromView.layer.position = CGPointMake(self.reverse ? 0.0 : size.width, size.height/2);
            leftFromView.layer.transform = CATransform3DRotate(transform, M_PI_2, 0.0, 1.0, 0);
            [leftFromView.subviews[1] setAlpha:1.0];
            
            UIView* rightFromView = fromViewFolds[i*2+1];
            rightFromView.layer.position = CGPointMake(self.reverse ? 0.0 : size.width, size.height/2);
            rightFromView.layer.transform = CATransform3DRotate(transform, -M_PI_2, 0.0, 1.0, 0);
            [rightFromView.subviews[1] setAlpha:1.0];
            
            // 折叠的左侧和右侧,交换且透明度为 0
            // 在阴影，每个视图在其最终位置
            UIView* leftToView = toViewFolds[i*2];
            leftToView.layer.position = CGPointMake(offset, size.height/2);
            leftToView.layer.transform = CATransform3DIdentity;
            [leftToView.subviews[1] setAlpha:0.0];
            
            UIView* rightToView = toViewFolds[i*2+1];
            rightToView.layer.position = CGPointMake(offset + foldWidth * 2, size.height/2);
            rightToView.layer.transform = CATransform3DIdentity;
            [rightToView.subviews[1] setAlpha:0.0];
            
            
        }
    }  completion:^(BOOL finished) {
        // 移除快照
        for (UIView *view in toViewFolds) {
            [view removeFromSuperview];
        }
        for (UIView *view in fromViewFolds) {
            [view removeFromSuperview];
        }
        
        BOOL transitionFinished = ![transitionContext transitionWasCancelled];
        if (transitionFinished) {
            //如果完成,还原起点和终点为最初的位置
            toView.frame = containerView.bounds;
            fromView.frame = containerView.bounds;
        }
        else {
            //如果取消,还原开始位置为最初的位置
            fromView.frame = containerView.bounds;
        }
        [transitionContext completeTransition:transitionFinished];
    }];
}

#pragma mark - 为给定 view 添加快照
-(UIView*) createSnapshotFromView:(UIView *)view afterUpdates:(BOOL)afterUpdates location:(CGFloat)offset left:(BOOL)left {
    
    CGSize size = view.frame.size;
    UIView *containerView = view.superview;
    float foldWidth = size.width * 0.5 / (float)self.folds ;
    
    UIView* snapshotView;
    
    if (!afterUpdates) {
        // 创建有规律的屏幕快照
        CGRect snapshotRegion = CGRectMake(offset, 0.0, foldWidth, size.height);
        snapshotView = [view resizableSnapshotViewFromRect:snapshotRegion  afterScreenUpdates:afterUpdates withCapInsets:UIEdgeInsetsZero];
        
    } else {
        // 由于某种原因，快照需要一段时间才能创建。这里我们放置快照
        // 另一个 view, 具有相同的背景颜色,使得屏幕快照在初始呈现时不明显
        snapshotView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, foldWidth, size.height)];
        snapshotView.backgroundColor = view.backgroundColor;
        CGRect snapshotRegion = CGRectMake(offset, 0.0, foldWidth, size.height);
        UIView* snapshotView2 = [view resizableSnapshotViewFromRect:snapshotRegion  afterScreenUpdates:afterUpdates withCapInsets:UIEdgeInsetsZero];
        [snapshotView addSubview:snapshotView2];
        
    }
    
    // 创建阴影
    UIView* snapshotWithShadowView = [self addShadowToView:snapshotView reverse:left];
    
    // 添加进 containerView
    [containerView addSubview:snapshotWithShadowView];
    
    // 设置锚点的左边缘或右边缘
    snapshotWithShadowView.layer.anchorPoint = CGPointMake( left ? 0.0 : 1.0, 0.5);
    
    return snapshotWithShadowView;
}

#pragma mark - 自定义方法
/*
    通过创建一个包含给定视图的 UIView 来为图像添加一个渐变
    为子视图添加梯度
 */
- (UIView*)addShadowToView:(UIView*)view reverse:(BOOL)reverse {
    
    // 创建一个相同尺寸的 view
    UIView* viewWithShadow = [[UIView alloc] initWithFrame:view.frame];
    
    // 创建阴影
    UIView* shadowView = [[UIView alloc] initWithFrame:viewWithShadow.bounds];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = shadowView.bounds;
    gradient.colors = @[(id)[UIColor colorWithWhite:0.0 alpha:0.0].CGColor,
                        (id)[UIColor colorWithWhite:0.0 alpha:1.0].CGColor];
    gradient.startPoint = CGPointMake(reverse ? 0.0 : 1.0, reverse ? 0.2 : 0.0);
    gradient.endPoint = CGPointMake(reverse ? 1.0 : 0.0, reverse ? 0.0 : 1.0);
    [shadowView.layer insertSublayer:gradient atIndex:1];
    
    // 将原始的 view 添加进新的 view
    view.frame = view.bounds;
    [viewWithShadow addSubview:view];
    
    //  将阴影添加到视图最上层
    [viewWithShadow addSubview:shadowView];
    
    return viewWithShadow;
}

@end
