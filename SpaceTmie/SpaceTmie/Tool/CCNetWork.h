//
//  CCNetWork.h
//  Video
//
//  Created by CC on 2017/3/25.
//  Copyright © 2017年 CC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ReturnDicBlock)(NSDictionary *dict);

@interface CCNetWork : NSObject

@property (nonatomic, copy) ReturnDicBlock dicBlock;

- (void)analysisUrl:(NSString *)urlStr;

- (void)getDicBlock:(ReturnDicBlock)block;

@end
