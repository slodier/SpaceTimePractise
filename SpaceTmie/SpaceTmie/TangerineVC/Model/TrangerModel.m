//
//  TrangerModel.m
//  SpaceTmie
//
//  Created by CC on 2016/12/14.
//  Copyright © 2016年 CC. All rights reserved.
//

#import "TrangerModel.h"

@implementation TrangerModel

+ (void)createArray:(NSMutableArray *)sectionArray
         firstArray:(NSMutableArray *)array1
        secondArray:(NSMutableArray *)array2
     collectionView:(UICollectionView *)collectionView
{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"Tranger.json" ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSError *error;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    [sectionArray addObject:dict[@"content"]];
    NSArray *tempArray = dict[@"content"][@"bigImg"];
    for (NSDictionary *dict in tempArray) {
        TrangerModel *model = [[TrangerModel alloc]init];
        model.title = JsonStr(dict[@"title"]);
        model.icon  = JsonStr(dict[@"icon"]);
        [array1 addObject:model];
    }
    
    NSArray *tempArray2 = dict[@"content"][@"smallImg"];
    for (NSDictionary *dict in tempArray2) {
        TrangerModel *model = [[TrangerModel alloc]init];
        model.title = JsonStr(dict[@"title"]);
        model.icon  = JsonStr(dict[@"icon"]);
        [array2 addObject:model];
    }
    [collectionView reloadData];
}

#pragma mark - 转换为字符串类型
+ (NSString *)toStringValue:(id)value {
    if ([value isKindOfClass:[NSString class]]) {
        return value;
    }else if ([value isKindOfClass:[NSNumber class]]){
        return [value stringValue];
    }else if ([value isKindOfClass:[NSNull class]]){
        return @"";
    }
    return @"";
}

@end
