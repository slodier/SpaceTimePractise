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
#import "CCTabView.h"
#import "TangerineVC.h"
#import "CardModel.h"
#import "BombTransitioning.h"
#import "FlowerVC.h"
#import "CCNetWork.h"
#import "CyslePicture.h"
#import "NewsCell.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "StoreNews.h"
#import "NewsDetailVC.h"
#import "CycleImgModel.h"
#import "Reachability.h"

static NSString *const newsCellID = @"newsCell";

@interface ViewController ()<SDCycleScrollViewDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource>

{
    // 请求的新闻数据从第 front 条到第 behind 条
    int __block front;
    int __block behind;
    
    BOOL _isPullComplete;   // 上拉刷新是否完成
    BOOL _isDropComplete;   // 下拉刷新是否完成
    BOOL __block _isOnline; // 是否在线
}

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UITableView *newsTableView;

@property (nonatomic, strong) UIImageView *segmentationView;  // 分割图

@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong) CCTabView *ccTabView;

@property (nonatomic, strong) CCNetWork *ccNetWork;
@property (nonatomic, strong) CyslePicture *cyclePicture;
@property (nonatomic, strong) NewsModel *newsModel;

@property (nonatomic, strong) NSMutableArray *cycleImgArray;    // 轮播图片字数组
@property (nonatomic, strong) NSMutableArray *cycleTitleArray;  // 轮播图文字数组
@property (nonatomic, strong) NSMutableArray *newsDataSource;   // 首页新闻数组源

@property (nonatomic, strong) Reachability *reach;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    front = 0;
    behind = 20;
    _isPullComplete = YES;
    _isDropComplete = YES;
    
    _reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    
    [self.view addSubview:self.ccTabView];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.title = @"新闻";
    self.navigationItem.backBarButtonItem = backItem;
    self.navigationItem.title = @"新闻";
    self.navigationController.navigationBar.backgroundColor = [UIColor lightGrayColor];
}

- (void)viewWillAppear:(BOOL)animated {
    
    if (_cycleScrollView) {
        [_cycleScrollView adjustWhenControllerViewWillAppera];
    }
    
    [self addsegmentationView];

    [_ccTabView storeMainBtn];
    self.navigationController.delegate = self;
    // 防止 tableView 自动下移 64 px
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.newsTableView];
    [self.view bringSubviewToFront:self.ccTabView];
}

- (void)viewDidAppear:(BOOL)animated {
    [self cycleData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [_reach stopNotifier];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_ccTabView storeMainBtn];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //NSLog(@"%@",NSStringFromCGPoint(scrollView.contentOffset));
    [_ccTabView storeMainBtn];
}

#pragma mark - 获取轮播图图片和文字数组 
- (void)cycleData {
    
    _ccNetWork    = [[CCNetWork alloc]init];
    _cyclePicture = [[CyslePicture alloc]init];
    _newsModel    = [[NewsModel alloc]init];
    
    _cycleTitleArray = [NSMutableArray arrayWithCapacity:5];
    _cycleImgArray   = [NSMutableArray arrayWithCapacity:5];
    _newsDataSource  = [NSMutableArray array];

    NSString *urlStr = [NSString stringWithFormat:@"http://c.m.163.com/nc/article/headline/T1348647853363/%d-%d.html",front,behind];
    
    __weak typeof(self)weakSelf = self;
    [_ccNetWork analysisUrl:urlStr complete:^(NSError *error) {
        __strong typeof(weakSelf)strongSelf = weakSelf;

        if (error) {
            StoreNews *storeNew = [[StoreNews alloc]init];
            [strongSelf.newsDataSource removeAllObjects];
            
            dispatch_queue_t queue = dispatch_queue_create("com.news.cc", NULL);
            dispatch_async(queue, ^{
                strongSelf.newsDataSource = [storeNew selectTable];
                
                CycleImgModel *cycleImgModel = [[CycleImgModel alloc]init];
                [strongSelf.cycleImgArray removeAllObjects];
                [strongSelf.cycleTitleArray removeAllObjects];
                
                NSMutableArray *cycleData = [cycleImgModel selectImageData];
                strongSelf.cycleImgArray   = cycleData[0];
                strongSelf.cycleTitleArray = cycleData[1];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [strongSelf.newsTableView reloadData];
                    [strongSelf layoutUI:strongSelf.cycleImgArray titleArray:strongSelf.cycleTitleArray];
                });
            });
        }
    } returnDic:^(NSDictionary *dict) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.newsDataSource removeAllObjects];
        [strongSelf.newsModel newsData:dict
                            dataSource:strongSelf.newsDataSource];
        
        [strongSelf.cyclePicture getValueFrom:dict
                                     imgArray:strongSelf.cycleImgArray
                                   titleArray:strongSelf.cycleTitleArray];
        
        // 主线程更新轮播图和新闻
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf layoutUI:strongSelf.cycleImgArray titleArray:strongSelf.cycleTitleArray];
            [strongSelf.newsTableView reloadData];
            [strongSelf dropTabelView];
            [strongSelf pullTabelView];
        });
    }];
}

#pragma mark - 上拉刷新当前
- (void)pullTabelView {

    if (_isPullComplete) {
        __weak typeof(self)weakSelf = self;
        self.newsTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            front = 0;
            behind = 20;
            NSString *urlStr = [NSString stringWithFormat:@"http://c.m.163.com/nc/article/headline/T1348647853363/%d-%d.html",front,behind];
            
            [_ccNetWork analysisUrl:urlStr complete:^(NSError *error) {
                __strong typeof(weakSelf)strongSelf = weakSelf;

                if (error) {
                    [strongSelf.newsTableView.mj_header endRefreshing];
                }
            } returnDic:^(NSDictionary *dict) {
                __strong typeof(weakSelf)strongSelf = weakSelf;
                [strongSelf.newsDataSource removeAllObjects];
                [strongSelf.newsModel newsData:dict dataSource:strongSelf.newsDataSource];

                dispatch_main_async_safe(^{
                    [strongSelf.newsTableView reloadData];
                    [strongSelf.newsTableView.mj_header endRefreshing];
                    _isPullComplete = NO;
                });
            }];
        }];
    }
}

#pragma mark - 下拉加载更多
- (void)dropTabelView {
    
    if (_isDropComplete) {
        __weak typeof(self)weakSelf = self;
        self.newsTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            front += 20;
            behind += 20;
            NSString *urlStr = [NSString stringWithFormat:@"http://c.m.163.com/nc/article/headline/T1348647853363/%d-%d.html",front,behind];
            
            [_ccNetWork analysisUrl:urlStr complete:^(NSError *error) {
                __strong typeof(weakSelf)strongSelf = weakSelf;
                if (error) {
                    [strongSelf.newsTableView.mj_footer endRefreshing];
                }
            } returnDic:^(NSDictionary *dict) {
                __strong typeof(weakSelf)strongSelf = weakSelf;
                [strongSelf.newsModel newsData:dict dataSource:strongSelf.newsDataSource];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [strongSelf.newsTableView reloadData];
                    [strongSelf.newsTableView.mj_footer endRefreshing];
                    _isDropComplete = NO;
                });
            }];
        }];
    
    }else{
        
        [self.newsTableView.mj_footer endRefreshing];
    }
}

#pragma mark - 按钮点击
#pragma mark 橙子按钮
- (void)tangerineClick {
    TangerineVC *tangerVC = [[TangerineVC alloc]init];
    [self.navigationController pushViewController:tangerVC animated:YES];
}

#pragma mark 鲜花按钮
- (void)flowerClick {
    __weak typeof(self)weakSelf = self;
    _reach.unreachableBlock = ^(Reachability *reachability) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        
    };
    
    _reach.reachableBlock = ^(Reachability *reachability) {
        __strong typeof(self)strongSelf = weakSelf;
        FlowerVC *flowerVC = [[FlowerVC alloc]init];
        
        dispatch_main_async_safe(^{
            [strongSelf.navigationController pushViewController:flowerVC animated:YES];
        });
    };
    [_reach startNotifier];
}

#pragma mark 金币按钮
- (void)chipClick {
    
}

#pragma mark - UINavigationControllerDelegate
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    BombTransitioning *cardModel = [[BombTransitioning alloc]init];
    return cardModel;
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        if (!_cycleScrollView.timer) {
            [_cycleScrollView setupTimer];
        }
        return _cycleScrollView;

    }else if (section == 1){
       // return _segmentationView;
        return nil;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
       return 0.3 *KScreenHeight;
    }else if (section == 1){
       //return 0.1 *KScreenHeight;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
//        return 0.487 *KScreenHeight;
        if (_newsDataSource.count >= 1) {
            NewsModel *newModel = _newsDataSource[indexPath.row];
            return [_newsModel cellHeightArrayNewsArray:newModel];
        }else{
            return 0.493 *KScreenHeight;
        }
    }
    return 0;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return _newsDataSource.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        NewsCell *newCell = [tableView dequeueReusableCellWithIdentifier:newsCellID];
        if (!newCell) {
            newCell = [[NewsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:newsCellID];
        }
        if (_newsDataSource.count > 0) {
            NewsModel *newsModel = _newsDataSource[indexPath.row];
            [newCell para:newsModel];
        }
        return newCell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        NewsModel *newModel = _newsDataSource[indexPath.row];
        NewsDetailVC *newDetainVC = [[NewsDetailVC alloc]init];
        newDetainVC.urlStr = newModel.urlStr;
        if (newModel.urlStr.length > 5) {
            [self.navigationController pushViewController:newDetainVC animated:YES];
        }
    }
}

#pragma mark - 构建 UI
- (void)layoutUI:(NSMutableArray *)pictureArray
      titleArray:(NSMutableArray *)titleArray
{
    /** 导航栏透明 **/
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = [UIImage new];
//    self.navigationController.navigationBar.translucent = YES;
    
    CGRect frame = CGRectMake(0, 64, KScreenWidth, 0.3 *KScreenHeight);
    UIImage *placeholder = [UIImage imageNamed:Img_path(@"placeholder")];
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:frame delegate:self placeholderImage:placeholder];
    
    _cycleScrollView.imageURLStringsGroup = pictureArray;
    _cycleScrollView.titlesGroup = titleArray;
    _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
}

#pragma mark - 轮播图和新闻之间加一张分割图
- (void)addsegmentationView {
    _segmentationView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0.3 *KScreenHeight + 64, KScreenWidth, 0.1 *KScreenHeight)];
    NSURL *imageUrl = [NSURL URLWithString:segmentationUrlStr];
    [_segmentationView sd_setImageWithURL:imageUrl];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(KScreenWidth /3, KScreenHeight *0.1/6, KScreenWidth / 3, 0.1 *2 /3 *KScreenHeight)];
    titleLabel.text = @"网易新闻";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [_segmentationView addSubview:titleLabel];
}

#pragma mark - getter 
- (CCTabView *)ccTabView {
    if (!_ccTabView) {
        _ccTabView = [[CCTabView alloc]initWithFrame:CGRectMake(0, 0.922 *KScreenHeight, KScreenWidth, 0.156 *KScreenHeight)];
        [_ccTabView.tangerineBtn addTarget:self action:@selector(tangerineClick) forControlEvents:UIControlEventTouchUpInside];
        [_ccTabView.flowerBtn addTarget:self action:@selector(flowerClick) forControlEvents:UIControlEventTouchUpInside];
        [_ccTabView.chipBtn addTarget:self action:@selector(chipClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ccTabView;
}

- (UITableView *)newsTableView {
    if (!_newsTableView) {
        _newsTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight - 64) style:UITableViewStyleGrouped];
        _newsTableView.delegate = self;
        _newsTableView.dataSource = self;
    }
    return _newsTableView;
}

@end
