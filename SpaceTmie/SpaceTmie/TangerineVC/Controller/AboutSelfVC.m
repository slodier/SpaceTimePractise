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

@interface AboutSelfVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *myTableView;

@property (nonatomic, strong) NSMutableArray *myDataSource; // 数据源
@property (nonatomic, strong) NSMutableArray *secionArray;  // section 数据源

@end

@implementation AboutSelfVC

static NSString *clearCache = @"清理缓存";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.myTableView];
}

#pragma mark - UITableViewDelegate
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MyHeaderView *headerView = [[MyHeaderView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight /6)];
    headerView.backgroundColor = [UIColor redColor];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return KScreenHeight /6;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 22)];
    view.backgroundColor = [UIColor blueColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 22;
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
    myCell.itemLabel.text = _myDataSource[indexPath.section][indexPath.row];
    return myCell;
}

#pragma mark - Getter
- (UITableView *)myTableView {
    if (!_myTableView) {
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 0.6 *KScreenHeight) style:UITableViewStyleGrouped];
        //_myTableView.rowHeight =
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
    }
    return _myTableView;
}

- (NSMutableArray *)myDataSource {
    if (!_myDataSource) {
        _myDataSource = [NSMutableArray array];
        NSArray *array1 = @[clearCache];
        [_myDataSource addObject:array1];
    }
    return _myDataSource;
}

@end
