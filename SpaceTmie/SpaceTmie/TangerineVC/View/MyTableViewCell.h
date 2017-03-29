//
//  MyTableViewCell.h
//  SpaceTmie
//
//  Created by CC on 2017/3/16.
//  Copyright © 2017年 CC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *itemLabel;

@property (nonatomic, strong) UILabel *cacheLabel; // 缓存值

- (void)adaptStyle;

@end
