//
//  AppDelegate.m
//  joybar
//
//  Created by 卢兴 on 15/4/2.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "AppDelegate.h"
#import "SocketManager.h"
#import "UMSocialData.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSnsService.h"
#import "payRequsestHandler.h"
#import "APService.h"
#define size 10
@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
    [APService setupWithOption:launchOptions];
    [UMSocialData setAppKey:@"557f8f1c67e58edf32000208"];
    //向微信注册
    [WXApi registerApp:APP_ID];

    //状态栏白色
//    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    CusTabBarViewController *cusTabbar = [[CusTabBarViewController alloc] init];
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:cusTabbar];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    [self connectionSoctet];
   
    return YES;
}
-(void)newMsg{
    
    [[SocketManager socketManager].socket on:@"new message" callback:^(NSArray *args) {
        
        NSLog(@"哈哈哈哈哈哈:");
    }];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}

-(void)connectionSoctet{
    
    [SIOSocket socketWithHost: SocketUrl response: ^(SIOSocket *socket) {
        [SocketManager socketManager].socket = socket;
        [socket on: @"connect" callback: ^(SIOParameterArray *args) {
            
            NSLog(@"connnection is success:%@",[args description]);
            
        }];

//        [socket on:@"disconnect" callback:^(NSArray *args) {
//            NSLog(@"disconnect");
//        }];
    }];
}

#pragma mark--APNs处理部分
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
}

// Called when your app has been activated by the user selecting an action from
// a local notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forLocalNotification:(UILocalNotification *)notification
  completionHandler:(void (^)())completionHandler {
}

// Called when your app has been activated by the user selecting an action from
// a remote notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void (^)())completionHandler {
}
#endif

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [APService handleRemoteNotification:userInfo];
    NSLog(@"收到通知");
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler
{
    [APService handleRemoteNotification:userInfo];
    NSLog(@"收到通知1111");
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    [APService showLocalNotificationAtFront:notification identifierKey:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
}



- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    
    
//    return [WXApi handleOpenURL:url delegate:self];
    
    return  [UMSocialSnsService handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    NSString *urlStr = [NSString stringWithFormat:@"%@",url];

    if ([urlStr isEqualToString:@"wx281aa8c2686c0e7c://platformId=wechat"])
    {
        return  [UMSocialSnsService handleOpenURL:url];
    }
    else if ([urlStr rangeOfString:@"wx281aa8c2686c0e7c://oauth?code="].location !=NSNotFound)
    {
        return  [UMSocialSnsService handleOpenURL:url];
    }
    return [WXApi handleOpenURL:url delegate:self];


}

//============================================================
// 微信支付流程实现
//============================================================

- (void)sendPay_demo:(NSString *)orderNum andName:(NSString *)name andPrice:(NSString *)price
{    
    //创建支付签名对象
    payRequsestHandler *req = [payRequsestHandler alloc];
    //初始化支付签名对象
    [req init:APP_ID mch_id:MCH_ID];
    //设置密钥
    [req setKey:PARTNER_ID];
    
    //}}}
    
    //获取到实际调起微信支付的参数后，在app端调起支付
    NSMutableDictionary *dict = [req sendPay_demo:orderNum andName:name andPrice:price];
    
    if(dict == nil)
    {
        //错误提示
        NSString *debug = [req getDebugifo];
        
        [self alert:@"提示信息" msg:debug];
        
        NSLog(@"%@\n\n",debug);
    }
    else
    {
        NSLog(@"%@\n\n",[req getDebugifo]);
        //[self alert:@"确认" msg:@"下单成功，点击OK后调起支付！"];
        
        NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
        
        //调起微信支付
        PayReq* req             = [[PayReq alloc] init];
        req.openID              = [dict objectForKey:@"appid"];
        req.partnerId           = [dict objectForKey:@"partnerid"];
        req.prepayId            = [dict objectForKey:@"prepayid"];
        req.nonceStr            = [dict objectForKey:@"noncestr"];
        req.timeStamp           = stamp.intValue;
        req.package             = [dict objectForKey:@"package"];
        req.sign                = [dict objectForKey:@"sign"];
        [WXApi sendReq:req];
    }
}


//客户端提示信息
- (void)alert:(NSString *)title msg:(NSString *)msg
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alter show];
}

-(void) onResp:(BaseResp*)resp
{
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;
    
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    }
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:
            {
                strMsg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PaySuccessNotification" object:self userInfo:nil];
            }
                break;
            case WXErrCodeUserCancel:
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PayCancleNotification" object:self userInfo:nil];
            }
                break;
                
            default:
//                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
//                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

}


@end
