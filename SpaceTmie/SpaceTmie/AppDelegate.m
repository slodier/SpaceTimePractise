//
//  AppDelegate.m
//  SpaceTmie
//
//  Created by CC on 2016/12/14.
//  Copyright © 2016年 CC. All rights reserved.
//

#import "AppDelegate.h"
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "LogInVC.h"
#import "AboutSelfVC.h"
#import "ShareView.h"
#import "ViewController.h"
#import "CCKeychain.h"

@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    //同时只可点击一个按钮
    [[UIButton appearance] setExclusiveTouch:YES];

    [WXApi registerApp:WXAppid];
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
//    LogInVC *vc = [[LogInVC alloc]init];
//    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];
    
    [self isLoginExpire];
    
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    return [WXApi handleOpenURL:url delegate:self] || [TencentOAuth HandleOpenURL:url];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [self removeShareView];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)onReq:(BaseReq *)req{
    
}

#pragma mark - 判断登陆凭证是否过期
- (void)isLoginExpire {
    
    UIViewController *mainVC = nil;
    if ([CCKeychain QQLocalData]) {
        ViewController *vc = [[ViewController alloc]init];
        [self rootViewControllerOfNav:vc];
        NSLog(@"QQ 自动登陆");
        
    }else if([CCKeychain WXLocalData]){
        ViewController *vc = [[ViewController alloc]init];
        [self rootViewControllerOfNav:vc];
        NSLog(@"WX 自动登陆");

    }else{
        LogInVC *logInVC = [[LogInVC alloc]init];
        mainVC = logInVC;
        self.window.rootViewController = mainVC;
        NSLog(@"重新登陆");
    }
}

- (void)rootViewControllerOfNav:(UIViewController *)vc {
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    self.window.rootViewController = nav;
}

#pragma mark - 授权后回调 WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    
    NSLog(@"授权后回调%@", resp);
    SendAuthResp *aresp = (SendAuthResp *)resp;
    // 只有登录才有 state 这个是属性,判断 state 存在否,可以判断是登陆还是分享回调
    if ([aresp respondsToSelector:NSSelectorFromString(@"state")]) {

        [self getCode:resp];
    }else{
        
        /*
         点击返回当前应用,会调用以下代码
         获取当前 ViewController, 根据 tag, 移除分享视图
         */
        [self removeShareView];
    }
}

#pragma mark - 登陆回调
- (void)getCode:(BaseResp *)resp{
    
    NSLog(@"%d", resp.errCode);
    
    // 授权成功
    if (resp.errCode == 0) {
        SendAuthResp *aresp = (SendAuthResp *)resp;
        // 跳转界面
        // 传code
        ViewController *vc = [[ViewController alloc]init];
        [self rootViewControllerOfNav:vc];
        NSLog(@"wx token :%@",aresp.code);
        [CCKeychain delete:KEY_QQ_PASSWORD];
        [CCKeychain wxSave:aresp.code];
        
    }else {

    }
}

- (BOOL)removeShareView {
    AboutSelfVC *currentVC = (AboutSelfVC *)[self getCurrentVC];
    UIView *currentView = (ShareView *)[currentVC.view viewWithTag:100];
    if (currentView) {
        [currentView removeFromSuperview];
        return YES;
    }else{
        return NO;
    }
}

#pragma mark - 获取当前 ViewController
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    return result;
}

@end
