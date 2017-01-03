//
//  DownLoadVC.m
//  SpaceTmie
//
//  Created by CC on 2016/12/16.
//  Copyright © 2016年 CC. All rights reserved.
//

#import "DownLoadVC.h"
#import "FlodModel.h"
#import "CCProgressView.h"
#import "DownloadModel.h"
#import "AttentionView.h"
#import "ActionView.h"
#import "FloatView.h"
#import "SDWebImageCompat.h"
#import "ZZCircleProgress.h"

//static NSString *const downloadStr = @"http://dldir1.qq.com/qqfile/qq/QQ7.6/15742/QQ7.6.exe";

static NSString *const downloadStr = @"http://dlsw.baidu.com/sw-search-sp/soft/9d/25765/sogou_mac_32c_V3.2.0.1437101586.dmg";

//http://dlsw.baidu.com/sw-search-sp/soft/9d/25765/sogou_mac_32c_V3.2.0.1437101586.dmg

@interface DownLoadVC ()<NSURLSessionDownloadDelegate>

@property (nonatomic, assign) BOOL allowAccess;

@property (nonatomic, strong) NSURLSession *session;

@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;

@property (nonatomic, strong) ZZCircleProgress *circle3; //进度条
@property (nonatomic, strong) AttentionView *attentionView;  //提示框
@property (nonatomic, strong) FloatView *floatView;          //飘提示
@property (nonatomic, strong) ActionView *actionView;    //提示框

@property (nonatomic, strong) UILabel *countLabel; //下载进度

@property (nonatomic, strong) DownloadModel *downloadModel;

@property (nonatomic, strong) NSURL *tempLoacationUrl; //临时存储的文件目录

@property (nonatomic, strong) NSData *resumeData;

@property (nonatomic, strong) NSUserDefaults *userDefaults;

@property (nonatomic, strong) UIButton *suspendBtn; // 挂起按钮
@property (nonatomic, strong) UIButton *resumeBtn;  // 继续按钮

@end

@implementation DownLoadVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    _downloadModel = [[DownloadModel alloc]init];
    
    _userDefaults = [NSUserDefaults standardUserDefaults];
    
    _floatView = [[FloatView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, -64)];
    
    [self addInterface];
    [self layoutUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [self seleteData];
}

- (void)viewWillDisappear:(BOOL)animated {
    if (_downloadTask) {
        [self cancel];
    }
}

#pragma mark - 查询本地有没有值
- (NSData *)seleteData {
    NSData *tempData = [_userDefaults objectForKey:@"resumeData"];
    if (tempData != NULL) {
        self.resumeData = tempData;
    }
    NSLog(@"seleteData:%@",tempData);
    return tempData;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [UIView animateWithDuration:0.5 animations:^{
        [_actionView removeFromSuperview];
        [_attentionView removeFromSuperview];
    }];
}

#pragma mark - 设置界面状态
-(void)setUIStatus:(int64_t)totalBytesWritten expectedTowrite:(int64_t)totalBytesExpectedWritten
{
    float progress = (float)totalBytesWritten / totalBytesExpectedWritten;
    //主线程,更新 UI
    dispatch_async(dispatch_get_main_queue(), ^{
        _circle3.progress = progress;
    });
}

#pragma mark - NSURLSessionDownloadDelegate
#pragma mark 下载中(会多次调用，可以记录下载进度)
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    [self setUIStatus:totalBytesWritten expectedTowrite:totalBytesExpectedToWrite];
}

#pragma mark 下载完成
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    NSError *error;
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
    NSString *savePath = [cachePath stringByAppendingPathComponent:[_downloadModel fileName]];
    NSLog(@"%@",savePath);
    
    NSURL *url = [NSURL fileURLWithPath:savePath];
    _tempLoacationUrl = location;
    NSLog(@"tempLocation:%@",location);
    
    [[NSFileManager defaultManager]moveItemAtURL:location toURL:url error:&error];
    if (error) {
        NSLog(@"%@",error.localizedDescription);
    }else{
        NSLog(@"move success");
    }
}

#pragma mark 任务完成，不管是否下载成功
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (error) {
        NSLog(@"downloadError:%@",error.localizedDescription);
        if ([error.localizedDescription isEqualToString:@"The request timed out."]) {
            self.actionView.tipLabel.text = @"下载超时,请重试";
            [self.view addSubview:self.attentionView];
            _countLabel.text = @"";
        }
    }else{
        NSLog(@"download success");
        _resumeData = NULL;
        [_userDefaults removeObjectForKey:@"resumeData"];
    }
}

#pragma mark - 下载
- (void)createSession {
    if (!_session) {
        NSURLSessionConfiguration *sessionConfigutation = [NSURLSessionConfiguration defaultSessionConfiguration];
        sessionConfigutation.allowsCellularAccess = _allowAccess; //是否使用蜂窝
        sessionConfigutation.timeoutIntervalForResource = 60; // 暂停超过 60 秒即超时
        _session = [NSURLSession sessionWithConfiguration:sessionConfigutation
                                                 delegate:self
                                            delegateQueue:nil];
    }
}

- (void)downloadBy:(NSString *)urlStr {
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [self createSession];
    _downloadTask = [_session downloadTaskWithRequest:request];
    [_downloadTask resume];
}

#pragma mark - 重新下载还是继续下载
- (void)restoreClick {
    [_actionView removeFromSuperview];
    [_userDefaults removeObjectForKey:@"resumeData"];
    __weak typeof(self) weakSelf = self;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [weakSelf downloadBy:downloadStr];
    });
}

- (void)resumeClick {
    [_actionView removeFromSuperview];
    
    [self createSession];
    
    _downloadTask = [_session downloadTaskWithResumeData:self.resumeData];
    [_downloadTask resume];
}

#pragma mark - 四个按钮方法
#pragma mark 下载
- (void)download {
    //避免重复下载
    if (_downloadTask) {
        self.floatView.contextLabel.text = @"等待当前下载完成!";
        [_floatView floatAniamtion];
        [self.view addSubview:self.floatView];
    }else{
        if ([_downloadModel isExistFile]) {
            NSLog(@"本地已有下载完成的文件,请删除后重新下载!");
            self.attentionView.tipLabel.text = @"本地已有下载完成的文件,请删除后重新下载!";
            [self.view addSubview:_attentionView];
        }else{
            if (self.resumeData != NULL) {
                self.actionView.tipLabel.text = @"是否继续上次下载?";
                [self.view addSubview:self.actionView];
            }else{
                __weak typeof(self) weakSelf = self;
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                dispatch_async(queue, ^{
                    [weakSelf downloadBy:downloadStr];
                });
            }
        }
    }
}

#pragma mark 取消下载
- (void)cancel {
    __weak __typeof(self)weakSelf = self;

    [_downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        if (resumeData == NULL) {
            return;
        }else{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            strongSelf.resumeData = resumeData;
            _downloadTask = nil;
            [_userDefaults setObject:resumeData forKey:@"resumeData"];
            // 立即同步,来不及解释了
            [_userDefaults synchronize];
        }
    }];
    _circle3.progress = 0;
    [_countLabel removeFromSuperview];
    
    [self addInterface];
}

#pragma mark 下载挂起
- (void)suspend:(UIButton *)sender {
    [_floatView removeFromSuperview];
    sender.selected =! sender.selected;
    [_downloadTask suspend];
    self.floatView.contextLabel.text = @"下载任务被挂起!";
    [_floatView floatAniamtion];
    [self.view addSubview:self.floatView];
}

#pragma mark 恢复下载
- (void)resumeTask:(UIButton *)sender {
    [_floatView removeFromSuperview];
    sender.selected =! sender.selected;
    [_downloadTask resume];
    self.floatView.contextLabel.text = @"恢复下载任务!";
    [_floatView floatAniamtion];
    [self.view addSubview:self.floatView];
}

#pragma mark 删除本地文件
- (void)deleteClick {
    if ([_downloadModel deleteDownloadFile]) {
        self.attentionView.tipLabel.text = @"删除成功!";
    }else{
        self.attentionView.tipLabel.text = @"文件不存在或删除失败!";
    }
    [self.view addSubview:_attentionView];
}

#pragma mark - 构建 UI
- (void)addInterface {
    CGFloat itemWidth = 0.2 *KScreenHeight;
    CGFloat xCrack = KScreenWidth /2.0 - itemWidth / 2;
    CGFloat yCrack = (KScreenWidth - itemWidth *2) / 3;
    //自定义起始角度
    _circle3 = [[ZZCircleProgress alloc] initWithFrame:CGRectMake(xCrack, yCrack, itemWidth, itemWidth) pathBackColor:nil pathFillColor:KColorWithRGB(arc4random()%255, arc4random()%255, arc4random()%255) startAngle:-255 strokeWidth:10];
    _circle3.reduceValue = 0.04 *KScreenWidth;
    [self.view addSubview:_circle3];
}

- (void)layoutUI {
    
    CGFloat btnW = KScreenWidth /5;
    
    UIButton *downloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    downloadBtn.frame = CGRectMake(btnW, btnW + KScreenHeight /2,  btnW, btnW);
    [self.view addSubview:downloadBtn];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(btnW *3, btnW + KScreenHeight /2, btnW, btnW);
    [self.view addSubview:cancelBtn];
    
    _suspendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _suspendBtn.frame = CGRectMake(btnW /2, btnW *2.5 + KScreenHeight /2, btnW, btnW);
    [self.view addSubview:_suspendBtn];
    
    _resumeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _resumeBtn.frame = CGRectMake(btnW *2, btnW *2.5 + KScreenHeight /2, btnW, btnW);
    [self.view addSubview:_resumeBtn];
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame = CGRectMake(btnW *3.5, btnW *2.5 + KScreenHeight /2, btnW, btnW);
    [self.view addSubview:deleteBtn];
    
    [downloadBtn addTarget:self action:@selector(download) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn   addTarget:self action:@selector(cancel)   forControlEvents:UIControlEventTouchUpInside];
    [_suspendBtn  addTarget:self action:@selector(suspend:)  forControlEvents:UIControlEventTouchUpInside];
    [_resumeBtn   addTarget:self action:@selector(resumeTask:)   forControlEvents:UIControlEventTouchUpInside];
    [deleteBtn   addTarget:self action:@selector(deleteClick)   forControlEvents:UIControlEventTouchUpInside];

    [downloadBtn setTitle:@"下载" forState:UIControlStateNormal];
    [cancelBtn   setTitle:@"取消" forState:UIControlStateNormal];
    [_resumeBtn   setTitle:@"继续" forState:UIControlStateNormal];
    [_suspendBtn  setTitle:@"挂起" forState:UIControlStateNormal];
    [deleteBtn   setTitle:@"删除文件" forState:UIControlStateNormal];
    
    UIColor *color = [UIColor grayColor];
    downloadBtn.backgroundColor = cancelBtn.backgroundColor = deleteBtn.backgroundColor = _suspendBtn.backgroundColor = _resumeBtn.backgroundColor = color;
}

#pragma mark - getter
- (AttentionView *)attentionView {
    if (!_attentionView) {
        _attentionView = [[AttentionView alloc]initWithFrame:self.view.bounds];
    }
    return _attentionView;
}

- (ActionView *)actionView {
    if (!_actionView) {
        _actionView = [[ActionView alloc]initWithFrame:self.view.bounds];
        [_actionView.downloadBtn addTarget:self action:@selector(restoreClick) forControlEvents:UIControlEventTouchUpInside];
        [_actionView.resumeDownBtn addTarget:self action:@selector(resumeClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _actionView;
}

@end
