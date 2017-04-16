//
//  WeatherController.m
//  SpaceTmie
//
//  Created by CC on 2017/3/23.
//  Copyright © 2017年 CC. All rights reserved.
//

#import "WeatherController.h"
#import <CoreLocation/CoreLocation.h>
#import "MBProgressHUD.h"
#import "Reachability.h"

@interface WeatherController ()<CLLocationManagerDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate>

{
    NSString *currentCity;
}

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, assign) BOOL isLocate;

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) Reachability *reach;

@property (nonatomic, strong) UIButton *backBtn; // 返回按钮

@end

@implementation WeatherController

static NSString *wheelStr = @"加载数据中...";

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    _reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 20, KScreenWidth, KScreenHeight)];
    _webView.scrollView.delegate = self;
    [self.view addSubview:_webView];

    [_webView addSubview:self.backBtn];
    
    [self locatedUser];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self slideView];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.locationManager stopUpdatingLocation];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 隐藏返回按钮,小把戏...
    CGFloat offY = scrollView.contentOffset.y;
    if (offY > 0.101 *KScreenHeight) {
        [UIView animateWithDuration:0.5 animations:^{
            _backBtn.alpha = 0;
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            _backBtn.alpha = 1;
        }];
    }
}

#pragma mark - 判断有无网络,没有不执行
- (void)isOnline {
    __weak typeof(self)weakSelf = self;
    _reach.reachableBlock = ^(Reachability *reachability) {
        dispatch_queue_t queue = dispatch_queue_create("com.weather.cc", NULL);
        dispatch_async(queue, ^{
            [weakSelf locatedUser];
        });
    };
}

#pragma mark - 滑动返回
- (void)slideView {
    
    id target = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:target action:@selector(handleNavigationTransition:)];
    pan.delegate = self;
    [self.view addGestureRecognizer:pan];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

#pragma mark - 先确认有没有开启定位权限
- (void)locatedUser {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES wheelStr:wheelStr];
    
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        NSLog(@"requestAlwaysAuthorization");
        [self.locationManager requestAlwaysAuthorization];
    }
    
    [self.locationManager startUpdatingLocation];
    _isLocate = YES;

    NSLog(@"start gps");
}

#pragma mark - CLLocationManagerDelegate
#pragma mark 定位成功
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    [manager stopUpdatingLocation];
    _isLocate = YES;
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    
    //反编码
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            CLPlacemark *placeMark = placemarks[0];
            currentCity = placeMark.locality;
            if (!currentCity) {
                currentCity = @"无法定位当前城市";
            }
            NSLog(@"省份:%@",placeMark.administrativeArea); //当前的省份
            NSLog(@"城市:%@",currentCity); //当前的城市
            
            dispatch_queue_t queue = dispatch_queue_create("com.weather.cc", NULL);
            dispatch_async(queue, ^{
                
                if (_isLocate) {
                    [self getWeatherDataBy:placeMark.administrativeArea city:currentCity];
                }
            });
        }else if (error == nil && placemarks.count == 0) {
            
            NSLog(@"No location and error return");
        }else if (error) {
            
            NSLog(@"location error: %@ ",error);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];
}

#pragma mark 失败
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    NSLog(@"location fail error:%@",error.localizedDescription);
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)getWeatherDataBy:(NSString *)province city:(NSString *)city {
    
    NSURL *url = [self removeProvince:province city:city];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    __weak typeof(self)weakSelf = self;
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        if (error) {
            NSLog(@"JSON error:%@",error);
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
            });
        }else{
            NSDictionary *str = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSLog(@"JSONStr:%@",str[@"chinaWeatherUrl"]);
            NSURL *url = [NSURL URLWithString:str[@"chinaWeatherUrl"]];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            [strongSelf.webView loadRequest:request];
            
            dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 1 *NSEC_PER_SEC);
            dispatch_after(time, dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
            });
        }
    }];
    [dataTask resume];
    _isLocate = NO;
}

- (void)locationManager:(CLLocationManager *)manager didFinishDeferredUpdatesWithError:(NSError *)error {
    NSLog(@"121321321");
}

#pragma mark - 判断是否包含省、市字符
- (NSURL *)removeProvince:(NSString *)province city:(NSString *)city {
    if ([province containsString:@"省"]) {
        
        province = [province stringByReplacingOccurrencesOfString:@"省" withString:@""];
    } else if ([province containsString:@"市"]){
        province = [province stringByReplacingOccurrencesOfString:@"市" withString:@""];
    }
    
    if ([city containsString:@"市"]) {
        city = [city stringByReplacingOccurrencesOfString:@"市" withString:@""];
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"http://c.3g.163.com/nc/weather/%@|%@.html",province,city];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    return url;
}

#pragma mark - 按钮点击
- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - getter
- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.frame = CGRectMake(0.026 *KScreenWidth, 0.026 *KScreenWidth, 0.1755 *KScreenWidth, 0.075 *KScreenHeight);
        [_backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
        [_backBtn setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    }
    return _backBtn;
}

@end
