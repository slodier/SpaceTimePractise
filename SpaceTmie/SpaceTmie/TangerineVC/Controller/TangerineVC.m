//
//  TangerineVC.m
//  SpaceTime
//
//  Created by CC on 2016/12/14.
//  Copyright © 2016年 CC. All rights reserved.
//

#import "TangerineVC.h"
#import "TrangerineCell.h"
#import "TrangerModel.h"

static NSString *const trangerCellID = @"tangerCell";

@interface TangerineVC ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *trangerCollectionView;

@property (nonatomic, strong) NSMutableArray *trangerArray;

@end

@implementation TangerineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _trangerArray = [NSMutableArray array];
    [self.view addSubview:self.trangerCollectionView];

    self.navigationController.navigationBar.tintColor = KColorWithRGB(83, 167, 176);
    
    [TrangerModel createArray:_trangerArray collectionView:_trangerCollectionView];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _trangerArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TrangerineCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:trangerCellID forIndexPath:indexPath];
    TrangerModel *model = _trangerArray[indexPath.row];
    [cell.btn setImage:[UIImage imageNamed:Img_path(model.icon)] forState:UIControlStateNormal];
    return cell;
}

#pragma mark - getter
- (UICollectionView *)trangerCollectionView {
    if (!_trangerCollectionView) {
        UICollectionViewFlowLayout *trangerFlowLayout = [[UICollectionViewFlowLayout alloc]init];
        trangerFlowLayout.itemSize = CGSizeMake(0.156 *KScreenWidth, 0.156 *KScreenWidth);
        CGRect frame = CGRectMake(0, 64, KScreenWidth, 500);
        _trangerCollectionView = [[UICollectionView alloc]initWithFrame:frame collectionViewLayout:trangerFlowLayout];
        _trangerCollectionView.backgroundColor = [UIColor whiteColor];
        [_trangerCollectionView registerClass:[TrangerineCell class] forCellWithReuseIdentifier:trangerCellID];
        _trangerCollectionView.delegate = self;
        _trangerCollectionView.dataSource = self;
    }
    return _trangerCollectionView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
