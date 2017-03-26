//
//  CyslePicture.h
//  Video
//
//  Created by CC on 2017/3/25.
//  Copyright © 2017年 CC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CyslePicture : NSObject

@property (nonatomic, copy) NSString *imgSrc; // 图片 url
@property (nonatomic, copy) NSString *title;  // 图片标题

- (void)getValueFrom:(NSDictionary *)dict
            imgArray:(NSMutableArray *)imgArray
          titleArray:(NSMutableArray *)titleArray;

@end
