//
//  CCNetWork.h
//  Video
//
//  Created by CC on 2017/3/25.
//  Copyright © 2017年 CC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ReturnDicBlock)(NSDictionary *dict);
typedef void(^OnFailed)(NSError *error);

@interface CCNetWork : NSObject

- (void)analysisUrl:(NSString *)urlStr
           complete:(OnFailed)onfailed
          returnDic:(ReturnDicBlock)returnBlock;

@end
