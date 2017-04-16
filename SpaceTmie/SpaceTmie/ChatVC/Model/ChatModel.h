//
//  ChatModel.h
//  图灵 Test
//
//  Created by CC on 2017/4/15.
//  Copyright © 2017年 CC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ChatModel : NSObject

@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, assign) CGSize labelSize;

@property (nonatomic, assign) BOOL isFromSelf;

- (NSString *)dateNow;

- (void)newData:(NSString *)content
     isFromSelf:(BOOL)isFromSelf
     dataSource:(NSMutableArray *)dataSource;

@end
