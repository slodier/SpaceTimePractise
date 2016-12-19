//
//  TrangerineCell.h
//  SpaceTmie
//
//  Created by CC on 2016/12/14.
//  Copyright © 2016年 CC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrangerModel.h"

@interface TrangerineCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;

- (void)refresh:(TrangerModel *)model;

@end
