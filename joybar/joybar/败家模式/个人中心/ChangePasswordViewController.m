//
//  ChangePasswordViewController.m
//  joybar
//
//  Created by 123 on 15/5/25.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "ChangePasswordViewController.h"

@interface ChangePasswordViewController ()

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addNavBarViewAndTitle:@"修改密码"];
    self.view.backgroundColor = kCustomColor(245, 246, 248);
    UIButton *finishBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    finishBtn.frame = CGRectMake(kScreenWidth-64, 9, 64, 64);
    finishBtn.backgroundColor = [UIColor clearColor];
    [finishBtn setTitle:@"完成" forState:(UIControlStateNormal)];
    [finishBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    finishBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [finishBtn addTarget:self action:@selector(didClickFinishBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.navView addSubview:finishBtn];
}

-(void)didClickFinishBtn
{
    NSMutableDictionary *dict =[[NSMutableDictionary alloc]init];
//    [dict setObject:self.oldPassword.text forKey:@"mobile"];
    [dict setObject:self.oldPassword.text forKey:@"oldpassword"];
    [dict setObject:self.repeatPassword.text forKey:@"password"];

    [HttpTool postWithURL:@"User/ChangePassword" params:dict success:^(id json) {
        BOOL  isSuccessful =[[json objectForKey:@"isSuccessful"] boolValue];
        if (isSuccessful) {
            [self showHudSuccess:@"修改成功"];
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
