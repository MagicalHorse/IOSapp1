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
#import "OSSClient.h"
#import "OSSTool.h"
#import "CusTabBarViewController.h"
#import "MobClick.h"
#import "DES3Util.h"
@implementation AppDelegate
{
    CusTabBarViewController *cusTabbar;
    UIPageControl *pageCtrl;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    application.statusBarHidden = NO;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    } else {
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
    
    [APService setupWithOption:launchOptions];
    [UMSocialData setAppKey:@"55d43bf367e58eac01002b7f"];
    [MobClick startWithAppkey:@"55d43bf367e58eac01002b7f"];
    //557f8f1c67e58edf32000208

    //向微信注册
    [WXApi registerApp:APP_ID];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    NSString *userId =[NSString stringWithFormat:@"%@",[[Public getUserInfo] objectForKey:@"id"]];
    
    if (![userId isEqualToString:@"(null)"])
    {
        [APService setAlias:userId callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
    }
    cusTabbar = [[CusTabBarViewController alloc] init];
//    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:cusTabbar];
    self.window.rootViewController = cusTabbar;
    [self.window makeKeyAndVisible];

    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstStart"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStart"];
        [self _initWithScrollViewForSoftHelp];
    }
    else
    {
        
    }
    [self aliyunSet];
    
//    [self startLocation];
    return YES;
}

//开始定位
-(void)startLocation
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 10.0f;
    [self.locationManager startUpdatingLocation];
    //在ios 8.0下要授权
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [_locationManager requestWhenInUseAuthorization];  //调用了这句,就会弹出允许框了.
    }
}

//定位代理经纬度回调
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [_locationManager stopUpdatingLocation];
    NSLog(@"location ok");
    
    NSLog(@"%@",[NSString stringWithFormat:@"经度:%3.5f\n纬度:%3.5f",newLocation.coordinate.latitude,newLocation.coordinate.longitude]);
    self.latitude =[NSString stringWithFormat:@"%f",newLocation.coordinate.latitude];
    self.longitude =[NSString stringWithFormat:@"%f",newLocation.coordinate.longitude];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"定位失败" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重新定位", nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        [self.locationManager startUpdatingLocation];
    }
}

//当软件第一次启动时运行
- (void)_initWithScrollViewForSoftHelp
{
    //创建存放引导图片的数组
    NSArray *helpImageArray;
    if (kScreenHeight==480)
    {
        helpImageArray= @[@"guidepage1_640x960",@"guidepage2_640x960",@"guidepage3_640x960"];
    }
    else if (kScreenHeight==1136/2)
    {
        
        helpImageArray= @[@"guidepage1_640x1136",@"guidepage2_640x1136",@"guidepage3_640x1136"];
    }
    else if (kScreenHeight==1334/2)
    {
        helpImageArray= @[@"guidepage1_750x1334",@"guidepage2_750x1334",@"guidepage3_750x1334"];
    }
    else
    {
        helpImageArray= @[@"guidepage1_1202x2208",@"guidepage2_1202x2208",@"guidepage3_1202x2208"];
    }
    UIScrollView *helpScrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    helpScrollView.backgroundColor = [UIColor clearColor];
    helpScrollView.pagingEnabled = YES;
    [helpScrollView setShowsHorizontalScrollIndicator:NO];
    [helpScrollView setShowsVerticalScrollIndicator:NO];
    helpScrollView.clipsToBounds = YES;
    helpScrollView.tag = 33333;
    helpScrollView.delegate = self;
    helpScrollView.bounces = NO;
    helpScrollView.contentSize = CGSizeMake(kScreenWidth*[helpImageArray count], kScreenHeight);
    [self.window addSubview:helpScrollView];
    

    
    for (int i = 0; i < [helpImageArray count]; i++)
    {
        UIImageView *helpImage = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth*i, 0, helpScrollView.width, helpScrollView.height)];
        helpImage.image = [UIImage imageNamed:helpImageArray[i]];
        [helpScrollView addSubview:helpImage];
        //创建进入按钮
        if (i == ([helpImageArray count]-1))
        {
            UIButton *enterBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
            enterBtn.center = CGPointMake(kScreenWidth/2+kScreenWidth*i, kScreenHeight-70);
            enterBtn.bounds = CGRectMake(0, 0, (kScreenWidth-80)/2, 40);
            enterBtn.backgroundColor = [UIColor orangeColor];
            [enterBtn setTitle:@"立即体验" forState:(UIControlStateNormal)];
            enterBtn.backgroundColor = [UIColor whiteColor];
            enterBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [enterBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
            [enterBtn addTarget:self action:@selector(introDidFinish) forControlEvents:(UIControlEventTouchUpInside)];
            [helpScrollView addSubview:enterBtn];
        }
    }
    pageCtrl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, kScreenHeight-40, kScreenWidth, 30)];  //创建UIPageControl，位置在屏幕最下方。
    pageCtrl.numberOfPages = helpImageArray.count;//总的图片页数
    pageCtrl.currentPage = 0; //当前页
    pageCtrl.pageIndicatorTintColor = [UIColor whiteColor];
    pageCtrl.currentPageIndicatorTintColor = [UIColor redColor];
    //    [pageCtrl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];  //用户点击UIPageControl的响应函数
    [self.window addSubview:pageCtrl];  //将UIPageControl添加到主界面上。

}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //更新UIPageControl的当前页
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.frame;
    [pageCtrl setCurrentPage:offset.x / bounds.size.width];
}

//引导页结束
- (void)introDidFinish
{
    [pageCtrl removeFromSuperview];
    UIScrollView *sc = (UIScrollView *)[self.window viewWithTag:33333];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [sc removeFromSuperview];
}

- (void)tagsAliasCallback:(int)iResCode
                     tags:(NSSet *)tags
                    alias:(NSString *)alias {
    NSString *callbackString =
    [NSString stringWithFormat:@"%d, \ntags: %@, \nalias: %@\n", iResCode,tags,alias];
    NSLog(@"TagsAlias回调:%@", callbackString);
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
    [APService setBadge:0];
    [application cancelAllLocalNotifications];
}

//socket
-(void)connectionSoctet{
    
    NSString *userId =[[Public getUserInfo]objectForKey:@"id"];
    if (userId)
    {
        //获取系统当前的时间戳
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval a=[dat timeIntervalSince1970]*1000;
        NSString *timeString = [NSString stringWithFormat:@"%f", a];//转为字符型

        NSString *sign = [NSString stringWithFormat:@"%@%@%@%@",userId,timeString,@"maishouapp",@"maishouapp"];
        NSString *url = [NSString stringWithFormat:@"%@?userid=%@&timestamp=%@&appid=%@&sign=%@",SocketUrl,userId,timeString,@"maishouapp",[sign md5Encrypt]];
        [SIOSocket socketWithHost:url response:^(SIOSocket *socket) {
            [SocketManager socketManager].socket = socket;
            [socket on: @"connect" callback: ^(SIOParameterArray *args)
            {
                NSLog(@"connnection is success:%@",[args description]);
            }];
            
            [[SocketManager socketManager].socket emit:@"online" args:@[userId]];
            [[SocketManager socketManager].socket on:@"room message" callback:^(NSArray *args) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:args.firstObject];
                NSString *toUserId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"toUserId"]];
                
                if (cusTabbar.selectedIndex==1||cusTabbar.selectedIndex ==2)
                {
                    cusTabbar.circleMarkLab.hidden = YES;
                    cusTabbar.msgMarkLab.hidden = YES;
                    
                    if ([toUserId isEqualToString:@"0"])
                    {
                        [cusTabbar.fastView receiveMessage];
                    }
                    else
                    {
                        [cusTabbar.messageView receiveMessage];
                    }
                }
                else
                {
                    if ([toUserId isEqualToString:@"0"])
                    {
                        cusTabbar.circleMarkLab.hidden = NO;
                    }
                    else
                    {
                        cusTabbar.msgMarkLab.hidden = NO;
                    }
                }
            }];
        }];
        
//        [[SocketManager socketManager].socket on:@"server_notice" callback:^(NSArray *args)
//        {
//            NSLog(@"%@",args);
//        }];
    }
    
}

//阿里云
-(void)aliyunSet{
    
    [HttpTool postWithURL:@"Common/GetALiYunAccessKey" params:nil isWrite:NO success:^(id json){
        
        if ([[json objectForKey:@"isSuccessful"]boolValue]) {
            
            NSString *key = [[json objectForKey:@"data"] objectForKey:@"AccessKey"] ;
            NSString *sign = [[json objectForKey:@"data"] objectForKey:@"AccessKeySecret"];
            [Common saveUserDefault:[DES3Util decrypt:key] keyName:@"alykey"];
            [Common saveUserDefault:[DES3Util decrypt:sign] keyName:@"alysign"];
        }
        
    
    } failure:^(NSError *error) {
        
    }];
    OSSClient *ossclient = [OSSClient sharedInstanceManage];
    [ossclient setGlobalDefaultBucketHostId:AlyBucketHostId];
    [ossclient setGenerateToken:^(NSString *method, NSString *md5, NSString *type, NSString *date, NSString *xoss, NSString *resource){
        NSString *signature = nil;
        NSString *content = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@%@", method, md5, type, date, xoss, resource];
        NSString *sign=[Common getUserDefaultKeyName:@"alysign"];
        NSString *key =[Common getUserDefaultKeyName:@"alykey"];
        signature = [OSSTool calBase64Sha1WithData:content withKey :sign];
        signature = [NSString stringWithFormat:@"OSS %@:%@",key , signature];
        NSLog(@"here signature:%@", signature);
        return signature;
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
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler
{
    [APService handleRemoteNotification:userInfo];
    NSString *type = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"type"]];
    if ([type isEqual:@"14"])
    {
        cusTabbar.msgMarkLab.hidden = YES;
        
        [cusTabbar.messageView receiveMessage];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[userInfo objectForKey:@"title"] message:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好", nil];
        [alert show];
    }
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    [APService showLocalNotificationAtFront:notification identifierKey:nil];
}
/*
 订单相关=1（暂时没用）
 买手审核通过 = 2,
 买手审核驳回 = 3,
 用户支付-推送给买手=4,
 用户支付--推送给用户 = 5,
 用户申请退款-推送给买手 = 6,
 用户申请退款--推送给用户= 7,
 用户收货--推送给买手 = 8,
 用户收货，推送给用户 = 9,
 提现货款  = 10,
 提现收益  = 11,
 买手同意退货= 12,
 买手不同意退货 = 13,
*/

- (void)applicationWillResignActive:(UIApplication *)application
{
    
}
- (void)applicationDidEnterBackground:(UIApplication *)application
{

}
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [APService setBadge:0];
    NSString *userId =[NSString stringWithFormat:@"%@",[[Public getUserInfo] objectForKey:@"id"]];
    
    if (![userId isEqualToString:@"(null)"])
    {
        [self connectionSoctet];
    }
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
    if ([urlStr isEqualToString:[NSString stringWithFormat:@"%@://platformId=wechat",APP_ID]])
    {
        return  [UMSocialSnsService handleOpenURL:url];
    }
    else if ([urlStr rangeOfString:[NSString stringWithFormat:@"%@://oauth?code=",APP_ID]].location !=NSNotFound)
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
- (void)sendPay_demo:(NSString *)orderNum andName:(NSString *)name andPrice:(NSString *)price andExtend:(NSString *)callBackUrl
{
    //创建支付签名对象
    payRequsestHandler *req = [payRequsestHandler alloc];
    //初始化支付签名对象
    [req init:APP_ID mch_id:MCH_ID];
    //设置密钥
    [req setKey:PARTNER_ID];
    
    //}}}
    
    //获取到实际调起微信支付的参数后，在app端调起支付
    NSMutableDictionary *dict = [req sendPay_demo:orderNum andName:name andPrice:price andExtend:callBackUrl];
    
    if(dict == nil)
    {
        //错误提示
        NSString *debug = [req getDebugifo];
        
//        [self alert:@"提示信息" msg:debug];
        
        NSLog(@"%@\n\n",debug);
    }
    else
    {
        NSLog(@"%@\n\n",[req getDebugifo]);
        //        [self alert:@"确认" msg:@"下单成功，点击OK后调起支付！"];
        
        NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
        NSMutableString *retcode = [dict objectForKey:@"retcode"];

        if (retcode.intValue == 0)
        {
            
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
        else
        {
            [self alert:@"提示信息" msg:[dict objectForKey:@"retmsg"]];
        }

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
    NSString *strTitle=@"";
    
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
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                [self alert:@"" msg:strMsg];
                break;
        }
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PaySuccessNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PayCancleNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"receivePrivateMessageNot" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"receiveCircleMessageNot" object:nil];
}

@end
