//
//  ActionView.h
//  SpaceTmie
//
//  Created by CC on 2016/12/22.
//  Copyright © 2016年 CC. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ActionView : UIView

@property (nonatomic, strong) UILabel *tipLabel;    //提示框文字

@property (nonatomic, strong) UIButton *cancelBtn;  //取消按钮
@property (nonatomic, strong) UIButton *resumeDownBtn;  //恢复下载按钮
@property (nonatomic, strong) UIButton *downloadBtn; //重新下载

@end
