//
//  CCProgressView.h
//  SpaceTmie
//
//  Created by CC on 2016/12/16.
//  Copyright © 2016年 CC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCProgressView : UIView

@property (nonatomic, assign) double progress;

@property (nonatomic, strong) CAShapeLayer *progressLayer;

@end
