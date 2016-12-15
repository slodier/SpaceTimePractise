//
//  ViewController.m
//  SpaceTime
//
//  Created by CC on 2016/12/13.
//  Copyright © 2016年 CC. All rights reserved.
//

#import "ViewController.h"
#import "SDCycleScrollView.h"
#import "ConstStr.h"
#import "GoodsCell.h"
#import "CCTabView.h"
#import "TangerineVC.h"
#import "BombTransitioning.h"

static NSString *const goodCellID = @"goodsCell";

@interface ViewController ()<SDCycleScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UINavigationControllerDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) CCTabView *ccTabView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.ccTabView];
    self.navigationController.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [self layoutUI];
}

#pragma mark - 按钮点击
#pragma mark 橙子按钮
- (void)tangerineClick {
    TangerineVC *tangerVC = [[TangerineVC alloc]init];
    [self.navigationController pushViewController:tangerVC animated:YES];
}

#pragma mark - UINavigationControllerDelegate
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    BombTransitioning *bombTransitioning = [[BombTransitioning alloc]init];
    return bombTransitioning;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:goodCellID forIndexPath:indexPath];
    return cell;
}

#pragma mark - 构建 UI
- (void)layoutUI {
    /** 导航栏透明 **/
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    NSArray *array = @[urlImageStr1,urlImageStr2,urlImageStr3,urlImageStr4,urlImageStr5];
    CGRect frame = CGRectMake(0, 64, KScreenWidth, 0.3 *KScreenHeight);
    UIImage *placeholder = [UIImage imageNamed:Img_path(@"placeholder")];
    SDCycleScrollView *scrollView = [SDCycleScrollView cycleScrollViewWithFrame:frame delegate:self placeholderImage:placeholder];
    scrollView.imageURLStringsGroup = array;
    scrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    [self.view addSubview:scrollView];
    [self.view addSubview:self.ccTabView];
}

#pragma mark 添加 UICollectionView
- (void)addCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    CGRect frame = CGRectMake(0, 0.3 *KScreenHeight + 64, KScreenWidth, 0.7 *KScreenHeight - 44);
    _collectionView = [[UICollectionView alloc]initWithFrame:frame collectionViewLayout:flowLayout];
    [_collectionView registerClass:[GoodsCell class] forCellWithReuseIdentifier:goodCellID];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
}

#pragma mark - getter 
- (CCTabView *)ccTabView {
    if (!_ccTabView) {
        _ccTabView = [[CCTabView alloc]initWithFrame:CGRectMake(0, 0.922 *KScreenHeight, KScreenWidth, 0.156 *KScreenHeight)];
        [_ccTabView.tangerineBtn addTarget:self action:@selector(tangerineClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ccTabView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
