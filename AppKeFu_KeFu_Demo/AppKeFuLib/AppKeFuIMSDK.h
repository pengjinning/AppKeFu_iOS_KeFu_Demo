//
//  AppKeFuIMSDK.h
//  AppKeFuIMSDK
//
//  Created by jack on 13-9-20.
//  Copyright (c) 2013年 appkefu.com. All rights reserved.
//
//

#import <Foundation/Foundation.h>

//消息通知
#define APPKEFU_NOTIFICATION_MESSAGE                @"appkefu_notification_message"

//登录成功通知
#define APPKEFU_IS_LOGIN_SUCCEED_NOTIFICATION       @"is_appkefu_login_succeed_notification"

//后台消息前缀，具有此前缀的消息将不显示在会话窗口中
#define APPKEFU_IN_VISIBLE_MESSAGE_PREFIX           @"appkefu_in_visible_"

//
typedef enum {
    KFMessageText = 0,              //文本消息
    KFMessageImageHTTPURL,          //图片消息
    KFMessageSoundHTTPURL           //语音消息
} KFMessageType;

typedef enum {
    KFMessageStyleDefault = 0,      //默认气泡形式
    KFMessageStyleSquare,           //正方形气泡
    KFMessageStyleDefaultGreen,     //绿色气泡
    KFMessageStyleFlat,             //扁平气泡
    KFMessageStyleWeixin            //微信气泡
} KFMessageStyle;

typedef enum {
    KFMessageAvatarStyleCircle = 0, //显示圆形头像
    KFMessageAvatarStyleSquare,     //显示正方形头像
    KFMessageAvatarStyleNone        //不显示头像
} KFMessageAvatarStyle;

typedef enum {
    KFMessagesAvatarPolicyIncomingOnly = 0,
    KFMessagesAvatarPolicyBoth,
    KFMessagesAvatarPolicyNone
} KFMessagesAvatarPolicy;


@interface KFMessageItem : NSObject

@property (nonatomic, strong) NSString      *username;
@property (nonatomic, strong) NSDate        *timestamp;
@property (nonatomic, strong) NSString      *messageContent;
@property (nonatomic, assign) KFMessageType messageType;
@property (nonatomic, assign) BOOL          isSendFromMe;
@property (nonatomic, strong) NSString      *roomName;//群聊消息专用

@end

////////////////////////////
@interface KFConversationItem : NSObject

@property (nonatomic, strong) NSString * username;
@property (nonatomic, strong) NSString * domain;

@property (nonatomic, strong) NSDate   * mostRecentMessageTimestamp;
@property (nonatomic, strong) NSString * mostRecentMessageBody;
@property (nonatomic, strong) NSNumber * mostRecentMessageOutgoing;
@property (nonatomic, strong) NSNumber * unreadMessagesCount;

@end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//请在使用前务必阅读README.md文件
//详细使用文档: http://appkefu.com/AppKeFu/tutorial-iOS.html
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


@interface AppKeFuIMSDK : NSObject

+(AppKeFuIMSDK*)sharedInstance;

//函数1: 这是使用此sdk的初始化函数, 函数将对appkey进行验证
//      如果appkey无效, 将无法登录/无法发送消息，
//      请务必在使用前到http://appkefu.com/AppKeFu/admin申请有效appkey
-(BOOL) initWithAppkey:(NSString*)appkey;

//函数2: 基于OpenUDID进行登录, 第一次登录会自行执行注册操作
//      登录结果会通过发送通知 APPKEFU_IS_LOGIN_SUCCEED_NOTIFICATION 进行广播,
//      结果为BOOL值：TRUE:登录成功，FALSE:登录失败
//      具体使用请参见MainViewController.m文件
-(void) login;

//函数3：判断登录状态，TRUE：已经登录；FALSE：未登录
-(BOOL) isConnected;

//函数4: 设置昵称，用于在客服客户端查看自定义用户名,否则客服客户端看到的将是一串数字, 请将其放在合适的位置
//建议: 请在发送消息(在调用 函数5 和 函数6 之前)前调用此函数
- (void) setNickName:(NSString*)nickname;

//函数5: 判断kefuUsername是否在线, 原理: 发送同步HTTP请求
- (BOOL)isKefuOnlineSync:(NSString*) kefuUsername;

//函数6: 发送自定义消息接口，请将其放在合适的位置, 在登录成功之后调用
-(void) sendTextMessage:(NSString*)content to:(NSString*)username;

//函数7: 利用此函数发送的消息不显示在消息记录中
-(void) sendBackgroundTextMessage:(NSString *)content to:(NSString *)username;

//函数8：发送图片
-(void) sendImageMessage:(NSData*)imageData to:(NSString*)username;

//函数9：发送语音（depreciated, 建议选择函数10~13发送语音，具体见Demo）
-(void) sendVoiceMessage:(NSData*)voiceData soundName:(NSString *)soundName to:(NSString*)username;

//函数10：开始录音
-(void) beginRecordingVoiceTo:(NSString*)username inView:(UIView *)inView;

//函数11：停止录音并发送语音
-(void) stopRecordingAndSendVoiceTo:(NSString*)username;

//函数12：取消录音
-(void) cancelRecording;

//函数13：首先现在urlPath上面的amr文件，然后转换为wav文件，再播放wav语音
-(void) playSoundWithPath:(NSString*)urlPath;

//函数14：转换wav文件为amr文件，如果转换成功返回TRUE, 否则返回FALSE
//其中：pathToWAV为wav文件的路径, pathToAMR为amr文件的保存路径
-(BOOL) convertWAVToAMR:(NSString *)pathToWAV to:(NSString *)pathToAMR;

//函数15：转换amr文件为wav文件，如果转换成功返回TRUE, 否则返回FALSE
//其中：pathToAMR为amr文件的路径, pathToWAV为wav文件的保存路径
-(BOOL) convertAMRToWAV:(NSString *)pathToAMR to:(NSString *)pathToWAV;

//函数16: 打开聊天窗口
- (void)showChatViewController:(UINavigationController *)navController
              withKefuUsername:(NSString *)kefuUsername                     //客服用户名
                 withGreetings:(NSString *)greetings                        //问候语
               withBubbleStyle:(KFMessageStyle)style                        //气泡样式
               withAvatarStyle:(KFMessageAvatarStyle)avatarStyle            //头像样式
                                                                            //当avatarStyle不为KFMessageAvatarStyleNone时，以下两个参数才有效
                withKefuAvatar:(UIImage *)kefuImage                         //客服头像
                  withMyAvatar:(UIImage *)myImage                           //访客头像
           withBackgroundImage:(UIImage *)backgroundImage                   //会话窗口背景
             hideNavigationBar:(BOOL)hideNav                                //适用于需要全屏的App设置为TRUE，比如：游戏类，否则设置为FALSE
                                                                            //需要配合AppDelegate中的[self.navigationController setNavigationBarHidden:TRUE animated:TRUE];
      hidesBottomBarWhenPushed:(BOOL)hideBottomBar                          //
                     withTitle:(NSString*)windowTitle;                      //会话窗口title

//函数17：排队咨询
- (void)showQChatViewController:(UINavigationController *)navController
              withWorkgroupName:(NSString *)workgroupName
                 withWindowTile:(NSString *)windowTitle
            withBackgroundImage:(UIImage *)backgroundImage;                 //会话窗口背景

//函数18: 显示常见问题FAQ,需要在管理后台配置
- (void)showFAQViewController:(UINavigationController *)navController;

//函数19: 登出
- (void)logout;

//函数20: 获取用户名
- (NSString*) getUsername;

@end










































