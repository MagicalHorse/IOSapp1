//
//  PayOrderViewController.m
//  joybar
//
//  Created by 123 on 15/6/11.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "PayOrderViewController.h"
#import "AppDelegate.h"
@interface PayOrderViewController ()<UIAlertViewDelegate>

@end

@implementation PayOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kCustomColor(240, 241, 242);
    [self addNavBarViewAndTitle:@"选择付款方式"];
    self.payCount.text = [NSString stringWithFormat:@"￥%@",self.proPrice];
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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"支付成功" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
    [alert show];

}

-(void)payCancelHandle
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PaySuccessNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PayCancleNotification" object:nil];

}

@end
