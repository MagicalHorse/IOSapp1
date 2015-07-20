//
//  CusAppealViewController.m
//  joybar
//
//  Created by 123 on 15/6/15.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "CusAppealViewController.h"

@interface CusAppealViewController ()

@end

@implementation CusAppealViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavBarViewAndTitle:@"申诉"];
    self.view.backgroundColor = kCustomColor(240, 241, 242);
    self.textView.layer.borderWidth = 0.5;
    self.textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.textView.layer.cornerRadius = 3;
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-49, kScreenWidth, 49)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.center = CGPointMake(kScreenWidth/2, bottomView.height/2);
    btn.bounds = CGRectMake(0, 0, 80, 30);
    btn.layer.borderWidth = 0.5;
    btn.layer.borderColor = [UIColor redColor].CGColor;
    [btn setTitle:@"提交申请" forState:(UIControlStateNormal)];
    btn.layer.cornerRadius = 3;
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
    [bottomView addSubview:btn];

}

@end
