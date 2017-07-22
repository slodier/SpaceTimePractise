# SpaceTimePractise
## 功能
#### 1. 轮播图
#### 2. 转场动画和一些普通动画(自认惨不忍睹)
#### 3. 下载相关:自定义进度条,断点下载
#### 4. 设置本地相册图片为新头像,及相关判断、存储
#### 5. 用户信息界面,微信和 QQ 登陆及登陆过期(默认一天)
#### 6. 分享(微信和 QQ )
#### 7. 显示当前地区天气情况(上海气象局接口),定位
#### 8. 网易新闻,刷新功能
#### 9. FMDB 存储离线数据,增加清除缓存
#### 10. 视频列表,可小屏幕播放,刷新功能
#### 11. 图灵机器人聊天,用户可以发送文字和语音,语音自动转换为文字,机器人回复语音播报
#### 12. 直播,使用抓取的印客直播数据

## 相关库
#### 1.[SDWebImage](https://github.com/rs/SDWebImage)
#### 2.[SDCycleScrollView](https://github.com/gsdios/SDCycleScrollView)
#### 3.[Masonry](https://github.com/SnapKit/Masonry)
#### 4.[MJRefresh](https://github.com/CoderMJLee/MJRefresh)
#### 5.[MBProgressHUD](https://github.com/jdg/MBProgressHUD)
#### 6.[FMDB](https://github.com/ccgus/fmdb)
#### 7.[WMPlayer](https://github.com/zhengwenming/WMPlayer)
#### 8.[Reachability](https://github.com/tonymillion/Reachability)
#### 9.[Turing](https://github.com/turing-robot/sdk-ios)
#### 10.[ijkplayer](https://github.com/Bilibili/ijkplayer)

## 踩到的一些坑
#### 1.腾讯 SDK, 分享和登陆,详见 [链接](https://github.com/slodier/TencentShare)
#### 2.图灵机器人
	   1).报 Linker command failed with exit code 1 连接失败
		解决方法:
		Building Setting - Library Search Paths 拖进 libTuringSDK.a 的路径,或者添加相对路径 $(SRCROOT)/项目名称/ pch 文件

	   2).报很多错误, too many errors emitted, stopping now...
		Expected unqualified-id 
		Unknown type name ’NSString’
		由于存在和 C++ 混编, pch 里面自动加的头文件是全局性的,当在 C 文件 import 是没有意义的,也就是问题出处,所以要和 Objective-C 区分开编译
		pch 中引用头文件加入
```OBjective-C
#ifdef __OBJC__
  #import <Foundation/Foundation.h>
  #import <UIKit/UIKit.h>
#endif
```