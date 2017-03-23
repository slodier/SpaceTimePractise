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

@interface AboutSelfVC ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong) UITableView *myTableView;

@property (nonatomic, strong) NSMutableArray *myDataSource; // 数据源
@property (nonatomic, strong) NSMutableArray *secionArray;  // section 数据源

@property (nonatomic, strong) MyHeaderView *headerView; // headerView

@end

@implementation AboutSelfVC

static NSString *clearCache = @"清理缓存";
static NSString *shareLink = @"分享";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.myTableView];
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

#pragma mark - UITableViewDataSource 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.myDataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.myDataSource[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyTableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!myCell) {
        myCell = [[MyTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
    myCell.itemLabel.text = _myDataSource[indexPath.section][indexPath.row];
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
        [_myDataSource addObject:array1];
        [_myDataSource addObject:array2];
    }
    return _myDataSource;
}

@end
