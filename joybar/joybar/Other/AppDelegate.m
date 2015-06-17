//
//  AppDelegate.m
//  joybar
//
//  Created by 卢兴 on 15/4/2.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "AppDelegate.h"
#import "BuyerIssueViewController.h"
#import "SocketManager.h"
#import "UMSocialData.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSnsService.h"
@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    [UMSocialData setAppKey:@"557f8f1c67e58edf32000208"];
    
    [UMSocialWechatHandler setWXAppId:@"wx0bd15e11e7c3090f" appSecret:@"e3ff58518855345970755d08a3540c26" url:@"http://www.umeng.com/social"];

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
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{

    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
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
    return  [UMSocialSnsService handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url];
}

@end
