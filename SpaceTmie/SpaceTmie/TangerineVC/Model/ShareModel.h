//
//  ShareModel.h
//  TencentShare
//
//  Created by CC on 2017/3/22.
//  Copyright © 2017年 CC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareModel : NSObject

@property (nonatomic, copy) NSString *thumbImageStr; // 缩略图图片

/*
    微信分享图片
    type{
        0 = 好友列表 
        1 = 朋友圈 
        2 = 收藏
    }
        
 */
#pragma mark - WX 分享链接
- (void)pictureWXShare:(int)type;

#pragma mark - WX 分享纯文本
- (void)textWXShare:(int)type;

#pragma mark - QQ 分享图片还是链接
- (void)qqShare:(BOOL)isPicure;

@end
