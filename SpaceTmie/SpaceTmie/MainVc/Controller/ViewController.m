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

static NSString *const newsCellID = @"newsCell";

@interface ViewController ()<SDCycleScrollViewDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource>

{
    // 请求的新闻数据从第 front 条到第 behind 条
    int front;
    int __block behind;
}

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UITableView *newsTableView;

@property (nonatomic, strong) CCTabView *ccTabView;

@property (nonatomic, strong) CCNetWork *ccNetWork;
@property (nonatomic, strong) CyslePicture *cyclePicture;
@property (nonatomic, strong) NewsModel *newsModel;

@property (nonatomic, strong) NSMutableArray *cycleImgArray;    // 轮播图片字数组
@property (nonatomic, strong) NSMutableArray *cycleTitleArray;  // 轮播图文字数组
@property (nonatomic, strong) NSMutableArray *newsDataSource;   // 首页新闻数组源

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    front = 0;
    behind = 20;
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.title = @"主界面";
    self.navigationItem.backBarButtonItem = backItem;
    
    self.navigationItem.title = @"新闻";
}

- (void)viewWillAppear:(BOOL)animated {
    //[self layoutUI];
    [self addsegmentationView];
    [self cycleData];
    [self pullTabelView];
    [self dropTabelView];
    
    [_ccTabView storeMainBtn];
    self.navigationController.delegate = self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_ccTabView storeMainBtn];
}

#pragma mark - 获取轮播图图片和文字数组 
- (void)cycleData {
    _ccNetWork    = [[CCNetWork alloc]init];
    _cyclePicture = [[CyslePicture alloc]init];
    _newsModel    = [[NewsModel alloc]init];
    
    _cycleTitleArray = [NSMutableArray arrayWithCapacity:5];
    _cycleImgArray   = [NSMutableArray arrayWithCapacity:5];
    _newsDataSource = [NSMutableArray array];

    NSString *urlStr = [NSString stringWithFormat:@"http://c.m.163.com/nc/article/headline/T1348647853363/%d-%d.html",front,behind];
    
    [_ccNetWork analysisUrl:urlStr];
    
    __weak typeof(self)weakSelf = self;
    // 此操作是异步,不会阻塞主线程
    [_ccNetWork getDicBlock:^(NSDictionary *dict) {
        __strong typeof(self)strongSelf = weakSelf;
        
        [strongSelf.newsModel newsData:dict
                            dataSource:strongSelf.newsDataSource];

        [strongSelf.cyclePicture getValueFrom:dict
                           imgArray:strongSelf.cycleImgArray
                         titleArray:strongSelf.cycleTitleArray];
        
        // 主线程更新轮播图和新闻
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf layoutUI:strongSelf.cycleImgArray titleArray:strongSelf.cycleTitleArray];
            [strongSelf.view addSubview:strongSelf.newsTableView];
            [self.view addSubview:self.ccTabView];
            [self.view bringSubviewToFront:self.ccTabView];
        });
    }];
}

#pragma mark - 上拉刷新当前
- (void)pullTabelView {
    front = 0;
    behind = 20;
    __weak typeof(self)weakSelf = self;
    self.newsTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        front = 0;
        behind = 20;
        NSString *urlStr = [NSString stringWithFormat:@"http://c.m.163.com/nc/article/headline/T1348647853363/%d-%d.html",front,behind];
        [_ccNetWork analysisUrl:urlStr];
        [_ccNetWork getDicBlock:^(NSDictionary *dict) {
            __strong typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf.newsModel newsData:dict dataSource:strongSelf.newsDataSource];

            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.newsTableView reloadData];
                [_newsTableView.mj_header endRefreshing];
            });
        }];
    }];
}

#pragma mark - 下拉加载更多
- (void)dropTabelView {
    
    front += 20;
    behind += 20;
    __weak typeof(self)weakSelf = self;
    self.newsTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        front += 20;
        behind += 20;
        NSString *urlStr = [NSString stringWithFormat:@"http://c.m.163.com/nc/article/headline/T1348647853363/%d-%d.html",front,behind];
        [_ccNetWork analysisUrl:urlStr];
        [_ccNetWork getDicBlock:^(NSDictionary *dict) {
            __strong typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf.newsModel newsData:dict dataSource:strongSelf.newsDataSource];
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.newsTableView reloadData];
                [_newsTableView.mj_footer endRefreshing];
            });
        }];
        
    }];
}

#pragma mark - 按钮点击
#pragma mark 橙子按钮
- (void)tangerineClick {
    TangerineVC *tangerVC = [[TangerineVC alloc]init];
    [self.navigationController pushViewController:tangerVC animated:YES];
}

#pragma mark 鲜花按钮
- (void)flowerClick {
    FlowerVC *flowerVC = [[FlowerVC alloc]init];
    [self.navigationController pushViewController:flowerVC animated:YES];
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

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _newsDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsCell *newCell = [tableView dequeueReusableCellWithIdentifier:@"newsCell"];
    if (!newCell) {
        newCell = [[NewsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"newsCell"];
    }
    NewsModel *newsModel = _newsDataSource[indexPath.row];
    [newCell para:newsModel];
    return newCell;
}


#pragma mark - 构建 UI
- (void)layoutUI:(NSMutableArray *)pictureArray
      titleArray:(NSMutableArray *)titleArray
{
    /** 导航栏透明 **/
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    CGRect frame = CGRectMake(0, 64, KScreenWidth, 0.3 *KScreenHeight);
    UIImage *placeholder = [UIImage imageNamed:Img_path(@"placeholder")];
    SDCycleScrollView *scrollView = [SDCycleScrollView cycleScrollViewWithFrame:frame delegate:self placeholderImage:placeholder];
    scrollView.imageURLStringsGroup = pictureArray;
    scrollView.titlesGroup = titleArray;
    scrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    [self.view addSubview:scrollView];
    [self.view addSubview:self.ccTabView];
}

#pragma mark - 轮播图和新闻之间加一张分割图
- (void)addsegmentationView {
    UIImageView *segmentationView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0.3 *KScreenHeight + 64, KScreenWidth, 0.1 *KScreenHeight)];
    NSURL *imageUrl = [NSURL URLWithString:segmentationUrlStr];
    [segmentationView sd_setImageWithURL:imageUrl];
    [self.view addSubview:segmentationView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(KScreenWidth /3, KScreenHeight *0.1/6, KScreenWidth / 3, 0.1 *2 /3 *KScreenHeight)];
    titleLabel.text = @"网易新闻";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [segmentationView addSubview:titleLabel];
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
        _newsTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0.4 *KScreenHeight + 64, KScreenWidth, 0.7 *KScreenHeight) style:UITableViewStylePlain];
        _newsTableView.delegate = self;
        _newsTableView.dataSource = self;
        _newsTableView.rowHeight = 0.487 *KScreenHeight;
    }
    return _newsTableView;
}

@end
