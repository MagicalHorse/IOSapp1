//
//  PayOrderViewController.m
//  joybar
//
//  Created by 123 on 15/6/11.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "PayOrderViewController.h"
#import "AppDelegate.h"
#import "CusOrderDetailViewController.h"
@interface PayOrderViewController ()<UIAlertViewDelegate>

@end

@implementation PayOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kCustomColor(240, 241, 242);
    [self addNavBarViewAndTitle:@"选择付款方式"];
    self.payCount.text = [NSString stringWithFormat:@"￥%@",self.proPrice];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (IBAction)didClickWXPay:(id)sender
{
    AppDelegate *app =(AppDelegate *)[UIApplication sharedApplication].delegate;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccessHandle) name:@"PaySuccessNotification" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(payCancelHandle) name:@"PayCancleNotification" object:nil];
    [app sendPay_demo:self.orderNum andName:self.proName andPrice:self.proPrice];
}

-(void)paySuccessHandle
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"支付成功" delegate:self cancelButtonTitle:@"返回首页" otherButtonTitles:@"查看订单", nil];
    [alert show];
}

-(void)payCancelHandle
{
//    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
    if (buttonIndex==0)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        CusOrderDetailViewController *VC = [[CusOrderDetailViewController alloc] init];
        VC.orderId = self.orderNum;
        
        NSLog(@"***************************%@",self.orderNum);
        VC.fromType = @"payOrder";
        [self.navigationController pushViewController:VC animated:YES];
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PaySuccessNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PayCancleNotification" object:nil];
}

-(void)returnBtnClicked:(UIButton *)button
{
//    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-3] animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
