//
//  Calculation.m
//  图灵 Test
//
//  Created by CC on 2017/4/15.
//  Copyright © 2017年 CC. All rights reserved.
//

#import "Calculation.h"

@implementation Calculation

// 计算文字高度
- (CGSize)calculationSize:(NSString *)labelStr {
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:labelStr];
    NSRange range = {0, labelStr.length};
    UIFont *font = [UIFont systemFontOfSize:13];
    [attrStr addAttribute:NSFontAttributeName value:font range:range];
    CGFloat maxWidth = KScreenWidth - 0.04 *KScreenWidth - 0.18 *KScreenHeight;
    CGSize attrSize = [attrStr boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    return attrSize;
}

@end
