//
//  PayOrderViewController.m
//  joybar
//
//  Created by 123 on 15/6/11.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "PayOrderViewController.h"

@interface PayOrderViewController ()

@end

@implementation PayOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kCustomColor(240, 241, 242);
    [self addNavBarViewAndTitle:@"选择付款方式"];
}

- (IBAction)didClickWXPay:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
@end
