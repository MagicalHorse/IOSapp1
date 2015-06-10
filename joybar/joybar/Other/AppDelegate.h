//
//  AppDelegate.h
//  joybar
//
//  Created by 卢兴 on 15/4/2.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CusTabBarViewController.h"
#import "BaseNavigationController.h"
#import "BuyerTabBarViewController.h"
#import "SIOSocket.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic ,strong) CusTabBarViewController *cusTab;
@property (nonatomic ,strong) BuyerTabBarViewController *buyerTab;
@property (nonatomic ,strong) BaseNavigationController *baseNav;

@end

