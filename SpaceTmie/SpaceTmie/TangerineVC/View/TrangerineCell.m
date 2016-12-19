//
//  TrangerineCell.m
//  SpaceTmie
//
//  Created by CC on 2016/12/14.
//  Copyright © 2016年 CC. All rights reserved.
//

#import "TrangerineCell.h"

@implementation TrangerineCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {

        self.backgroundColor = [UIColor redColor];
        
        _imageView = [[UIImageView alloc]init];
        _imageView.frame = CGRectMake(0.031 *KScreenWidth, 0.01 *KScreenHeight, 0.094 *KScreenWidth, 0.05 *KScreenHeight);
        _imageView.userInteractionEnabled = YES;
        [self.contentView addSubview:_imageView];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.bounds.size.height *3/4, self.bounds.size.width, self.bounds.size.height /4)];
        _titleLabel.font = [UIFont systemFontOfSize:10];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_titleLabel];
    }
    return self;
}

#pragma mark - cell 赋值
- (void)refresh:(TrangerModel *)model
{
    _imageView.image = [UIImage imageNamed:Img_path(model.icon)];
    _titleLabel.text = model.title;
}

@end
