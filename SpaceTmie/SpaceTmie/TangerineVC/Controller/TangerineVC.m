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
#import "UIImageView+WebCache.h"
#import "DownLoadVC.h"
#import "FlodModel.h"

static NSString *const collBgStr = @"http://pic.58pic.com/58pic/15/69/49/60p58PICtXG_1024.jpg";
static NSString *const trangerCellID = @"tangerCell";

@interface TangerineVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UINavigationControllerDelegate>

@property (nonatomic, strong) UIImageView *collBgView; //collectionview 底图
@property (nonatomic, strong) UICollectionView *trangerCollectionView;

@property (nonatomic, strong) NSMutableArray *sectionArray;
@property (nonatomic, strong) NSMutableArray *firstArray;
@property (nonatomic, strong) NSMutableArray *secondArray;

@end

@implementation TangerineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.delegate = self;
    
    _sectionArray = [NSMutableArray array];
    _firstArray   = [NSMutableArray array];
    _secondArray  = [NSMutableArray array];
    
    [self layoutUI];

    self.navigationController.navigationBar.tintColor = KColorWithRGB(83, 167, 176);
    
    [TrangerModel createArray:_sectionArray firstArray:_firstArray secondArray:_secondArray collectionView:_trangerCollectionView];
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    FlodModel *flod = [[FlodModel alloc]init];
    flod.reverse = YES;
    return flod;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    if (indexPath.section == 0) {
        TrangerModel *model = _firstArray[indexPath.row];
        backItem.title = model.title;
        
        
    }else{
        TrangerModel *model = _secondArray[indexPath.row];
        backItem.title = model.title;

        if (indexPath.row == 0) {
            DownLoadVC *downLoadVC = [[DownLoadVC alloc]init];
            [self.navigationController pushViewController:downLoadVC animated:YES];
        }else if (indexPath.row == 1){
            
        }
    }
    self.navigationItem.backBarButtonItem = backItem;
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [_sectionArray[0] count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return _firstArray.count;
    }else{
        return _secondArray.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TrangerineCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:trangerCellID forIndexPath:indexPath];
    if (indexPath.section == 0) {
        TrangerModel *model = _firstArray[indexPath.row];
        [cell refresh:model];
    }else{
        TrangerModel *model = _secondArray[indexPath.row];
        [cell refresh:model];
    }
    return cell;
}

#pragma mark - 构建 UI
- (void)layoutUI {
    _collBgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth, 0.5 *KScreenHeight)];
    _collBgView.userInteractionEnabled = YES;
    NSURL *collBgUrl = [NSURL URLWithString:collBgStr];
    UIImage *placaholderimage = [UIImage imageNamed:Img_path(@"placeholder")];
    [_collBgView sd_setImageWithURL:collBgUrl placeholderImage:placaholderimage];
    [self.view addSubview:_collBgView];
    [_collBgView addSubview:self.trangerCollectionView];
}

#pragma mark - getter
- (UICollectionView *)trangerCollectionView {
    if (!_trangerCollectionView) {
        UICollectionViewFlowLayout *trangerFlowLayout = [[UICollectionViewFlowLayout alloc]init];
        trangerFlowLayout.itemSize = CGSizeMake(0.156 *KScreenWidth, 0.156 *KScreenWidth);
        trangerFlowLayout.minimumInteritemSpacing = 0.15 *KScreenWidth;
        trangerFlowLayout.minimumLineSpacing = 0.03 *KScreenHeight;
        trangerFlowLayout.headerReferenceSize = CGSizeMake(100, 0.03 *KScreenHeight);
        CGRect frame = CGRectMake(30, 0, _collBgView.frame.size.width-60, _collBgView.frame.size.height);
        _trangerCollectionView = [[UICollectionView alloc]initWithFrame:frame collectionViewLayout:trangerFlowLayout];
        _trangerCollectionView.backgroundColor = [UIColor clearColor];
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
