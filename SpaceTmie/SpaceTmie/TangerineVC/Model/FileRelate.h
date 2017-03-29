//
//  FileRelate.h
//  SpaceTmie
//
//  Created by CC on 2017/3/29.
//  Copyright © 2017年 CC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileRelate : NSObject

// 获得文件夹总大小
- (NSString *)folderSizeAtPath;

// 删除文件夹
- (BOOL)deleteCacheFile;

@end
