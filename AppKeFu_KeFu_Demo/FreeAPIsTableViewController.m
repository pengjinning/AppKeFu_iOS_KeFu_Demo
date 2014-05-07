//
//  FreeAPIsTableViewController.m
//  AppKeFu_KeFu_Demo
//
//  Created by jack on 14-4-13.
//  Copyright (c) 2014年 appkefu.com. All rights reserved.
//

#import "FreeAPIsTableViewController.h"
#import "AppKeFuIMSDK.h"
#import "SendTextViewController.h"
#import "SendVoiceViewController.h"
#import "WTStatusBar.h"
#import "SVProgressHUD.h"
#import "TagsTableViewController.h"

@interface FreeAPIsTableViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation FreeAPIsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"免费接口";
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(messageReceived:) name:APPKEFU_NOTIFICATION_MESSAGE object:nil];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(isConnected:) name:APPKEFU_IS_LOGIN_SUCCEED_NOTIFICATION object:nil];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (indexPath.row == 0)
    {
        cell.textLabel.text = @"1.常见问题FAQ";
    }
    else if (indexPath.row == 1)
    {
        //需要用真实的客服用户名替代"your_kefu_username", 具体参见：http://appkefu.com/AppKeFu/tutorial-iOS.html
        if ([[AppKeFuIMSDK sharedInstance] isKefuOnlineSync:@"your_kefu_username"])
        {
            cell.textLabel.text = @"2.咨询客服(在线)";
        }
        else
        {
            cell.textLabel.text = @"2.咨询客服(离线)";
        }
    }
    else if (indexPath.row == 2)
    {
        cell.textLabel.text = @"3.发送文字信息";
    }
    else if (indexPath.row == 3)
    {
        cell.textLabel.text = @"4.发送后台文字消息,不显示在用户会话界面";
    }
    else if (indexPath.row == 4)
    {
        cell.textLabel.text = @"5.发送图片信息";
    }
    else if (indexPath.row == 5)
    {
        cell.textLabel.text = @"6.发送语音信息";
    }
    else if (indexPath.row == 6)
    {
        cell.textLabel.text = @"7.设置用户标签";
    }
    else if (indexPath.row == 7)
    {
        cell.textLabel.text = @"8.设置用户昵称";
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        [[AppKeFuIMSDK sharedInstance] showFAQViewController:self.navigationController];
    }
    else if (indexPath.row == 1)
    {
        [self startChatViewController];
    }
    else if (indexPath.row == 2)
    {
        SendTextViewController *textVC = [[SendTextViewController alloc] initWithStyle:UITableViewStyleGrouped];
        textVC.isBackgroundMessage = FALSE;
        [self.navigationController pushViewController:textVC animated:YES];
    }
    else if (indexPath.row == 3)
    {
        SendTextViewController *textVC = [[SendTextViewController alloc] initWithStyle:UITableViewStyleGrouped];
        textVC.isBackgroundMessage = TRUE;
        [self.navigationController pushViewController:textVC animated:YES];
    }
    else if (indexPath.row == 4)
    {
        [self sendImgMsg];
    }
    else if (indexPath.row == 5)
    {
        SendVoiceViewController *voiceVC = [[SendVoiceViewController alloc] init];
        [self.navigationController pushViewController:voiceVC animated:YES];
    }
    else if (indexPath.row == 6)//6.设置用户标签
    {
        TagsTableViewController *tagsVC = [[TagsTableViewController alloc] init];
        [self.navigationController pushViewController:tagsVC animated:YES];
    }
    else if (indexPath.row == 7)//设置用户昵称
    {
        //设置昵称，用于在客服客户端查看自定义用户名,否则客服客户端看到的将是一串数字, 请将其放在合适的位置
        [[AppKeFuIMSDK sharedInstance] setNickName:@"访客_ios"];
        
        [SVProgressHUD showSuccessWithStatus:@"用户昵称设置"];
    }
    
}

- (void)startChatViewController
{
    //自定义会话页面'返回'按钮
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title = @"自定义";
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    
    //需要用真实的客服用户名替代"your_kefu_username", 具体参见：http://appkefu.com/AppKeFu/tutorial-iOS.html
    [[AppKeFuIMSDK sharedInstance] showChatViewController:self.navigationController
                                         withKefuUsername:@"your_kefu_username"
                                            withGreetings:@"你好，请问有什么可以帮您的？" //@"你好，请问有什么可以帮您的？"
                                          withBubbleStyle:KFMessageStyleFlat         //扁平气泡
                                          withAvatarStyle:KFMessageAvatarStyleSquare //自定义头像形状，
     //当avatarStyle不为KFMessageAvatarStyleNone时，以下两个参数才有效
                                           withKefuAvatar:nil                       //自定义客服头像
                                             withMyAvatar:nil                       //自定义访客头像
                                      withBackgroundImage:nil                       //backgroundImage
                                        hideNavigationBar:FALSE                     //适用于需要全屏的App，比如：游戏类，需要全屏时需要设置为TRUE
                                 hidesBottomBarWhenPushed:TRUE
                                                withTitle:@"咨询客服"];
    
}

- (void)sendImgMsg
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"发送图片"
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"相册",@"拍照", nil];
    [actionSheet showInView:self.view];
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
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
	picker.allowsEditing = YES;
    
    [self presentViewController:picker animated:YES completion:^{
    }];
    
}

#pragma mark 拍照
- (void)takePhoto
{
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
    [picker dismissViewControllerAnimated:YES completion:^{}];
	NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
	if([mediaType isEqualToString:@"public.movie"])			//被选中的是视频
	{
        
	}
	else if([mediaType isEqualToString:@"public.image"])	//被选中的是图片
	{
        //获取照片实例
		UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        //请将“your_kefu_username”替换为实际的对方的用户名
        [[AppKeFuIMSDK sharedInstance] sendImageMessage:UIImageJPEGRepresentation(image, 0) to:@"your_kefu_username"];
	}
	else
	{
		NSLog(@"Error media type");
		return;
	}
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
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
    
    [WTStatusBar setStatusText:[NSString stringWithFormat:@"来自%@的消息",msgItem.username] timeout:2 animated:YES];
    
}

//接收是否登录成功通知
- (void)isConnected:(NSNotification*)notification
{
    NSNumber *isConnected = [notification object];
    if ([isConnected boolValue])
    {
        //登录成功
        self.title = @"微客服(登录成功)";
        
        [SVProgressHUD showSuccessWithStatus:@"登录成功"];
    }
    else
    {
        //登录失败
        self.title = @"微客服(登录失败)";
        
        [SVProgressHUD showErrorWithStatus:@"登录失败"];
    }
}


@end








