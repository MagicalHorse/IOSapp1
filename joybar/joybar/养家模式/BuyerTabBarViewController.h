//
//  BuyerTabBarViewController.h
//  joybar
//
//  Created by 卢兴 on 15/4/16.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "BaseTabBarController.h"
#import "BaseNavigationController.h"
@interface BuyerTabBarViewController : BaseTabBarController
//切换按钮
@property (strong, nonatomic) NSMutableArray *btnArray;
@property (strong, nonatomic) BaseNavigationController *buyerHomeNav;
@property (strong, nonatomic) BaseNavigationController *buyerTicketNav;
@property (strong, nonatomic) BaseNavigationController *buyerCircleNav;
@property (strong, nonatomic) BaseNavigationController *buyerMesNav;
@property (strong, nonatomic) BaseNavigationController *buyerStoreNav;

-(void)SelectedIndex:(NSUInteger)selectedIndex;

@end
