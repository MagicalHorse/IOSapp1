//
//  AppDelegate.h
//  joybar
//
//  Created by 卢兴 on 15/4/2.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"
#import "BuyerTabBarViewController.h"
#import "SIOSocket.h"
#import "WXApi.h"
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate,UIAlertViewDelegate,CLLocationManagerDelegate,UIScrollViewDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic ,strong) BaseNavigationController *baseNav;
@property (strong, nonatomic) CLLocationManager* locationManager;

- (void)sendPay_demo:(NSString *)orderNum andName:(NSString *)name andPrice:(NSString *)price;
- (void)sendPay_demo:(NSString *)orderNum andName:(NSString *)name andPrice:(NSString *)price andExtend:(NSString *)callBackUrl;

@property (nonatomic ,strong) NSString *longitude;
@property (nonatomic ,strong) NSString *latitude;

@end

