//
//  MyTableViewCell.m
//  SpaceTmie
//
//  Created by CC on 2017/3/16.
//  Copyright © 2017年 CC. All rights reserved.
//

#import "MyTableViewCell.h"
#import "Masonry.h"
#import "FileRelate.h"

@interface MyTableViewCell ()

{
    UIImageView *_arrowImageView; // 右箭头
}

@property (nonatomic, copy) NSString *cacheStr;

@end

@implementation MyTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        FileRelate *fileRelate = [[FileRelate alloc]init];
        _cacheStr = [fileRelate folderSizeAtPath];
        
        [self layoutUI];
    }
    return self;
}

#pragma mark - 样式不同
- (void)adaptStyle {
    if ([_itemLabel.text isEqualToString:@"清理缓存"]) {
        _arrowImageView.hidden = YES;
        _cacheLabel.hidden = NO;
        
        if (!(_cacheStr.length > 0)) {
            _cacheLabel.text = @"0";
        }else{
            _cacheLabel.text = _cacheStr;
        }
        
    }else{
        _arrowImageView.hidden = NO;
        _cacheLabel.hidden = YES;
    }
}

#pragma mark - 构建 UI
- (void)layoutUI {
    _itemLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    [self addSubview:_itemLabel];
    [_itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0.05 *KScreenWidth);
        make.top.equalTo(self).offset(0.03 *KScreenWidth);
        make.size.mas_equalTo(CGSizeMake(KScreenWidth /2, 0.022 *KScreenHeight));
    }];
    
    UIImageView *bottomLine = [[UIImageView alloc]initWithFrame:CGRectZero];
    [self addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self).offset(self.frame.size.height - 3);
        make.size.mas_equalTo(CGSizeMake(KScreenWidth, 1));
    }];
    bottomLine.image = [UIImage imageNamed:Img_path(@"navigation_rainbow@2x")];
    
    _arrowImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    [self addSubview:_arrowImageView];
    _arrowImageView.backgroundColor = [UIColor redColor];
    [_arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-0.03 *KScreenWidth);
        make.top.equalTo(self).offset(0.015 *KScreenHeight);
        make.size.mas_equalTo(CGSizeMake(0.04 *KScreenWidth, 0.03 *KScreenHeight));
    }];
    _arrowImageView.image = [UIImage imageNamed:@"19858PICScJ_1024.jpg"];
    
    CGFloat cacheW = 0;
    if (_cacheStr.length > 0) {
        cacheW = [self reSizeCacheStr:_cacheStr];
    }
    
    _cacheLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    [self addSubview:_cacheLabel];
    [_cacheLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(0.01 *KScreenWidth);
        make.top.equalTo(_arrowImageView);
        make.size.mas_equalTo(CGSizeMake(cacheW + 30, 0.03 *KScreenHeight));
    }];
    _arrowImageView.hidden = YES;
    _cacheLabel.textAlignment = NSTextAlignmentCenter;
}

#pragma mark - 计算文字宽度
- (CGFloat)reSizeCacheStr:(NSString *)labelStr {
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:labelStr];
    CGSize attrSize = [attrStr boundingRectWithSize:CGSizeMake(MAXFLOAT, 200) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    return attrSize.width;
}

@end
