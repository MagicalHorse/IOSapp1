//
//  BueryAuthFinishViewController.m
//  joybar
//
//  Created by joybar on 15/5/16.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "BueryAuthFinishViewController.h"

@interface BueryAuthFinishViewController ()

@end

@implementation BueryAuthFinishViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.hidesBottomBarWhenPushed = YES;
        
    }
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavBarViewAndTitle:@"结果详情"];
    [self settingView];
    self.retBtn.hidden =YES;
    self.view.backgroundColor = kCustomColor(241, 241, 241);
}

- (void)settingView {
    
   UIView *view= [[UIView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, 150)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    UILabel* lable=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 150)];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text =@"申请已提交,请等待处理";
    lable.font = [UIFont systemFontOfSize:20];
    [view addSubview:lable];
    UIButton * btn=[[UIButton alloc]initWithFrame:CGRectMake(0, kScreenHeight-49, kScreenWidth, 49)];
    btn.backgroundColor =[UIColor whiteColor];
    [btn setTitle:@"回到首页" forState:UIControlStateNormal];
    [btn setTitleColor:kCustomColor(56,155, 234) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:btn];
    
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
}
-(void)btnClick{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
