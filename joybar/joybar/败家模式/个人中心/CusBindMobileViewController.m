//
//  CusBindMobileViewController.m
//  joybar
//
//  Created by 123 on 15/7/1.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "CusBindMobileViewController.h"

@interface CusBindMobileViewController ()<UITextFieldDelegate>

@end

@implementation CusBindMobileViewController
{
    UIButton*authBtn;
    UITextField *registerPhoneText;
    UITextField *registerAuthText;
    
    NSTimer *timer;
    NSInteger timerInterget;

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = kCustomColor(235, 238, 240);
    [self addView];
    [self addNavBarViewAndTitle:@"绑定手机号"];
}

-(void)addView
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 64+15, kScreenWidth, 90)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    UILabel *line4 = [[UILabel alloc] initWithFrame:CGRectMake(10, 45,kScreenWidth-20, 0.5)];
    line4.backgroundColor = [UIColor lightGrayColor];
    [bgView addSubview:line4];
    
    UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, 30, 30)];
    lab1.text = @"+86";
    lab1.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:lab1];
    
    UILabel *line5 = [[UILabel alloc] initWithFrame:CGRectMake(40, 15, 0.5, 24)];
    line5.backgroundColor = [UIColor lightGrayColor];
    [bgView addSubview:line5];
    
    registerPhoneText = [[UITextField alloc] initWithFrame:CGRectMake(line5.right+15, 7, 200, 40)];
    registerPhoneText.delegate = self;
    registerPhoneText.placeholder = @"请输入您的手机号码";
    registerPhoneText.backgroundColor = [UIColor clearColor];
    registerPhoneText.font = [UIFont systemFontOfSize:14];
    registerPhoneText.keyboardType = UIKeyboardTypeNumberPad;
    [bgView addSubview:registerPhoneText];
    
    registerAuthText = [[UITextField alloc] initWithFrame:CGRectMake(10, 47, 200, 40)];
    registerAuthText.placeholder = @"请输入短信验证码";
    registerAuthText.font = [UIFont systemFontOfSize:14];
    registerAuthText.keyboardType = UIKeyboardTypeNumberPad;
    [bgView addSubview:registerAuthText];
    
    authBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    authBtn.frame = CGRectMake(kScreenWidth-75, 10, 132/2, 56/1.8);
    [authBtn setTitle:@"验证" forState:(UIControlStateNormal)];
    authBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    authBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    authBtn.layer.cornerRadius = authBtn.height/2;
    authBtn.backgroundColor = [UIColor redColor];
    [authBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [authBtn addTarget:self action:@selector(didCilckGetAuthCode) forControlEvents:(UIControlEventTouchUpInside)];
    authBtn.hidden = YES;
    [bgView addSubview:authBtn];
    
    UIButton *submitBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    submitBtn.frame = CGRectMake(15, bgView.bottom+30, kScreenWidth-30, 40);
    [submitBtn setTitle:@"确定" forState:(UIControlStateNormal)];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    submitBtn.layer.cornerRadius = 3;
    
    submitBtn.backgroundColor = kCustomColor(253, 137, 83);
    [submitBtn addTarget:self action:@selector(didClickSubmit) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:submitBtn];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSInteger strLength = textField.text.length - range.length + string.length;
    
    if (strLength>0)
    {
        authBtn.hidden = NO;
    }
    else
    {
        authBtn.hidden = YES;
    }
    return YES;
}

//验证
-(void)didCilckGetAuthCode
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:registerPhoneText.text forKey:@"mobile"];
    [dic setObject:@"2" forKey:@"type"];
    [HttpTool postWithURL:@"user/SendMobileCode" params:dic success:^(id json) {
        
        if ([[json objectForKey:@"isSuccessful"] boolValue])
        {
            timerInterget = 60;
            
            timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                     target:self
                                                   selector:@selector(checkButtonAction:)
                                                   userInfo:nil
                                                    repeats:YES];
            [timer fire];
        }
        else
        {
            [self showHudFailed:[json objectForKey:@"message"]];
        }
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)checkButtonAction:(NSTimer *)time
{
    if (timerInterget >0 && timerInterget <= 60)
    {
        timerInterget--;
        NSString *str = [NSString stringWithFormat:@" %ld″",(long)timerInterget];
        [authBtn setTitle:str forState:UIControlStateNormal];
        [authBtn setUserInteractionEnabled:NO];
    }
    else
    {
        [authBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        timerInterget = 60;
        [authBtn setUserInteractionEnabled:YES];
        [time invalidate];
    }
}


//确定
-(void)didClickSubmit
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:registerPhoneText.text forKey:@"mobile"];
    [HttpTool postWithURL:@"User/BindMobile" params:dic success:^(id json) {
        if ([[json objectForKey:@"isSuccessful"] boolValue])
        {
            [self showHudSuccess:@"绑定成功"];
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[Public getUserInfo]];
            [dic setObject:@"1" forKey:@"IsBindMobile"];
            [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"userInfo"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"bindMobileNot" object:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        else
        {
            [self showHudFailed:[json objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        
    }];
}

@end
