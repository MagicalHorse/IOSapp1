//
//  SetPasswordViewController.m
//  joybar
//
//  Created by 123 on 15/4/17.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "SetPasswordViewController.h"

@interface SetPasswordViewController ()

@end

@implementation SetPasswordViewController
{
    UIView *bgView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kCustomColor(235, 238, 240);
    [self addView];
    [self addNavBarViewAndTitle:@"设置新密码"];
}

-(void)addView
{
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 15+64, kScreenWidth, 90)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    NSArray *name = @[@"请输入新密码",@"确认密码"];
    
    for (int i=0; i<2; i++)
    {
        UITextField *text = [[UITextField alloc] initWithFrame:CGRectMake(15, 45*i, kScreenWidth, 45)];
        text.placeholder = [name objectAtIndex:i];
        text.tag = 1000+i;
        text.font = [UIFont systemFontOfSize:14];
        [bgView addSubview:text];
    }
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(10, 45,kScreenWidth-20, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [bgView addSubview:line];

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

-(void)didClickSubmit
{
    UITextField *password = (UITextField *)[bgView viewWithTag:1000];
    UITextField *rePassword = (UITextField *)[bgView viewWithTag:1001];

    if (![password.text isEqualToString: rePassword.text])
    {
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.mobilePhone forKey:@"mobile"];
    [dic setObject:password.text forKey:@"password"];
    [HttpTool postWithURL:@"user/ResetPassword" params:dic success:^(id json) {
        if ([[json objectForKey:@"isSuccessful"] boolValue])
        {
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
        }
        NSLog(@"%@",json);
    } failure:^(NSError *error) {
        NSLog(@"%@",[error description]);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
