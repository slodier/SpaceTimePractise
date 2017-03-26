//
//  CCNetWork.m
//  Video
//
//  Created by CC on 2017/3/25.
//  Copyright © 2017年 CC. All rights reserved.
//

#import "CCNetWork.h"

@implementation CCNetWork

- (void)jiexi:(NSString *)urlStr {
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSError *jsonError = nil;
        
        if (error) {
          
            NSLog(@"dataTaskError:%@",error);
        }else{
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            if (jsonError) {
               
                NSLog(@"jsonError:%@",jsonError);
            }else{
                
                if (_dicBlock) {
                    _dicBlock(dict);
                }
            }
        }
    }];
    [dataTask resume];
}

- (void)analysisUrl:(NSString *)urlStr {
    dispatch_queue_t queue = dispatch_queue_create("com.jiexi.cc", NULL);
    __weak typeof(self)weakSelf = self;
    dispatch_async(queue, ^{
        __strong typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf jiexi:urlStr];
    });
}

#pragma mark - Block 传值
- (void)getDicBlock:(ReturnDicBlock)block {
    _dicBlock = block;;
}

@end
