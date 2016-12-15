//
//  TrangerModel.m
//  SpaceTmie
//
//  Created by CC on 2016/12/14.
//  Copyright © 2016年 CC. All rights reserved.
//

#import "TrangerModel.h"

@implementation TrangerModel

+ (void)createArray:(NSMutableArray *)array
     collectionView:(UICollectionView *)collectionView
{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"Tranger.json" ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSError *error;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    NSArray *tempArray = dict[@"array"];
    for (NSDictionary *dict in tempArray) {
        TrangerModel *model = [[TrangerModel alloc]init];
        model.title = JsonStr(dict[@"title"]);
        model.icon  = dict[@"icon"];
        [array addObject:model];
    }
    [collectionView reloadData];
}

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
