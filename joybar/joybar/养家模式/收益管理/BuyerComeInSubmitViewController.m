//
//  BuyerComeInSubmitViewController.m
//  joybar
//
//  Created by joybar on 15/6/3.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "BuyerComeInSubmitViewController.h"

@interface BuyerComeInSubmitViewController ()

@end

@implementation BuyerComeInSubmitViewController

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
    self.retBtn.hidden =NO;
    self.view.backgroundColor = kCustomColor(241, 241, 241);
}

- (void)settingView {
    
    UIView *view= [[UIView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, 150)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    UILabel* lable=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 136)];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text =@"提现申请已提交，请等待处理";
    lable.font = [UIFont systemFontOfSize:20];
    [view addSubview:lable];
    
    UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(15, 150-24, 19, 19)];
    img.image =[UIImage imageNamed:@"重点"];
    [view addSubview:img];

    UILabel* lable1=[[UILabel alloc]initWithFrame:CGRectMake(40, 150-24, kScreenWidth-40, 14)];
    lable1.text =@"预计到账时间5月19日";
    lable1.font = [UIFont systemFontOfSize:14];
    [view addSubview:lable1];
    
    UIButton * btn=[[UIButton alloc]initWithFrame:CGRectMake(0, kScreenHeight-49, kScreenWidth, 49)];
    btn.backgroundColor =[UIColor whiteColor];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn setTitleColor:kCustomColor(56,155, 234) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:btn];
    
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
}
-(void)btnClick{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
