//
//  NewsModel.h
//  Video
//
//  Created by CC on 2017/3/25.
//  Copyright © 2017年 CC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsModel : NSObject

@property (nonatomic, copy) NSString *imgStr;   // 图片链接
@property (nonatomic, copy) NSString *titleStr; // 标题链接
@property (nonatomic, copy) NSString *urlStr;   // 点开详情链接
@property (nonatomic, copy) NSString *sourceStr;   // 点开详情链接
@property (nonatomic, copy) NSString *replyCount;   // 回复数

@property (nonatomic, copy) NSString *rowH;  // 计算 row 总高度

- (void)newsData:(NSDictionary *)dict
      dataSource:(NSMutableArray *)dataSource;

// 计算 cell 高度
- (CGFloat)cellHeightArrayNewsArray:(NewsModel *)newModel;

@end
