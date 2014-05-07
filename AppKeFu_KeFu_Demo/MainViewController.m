//
//  MainViewController.m
//  AppKeFu_KeFu_Demo
//
//  Created by jack on 14-1-10.
//  Copyright (c) 2014年 appkefu.com. All rights reserved.
//

#import "MainViewController.h"
#import "AppKeFuIMSDK.h"
#import "WTStatusBar.h"
#import "SVProgressHUD.h"
#import "FreeAPIsTableViewController.h"
#import "VIPAPIsTableViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

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
    
    self.title = @"微客服(客服Demo)";
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
    return 2;
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
        cell.textLabel.text = @"1.免费接口";
    }
    else if (indexPath.row == 1)
    {
        cell.textLabel.text = @"2.高级接口";
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        FreeAPIsTableViewController *freeAPIsVC = [[FreeAPIsTableViewController alloc] init];
        [self.navigationController pushViewController:freeAPIsVC animated:YES];
    }
    else if (indexPath.row == 1)
    {
        VIPAPIsTableViewController *vipAPIsVC = [[VIPAPIsTableViewController alloc] init];
        [self.navigationController pushViewController:vipAPIsVC animated:YES];
    }
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












