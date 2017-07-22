//
//  HamburgerVC.m
//  SpaceTmie
//
//  Created by CC on 2016/12/25.
//  Copyright © 2016年 CC. All rights reserved.
//

#import "HamburgerVC.h"
#import "CCNetWork.h"
#import "UIImageView+WebCache.h"
#import "LiveItem.h"
#import "LiveCell.h"
#import "LiveDetailViewController.h"
#import "MJRefresh.h"

@interface HamburgerVC ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *liveCollectionView;  // 直播列表视图
@property (strong, nonatomic) NSMutableArray *livesArray;  // 数据源

@property (assign, nonatomic) BOOL isRefreshComplete;

@property (assign, nonatomic) BOOL isUpComplete;

@property (assign, nonatomic) int upRefreshCount;  // 加载的次数

@end

@implementation HamburgerVC

static NSString *cell_id = @"live_cell";
static NSString *videoUrl = @"http://116.211.167.106/api/live/aggregation?uid=133825214&interest=1";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"直播";
    self.navigationItem.backBarButtonItem.title = @"其他";
    _livesArray = [[NSMutableArray alloc]init];
    [self.view addSubview:self.liveCollectionView];
    [self loadData];
    _isRefreshComplete = YES;
    _isUpComplete = YES;
    _upRefreshCount = 0;
}

- (void)viewWillAppear:(BOOL)animated {
    [self slideView];
}

#pragma mark - 上拉加载
- (void)pullUpLoad {
    if(_isUpComplete){
        __weak typeof(self)weakSelf = self;
        self.liveCollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _upRefreshCount++;
            if (_upRefreshCount == 7) {
                return;
            }
            CCNetWork *ccnetWork = [[CCNetWork alloc]init];
            [ccnetWork analysisUrl:videoUrl
                          complete:^(NSError *error) {
                              __strong typeof(weakSelf)strongSelf = weakSelf;
                              if(error){
                                  [strongSelf.liveCollectionView.mj_footer endRefreshing];
                                  _upRefreshCount--;
                              }
                          } returnDic:^(NSDictionary *dict) {
                              __strong typeof(weakSelf)strongSelf = weakSelf;

                              [LiveItem addDataFrom:dict into:strongSelf.livesArray from:20 *_upRefreshCount end:20 *(_upRefreshCount + 1)];
                              NSLog(@"--------%@", strongSelf.livesArray);
                              
                              dispatch_main_async_safe(^{
                                  [strongSelf.liveCollectionView reloadData];
                                  [strongSelf.liveCollectionView.mj_footer endRefreshing];
                                  _isUpComplete = NO;
                              });
                          }];
        }];
    }
}

#pragma mark - 下拉刷新
- (void)pullDownLoad {
    if(_isRefreshComplete){
        __weak typeof(self)weakSelf = self;
        self.liveCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{

            CCNetWork *ccnetWork = [[CCNetWork alloc]init];
            [ccnetWork analysisUrl:videoUrl
                          complete:^(NSError *error) {
                              __strong typeof(weakSelf)strongSelf = weakSelf;
                              if(error){
                                  [strongSelf.liveCollectionView.mj_header endRefreshing];
                              }
                          } returnDic:^(NSDictionary *dict) {
                              __strong typeof(weakSelf)strongSelf = weakSelf;
                              [strongSelf.livesArray removeAllObjects];
                              [LiveItem getDataFrom:dict into:strongSelf.livesArray];
                              //NSLog(@"--------%@", strongSelf.livesArray);

                              dispatch_main_async_safe(^{
                                  [strongSelf.liveCollectionView reloadData];
                                  [strongSelf.liveCollectionView.mj_header endRefreshing];
                                  _isRefreshComplete = NO;
                              });
                          }];
        }];
    }
}

#pragma mark - 滑动回到上一层界面
- (void)slideView {
    id target = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:target action:@selector(handleNavigationTransition:)];
    pan.delegate = self;
    [self.view addGestureRecognizer:pan];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    LiveDetailViewController *liveDetailVC = [[LiveDetailViewController alloc]init];
    liveDetailVC.liveItem = _livesArray[indexPath.row];
    [self.navigationController pushViewController:liveDetailVC animated:YES];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _livesArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LiveCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cell_id forIndexPath:indexPath];
    cell.liveItem = _livesArray[indexPath.row];
    return cell;
}

#pragma mark - 获取直播数据
- (void)loadData {
    __weak typeof(self)weakSelf = self;
    CCNetWork *ccnetWork = [[CCNetWork alloc]init];
    [ccnetWork analysisUrl:videoUrl
                  complete:^(NSError *error) {
        
    } returnDic:^(NSDictionary *dict) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        [LiveItem getDataFrom:dict into:strongSelf.livesArray];
        dispatch_main_async_safe(^{
            [strongSelf.liveCollectionView reloadData];
            [strongSelf pullDownLoad];
            [strongSelf pullUpLoad];
        });
    }];
}

#pragma mark - getter
- (UICollectionView *)liveCollectionView{
    if(!_liveCollectionView){
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.minimumInteritemSpacing = 0.0 *KScreenWidth;
        flowLayout.minimumLineSpacing = 0.05 *KScreenHeight;
        flowLayout.itemSize = CGSizeMake(KScreenWidth * 0.45, 0.324 *KScreenHeight);
        _liveCollectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        _liveCollectionView.backgroundColor = [UIColor whiteColor];
        [_liveCollectionView registerClass:[LiveCell class] forCellWithReuseIdentifier:cell_id];
        _liveCollectionView.delegate = self;
        _liveCollectionView.dataSource = self;
    }
    return _liveCollectionView;
}



@end
