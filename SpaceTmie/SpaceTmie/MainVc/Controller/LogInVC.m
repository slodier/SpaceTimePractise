//
//  LogInVC.m
//  SpaceTmie
//
//  Created by CC on 2017/4/10.
//  Copyright © 2017年 CC. All rights reserved.
//

#import "LogInVC.h"
#import "ViewController.h"
#import "Masonry.h"
#import "CCLogin.h"
#import "UIView+Animations.h"
#import "ViewController.h"

@interface LogInVC ()

@property (nonatomic, strong)  UIImageView *bgView;

@property (nonatomic, strong) UIButton *wxLogInbtn;  // 微信登陆
@property (nonatomic, strong) UIButton *qqLogInbtn;  // qq 登陆
@property (nonatomic, strong) CCLogin *ccLogin;

@end

@implementation LogInVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutUI];
    
    [UIView moveAndGain:_wxLogInbtn destination:CGPointMake(0.2755 *KScreenWidth, 0.65 *KScreenHeight)];
    [UIView moveAndGain:_qqLogInbtn destination:CGPointMake(0.7235 *KScreenWidth, 0.65 *KScreenHeight)];

    [self.navigationController setNavigationBarHidden:YES animated:YES];
    _ccLogin = [[CCLogin alloc]init];
    _ccLogin.mainVC = [[ViewController alloc]init];
    
    [self addTestBtn];
}

#pragma mark - test
- (void)addTestBtn {
    UIButton *testBtn = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    testBtn.backgroundColor = [UIColor redColor];
    [self.view addSubview:testBtn];
    [testBtn addTarget:self action:@selector(testClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)testClick {
    ViewController *vc1 = [[ViewController alloc]init];
   // [self presentViewController:vc1 animated:YES completion:nil];
    
    // 登陆成功直接跳转到主界面,使用设置 rootViewController 方法
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc1];
    keyWindow.rootViewController = nav;
}

#pragma mark - 按钮方法
#pragma mark 微信登陆
- (void)wxLogIn {

    [_ccLogin WXLogin];
}

#pragma mark qq 登陆
- (void)qqLogIn {
    [_ccLogin QQLogin];
}

#pragma mark - 构建 UI
- (void)layoutUI {
    
    _bgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    [self.view addSubview:_bgView];
    _bgView.userInteractionEnabled = YES;
    _bgView.image = [UIImage imageNamed:@"bg.jpeg"];
    
    _wxLogInbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_wxLogInbtn];
    [_wxLogInbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bgView).offset(0.103 *KScreenWidth);
        make.top.equalTo(_bgView).offset(KScreenHeight * 0.65);
        make.size.mas_equalTo(CGSizeMake(0.345 *KScreenWidth, 0.06 *KScreenHeight));
    }];
    [_wxLogInbtn setImage:[UIImage imageNamed:@"icon_wx"] forState:UIControlStateNormal];
    
    _qqLogInbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_qqLogInbtn];
    [_qqLogInbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bgView).offset(0.551 *KScreenWidth);
        make.top.equalTo(_wxLogInbtn);
        make.size.mas_equalTo(_wxLogInbtn);
    }];
    [_qqLogInbtn setImage:[UIImage imageNamed:@"icon_qq"] forState:UIControlStateNormal];
    
    [_wxLogInbtn addTarget:self action:@selector(wxLogIn) forControlEvents:UIControlEventTouchUpInside];
    [_qqLogInbtn addTarget:self action:@selector(qqLogIn) forControlEvents:UIControlEventTouchUpInside];
    
}

@end
