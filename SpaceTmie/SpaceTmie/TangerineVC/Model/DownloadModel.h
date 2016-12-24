//
//  DownloadModel.h
//  SpaceTmie
//
//  Created by CC on 2016/12/16.
//  Copyright © 2016年 CC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadModel : NSObject

- (NSString *)fileName;

- (NSString *)downloadFile;

- (BOOL)isExistFile;

- (BOOL)deleteDownloadFile;

- (BOOL)removeTempFile:(NSURL *)tempUrl;

- (NSData *)seleteTempData;

@end
