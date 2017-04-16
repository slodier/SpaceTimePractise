//
//  NewsCell.m
//  Video
//
//  Created by CC on 2017/3/26.
//  Copyright © 2017年 CC. All rights reserved.
//

#import "NewsCell.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"

@implementation NewsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self layoutUI];
    }
    return self;
}

#pragma mark - 值操作
- (void)para:(NewsModel *)newModel {
    
    _titleLabel.text  = newModel.titleStr;
    NSURL *imageUrl   = [NSURL URLWithString:newModel.imgStr];
    [_newsImageView sd_setImageWithURL:imageUrl];
    _sourceLabel.text = newModel.sourceStr;
    _replayLabel.text = [newModel.replyCount stringByAppendingString:@"评"];
    
    CGFloat titleHeight = [self heightForTitle];
    [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0.007 *KScreenHeight);
        make.left.equalTo(self).offset(0.02 *KScreenWidth);
        make.size.mas_equalTo(CGSizeMake(KScreenWidth - 0.04 *KScreenWidth, titleHeight));
    }];
    
    CGFloat sourceWidth = [self reSizeLabel:_sourceLabel];
    [_sourceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel);
        make.bottom.equalTo(_newsImageView).offset(0.03 *KScreenHeight);
        make.size.mas_equalTo(CGSizeMake(sourceWidth, 0.015 *KScreenHeight));
    }];
    
    CGFloat replyWidth = [self reSizeLabel:_replayLabel];
    [_replayLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_sourceLabel);
        make.left.equalTo(_titleLabel).offset(sourceWidth + 0.01 *KScreenWidth);
        make.size.mas_equalTo(CGSizeMake(replyWidth, 0.015 *KScreenHeight));
    }];
}

#pragma mark - 计算文字宽度
- (CGFloat)reSizeLabel:(UILabel *)label {
   
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:label.text];
    CGSize attrSize = [attrStr boundingRectWithSize:CGSizeMake(MAXFLOAT, 200) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    return attrSize.width;
}

// 标题的高度
- (CGFloat)heightForTitle {
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:_titleLabel.text];
        CGSize attrSize = [attrStr boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    //NSLog(@"标题高度:%f",attrSize.height);
    return attrSize.height + 15;
}

#pragma mark - 构建 UI
- (void)layoutUI {
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0.007 *KScreenHeight);
        make.left.equalTo(self).offset(0.02 *KScreenWidth);
        make.size.mas_equalTo(CGSizeMake(KScreenWidth - 0.04 *KScreenWidth, 0.03 *KScreenHeight));
    }];
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.numberOfLines = 0;
    _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    _newsImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    [self addSubview:_newsImageView];
    [_newsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel);
        make.bottom.equalTo(_titleLabel).offset(0.4 *KScreenHeight);
        make.size.mas_equalTo(CGSizeMake(KScreenWidth - 0.04 *KScreenWidth, 0.4 *KScreenHeight));
    }];
    
    _sourceLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    [self addSubview:_sourceLabel];
    [_sourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel);
        make.bottom.equalTo(_newsImageView).offset(0.03 *KScreenHeight);
        make.size.mas_equalTo(CGSizeMake(0.1 *KScreenWidth, 0.015 *KScreenHeight));
    }];
    _sourceLabel.font = [UIFont systemFontOfSize:10];
    
    _replayLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    [self addSubview:_replayLabel];
    [_replayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_sourceLabel);
        make.left.equalTo(_titleLabel).offset(0.12 *KScreenHeight);
        make.size.mas_equalTo(CGSizeMake(0.07 *KScreenWidth, 0.015 *KScreenHeight));
    }];
    _replayLabel.font = _sourceLabel.font;
}

@end
