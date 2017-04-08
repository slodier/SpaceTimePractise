//
//  FlowerVC.m
//  SpaceTmie
//
//  Created by CC on 2016/12/25.
//  Copyright © 2016年 CC. All rights reserved.
//

#import "FlowerVC.h"
#import "CCNetWork.h"
#import "VideoModel.h"
#import "WMPlayer.h"
#import "VideoCell.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"

@interface FlowerVC ()<UITableViewDelegate,UITableViewDataSource,WMPlayerDelegate,UIScrollViewDelegate>

{
    int front;
    int behind;
}

@property (nonatomic, strong) UITableView *videoTableView;

@property (nonatomic, strong) CCNetWork *ccNetWork;
@property (nonatomic, strong) VideoModel *videoModel;
@property (nonatomic, strong) WMPlayer *wmPlayer;

@property (nonatomic, strong) NSMutableArray *dataSource; // 数据源

@property (nonatomic, assign) BOOL isHiddenStatusBar; //  记录状态的隐藏显示
@property (nonatomic, assign) BOOL isSmallScreen; // 是否小屏幕播放

@property (nonatomic, strong) NSIndexPath *selectIndexPath; //  记录点击的某一行

@property (nonatomic, strong) VideoCell *currentCell; // 当前 Cell

@end

@implementation FlowerVC

static NSString *videoCellID = @"videoCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"视频";
    self.navigationController.navigationBar.tintColor = KColorWithRGB(83, 167, 176);

    [MBProgressHUD showHUDAddedTo:self.view animated:YES wheelStr:@"加载中..."];
    
    _ccNetWork = [[CCNetWork alloc]init];
    _dataSource = [NSMutableArray array];
    _videoModel = [[VideoModel alloc]init];
    
    front = 0;
    behind = 20;
    _isSmallScreen = NO;
    
    [self.view addSubview:self.videoTableView];

    [self getData];
    [self addMJRefresh];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 获取设备旋转方向的通知,即使关闭了自动旋转,一样可以监测到设备的旋转方向
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    // 旋转屏幕通知
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(onDeviceOrientationChange)
                                                name:UIDeviceOrientationDidChangeNotification
                                              object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self releaseWMPlayer];
}

#pragma mark - 状态栏
- (BOOL)prefersStatusBarHidden {
    if (_wmPlayer) {
        if (_wmPlayer.isFullscreen) {
            return YES;
        }else{
            return NO;
        }
    }
    return NO;
}

#pragma mark - 刷新控件
- (void)addMJRefresh {
    __weak typeof(self)weakSelf = self;
    self.videoTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong typeof(weakSelf)strongSelf = weakSelf;
        front = 0;
        behind = 20;
        [strongSelf.dataSource removeAllObjects];
        [strongSelf getData];
    }];
    
    self.videoTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        __strong typeof(weakSelf)strongSelf = weakSelf;
        front += 20;
        behind += 20;
        [strongSelf getData];
    }];
}

#pragma mark - 旋转屏幕通知
- (void)onDeviceOrientationChange{
    if (_wmPlayer==nil||_wmPlayer.superview==nil){
        return;
    }
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortraitUpsideDown:{
            NSLog(@"第3个旋转方向---电池栏在下");
        }
            break;
        case UIInterfaceOrientationPortrait:{
            NSLog(@"第0个旋转方向---电池栏在上");
            if (_wmPlayer.isFullscreen) {
                if (_isSmallScreen) {
                    // 小屏幕显示
                    dispatch_main_async_safe(^{
                        [self toSmallScreen];
                    });
                }else{
                    // Cell 内显示
                    dispatch_main_async_safe(^{
                        [self toCell];
                    });
                }
            }
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:{
            NSLog(@"第2个旋转方向---电池栏在左");
            _wmPlayer.isFullscreen = YES;
            [self setNeedsStatusBarAppearanceUpdate];
            
            dispatch_main_async_safe(^{
                [self toFullScreenWithInterfaceOrientation:UIInterfaceOrientationLandscapeLeft];
            });
        }
            break;
        case UIInterfaceOrientationLandscapeRight:{
            NSLog(@"第1个旋转方向---电池栏在右");
            _wmPlayer.isFullscreen = YES;
            [self setNeedsStatusBarAppearanceUpdate];
            dispatch_main_async_safe(^{
                [self toFullScreenWithInterfaceOrientation:UIInterfaceOrientationLandscapeLeft];
            });
        }
            break;
        default:
            break;
    }
}

#pragma mark - 按钮点击方法
-(void)startPlayVideo:(UIButton *)sender{
    VideoCell *currentCell = (VideoCell *)[self.videoTableView cellForRowAtIndexPath:_selectIndexPath];
    [currentCell.playBtn.superview bringSubviewToFront:currentCell.playBtn];
    _selectIndexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    NSLog(@"currentIndexPath.row = %ld",_selectIndexPath.row);
    
    UIView *cellView = [sender superview];
    while (![cellView isKindOfClass:[UITableViewCell class]])
    {
        cellView =  [cellView superview];
    }
    self.currentCell = (VideoCell *)cellView;
    
    VideoModel *model = [_dataSource objectAtIndex:sender.tag];
    
    if (_isSmallScreen) {
        [self releaseWMPlayer];
        _isSmallScreen = NO;
    }
    if (_wmPlayer) {
        [self releaseWMPlayer];
    }
    _wmPlayer = [[WMPlayer alloc]initWithFrame:CGRectZero];
    
    _wmPlayer.frame = CGRectMake(0, 0,  KScreenWidth, self.currentCell.bgView.bounds.size.height);
    _wmPlayer.delegate = self;
    _wmPlayer.closeBtnStyle = CloseBtnStyleClose;
    //关闭音量调节的手势
    _wmPlayer.enableVolumeGesture = NO;
    _wmPlayer.titleLabel.text = model.title;
    _wmPlayer.URLString = model.urlStr;
    _wmPlayer.dragEnable = NO;
    
    [self.currentCell.bgView addSubview:_wmPlayer];
    [self.currentCell.bgView bringSubviewToFront:_wmPlayer];
    [self.currentCell.playBtn.superview sendSubviewToBack:self.currentCell.playBtn];
    [_wmPlayer play];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoCell *videoCell = [tableView dequeueReusableCellWithIdentifier:videoCellID];
    if (!videoCell) {
        videoCell = [[VideoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:videoCellID];
    }
    
    VideoModel *model = _dataSource[indexPath.row];
    [videoCell para:model];
    [videoCell.playBtn addTarget:self action:@selector(startPlayVideo:) forControlEvents:UIControlEventTouchUpInside];
    videoCell.playBtn.tag = indexPath.row;
    
    if (_wmPlayer && _wmPlayer.superview) {
        if (indexPath.row == _selectIndexPath.row) {
            [videoCell.playBtn.superview sendSubviewToBack:videoCell.playBtn];
        }else{
            [videoCell.playBtn.superview bringSubviewToFront:videoCell.playBtn];
        }
        
        NSArray *indexPaths = [tableView indexPathsForVisibleRows];
        if (![indexPaths containsObject:_selectIndexPath] && _selectIndexPath) {
            // 复用
            if ([[UIApplication sharedApplication].keyWindow.subviews containsObject:_wmPlayer]) {
                _wmPlayer.hidden = NO;
            }else{
                _wmPlayer.hidden = YES;
                [videoCell.playBtn.superview bringSubviewToFront:videoCell.playBtn];
            }
        }else{
            if ([videoCell.bgView.subviews containsObject:_wmPlayer]) {
                [videoCell.bgView addSubview:_wmPlayer];
                [_wmPlayer play];
                _wmPlayer.hidden = NO;
            }
        }
    }
    return videoCell;
}

#pragma mark - WMPlayerDelegate
- (void)wmplayer:(WMPlayer *)wmplayer clickedCloseButton:(UIButton *)closeBtn {
    NSLog(@"didClickedCloseButton");
    VideoCell *currentCell = (VideoCell *)[self.videoTableView cellForRowAtIndexPath:_selectIndexPath];
    [currentCell.playBtn.superview bringSubviewToFront:currentCell.playBtn];
    [self releaseWMPlayer];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)wmplayer:(WMPlayer *)wmplayer clickedFullScreenButton:(UIButton *)fullScreenBtn {
    if (fullScreenBtn.isSelected) {
        _wmPlayer.isFullscreen = YES;
        [self setNeedsStatusBarAppearanceUpdate];
        [self toFullScreenWithInterfaceOrientation:UIInterfaceOrientationLandscapeLeft];
    }else{
        if (_isSmallScreen) {
            // 小屏幕显示
            dispatch_main_async_safe(^{
                [self toSmallScreen];
            });
        }else{
            dispatch_main_async_safe(^{
                [self toCell];
            });
        }
    }
}

#pragma mark 操作栏隐藏或者显示都会调用此方法
- (void)wmplayer:(WMPlayer *)wmplayer isHiddenTopAndBottomView:(BOOL)isHidden {
    _isHiddenStatusBar = isHidden;
    [self setNeedsStatusBarAppearanceUpdate];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.videoTableView) {
        if (!_wmPlayer) {
            return;
        }
        if (_wmPlayer.superview) {
            CGRect rectInTableView = [self.videoTableView rectForRowAtIndexPath:_selectIndexPath];
            CGRect rectInSuperView = [self.videoTableView convertRect:rectInTableView toView:[self.videoTableView superview]];
            
            if (rectInSuperView.origin.y < -self.currentCell.bgView.frame.size.height ||rectInSuperView.origin.y > KScreenHeight - 64) {//往上拖动
                if ([[UIApplication sharedApplication].keyWindow.subviews containsObject:_wmPlayer] && _isSmallScreen) {
                    _isSmallScreen = YES;
                }else{
                    // 小屏幕显示
                    dispatch_main_async_safe(^{
                        [self toSmallScreen];
                    });
                }
            }else{
                if ([self.currentCell.bgView.subviews containsObject:_wmPlayer]) {
                    
                }else{
                    dispatch_main_async_safe(^{
                        [self toCell];
                    });
                }
            }
        }
    }
}

#pragma mark - 获取数据
- (void)getData {
    __weak typeof(self)weakSelf = self;
    [_ccNetWork analysisUrl:[self urlStr] complete:^(NSError *error) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        if (error) {
            if (strongSelf.videoTableView.mj_header) {
                [strongSelf.videoTableView.mj_header endRefreshing];
            }else if (strongSelf.videoTableView.mj_footer){
                [strongSelf.videoTableView.mj_footer endRefreshing];
            }
            NSLog(@"error:%@",error.localizedDescription);
            [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
        }
    } returnDic:^(NSDictionary *dict) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.dataSource = [strongSelf.videoModel vedioData:dict];
        dispatch_main_async_safe(^{
            if ([strongSelf.videoTableView.mj_header isRefreshing]) {
                [strongSelf.videoTableView.mj_header endRefreshing];
            }else if ([strongSelf.videoTableView.mj_footer isRefreshing]){
                [strongSelf.videoTableView.mj_footer endRefreshing];
            }
            [strongSelf.videoTableView reloadData];
            [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
        });
    }];
}

#pragma mark - 播放状态
#pragma mark 失败
-(void)wmplayerFailedPlay:(WMPlayer *)wmplayer WMPlayerStatus:(WMPlayerState)state{
    NSLog(@"wmplayerDidFailedPlay");
}

#pragma mark 准备
-(void)wmplayerReadyToPlay:(WMPlayer *)wmplayer WMPlayerStatus:(WMPlayerState)state{
    NSLog(@"wmplayerDidReadyToPlay");
}

#pragma mark 结束
- (void)wmplayerFinishedPlay:(WMPlayer *)wmplayer {
    VideoCell *cell = (VideoCell *)[self.videoTableView cellForRowAtIndexPath:_selectIndexPath];
    [cell.playBtn.superview bringSubviewToFront:cell.playBtn];
    [self releaseWMPlayer];
    [_wmPlayer removeFromSuperview];
}

#pragma mark - 点击进入、退出全屏,或者检测到屏幕旋转去调用的方法
- (void)orientation:(UIInterfaceOrientation)orientation {
    // 获取到状态条的方向
    UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
    // 如果当前方向和要旋转的方向一致,那么不作任何操作
    if (currentOrientation == orientation) {
        return;
    }
    // 根据要旋转的方向, remake 限制
    if (orientation == UIInterfaceOrientationPortrait) {
        VideoCell *cell = (VideoCell *)[self.videoTableView cellForRowAtIndexPath:_selectIndexPath];
        [_wmPlayer mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.bgView);
            make.left.equalTo(cell.bgView);
            make.right.equalTo(cell.bgView);
            make.height.equalTo(@(cell.bgView.frame.size.height));
        }];
    }else{
        if (currentOrientation == UIInterfaceOrientationPortrait) {
            [_wmPlayer mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(KScreenHeight));
                make.height.equalTo(@(KScreenWidth));
                make.center.equalTo(_wmPlayer.superview);
            }];
        }
    }
    [[UIApplication sharedApplication]setStatusBarOrientation:orientation animated:NO];
    [UIView beginAnimations:nil context:nil];
    _wmPlayer.transform = CGAffineTransformIdentity;
    _wmPlayer.transform = [WMPlayer getCurrentDeviceOrientation];
    [UIView setAnimationDuration:1];
    [UIView commitAnimations];
}


#pragma mark 拼接 url
- (NSString *)urlStr {
    NSString *tempStr = [NSString stringWithFormat:@"http://c.m.163.com/nc/video/home/%d-%d.html",front,behind];
    return tempStr;
}

#pragma mark - 释放 WMPlayer
- (void)releaseWMPlayer {
    //堵塞主线程
    //    [wmPlayer.player.currentItem cancelPendingSeeks];
    //    [wmPlayer.player.currentItem.asset cancelLoading];
    [_wmPlayer pause];
    
    [_wmPlayer removeFromSuperview];
    [_wmPlayer.playerLayer removeFromSuperlayer];
    [_wmPlayer.player replaceCurrentItemWithPlayerItem:nil];
    _wmPlayer.player = nil;
    _wmPlayer.currentItem = nil;
    //释放定时器，否侧不会调用WMPlayer中的dealloc方法
    [_wmPlayer.autoDismissTimer invalidate];
    _wmPlayer.autoDismissTimer = nil;
    
    _wmPlayer.playOrPauseBtn = nil;
    _wmPlayer.playerLayer = nil;
    _wmPlayer = nil;
}

#pragma mark - change WMPlayer
#pragma mark 把播放器wmPlayer对象放到cell上，同时更新约束
-(void)toCell{
    _wmPlayer.dragEnable = NO;
    VideoCell *currentCell = (VideoCell *)[self.videoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_selectIndexPath.row inSection:0]];
    [_wmPlayer removeFromSuperview];
    [UIView animateWithDuration:0.7f animations:^{
        _wmPlayer.transform = CGAffineTransformIdentity;
        _wmPlayer.frame = CGRectMake(0, 0,  KScreenWidth, self.currentCell.bgView.bounds.size.height);
        _wmPlayer.playerLayer.frame =  _wmPlayer.bounds;
        [currentCell.bgView addSubview:_wmPlayer];
        [currentCell.bgView bringSubviewToFront:_wmPlayer];
        [_wmPlayer.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_wmPlayer).with.offset(0);
            make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width);
            make.height.mas_equalTo(_wmPlayer.frame.size.height);
        }];
        if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
            _wmPlayer.effectView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-155/2, [UIScreen mainScreen].bounds.size.height/2-155/2, 155, 155);
        }else{
            //            wmPlayer.lightView.frame = CGRectMake(kScreenWidth/2-155/2, kScreenHeight/2-155/2, 155, 155);
        }
        
        [_wmPlayer.FF_View  mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(CGPointMake([UIScreen mainScreen].bounds.size.width/2-180, _wmPlayer.frame.size.height/2-144));
            make.height.mas_equalTo(60);
            make.width.mas_equalTo(120);
        }];
        
        [_wmPlayer.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_wmPlayer).with.offset(0);
            make.right.equalTo(_wmPlayer).with.offset(0);
            make.height.mas_equalTo(50);
            make.bottom.equalTo(_wmPlayer).with.offset(0);
        }];
        [_wmPlayer.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_wmPlayer).with.offset(0);
            make.right.equalTo(_wmPlayer).with.offset(0);
            make.height.mas_equalTo(70);
            make.top.equalTo(_wmPlayer).with.offset(0);
        }];
        [_wmPlayer.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_wmPlayer.topView).with.offset(45);
            make.right.equalTo(_wmPlayer.topView).with.offset(-45);
            make.center.equalTo(_wmPlayer.topView);
            make.top.equalTo(_wmPlayer.topView).with.offset(0);
        }];
        [_wmPlayer.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_wmPlayer).with.offset(5);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(30);
            make.top.equalTo(_wmPlayer).with.offset(20);
        }];
        [_wmPlayer.loadFailedLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_wmPlayer);
            make.width.equalTo(_wmPlayer);
            make.height.equalTo(@30);
        }];
    }completion:^(BOOL finished) {
        _wmPlayer.isFullscreen = NO;
        [self setNeedsStatusBarAppearanceUpdate];
        _isSmallScreen = NO;
        _wmPlayer.fullScreenBtn.selected = NO;
        _wmPlayer.FF_View.hidden = YES;
    }];
}

#pragma mark 全屏
-(void)toFullScreenWithInterfaceOrientation:(UIInterfaceOrientation )interfaceOrientation{
    [_wmPlayer removeFromSuperview];
    _wmPlayer.dragEnable = NO;
    _wmPlayer.transform = CGAffineTransformIdentity;
    if (interfaceOrientation==UIInterfaceOrientationLandscapeLeft) {
        _wmPlayer.transform = CGAffineTransformMakeRotation(-M_PI_2);
    }else if(interfaceOrientation==UIInterfaceOrientationLandscapeRight){
        _wmPlayer.transform = CGAffineTransformMakeRotation(M_PI_2);
    }
    _wmPlayer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    _wmPlayer.playerLayer.frame =  CGRectMake(0,0, [UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width);
    
    [_wmPlayer.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.height);
        make.height.mas_equalTo([UIScreen mainScreen].bounds.size.width);
        make.left.equalTo(_wmPlayer).with.offset(0);
        make.top.equalTo(_wmPlayer).with.offset(0);
    }];
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        _wmPlayer.effectView.frame = CGRectMake([UIScreen mainScreen].bounds.size.height/2-155/2, [UIScreen mainScreen].bounds.size.width/2-155/2, 155, 155);
    }else{
        //        wmPlayer.lightView.frame = CGRectMake(kScreenHeight/2-155/2, kScreenWidth/2-155/2, 155, 155);
    }
    [_wmPlayer.FF_View  mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_wmPlayer).with.offset([UIScreen mainScreen].bounds.size.height/2-120/2);
        make.top.equalTo(_wmPlayer).with.offset([UIScreen mainScreen].bounds.size.width/2-60/2);
        make.height.mas_equalTo(60);
        make.width.mas_equalTo(120);
    }];
    [_wmPlayer.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(50);
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.height);
        make.bottom.equalTo(_wmPlayer.contentView).with.offset(0);
    }];
    
    [_wmPlayer.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(70);
        make.left.equalTo(_wmPlayer).with.offset(0);
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.height);
    }];
    
    [_wmPlayer.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_wmPlayer.topView).with.offset(5);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
        make.top.equalTo(_wmPlayer).with.offset(20);
    }];
    
    [_wmPlayer.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_wmPlayer.topView).with.offset(45);
        make.right.equalTo(_wmPlayer.topView).with.offset(-45);
        make.center.equalTo(_wmPlayer.topView);
        make.top.equalTo(_wmPlayer.topView).with.offset(0);
    }];
    
    [_wmPlayer.loadFailedLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_wmPlayer).with.offset(0);
        make.top.equalTo(_wmPlayer).with.offset([UIScreen mainScreen].bounds.size.width/2-30/2);
        make.height.equalTo(@30);
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.height);
    }];
    
    [_wmPlayer.loadingView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_wmPlayer).with.offset([UIScreen mainScreen].bounds.size.height/2-22/2);
        make.top.equalTo(_wmPlayer).with.offset([UIScreen mainScreen].bounds.size.width/2-22/2);
        make.height.mas_equalTo(22);
        make.width.mas_equalTo(22);
    }];
    
    [self.view addSubview:_wmPlayer];
    [[UIApplication sharedApplication].keyWindow addSubview:_wmPlayer];
    _wmPlayer.fullScreenBtn.selected = YES;
    _wmPlayer.isFullscreen = YES;
    _wmPlayer.FF_View.hidden = YES;
}

#pragma mark 小屏幕
- (void)toSmallScreen{
    _wmPlayer.dragEnable = YES;
    [_wmPlayer removeFromSuperview];
    [UIView animateWithDuration:0.7f animations:^{
        _wmPlayer.transform = CGAffineTransformIdentity;
        _wmPlayer.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2,[UIScreen mainScreen].bounds.size.height-49-([UIScreen mainScreen].bounds.size.width/2)*0.75, [UIScreen mainScreen].bounds.size.width/2, ([UIScreen mainScreen].bounds.size.width/2)*0.75);
        _wmPlayer.freeRect = CGRectMake(0,64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64-49);
        _wmPlayer.playerLayer.frame =  _wmPlayer.bounds;
        [[UIApplication sharedApplication].keyWindow addSubview:_wmPlayer];
        [_wmPlayer.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width/2);
            make.height.mas_equalTo(([UIScreen mainScreen].bounds.size.width/2)*0.75);
            make.left.equalTo(_wmPlayer).with.offset(0);
            make.top.equalTo(_wmPlayer).with.offset(0);
        }];
        [_wmPlayer.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_wmPlayer).with.offset(0);
            make.right.equalTo(_wmPlayer).with.offset(0);
            make.height.mas_equalTo(40);
            make.bottom.equalTo(_wmPlayer).with.offset(0);
        }];
        [_wmPlayer.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_wmPlayer).with.offset(0);
            make.right.equalTo(_wmPlayer).with.offset(0);
            make.height.mas_equalTo(40);
            make.top.equalTo(_wmPlayer).with.offset(0);
        }];
        [_wmPlayer.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_wmPlayer.topView).with.offset(45);
            make.right.equalTo(_wmPlayer.topView).with.offset(-45);
            make.center.equalTo(_wmPlayer.topView);
            make.top.equalTo(_wmPlayer.topView).with.offset(0);
        }];
        [_wmPlayer.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_wmPlayer).with.offset(5);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(30);
            make.top.equalTo(_wmPlayer).with.offset(5);
        }];
        [_wmPlayer.loadFailedLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_wmPlayer);
            make.width.equalTo(_wmPlayer);
            make.height.equalTo(@30);
        }];
        
    }completion:^(BOOL finished) {
        _wmPlayer.isFullscreen = NO;
        [self setNeedsStatusBarAppearanceUpdate];
        _wmPlayer.fullScreenBtn.selected = NO;
        _isSmallScreen = YES;
        _wmPlayer.FF_View.hidden = YES;
        [[UIApplication sharedApplication].keyWindow bringSubviewToFront:_wmPlayer];
    }];
}

#pragma mark - getter
- (UITableView *)videoTableView {
    if (!_videoTableView) {
        _videoTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) style:UITableViewStylePlain];
        _videoTableView.delegate = self;
        _videoTableView.dataSource = self;
        _videoTableView.rowHeight = 0.372 *KScreenHeight;
    }
    return _videoTableView;
}

@end
