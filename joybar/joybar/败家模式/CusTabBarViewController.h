//
//  CusTabBarViewController.h
//  joybar
//
//  Created by 卢兴 on 15/4/16.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "BaseTabBarController.h"
#import "BaseNavigationController.h"
@interface CusTabBarViewController : BaseTabBarController
//切换按钮
@property (strong, nonatomic) NSMutableArray *btnArray;
@property (strong, nonatomic) BaseNavigationController *homeNav;
@property (strong, nonatomic) BaseNavigationController *fastNav;
@property (strong, nonatomic) BaseNavigationController *cartNav;
@property (strong, nonatomic) BaseNavigationController *findNav;
@property (strong, nonatomic) BaseNavigationController *myAccountNav;

-(void)SelectedIndex:(NSUInteger)selectedIndex;

@end
