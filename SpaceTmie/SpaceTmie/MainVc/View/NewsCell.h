//
//  NewsCell.h
//  Video
//
//  Created by CC on 2017/3/26.
//  Copyright © 2017年 CC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsModel.h"

@interface NewsCell : UITableViewCell

@property (nonatomic, strong) UIImageView *newsImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *sourceLabel;
@property (nonatomic, strong) UILabel *replayLabel;

- (void)para:(NewsModel *)newModel;

@end
