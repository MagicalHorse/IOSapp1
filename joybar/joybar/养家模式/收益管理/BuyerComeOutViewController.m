//
//  BuyerComeOutViewController.m
//  joybar
//
//  Created by joybar on 15/6/3.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "BuyerComeOutViewController.h"
#import "BuyerComeInSubmitViewController.h"

@interface BuyerComeOutViewController ()
- (IBAction)btnClick:(UIButton *)sender;

@end

@implementation BuyerComeOutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =kCustomColor(241, 241, 241);
    [self addNavBarViewAndTitle:@"申请提现"];
}


- (IBAction)btnClick:(UIButton *)sender {
    BuyerComeInSubmitViewController * sb=[[BuyerComeInSubmitViewController alloc]init];
    [self.navigationController pushViewController:sb animated:YES];
}
@end
