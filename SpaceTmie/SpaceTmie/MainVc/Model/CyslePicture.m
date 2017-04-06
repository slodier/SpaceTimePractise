//
//  CyslePicture.m
//  Video
//
//  Created by CC on 2017/3/25.
//  Copyright © 2017年 CC. All rights reserved.
//

#import "CyslePicture.h"
#import "ConstStr.h"
#import "CycleImgModel.h"

@interface CyslePicture ()

@property (nonatomic, strong) CycleImgModel *cycleImgModel;

@end

@implementation CyslePicture

- (instancetype)init {
    if (self = [super init]) {
        
        _cycleImgModel = [[CycleImgModel alloc]init];
    }
    return self;
}

- (void)getValueFrom:(NSDictionary *)dict
            imgArray:(NSMutableArray *)imgArray
          titleArray:(NSMutableArray *)titleArray
{
    NSMutableArray *cycleArray = [NSMutableArray array];
    
    NSArray *tempArray = dict[@"T1348647853363"][0][@"ads"];
    for (NSDictionary *dii in tempArray) {
        CyslePicture *cyclePic = [[CyslePicture alloc]init];
        cyclePic.imgSrc = JsonStr(dii[@"imgsrc"]);
        cyclePic.title = JsonStr(dii[@"title"]);
        
        [imgArray   addObject:cyclePic.imgSrc];
        [titleArray addObject:cyclePic.title];
        
        [cycleArray addObject:cyclePic];
    }
    
    // 每次只执行一次,将数据存进数据库
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        [_cycleImgModel deleteCycleImg];
        for (int i = 0; i < cycleArray.count; i++) {
            CyslePicture *cyslePicture = cycleArray[i];
            [_cycleImgModel insertImageData:cyslePicture];
        }
    });
}

@end
