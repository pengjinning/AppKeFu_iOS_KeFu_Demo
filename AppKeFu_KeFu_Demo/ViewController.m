//
//  ViewController.m
//  AppKeFu_KeFu_Demo
//
//  Created by jack on 13-10-17.
//  Copyright (c) 2013年 appkefu.com. All rights reserved.
//

#import "ViewController.h"

#import "AppKeFuIMSDK.h"

@interface ViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong)UIButton *faqBtn;
@property (nonatomic, strong)UIButton *chatBtn;
@property (nonatomic, strong)UIButton *sendTextMsgBtn;
@property (nonatomic, strong)UIButton *sendImgMsgBtn;
@property (nonatomic, strong)UIButton *sendVoiceMsgBtn;

@end

@implementation ViewController

@synthesize faqBtn,chatBtn,sendTextMsgBtn, sendImgMsgBtn, sendVoiceMsgBtn;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"登录中...";
    self.view.backgroundColor = [UIColor whiteColor];
    
    faqBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [faqBtn setBackgroundImage:[[UIImage imageNamed:@"custom-button-normal.png"]
                                stretchableImageWithLeftCapWidth:8 topCapHeight:0]
					  forState:UIControlStateNormal];
    faqBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    faqBtn.frame = CGRectMake(85, 62, 143, 44);
    [faqBtn setTitle:@"常见问题FAQ" forState:UIControlStateNormal];

    chatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[chatBtn setBackgroundImage:[[UIImage imageNamed:@"custom-button-normal.png"]
                                 stretchableImageWithLeftCapWidth:8 topCapHeight:0]
					  forState:UIControlStateNormal];
	chatBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
	chatBtn.frame = CGRectMake(85, 125, 143, 44);
	chatBtn.autoresizingMask = 45;
    
    sendTextMsgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[sendTextMsgBtn setBackgroundImage:[[UIImage imageNamed:@"custom-button-normal.png"]
                                        stretchableImageWithLeftCapWidth:8 topCapHeight:0]
                       forState:UIControlStateNormal];
	sendTextMsgBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
	sendTextMsgBtn.frame = CGRectMake(85, 184, 143, 44);
	sendTextMsgBtn.autoresizingMask = 45;
    [sendTextMsgBtn setTitle:@"发送文字信息" forState:UIControlStateNormal];
    
    sendImgMsgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[sendImgMsgBtn setBackgroundImage:[[UIImage imageNamed:@"custom-button-normal.png"]
                                       stretchableImageWithLeftCapWidth:8 topCapHeight:0]
                       forState:UIControlStateNormal];
	sendImgMsgBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
	sendImgMsgBtn.frame = CGRectMake(85, 243, 143, 44);
	sendImgMsgBtn.autoresizingMask = 45;
    [sendImgMsgBtn setTitle:@"发送图片信息" forState:UIControlStateNormal];
    
    sendVoiceMsgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[sendVoiceMsgBtn setBackgroundImage:[[UIImage imageNamed:@"custom-button-normal.png"]
                                         stretchableImageWithLeftCapWidth:8 topCapHeight:0]
                       forState:UIControlStateNormal];
	sendVoiceMsgBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
	sendVoiceMsgBtn.frame = CGRectMake(85, 380, 143, 44);
	sendVoiceMsgBtn.autoresizingMask = 45;
    [sendVoiceMsgBtn setTitle:@"按住开始录音" forState:UIControlStateNormal];
    
    //需要用真实的客服用户名替代"admin"和appkey, 具体参见：http://appkefu.com/AppKeFu/tutorial-iOS.html
    if ([[AppKeFuIMSDK sharedInstance] isKefuOnlineSync:@"admin"])
    {
        [chatBtn setTitle:@"咨询客服(在线)" forState:UIControlStateNormal];
    }
    else
    {
        [chatBtn setTitle:@"咨询客服(离线)" forState:UIControlStateNormal];
    }
	
	[chatBtn addTarget:self action:@selector(startChatViewController:) forControlEvents:UIControlEventTouchUpInside];
    //发送文字消息
    [sendTextMsgBtn addTarget:self action:@selector(sendTextMsg) forControlEvents:UIControlEventTouchUpInside];
    
    //发送图片消息
    [sendImgMsgBtn addTarget:self action:@selector(sendImgMsg) forControlEvents:UIControlEventTouchUpInside];
    
    //按下按钮开始录音
    [sendVoiceMsgBtn addTarget:self action:@selector(recordStart) forControlEvents:UIControlEventTouchDown];
    //松开按钮发送语音
    [sendVoiceMsgBtn addTarget:self action:@selector(recordEndAndSendVoiceMessage) forControlEvents:UIControlEventTouchUpInside];
    //划出按钮取消发送语音
    [sendVoiceMsgBtn addTarget:self action:@selector(recordCancel) forControlEvents:UIControlEventTouchUpOutside];
    
    
    [self.view addSubview:faqBtn];
	[self.view addSubview:chatBtn];
    [self.view addSubview:sendTextMsgBtn];
    [self.view addSubview:sendImgMsgBtn];
    [self.view addSubview:sendVoiceMsgBtn];
    

}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(messageReceived:)
                                                 name:APPKEFU_NOTIFICATION_MESSAGE
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(isConnected:)
                                                 name:APPKEFU_IS_LOGIN_SUCCEED_NOTIFICATION
                                               object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:APPKEFU_NOTIFICATION_MESSAGE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:APPKEFU_IS_LOGIN_SUCCEED_NOTIFICATION object:nil];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startChatViewController:(id)sender
{
    //自定义聊天窗口背景图片
    //UIImage *backgroundImage = [UIImage imageNamed:@"AppKeFuResources.bundle/chatting_bg_default.jpg"];
    
    //iOS 7.0以上版本显示扁平气泡
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        
        //需要用真实的客服用户名替代"admin", 具体参见：http://appkefu.com/AppKeFu/tutorial-iOS.html
        [[AppKeFuIMSDK sharedInstance] showChatViewController:self.navigationController
                                             withKefuUsername:@"admin"
                                                withGreetings:nil                       //@"你好，请问有什么可以帮您的？"
                                              withBubbleStyle:KFMessageStyleFlat        //扁平气泡
                                              withAvatarStyle:KFMessageAvatarStyleCircle//圆角头像，
                                                                                        //当avatarStyle不为KFMessageAvatarStyleNone时，以下两个参数才有效
                                               withKefuAvatar:nil                       //自定义客服头像
                                                 withMyAvatar:nil                       //自定义访客头像
                                          withBackgroundImage:nil                       //backgroundImage
                                            hideNavigationBar:FALSE                     //适用于需要全屏的App，比如：游戏类，需要全屏时需要设置为TRUE
                                     hidesBottomBarWhenPushed:TRUE
                                                    withTitle:@"咨询客服"];
    }
    //iOS 7.0以下版本显示立体气泡
    else
    {
        //需要用真实的客服用户名替代"admin", 具体参见：http://appkefu.com/AppKeFu/tutorial-iOS.html
        [[AppKeFuIMSDK sharedInstance] showChatViewController:self.navigationController
                                             withKefuUsername:@"admin"
                                                withGreetings:nil                       //@"你好，请问有什么可以帮您的？"
                                              withBubbleStyle:KFMessageStyleDefault     //默认立体气泡
                                              withAvatarStyle:KFMessageAvatarStyleSquare//圆角头像
                                               withKefuAvatar:nil
                                                 withMyAvatar:nil
                                          withBackgroundImage:nil                       //backgroundImage
                                            hideNavigationBar:FALSE                     //适用于需要全屏的App，比如：游戏类，需要全屏时需要设置为TRUE
                                     hidesBottomBarWhenPushed:TRUE
                                                    withTitle:@"咨询客服"];
    }
    
    //发送自定义消息接口，请将其放在合适的位置
    //[[AppKeFuIMSDK sharedInstance] sendTextMessage:@"发送自定义消息，会显示在用户会话窗口中" to:@"admin"];
    
    //利用此函数发送的消息不显示在消息记录中
    //[[AppKeFuIMSDK sharedInstance] sendBackgroundTextMessage:@"后台消息, 用户会话窗口无显示" to:@"admin"];
    
    //设置昵称，用于在客服客户端查看自定义用户名,否则客服客户端看到的将是一串数字, 请将其放在合适的位置
    //[[AppKeFuIMSDK sharedInstance] setNickName:@"访客_ios"];
    
}

- (void)sendTextMsg
{
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要发送自定义消息？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertview.tag = 3;
    [alertview show];
}

- (void)sendImgMsg
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"发送图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册",@"拍照", nil];
    [actionSheet showInView:self.view];
}

-(void)recordStart
{
    sendVoiceMsgBtn.titleLabel.text = @"松开发送语音";
    
    //
    [[AppKeFuIMSDK sharedInstance] beginRecordingVoiceTo:@"admin" inView:self.view];
}

-(void)recordEndAndSendVoiceMessage
{
    sendVoiceMsgBtn.titleLabel.text = @"按住开始录音";
    
    [[AppKeFuIMSDK sharedInstance] stopRecordingAndSendVoiceTo:@"admin"];
}

-(void)recordCancel
{
    sendVoiceMsgBtn.titleLabel.text = @"按住开始录音";
    
    [[AppKeFuIMSDK sharedInstance] cancelRecording];
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 3) {
        
        if (buttonIndex == 1) {
            [[AppKeFuIMSDK sharedInstance] sendTextMessage:@"发送自定义消息_ios" to:@"admin"];
        }
        
    }
    
}


#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if (buttonIndex == 0) {
        [self pickPhoto];
    }
    else if (buttonIndex == 1) {
        [self takePhoto];
    }
    
}

#pragma mark 相册
- (void)pickPhoto
{
    NSLog(@"%s",__FUNCTION__);
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
	picker.allowsEditing = YES;
    
    [self presentViewController:picker animated:YES completion:^{
    }];
    
}

#pragma mark 拍照
- (void)takePhoto
{
    NSLog(@"%s",__FUNCTION__);
    UIImagePickerController *camera = [[UIImagePickerController alloc] init];
	camera.delegate = self;
	camera.allowsEditing = YES;
	
	//检查摄像头是否支持摄像机模式
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
	{
		camera.sourceType = UIImagePickerControllerSourceTypeCamera;
		camera.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
	}
	else
	{
		NSLog(@"Camera not exist");
		return;
	}
	
    [self presentViewController:camera animated:YES completion:^{
        
    }];
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"%s",__FUNCTION__);
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
	NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
	if([mediaType isEqualToString:@"public.movie"])			//被选中的是视频
	{
        
	}
	else if([mediaType isEqualToString:@"public.image"])	//被选中的是图片
	{
        //获取照片实例
		UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        //请将“admin”替换为实际的对方的用户名
        [[AppKeFuIMSDK sharedInstance] sendImageMessage:UIImageJPEGRepresentation(image, 0) to:@"admin"];
	}
	else
	{
		NSLog(@"Error media type");
		return;
	}
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"%s",__FUNCTION__);
    [picker dismissViewControllerAnimated:YES completion:^{}];
}


#pragma mark 接收消息通知
- (void)messageReceived:(NSNotification *)notification
{
    KFMessageItem *msgItem = [notification object];
    
    if (msgItem.isSendFromMe)
    {
        NSLog(@"消息发送给: %@, 消息内容：%@, 发送时间：%@",msgItem.username, msgItem.messageContent, msgItem.timestamp);
    }
    else
    {
        NSLog(@"消息来自于: %@, 消息内容：%@, 发送时间：%@",msgItem.username, msgItem.messageContent, msgItem.timestamp);
    }
    
    switch (msgItem.messageType) {
        case KFMessageText:
            NSLog(@"消息类型：文本");
            break;
        case KFMessageImageHTTPURL:
            NSLog(@"消息类型：图片(地址)");
            break;
        case KFMessageSoundHTTPURL:
            NSLog(@"消息类型：语音(地址)");
            break;
        default:
            break;
    }
}

//接收是否登录成功通知
- (void)isConnected:(NSNotification*)notification
{
    NSNumber *isConnected = [notification object];
    if ([isConnected boolValue])
    {
        //登录成功
        self.title = @"微客服(登录成功)";
    }
    else
    {
        //登录失败
        self.title = @"微客服(登录失败)";
    }
}


@end














