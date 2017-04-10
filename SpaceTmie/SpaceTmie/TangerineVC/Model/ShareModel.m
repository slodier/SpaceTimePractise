//
//  ShareModel.m
//  TencentShare
//
//  Created by CC on 2017/3/22.
//  Copyright © 2017年 CC. All rights reserved.
//

#import "ShareModel.h"
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentApiInterface.h>
#import <TencentOpenAPI/QQApiInterface.h>

@interface ShareModel ()<TencentSessionDelegate>

@property (nonatomic, strong) TencentOAuth *tencent;

@end

@implementation ShareModel

// 微信分享的链接、标题、描述
static NSString *KLinkURL = @"http://v.youku.com/v_show/id_XNTY1ODY1OTA0.html";
static NSString *KLinkTitle = @"老司机带你飞";
static NSString *KLinkDescription = @"快上车,来不及解释了!";

#pragma mark - 
- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)pictureWXShare:(int)type {
    [self wxShare:type useText:NO];
}

- (void)textWXShare:(int)type {
    [self wxShare:type useText:YES];
}

#pragma mark - 微信分享的是链接
- (void)wxShare:(int)type useText:(BOOL)flag {
    //检测是否安装微信
    if (![WXApi isWXAppInstalled]) {
        NSLog(@"Not install weixi");
        [self alert:@"Not install weixi"];
    }else{
        SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc]init];
        WXMediaMessage *urlMessage = [WXMediaMessage message];

        if (flag) {
            // 纯文本
            sendReq.bText = flag;
            sendReq.text = KLinkDescription;
            sendReq.scene = type;
            
        }else{
            // 带缩略图、链接
            sendReq.bText = flag; //不使用文本信息
            urlMessage.title = KLinkTitle;
            urlMessage.description = KLinkDescription;
            sendReq.scene = type;  //0 = 好友列表 1 = 朋友圈 2 = 收藏
            
            UIImage *image = [UIImage imageNamed:_thumbImageStr];
            // 缩略图,压缩图片,不超过 32 KB
            NSData *thumbData = UIImageJPEGRepresentation(image, 0.25);
            [urlMessage setThumbData:thumbData];
            // 分享实例
            WXWebpageObject *webObj = [WXWebpageObject object];
            webObj.webpageUrl = KLinkURL;
            
            urlMessage.mediaObject = webObj;
            
            sendReq.message = urlMessage;
        }
        
        // 发送分享
        [WXApi sendReq:sendReq];
    }
}

#pragma mark - QQ 分享的是图片还是链接
- (void)qqShare:(BOOL)isPicure
{   // 检测是否安装 QQ
    if (![TencentOAuth iphoneQQInstalled]) {
        NSLog(@"请移步 Appstore 去下载腾讯 QQ 客户端");
        [self alert:@"请移步 Appstore 去下载腾讯 QQ 客户端"];
    }else{
        
        _tencent = [[TencentOAuth alloc]initWithAppId:QQappid andDelegate:self];
        UIImage *image = [UIImage imageNamed:_thumbImageStr];
        // QQ 分享图片不超过 1M，没有压缩的必要
        NSData *data = UIImagePNGRepresentation(image);

        SendMessageToQQReq *req = nil;
        
        if (isPicure) {
            QQApiImageObject *imgObj = [QQApiImageObject objectWithData:data
                                                       previewImageData:data
                                                                  title:KLinkTitle
                                                            description:KLinkDescription];
            req = [SendMessageToQQReq reqWithContent:imgObj];
        }else{
            
            NSURL *url = [NSURL URLWithString:KLinkURL];
            QQApiURLObject *urlObj = [QQApiURLObject objectWithURL:url
                                                             title:KLinkTitle
                                                       description:KLinkDescription
                                                  previewImageData:data
                                                 targetContentType:QQApiURLTargetTypeVideo];
            req = [SendMessageToQQReq reqWithContent:urlObj];
        }
        
        // 因为分享的是联系人和空间的结合体，下面的判断其实多此一举
        
        QQApiSendResultCode code = [QQApiInterface sendReq:req];
        NSLog(@"QQ share Code:%d",code);
    }
}

#pragma mark - QQ 代理
- (void)tencentDidLogin {
    
}

- (void)tencentDidNotNetWork {
    
}

- (void)tencentDidNotLogin:(BOOL)cancelled {
    
}

#pragma mark - 微信、QQ 没有安装，提示框
- (void)alert:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示"
                                                       message:message
                                                      delegate:nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil, nil];
    [alertView show];
}

@end
