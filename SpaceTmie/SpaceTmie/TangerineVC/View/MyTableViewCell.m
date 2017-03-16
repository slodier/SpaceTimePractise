//
//  MyTableViewCell.m
//  SpaceTmie
//
//  Created by CC on 2017/3/16.
//  Copyright © 2017年 CC. All rights reserved.
//

#import "MyTableViewCell.h"
#import "Masonry.h"

@implementation MyTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self layoutUI];
    }
    return self;
}

#pragma mark - 构建 UI
- (void)layoutUI {
    _itemLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    [self addSubview:_itemLabel];
    [_itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0.05 *KScreenWidth);
        make.top.equalTo(self).offset(0.05 *KScreenWidth);
        make.size.mas_equalTo(CGSizeMake(KScreenWidth /2, 0.022 *KScreenHeight));
    }];
}

@end
