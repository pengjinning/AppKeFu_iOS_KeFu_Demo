//
//  SendTextViewController.m
//  AppKeFu_KeFu_Demo
//
//  Created by jack on 14-2-22.
//  Copyright (c) 2014年 appkefu.com. All rights reserved.
//

#import "SendTextViewController.h"
#import "AppKeFuIMSDK.h"
#import "WTStatusBar.h"

@interface SendTextViewController ()<UITextFieldDelegate, UIAlertViewDelegate>

@property (nonatomic,strong) UITextField *sendTextMessageField;

@end

@implementation SendTextViewController

@synthesize sendTextMessageField;

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
    
    self.tableView.allowsSelection = NO;
	self.tableView.allowsSelectionDuringEditing = NO;
    
    self.title = @"添加同事";
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleFingerTap];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyMessage:) name:APPKEFU_NOTIFICATION_MESSAGE object:nil];
    
    if (sendTextMessageField != nil) {
        [sendTextMessageField becomeFirstResponder];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:APPKEFU_NOTIFICATION_MESSAGE object:nil];
}

- (void)notifyMessage:(NSNotification *)nofication
{
    KFMessageItem *msgItem = [nofication object];
    
    [WTStatusBar setStatusText:[NSString stringWithFormat:@"来自%@的消息",msgItem.username] timeout:2 animated:YES];
}

- (void)notifyMUCMessage:(NSNotification *)nofication
{
    KFMessageItem *msgItem = [nofication object];
    
    [WTStatusBar setStatusText:[NSString stringWithFormat:@"来自群%@的消息",msgItem.roomName] timeout:2 animated:YES];
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
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    else
    {
        // the cell is being recycled, remove old embedded controls
        UIView *viewToRemove = nil;
        viewToRemove = [cell.contentView viewWithTag:5];
        if (viewToRemove)
            [viewToRemove removeFromSuperview];
    }
    
    sendTextMessageField = [[UITextField alloc] initWithFrame:CGRectMake(10, 7, 290, 30)];
    sendTextMessageField.placeholder = @"请输入自定义消息内容";
    sendTextMessageField.borderStyle = UITextBorderStyleNone;
    sendTextMessageField.clearButtonMode = UITextFieldViewModeAlways;
    sendTextMessageField.keyboardType = UIKeyboardTypeASCIICapable;
    sendTextMessageField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    sendTextMessageField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    sendTextMessageField.returnKeyType = UIReturnKeySend;
    [sendTextMessageField becomeFirstResponder];
    sendTextMessageField.delegate = self;
    [cell.contentView addSubview:sendTextMessageField];
    
    return cell;
}

- (void)sendTextMessage
{
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要发送自定义消息？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertview show];
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if([[sendTextMessageField text] length] <= 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"消息内容不能为空哦" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        return FALSE;
    }
    else
    {
        [self sendTextMessage];
    }
    
    return YES;
}

#pragma mark TAP
- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer
{
    [self.view endEditing:YES];
}

#pragma UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[AppKeFuIMSDK sharedInstance] sendTextMessage:[sendTextMessageField text] to:@"admin"];
        [sendTextMessageField setText:@""];
    }
}


@end







