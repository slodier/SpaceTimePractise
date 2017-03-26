//
//  CyslePicture.m
//  Video
//
//  Created by CC on 2017/3/25.
//  Copyright © 2017年 CC. All rights reserved.
//

#import "CyslePicture.h"
#import "ConstStr.h"

@implementation CyslePicture

- (void)getValueFrom:(NSDictionary *)dict
            imgArray:(NSMutableArray *)imgArray
          titleArray:(NSMutableArray *)titleArray
{
    NSArray *tempArray = dict[@"T1348647853363"][0][@"ads"];
    for (NSDictionary *dii in tempArray) {
        _imgSrc = JsonStr(dii[@"imgsrc"]);
        _title = JsonStr(dii[@"title"]);
        
        [imgArray   addObject:_imgSrc];
        [titleArray addObject:_title];
    }
    [imgArray replaceObjectAtIndex:imgArray.count - 1 withObject:urlImageStr1];
    [titleArray replaceObjectAtIndex:imgArray.count - 1 withObject:@"你的名字,我的姓氏"];
}

@end
