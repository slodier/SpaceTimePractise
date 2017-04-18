//
//  ChatViewController.m
//  SpaceTmie
//
//  Created by CC on 2017/4/16.
//  Copyright © 2017年 CC. All rights reserved.
//

#import "ChatViewController.h"
#import "CCNetWork.h"
#import "ChatCell.h"
#import "Calculation.h"
#import "ChatModel.h"
#import "MBProgressHUD.h"
#import "TRRVoiceRecognitionManager.h"
#import "TRRTuringAPIConfig.h"
#import "TRRSpeechSythesizer.h"
#import "TRRTuringRequestManager.h"
#import "SpeakModel.h"

@interface ChatViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,TRRVoiceRecognitionManagerDelegate>

{
    BOOL _isSpeed;  // 是说话还是打字
}

@property (strong, nonatomic) TRRVoiceRecognitionManager *sharedInstance;

@property (nonatomic, strong) UITextField *field;

@property (nonatomic, strong) CCNetWork *ccNetWork;
@property (nonatomic, strong) Calculation *calculation;
@property (nonatomic, strong) ChatModel *chatNormalModel;
@property (nonatomic, strong) SpeakModel *speakModel;

@property (nonatomic, strong) UITableView *chatTableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) UIButton *voiceBtn;  // 声音按钮
@property (nonatomic, strong) UIButton *speedBtn; // 按住说话

@end

@implementation ChatViewController

static NSString *cell_ID = @"chatCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _ccNetWork = [[CCNetWork alloc]init];
    _calculation = [[Calculation alloc]init];
    _dataSource = [NSMutableArray array];
    _chatNormalModel = [[ChatModel alloc]init];
    _speakModel = [[SpeakModel alloc]init];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.chatTableView];
    [self.view addSubview:self.field];
    [self.view addSubview:self.voiceBtn];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"图灵机器人";
    self.navigationController.navigationBar.backgroundColor = [UIColor lightGrayColor];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self keyboardHidden];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self keyboardHidden];
}

- (void)viewWillAppear:(BOOL)animated {
    _sharedInstance = [TRRVoiceRecognitionManager sharedInstance];
    [_sharedInstance setApiKey:BaiduAPIKey secretKey:BaiduSecretKey];
    _sharedInstance.delegate = self;
    NSArray *array = @[@(20000)];
    _sharedInstance.recognitionPropertyList = array;
}

- (void)viewWillDisappear:(BOOL)animated {
    [_sharedInstance stopRecognize];
    _sharedInstance = nil;
    [_speakModel stopSpeak];
}

#pragma mark - 按钮点击事件
- (void)sendVoice:(UIButton *)sender {
    sender.selected =! sender.selected;
    
    if (sender.selected) {
        [self.view addSubview:self.speedBtn];
        [_sharedInstance startVoiceRecognition];
        [_speakModel stopSpeak];
    }else{
        [self.speedBtn removeFromSuperview];
        [_sharedInstance stopRecognize];
    }
}

- (void)speedVoice:(UIButton *)sender {
    //sender.selected =! sender.selected;
}

//#pragma mark 长按事件
//- (void)dealVoice:(UILongPressGestureRecognizer *)gesture {
//    
//    switch (gesture.state) {
//        case UIGestureRecognizerStateBegan:
//        {
//            NSLog(@"长按开始");
//            [_sharedInstance startVoiceRecognition];
//            [UIView animateWithDuration:0.3 animations:^{
//                _speedBtn.selected = YES;
//                _speedBtn.backgroundColor = [UIColor lightGrayColor];
//            }];
//        }
//            break;
//            
//        default:
//        {
//            NSLog(@"长按结束");
//            [UIView animateWithDuration:0.3 animations:^{
//                _speedBtn.selected = NO;
//                _speedBtn.backgroundColor = [UIColor whiteColor];
//            }];
//        }
//            break;
//    }
//}

#pragma mark - TRRVoiceRecognitionManagerDelegate
- (void)onRecognitionResult:(NSString *)result {
    NSLog(@"result:%@",result);
    _isSpeed = YES;
    [_chatNormalModel newData:result
                   isFromSelf:YES
                   dataSource:_dataSource];
    
    [self inserNewCell];
    [self getData:result];
    
}

- (void)onStartRecognize {
    NSLog(@"正在讲话");
    [_speedBtn setTitle:@"正在讲话" forState:UIControlStateNormal];
}

- (void)onRecognitionError:(NSString *)errStr {
    NSLog(@"erorr:%@",errStr);
}

- (void)onSpeechStart {
    NSLog(@"开始讲话");
    [_speedBtn setTitle:@"开始讲话" forState:UIControlStateNormal];
}

- (void)onSpeechEnd {
    NSLog(@"停止讲话");
    [_speedBtn setTitle:@"停止讲话" forState:UIControlStateNormal];
    _voiceBtn.selected =! _voiceBtn.selected;
    [_speedBtn removeFromSuperview];

}

#pragma mark - 插入新的 cell
- (void)inserNewCell {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_dataSource.count - 1 inSection:0];
    [_chatTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - 收起键盘,视图恢复
- (void)keyboardHidden {
    _field.text = @"";
    [_field resignFirstResponder];
    [UIView animateWithDuration:0.4 animations:^{
        _field.frame = CGRectMake(45, KScreenHeight - 54, KScreenWidth - 60, 40);
        if (_chatTableView.contentSize.height > 321) {
            _chatTableView.frame = CGRectMake(0, 64, KScreenWidth, KScreenHeight - 118);
        }
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatModel *chatModel = _dataSource[indexPath.row];
    CGFloat height = chatModel.labelSize.height + 0.03 *KScreenHeight + 34;
    NSLog(@"%f",height);
    if (height > 0.09 *KScreenHeight + 17) {
        return height;
    }
    return 0.09 *KScreenHeight + 34;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatCell *chatCell = [tableView dequeueReusableCellWithIdentifier:cell_ID];
    if (!chatCell) {
        chatCell = [[ChatCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_ID];
    }
    ChatModel *chatModel = _dataSource[indexPath.row];
    [chatCell para:chatModel];
    NSLog(@"offSet:%f",tableView.contentSize.height);
    return chatCell;
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [textField becomeFirstResponder];
    [UIView animateWithDuration:0.4 animations:^{
        
        textField.frame = CGRectMake(20, KScreenHeight - 50 - 271, KScreenWidth - 40, 40);
        
        if (_dataSource.count > 0) {
            if (_chatTableView.contentSize.height > 321) {
                _chatTableView.frame = CGRectMake(0, -200, KScreenWidth, KScreenHeight - 118);
            }
        }
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField.text.length > 0) {
        
        [_chatNormalModel newData:textField.text
                       isFromSelf:YES
                       dataSource:_dataSource];
        [self inserNewCell];
        [self getData:textField.text];
        [self keyboardHidden];
        
        return YES;
    }
    textField.text = @"";
    [textField resignFirstResponder];
    [UIView animateWithDuration:0.4 animations:^{
        textField.frame = CGRectMake(20, KScreenHeight - 50, KScreenWidth - 40, 40);
    }];
    return NO;
}

#pragma mark - 解析 JSON
- (void)getData:(NSString *)text {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES wheelStr:@"分析中..."];
    NSString *urlStr = [NSString stringWithFormat:@"http://www.tuling123.com/openapi/api?key=e47d9ff26dfe40bc8e70dab1fe72eabd&&info=%@",text];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    __weak typeof(self)weakSelf = self;
    [_ccNetWork analysisUrl:urlStr
                   complete:^(NSError *error) {
                       if (error) {
                           NSLog(@"error:%@",error.localizedDescription);
                       }
                       
                   } returnDic:^(NSDictionary *dict) {
                       __strong typeof(weakSelf)strongSelf = weakSelf;
                       
                       NSLog(@"dict:%@",dict);
                       [strongSelf.chatNormalModel newData:dict[@"text"]
                                                isFromSelf:NO
                                                dataSource:_dataSource];
                       
                       if (_isSpeed) {
                           //[_sharedInstance startVoiceRecognition];
//                           [_speakModel speak:text];
                           _isSpeed = NO;
                       }
                       
                       NSIndexPath *indexPath = [NSIndexPath indexPathForRow:strongSelf.dataSource.count - 1 inSection:0];
                       // 主线程插入新的一行
                       dispatch_async(dispatch_get_main_queue(), ^{
                           
                           // 
                           [_speakModel speak:dict[@"text"]];
                           
                           [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
                           
                           [strongSelf.chatTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                           strongSelf.field.text = @"";
                           [strongSelf.field resignFirstResponder];
                           [strongSelf.chatTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]
                                                                 animated:YES
                                                           scrollPosition:UITableViewScrollPositionBottom];
                       });
                   }];
}

#pragma mark - getter
- (UIButton *)speedBtn {
    if (!_speedBtn) {
        _speedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _speedBtn.frame = self.field.frame;
        _speedBtn.backgroundColor = [UIColor whiteColor];
        [_speedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //[_speedBtn setTitle:@"按住 说话" forState:UIControlStateNormal];
        //[_speedBtn setTitle:@"松开 结束" forState:UIControlStateSelected];
        
        _speedBtn.layer.borderColor = [UIColor blackColor].CGColor;
        _speedBtn.layer.borderWidth = 0.5;
        
//        UILongPressGestureRecognizer *speendLongRec = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(dealVoice:)];
//        [_speedBtn addGestureRecognizer:speendLongRec];
        _speedBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_speedBtn addTarget:self action:@selector(speedVoice:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _speedBtn;
}

- (UIButton *)voiceBtn {
    if (!_voiceBtn) {
        _voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _voiceBtn.frame = CGRectMake(0, KScreenHeight - 54, 40, 40);
        [_voiceBtn setImage:[UIImage imageNamed:@"voice"] forState:UIControlStateNormal];
        [_voiceBtn setImage:[UIImage imageNamed:@"keyboard"] forState:UIControlStateSelected];
        [_voiceBtn addTarget:self action:@selector(sendVoice:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _voiceBtn;
}

- (UITextField *)field {
    if (!_field) {
        _field = [[UITextField alloc]initWithFrame:CGRectMake(45, KScreenHeight - 54, KScreenWidth - 60, 40)];
        _field.delegate = self;
        _field.backgroundColor = [UIColor greenColor];
    }
    return _field;
}

- (UITableView *)chatTableView {
    if (!_chatTableView) {
        _chatTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight - 118)];
        _chatTableView.delegate = self;
        _chatTableView.dataSource = self;
        _chatTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
    }
    return _chatTableView;
}

@end
