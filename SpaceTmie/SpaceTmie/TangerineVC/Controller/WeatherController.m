//
//  WeatherController.m
//  SpaceTmie
//
//  Created by CC on 2017/3/23.
//  Copyright © 2017年 CC. All rights reserved.
//

#import "WeatherController.h"
#import <CoreLocation/CoreLocation.h>

@interface WeatherController ()<CLLocationManagerDelegate>

{
    NSString *currentCity;
}

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation WeatherController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self locatedUser];
}

#pragma mark - 先确认有没有开启定位权限
- (void)locatedUser {
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        NSLog(@"requestAlwaysAuthorization");
        [self.locationManager requestAlwaysAuthorization];
    }
    
    [self.locationManager startUpdatingLocation];
    NSLog(@"start gps");
}

#pragma mark - CLLocationManagerDelegate
#pragma mark 定位成功
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    [manager stopUpdatingLocation];
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
                [self getWeatherDataBy:placeMark.administrativeArea city:currentCity];
            });
        }else if (error == nil && placemarks.count == 0) {
            
            NSLog(@"No location and error return");
        }else if (error) {
            
            NSLog(@"location error: %@ ",error);
        }
    }];
}

- (void)getWeatherDataBy:(NSString *)province city:(NSString *)city {
    // 去除  xx市的市
    [self removeProvince:province city:city];
    
    NSString *urlStr = [NSString stringWithFormat:@"http://c.3g.163.com/nc/weather/%@|%@.html",province,city];
    // url 中不能包含中文,先转码
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"JSON error:%@",error);
        }else{
            NSString *str = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSLog(@"JSONStr:%@",str);
        }
    }];
    [dataTask resume];
}

#pragma mark - 判断是否包含省、市字符
- (void)removeProvince:(NSString *)province city:(NSString *)city {
    if ([province containsString:@"省"]) {
        province = [province stringByReplacingOccurrencesOfString:@"省" withString:@""];
    } else if ([province containsString:@"市"]){
        province = [province stringByReplacingOccurrencesOfString:@"市" withString:@""];
    }
    
    if ([city containsString:@"市"]) {
        city = [city stringByReplacingOccurrencesOfString:@"市" withString:@""];
    }
}

@end
