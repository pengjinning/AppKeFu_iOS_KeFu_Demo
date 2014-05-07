//
//  TagsChangeTableViewController.m
//  AppKeFu_KeFu_Demo
//
//  Created by jack on 14-4-13.
//  Copyright (c) 2014年 appkefu.com. All rights reserved.
//

#import "TagsChangeTableViewController.h"
#import "AppKeFuIMSDK.h"
#import "WTStatusBar.h"

@interface TagsChangeTableViewController ()<UITextFieldDelegate>

@property (nonatomic,strong) UITextField *tagChangeField;

@end

@implementation TagsChangeTableViewController

@synthesize tagChangeField, m_tag;

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
    
    self.title = @"修改用户标签";
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleFingerTap];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyMessage:) name:APPKEFU_NOTIFICATION_MESSAGE object:nil];
    
    if (tagChangeField != nil) {
        [tagChangeField becomeFirstResponder];
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
    
    tagChangeField = [[UITextField alloc] initWithFrame:CGRectMake(10, 7, 290, 30)];
    tagChangeField.placeholder = @"请输入内容";
    tagChangeField.borderStyle = UITextBorderStyleNone;
    tagChangeField.clearButtonMode = UITextFieldViewModeAlways;
    //tagChangeField.keyboardType = UIKeyboardTypeASCIICapable;
    tagChangeField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    tagChangeField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    tagChangeField.returnKeyType = UIReturnKeySend;
    [tagChangeField becomeFirstResponder];
    tagChangeField.delegate = self;
    [cell.contentView addSubview:tagChangeField];
    
    return cell;
}

- (void)tagChange
{
    if ([m_tag isEqualToString:@"NICKNAME"])
    {
        [APPKEFU setTagNickname:[tagChangeField text]];
    }
    else if ([m_tag isEqualToString:@"SEX"])
    {
        [APPKEFU setTagSex:[tagChangeField text]];
    }
    else if ([m_tag isEqualToString:@"LANGUAGE"])
    {
        [APPKEFU setTagLanguage:[tagChangeField text]];
    }
    else if ([m_tag isEqualToString:@"CITY"])
    {
        [APPKEFU setTagCity:[tagChangeField text]];
    }
    else if ([m_tag isEqualToString:@"PROVINCE"])
    {
        [APPKEFU setTagProvince:[tagChangeField text]];
    }
    else if ([m_tag isEqualToString:@"COUNTRY"])
    {
        [APPKEFU setTagCountry:[tagChangeField text]];
    }
    else if ([m_tag isEqualToString:@"OTHER"])
    {
        [APPKEFU setTagOther:[tagChangeField text]];
    }
    
    [tagChangeField setText:@""];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if([[tagChangeField text] length] <= 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"内容不能为空哦" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        return FALSE;
    }
    else
    {
        [self tagChange];
    }
    
    return YES;
}

#pragma mark TAP
- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer
{
    [self.view endEditing:YES];
}



@end
