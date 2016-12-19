//
//  TrangerModel.h
//  SpaceTmie
//
//  Created by CC on 2016/12/14.
//  Copyright © 2016年 CC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TrangerModel : NSObject

@property (nonatomic, copy) NSString *title; //按钮标题
@property (nonatomic, copy) NSString *icon;  //按钮图片

+ (void)createArray:(NSMutableArray *)sectionArray
         firstArray:(NSMutableArray *)array1
        secondArray:(NSMutableArray *)array2
     collectionView:(UICollectionView *)collectionView;

+ (NSString *)toStringValue:(id)value;

@end
