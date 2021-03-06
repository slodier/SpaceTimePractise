//
//  AboutSelfVC.m
//  SpaceTmie
//
//  Created by CC on 2017/3/16.
//  Copyright © 2017年 CC. All rights reserved.
//

#import "AboutSelfVC.h"
#import "MyTableViewCell.h"
#import "MyHeaderView.h"
#import "CCUserDefaults.h"
#import "FileRelate.h"
#import "MBProgressHUD.h"
#import "ShareView.h"
#import "Masonry.h"
#import "UIView+Animations.h"
#import "CCKeychain.h"
#import "LogInVC.h"
#import "TipsView.h"

@interface AboutSelfVC ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITableView *myTableView;

@property (nonatomic, strong) NSMutableArray *myDataSource; // 数据源
@property (nonatomic, strong) NSMutableArray *secionArray;  // section 数据源

@property (nonatomic, strong) MyHeaderView *headerView; // headerView
@property (nonatomic, strong) ShareView *shareView;  // 分享图层
@property (nonatomic, strong) TipsView *tipsView;    // 提示视图

@property (nonatomic, strong) FileRelate *fileRelate;

@end

@implementation AboutSelfVC

static NSString *clearCache = @"清理缓存";
static NSString *shareLink = @"分享";
static NSString *logOut = @"注销";

static NSString *myCellID = @"myCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.myTableView];
    
    _fileRelate = [[FileRelate alloc]init];
}

- (void)viewWillAppear:(BOOL)animated {
    [self slideView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(removeShareView)
                                                name:UIApplicationWillEnterForegroundNotification
                                              object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - 回到前台通知方法
- (void)removeShareView {
    UIView *currentView = (ShareView *)[self.view viewWithTag:100];
    if (currentView) {
        [self closeShareView];
    }
}

#pragma mark - 滑动返回
- (void)slideView {
    
    id target = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:target action:@selector(handleNavigationTransition:)];
    pan.delegate = self;
    [self.view addGestureRecognizer:pan];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

#pragma mark 分享视图
- (void)addShareView {
    if (!_shareView) {
        _shareView = [[ShareView alloc]initWithFrame:CGRectZero];
        _shareView.tag = 100;
    }
    [self.view addSubview:_shareView];
    [_shareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    [_shareView.cancelBtn addTarget:self action:@selector(closeShareView) forControlEvents:UIControlEventTouchUpInside];
    
    [UIView moveAndGain:_shareView destination:CGPointMake(KScreenWidth / 2, KScreenHeight / 2)];
}

- (void)closeShareView {
    [UIView animateWithDuration:0.3 animations:^{
        _shareView.bounds = CGRectMake(0, - KScreenHeight, KScreenWidth, KScreenHeight);
    }completion:^(BOOL finished) {
        [_shareView removeFromSuperview];
        _shareView = nil;
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (_shareView) {
        [self closeShareView];
    }
}

#pragma mark - headerView 头像按钮点击事件
#pragma mark - 打开本地图册
- (void)openAlbum {
    [self openImagePickerControllerWithType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (void)openImagePickerControllerWithType:(UIImagePickerControllerSourceType)type
{
    // 判断设备是否支持
    if (![UIImagePickerController isSourceTypeAvailable:type]) {
        return;
    }
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc]init];
    imgPicker.sourceType = type;
    imgPicker.delegate = self;
    [self presentViewController:imgPicker animated:YES completion:nil];
}

#pragma mark - UINavigationControllerDelegate, UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    _headerView.avatarView.image = image;
    [CCUserDefaults saveImage:image];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDelegate
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        _headerView = [[MyHeaderView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight /6)];
        [_headerView.iconButton addTarget:self action:@selector(openAlbum) forControlEvents:UIControlEventTouchUpInside];
        return _headerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return KScreenHeight /6;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 22)];
    view.backgroundColor = KColorWithRGB(204, 204, 204);
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0 *KScreenHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        MyTableViewCell *selectCell = (MyTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        if (![selectCell.cacheLabel.text isEqualToString:@"0"]) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES wheelStr:@"清理缓存中..."];
        }
        
        if ([_fileRelate deleteCacheFile]) {
            MyTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.cacheLabel.text = @"0";
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [_myTableView addSubview:self.tipsView];
            _tipsView.tipsLabel.text = @"缓存清理成功";
            [_tipsView addAnimations];
        }
    }else if(indexPath.section == 1){
        // share code
        [self addShareView];
        
    }else if (indexPath.section == 2){
        // 注销,删除本地微信和 qq 凭证
        [CCKeychain delete:KEY_WX_PASSWORD];
        [CCKeychain delete:KEY_QQ_PASSWORD];
        LogInVC *logInVC = [[LogInVC alloc]init];
        [self presentViewController:logInVC animated:YES completion:nil];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.myDataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.myDataSource[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyTableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:myCellID];
    if (!myCell) {
        myCell = [[MyTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellID];
    }
    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
    myCell.itemLabel.text = _myDataSource[indexPath.section][indexPath.row];
    [myCell adaptStyle];
    return myCell;
}

#pragma mark - Getter
- (UITableView *)myTableView {
    if (!_myTableView) {
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) style:UITableViewStyleGrouped];
        //_myTableView.rowHeight =
        _myTableView.backgroundColor = [UIColor whiteColor];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
    }
    return _myTableView;
}

- (NSMutableArray *)myDataSource {
    if (!_myDataSource) {
        _myDataSource = [NSMutableArray array];
        NSArray *array1 = @[clearCache];
        NSArray *array2 = @[shareLink];
        NSArray *array3 = @[logOut];
        [_myDataSource addObject:array1];
        [_myDataSource addObject:array2];
        [_myDataSource addObject:array3];
    }
    return _myDataSource;
}

- (TipsView *)tipsView {
    if (!_tipsView) {
        _tipsView = [[TipsView alloc]initWithFrame:self.view.bounds];
    }
    return _tipsView;
}

@end
