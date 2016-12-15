//
//  GoodsCell.m
//  SpaceTime
//
//  Created by CC on 2016/12/13.
//  Copyright © 2016年 CC. All rights reserved.
//

#import "GoodsCell.h"

@implementation GoodsCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

#pragma mark - 按钮 + title
- (void)layoutUI {
    _itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _itemBtn.frame = self.bounds;
    [self.contentView addSubview:_itemBtn];
}

@end
