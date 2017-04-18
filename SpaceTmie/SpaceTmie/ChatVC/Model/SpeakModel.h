//
//  SpeakModel.h
//  语音播报
//
//  Created by CC on 2017/4/18.
//  Copyright © 2017年 CC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpeakModel : NSObject

- (void)speak:(NSString *)text;

- (void)stopSpeak;

@end
