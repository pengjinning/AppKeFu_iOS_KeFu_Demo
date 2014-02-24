


# AppKeFu_sdk 使用说明

具体参考：http://appkefu.com/AppKeFu/tutorial-iOS.html

一：添加库文件
    libxml2.dylib
    libresolve.dylib
    SystemConfiguration.framework
    CoreLocation.framework
    CoreData.framework
    AVFundation.framework
    AudioToolbox.framework
    ImageIO.framework
    MapKit.framework
    Accelerate.framework
    

二：
 选中target中的Build Settings:
1. Other Linker Flags 添加 -all_load  -lstdc++
2(可选).Header Search Paths 添加 “/usr/include/libxml2”


三：上述两步骤后，如报错可尝试添加如下framework
(根据具体情况添加：Security.framework，CFNetwork.framework，QuartzCore.framework)


四、在模拟器上测试要 添加 libiconv.dylib， 注意：模拟器上不能测试语音


五、libAppKeFu_KeFu_SDK_device.a 只能在真机上运行，体积较小，可用来发布
libAppKeFu_KeFu_SDK.a 可同时在真机和模拟器上运行，体积较大



升级日志：

20140111: 客服SDK：1、增加常见问题FAQ模块; 2、增加状态栏消息通知
20140107:1、修复消息气泡高亮背景bug
20131220:1、增加扁平气泡样式；2、可自行显示/隐藏/自定义客服/访客头像；3、可停止播放语音；





















