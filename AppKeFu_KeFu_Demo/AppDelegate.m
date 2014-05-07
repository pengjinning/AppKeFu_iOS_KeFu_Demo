//
//  AppDelegate.m
//  AppKeFu_KeFu_Demo
//
//  Created by jack on 13-10-17.
//  Copyright (c) 2013年 appkefu.com. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "AppKeFuIMSDK.h"
#import "SVProgressHUD.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //自定义UINavigationBar
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        // Uncomment to change the background color of navigation bar
        [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0x067AB5)];
        // Uncomment to change the color of back button
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    }
    
    //注册离线消息推送
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes: UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert];

    // Override point for customization after application launch.
    MainViewController *sampleViewController = [[MainViewController alloc] init];
    self.navigationController = [[MyNavigationController alloc] initWithRootViewController:sampleViewController];
    //适用于全屏App，需要隐藏导航条的情况，比如：游戏类
    //[self.navigationController setNavigationBarHidden:TRUE animated:FALSE];
    
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    
    
    //请到http://appkefu.com/AppKeFu/admin 申请 app key
    if ([[AppKeFuIMSDK sharedInstance] initWithAppkey:@"6f8103225b6ca0cfec048ecc8702dbce"])
    {
        [SVProgressHUD showWithStatus:@"登录中..."];
        //OpenUDID登录
        [[AppKeFuIMSDK sharedInstance] login];
    }
    else
    {
        NSLog(@"app key 无效， 请到http://appkefu.com/AppKeFu/admin, 申请");
    }
    
    return YES;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark 离线消息推送
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    //需要填写真实的appkey, 并在后台相应的应用内上传必要的证书
    //请到http://appkefu.com/AppKeFu/admin 申请 app key
    NSString *myappkey = @"6f8103225b6ca0cfec048ecc8702dbce";
    
    //已经登录的用户名
    NSString *myusername = [[AppKeFuIMSDK sharedInstance] getUsername];//有待替换此方法，改为本地存储的
    if ([myusername isEqualToString:@"未登录"]) {
        NSLog(@"未登录, 请登录!");
        return;
    }
    
    //本机的deviceToken
    NSString* newToken = [deviceToken description];
    newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"deviceToken:%@", newToken);
    
    //通过http get的方式将myusername, deviceToken, myappkey送到服务器，用于离线消息推送
    NSURL *url = [NSURL URLWithString:[NSString localizedStringWithFormat:@"http://appkefu.com/AppKeFu/uploadDeviceToken.php?username=%@&token=%@&appkey=%@",myusername, newToken, myappkey]];
    
    NSMutableURLRequest* request = [NSMutableURLRequest new];
    [request setURL:url];
    [request setHTTPMethod:@"GET"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:nil error:nil];
    NSString* response = [[NSString alloc] initWithData:data
                                               encoding:NSUTF8StringEncoding];
    
    NSLog(@"%s,%@",__FUNCTION__, response);

}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    NSLog(@"收到推送消息。这里主要起到通知的作用，用户进入应用后，服务器会再次推送即时通讯消息");
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"注册推送失败，原因：%@",error);
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    //苹果官方规定除特定应用类型，如：音乐、VOIP类可以在后台运行，其他类型应用均不得在后台运行，所以在程序退到后台要执行logout登出，
    //离线消息通过服务器推送可接收到
    //在程序切换到前台时，执行重新登录，见applicationWillEnterForeground函数中
    [[AppKeFuIMSDK sharedInstance] logout];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    //切换到前台重新登录
    //[SVProgressHUD showWithStatus:@"登录中..."];
    [[AppKeFuIMSDK sharedInstance] login];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
