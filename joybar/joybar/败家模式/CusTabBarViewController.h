//
//  CusTabBarViewController.h
//  joybar
//
//  Created by 卢兴 on 15/4/16.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "BaseTabBarController.h"
#import "BaseNavigationController.h"
#import "CusHomeViewController.h"
#import "CusCircleViewController.h"
#import "CusCartViewController.h"
#import "CusMoreBrandViewController.h"
#import "CusMineViewController.h"
#import "LoginAndRegisterViewController.h"
#import "CusMessageViewController.h"
#import "AppDelegate.h"
#import "FindShopGuideViewController.h"


@interface CusTabBarViewController : BaseTabBarController
@property (nonatomic ,strong) UILabel *circleMarkLab;
@property (nonatomic ,strong) UILabel *msgMarkLab;

//切换按钮
@property (strong, nonatomic) NSMutableArray *btnArray;
@property (strong, nonatomic) BaseNavigationController *homeNav;
@property (strong, nonatomic) BaseNavigationController *fastNav;
@property (strong, nonatomic) BaseNavigationController *cartNav;
@property (strong, nonatomic) BaseNavigationController *myAccountNav;

@property (strong, nonatomic) CusHomeViewController *homeView;
@property (strong, nonatomic) CusCircleViewController *fastView;
@property (strong, nonatomic) CusMessageViewController *messageView;
@property (strong, nonatomic) CusMineViewController *myAccountView;
@property (strong ,nonatomic) FindShopGuideViewController * findView;


-(void)SelectedIndex:(NSUInteger)selectedIndex;

@end
