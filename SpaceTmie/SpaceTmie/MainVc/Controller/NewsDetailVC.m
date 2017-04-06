//
//  NewsDetailVC.m
//  SpaceTmie
//
//  Created by CC on 2017/3/30.
//  Copyright © 2017年 CC. All rights reserved.
//

#import "NewsDetailVC.h"
#import "MBProgressHUD.h"
#import <WebKit/WebKit.h>

@interface NewsDetailVC ()<UIGestureRecognizerDelegate,UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, assign) BOOL isLoaded; // 是否第一次加载

@end

@implementation NewsDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webView];

    [self webViewLoad:_urlStr];
    NSLog(@"新闻链接:%@",_urlStr);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES wheelStr:@"加载中..."];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewWillAppear:(BOOL)animated {

    [self slideView];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [_webView stopLoading];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (!_isLoaded) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        _isLoaded = YES;
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

- (void)webViewLoad:(NSString *)urlStr {
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight)];
        _webView.delegate = self;
    }
    return _webView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
