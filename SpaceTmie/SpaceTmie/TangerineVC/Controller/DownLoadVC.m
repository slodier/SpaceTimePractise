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

static NSString *const downloadStr = @"http://dldir1.qq.com/qqfile/qq/QQ7.6/15742/QQ7.6.exe";

@interface DownLoadVC ()<NSURLSessionDownloadDelegate>

@property (nonatomic, assign) BOOL allowAccess;

@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;

@property (nonatomic, strong) CCProgressView *ccProgressView;//进度条
@property (nonatomic, strong) AttentionView *attentionView;  //提示框

@property (nonatomic, strong) UILabel *countLabel; //下载进度

@property (nonatomic, strong) DownloadModel *downloadModel;

@end

@implementation DownLoadVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    _downloadModel = [[DownloadModel alloc]init];
    
    [self layoutUI];
}

#pragma mark - 设置界面状态
-(void)setUIStatus:(int64_t)totalBytesWritten expectedTowrite:(int64_t)totalBytesExpectedWritten
{
    //主线程,更新 UI
    dispatch_async(dispatch_get_main_queue(), ^{
        float progress = (float)totalBytesWritten / totalBytesExpectedWritten;
        _ccProgressView.progress = progress;
        [_ccProgressView setNeedsDisplay];
        _countLabel.text = [NSString stringWithFormat:@"%.2f%s",progress *100,"%"];
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
    
    [[NSFileManager defaultManager]moveItemAtURL:location toURL:url error:&error];
    if (error) {
        NSLog(@"%@",error.localizedDescription);
    }else{
        NSLog(@"move success");
    }
}

#pragma mark 任务完成，不管是否下载成功
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    if (error) {
        NSLog(@"%@",error.localizedDescription);
    }else{
        NSLog(@"download success");
    }
}

#pragma mark - 下载
- (void)downloadBy:(NSString *)urlStr {
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSURLSessionConfiguration *sessionConfigutation = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfigutation.allowsCellularAccess = _allowAccess; //是否使用蜂窝
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfigutation
                                                          delegate:self
                                                     delegateQueue:nil];
    _downloadTask = [session downloadTaskWithRequest:request];
    [_downloadTask resume];
}

#pragma mark - 四个按钮方法
- (void)download {
    if ([_downloadModel isExistFile]) {
        self.attentionView.tipLabel.text = @"本地已存在下载完成的文件,\n请删除后重试!";
        [self.view addSubview:_attentionView];
    }else{
        [self downloadBy:downloadStr];
        _ccProgressView.layer.opacity = 1;
    }
}

- (void)cancel {
    [_downloadTask cancel];
    [_ccProgressView.progressLayer removeFromSuperlayer];
    _countLabel.text = @"";
}

- (void)suspend {
    [_downloadTask suspend];
}

- (void)resume {
    [_downloadTask resume];
}

- (void)deleteClick {
    if ([_downloadModel deleteDownloadFile]) {
        self.attentionView.tipLabel.text = @"删除成功!";
    }else{
        self.attentionView.tipLabel.text = @"文件不存在或删除失败!";
    }
    [self.view addSubview:_attentionView];
}

#pragma mark - 构建 UI
- (void)layoutUI {
    
    _ccProgressView = [[CCProgressView alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight /2)];
    [self.view addSubview:_ccProgressView];
    _ccProgressView.backgroundColor = [UIColor cyanColor];
    
    _countLabel = [[UILabel alloc]init];
    _countLabel.bounds = CGRectMake(0, 0, 80, 40);
    _countLabel.center = _ccProgressView.center;
    _countLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_countLabel];
    _countLabel.backgroundColor = [UIColor redColor];
    
    CGFloat btnW = KScreenWidth /5;
    
    UIButton *downloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    downloadBtn.frame = CGRectMake(btnW, btnW + KScreenHeight /2,  btnW, btnW);
    [self.view addSubview:downloadBtn];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(btnW *3, btnW + KScreenHeight /2, btnW, btnW);
    [self.view addSubview:cancelBtn];
    
    UIButton *suspendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    suspendBtn.frame = CGRectMake(btnW /2, btnW *2.5 + KScreenHeight /2, btnW, btnW);
    [self.view addSubview:suspendBtn];
    
    UIButton *resumeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    resumeBtn.frame = CGRectMake(btnW *2, btnW *2.5 + KScreenHeight /2, btnW, btnW);
    [self.view addSubview:resumeBtn];
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame = CGRectMake(btnW *3.5, btnW *2.5 + KScreenHeight /2, btnW, btnW);
    [self.view addSubview:deleteBtn];
    
    [downloadBtn addTarget:self action:@selector(download) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn   addTarget:self action:@selector(cancel)   forControlEvents:UIControlEventTouchUpInside];
    [suspendBtn  addTarget:self action:@selector(suspend)  forControlEvents:UIControlEventTouchUpInside];
    [resumeBtn   addTarget:self action:@selector(resume)   forControlEvents:UIControlEventTouchUpInside];
    [deleteBtn   addTarget:self action:@selector(deleteClick)   forControlEvents:UIControlEventTouchUpInside];

    
    [downloadBtn setTitle:@"下载" forState:UIControlStateNormal];
    [cancelBtn   setTitle:@"取消" forState:UIControlStateNormal];
    [resumeBtn   setTitle:@"继续" forState:UIControlStateNormal];
    [suspendBtn  setTitle:@"挂起" forState:UIControlStateNormal];
    [deleteBtn   setTitle:@"删除文件" forState:UIControlStateNormal];
    
    UIColor *color = [UIColor grayColor];
    downloadBtn.backgroundColor = cancelBtn.backgroundColor = deleteBtn.backgroundColor = suspendBtn.backgroundColor = resumeBtn.backgroundColor = color;
}

#pragma mark - getter
- (AttentionView *)attentionView {
    if (!_attentionView) {
        _attentionView = [[AttentionView alloc]initWithFrame:self.view.bounds];
    }
    return _attentionView;
}

@end
