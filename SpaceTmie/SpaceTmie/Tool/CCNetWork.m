//
//  CCNetWork.m
//  Video
//
//  Created by CC on 2017/3/25.
//  Copyright © 2017年 CC. All rights reserved.
//

#import "CCNetWork.h"

@implementation CCNetWork

- (void)analysisUrl:(NSString *)urlStr
           complete:(OnFailed)onfailed
          returnDic:(ReturnDicBlock)returnBlock
{
    dispatch_queue_t queue = dispatch_queue_create("com.jiexi.cc", NULL);
    dispatch_async(queue, ^{
        NSURL *url = [NSURL URLWithString:urlStr];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSError *jsonError = nil;
            if (error) {
                onfailed(error);
                NSLog(@"dataTaskError:%@",error);
            }else{
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                if (jsonError) {
                    onfailed(jsonError);
                    NSLog(@"jsonError:%@",jsonError);
                }else{
                    if (returnBlock) {
                        returnBlock(dict);
                    }
                }
            }
        }];
        [dataTask resume];
    });
}

@end
