//
//  SpeakModel.m
//  语音播报
//
//  Created by CC on 2017/4/18.
//  Copyright © 2017年 CC. All rights reserved.
//

#import "SpeakModel.h"
#import <iflyMSC/iflyMSC.h>

@interface SpeakModel ()<IFlySpeechSynthesizerDelegate>

{
    IFlySpeechSynthesizer * _iFlySpeechSynthesizer;
}

@end

@implementation SpeakModel

- (instancetype)init {
    if (self = [super init]) {
        [self addSpeech];
    }
    return self;
}

#pragma mark - 文字转语音
- (void)speak:(NSString *)text {
    if (text.length > 0) {
        [_iFlySpeechSynthesizer startSpeaking:text];
    }
}

#pragma mark 停止播报
- (void)stopSpeak {
    [_iFlySpeechSynthesizer stopSpeaking];
    //_iFlySpeechSynthesizer = nil;
}

#pragma mark - IFlySpeechSynthesizerDelegate
//合成结束，此代理必须要实现
- (void) onCompleted:(IFlySpeechError *) error{
    if (error) {
        NSLog(@"error:%@",error);
    }
    
}

- (void)addSpeech {
    // 注册 ID
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",XUNFEIID];
    [IFlySpeechUtility createUtility:initString];
    
    // 创建合成对象，为单例模式
    _iFlySpeechSynthesizer = [IFlySpeechSynthesizer sharedInstance]; _iFlySpeechSynthesizer.delegate = self;
    //设置语音合成的参数
    //语速,取值范围 0~100
    [_iFlySpeechSynthesizer setParameter:@"50" forKey:[IFlySpeechConstant SPEED]];
    //音量;取值范围 0~100
    [_iFlySpeechSynthesizer setParameter:@"50" forKey: [IFlySpeechConstant VOLUME]];
    //发音人,默认为”xiaoyan”;可以设置的参数列表可参考个 性化发音人列表
    [_iFlySpeechSynthesizer setParameter:@" xiaoyan " forKey: [IFlySpeechConstant VOICE_NAME]];
    //音频采样率,目前支持的采样率有 16000 和 8000
    [_iFlySpeechSynthesizer setParameter:@"8000" forKey: [IFlySpeechConstant SAMPLE_RATE]];
    //asr_audio_path保存录音文件路径，如不再需要，设置value为nil表示取消，默认目录是documents
    [_iFlySpeechSynthesizer setParameter:nil forKey: [IFlySpeechConstant TTS_AUDIO_PATH]];
}

@end
