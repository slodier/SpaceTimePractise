//
//  LiveDetailViewController.m
//  SpaceTmie
//
//  Created by CC on 2017/7/21.
//  Copyright © 2017年 CC. All rights reserved.
//

#import "LiveDetailViewController.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import <IJKMediaFramework/IJKMediaFramework.h>
#import "MBProgressHUD.h"

@interface LiveDetailViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIImageView *bgImageview;

@property (nonatomic, strong) IJKFFMoviePlayerController *playerController;

@property (nonatomic, assign) BOOL isFullScreen;  // 是否全屏

@end

@implementation LiveDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = _liveItem.creatorNick;
    
    [self layoutUI];
    [self deallive];
}

- (void)viewWillDisappear:(BOOL)animated {
    [_playerController pause];
    [_playerController stop];
    [_playerController shutdown];
    _playerController = NULL;
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerLoadStateDidChangeNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES wheelStr:@"加载中..."];
    
    [self slideView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadStateChanged) name:IJKMPMoviePlayerLoadStateDidChangeNotification object:nil];
}

#pragma mark - 加载状态改变操作
- (void)loadStateChanged {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    _isFullScreen = YES;
    [UIView animateWithDuration:0.6 animations:^{
        self.navigationController.navigationBar.hidden = YES;
    }];
}

#pragma mark - 滑动回到上一层界面
- (void)slideView {
    id target = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:target action:@selector(handleNavigationTransition:)];
    pan.delegate = self;
    [self.view addGestureRecognizer:pan];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

#pragma mark - 点击全屏
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if(_isFullScreen){
        [UIView animateWithDuration:0.6 animations:^{
            self.navigationController.navigationBar.hidden = NO;
        }];
        _isFullScreen = NO;
    }else{
        _isFullScreen = YES;
        [UIView animateWithDuration:0.6 animations:^{
            self.navigationController.navigationBar.hidden = YES;
        }];
    }
}

#pragma mark - 添加直播播放器
- (void)deallive {
    // 设置直播占位图
    NSURL *imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://img.meelive.cn/%@", _liveItem.creatorIcon]];
    [_bgImageview sd_setImageWithURL:imageUrl];
    
    // 拉流地址
    NSURL *steamUrl = [NSURL URLWithString:_liveItem.stream_addr];
    
    // 创建 IJKFFMoivePlayerController: 专门用来直播,传入拉流地址就行了
    IJKFFMoviePlayerController *playerVC = [[IJKFFMoviePlayerController alloc]initWithContentURL:steamUrl withOptions:nil];
    
    playerVC.view.userInteractionEnabled = YES;
    
    // 准备播放
    [playerVC prepareToPlay];
    
    // 强引用,防止被销毁
    _playerController = playerVC;
    
    playerVC.view.frame = [UIScreen mainScreen].bounds;
    
    [self.view insertSubview:playerVC.view atIndex:1];
    
    [playerVC play];
    
}

#pragma mark - 构建 UI
- (void)layoutUI {
    _bgImageview = [[UIImageView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_bgImageview];
    _bgImageview.userInteractionEnabled = YES;
}

@end
