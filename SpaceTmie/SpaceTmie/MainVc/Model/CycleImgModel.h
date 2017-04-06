//
//  CycleImgModel.h
//  SpaceTmie
//
//  Created by CC on 2017/4/6.
//  Copyright © 2017年 CC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "CyslePicture.h"

@interface CycleImgModel : NSObject

#pragma mark - 数据插进表
- (void)insertImageData:(CyslePicture *)cyslePicture;

#pragma mark - 查询轮播表
- (NSMutableArray *)selectImageData;

#pragma mark - 删除数据库
- (BOOL)deleteCycleImg;

@end
