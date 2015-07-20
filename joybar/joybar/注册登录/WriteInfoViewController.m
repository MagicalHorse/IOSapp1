//
//  WriteInfoViewController.m
//  joybar
//
//  Created by 123 on 15/4/17.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "WriteInfoViewController.h"
#import "SelectCityViewController.h"

@interface WriteInfoViewController ()

@property (nonatomic ,strong)NSString *cityID;



@end

@implementation WriteInfoViewController
{
    UILabel *cityNameLab;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = kCustomColor(235, 238, 240);
    
    [self addInfoView];
    [self addSelectCityView];
    
    
    [self addNavBarViewAndTitle:@"完善个人资料"];
}

-(void)addInfoView
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 15+64, kScreenWidth, 45*3)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.tag = 100;
    [self.view addSubview:bgView];
    
    NSArray *arr = @[@"创建用户名",@"设置密码",@"再次输入密码"];
    for (int i=0; i<3; i++)
    {
        UITextField *text = [[UITextField alloc] initWithFrame:CGRectMake(15, 45*i, kScreenWidth, 45)];
        text.placeholder = [arr objectAtIndex:i];
        text.font = [UIFont systemFontOfSize:14];
        text.tag = 1000+i;
        [bgView addSubview:text];
        if (i>0)
        {
            text.secureTextEntry = YES;
        }
        else
        {
            text.secureTextEntry = NO;
        }
        
        if (i<2)
        {
            UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(15, 45+45*i, kScreenWidth-30, 0.5)];
            line.backgroundColor = [UIColor lightGrayColor];
            [bgView addSubview:line];
        }
    }
}

-(void)addSelectCityView
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 45*3+30+64, kScreenWidth, 45)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    cityNameLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 45)];
    cityNameLab.text = @"未选择";
    cityNameLab.textAlignment = NSTextAlignmentLeft;
    cityNameLab.font = [UIFont systemFontOfSize:14];
    cityNameLab.textColor = kCustomColor(253, 137, 83);
    [bgView addSubview:cityNameLab];
    
    UILabel *selectCity = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-85, 0, 70, 45)];
    selectCity.text = @"更换城市 >";
    selectCity.font = [UIFont systemFontOfSize:14];
    selectCity.textColor = [UIColor lightGrayColor];
    [bgView addSubview:selectCity];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickSelectCity)];
    [bgView addGestureRecognizer:tap];
    
    UIButton *submitBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    submitBtn.frame = CGRectMake(15, bgView.bottom+20, kScreenWidth-30, 40);
    [submitBtn setTitle:@"确定" forState:(UIControlStateNormal)];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    submitBtn.layer.cornerRadius = 3;
    submitBtn.backgroundColor = kCustomColor(253, 137, 83);
    [submitBtn addTarget:self action:@selector(didClickSubmit) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:submitBtn];
}

//选择城市
-(void)didClickSelectCity
{
    SelectCityViewController *VC = [[SelectCityViewController alloc] init];
    
    VC.cityBlock = ^(NSString *cityID,NSString *cityName)
    {
        self.cityID = cityID;
        cityNameLab.text = cityName;
    };
    [self.navigationController pushViewController:VC animated:YES];
}

//确定
-(void)didClickSubmit
{
    UIView *bgView = [self.view viewWithTag:100];
    NSString *nameStr = ((UITextField *)[bgView viewWithTag:1000]).text;
    NSString *passwordStr = ((UITextField *)[bgView viewWithTag:1001]).text;
    NSString *rePassword = ((UITextField *)[bgView viewWithTag:1002]).text;
    if (![passwordStr isEqualToString:rePassword])
    {
        [self showHudFailed:@"密码不一致"];
        return;
    }
    NSMutableDictionary *dic =[NSMutableDictionary dictionary];
    if ([nameStr isEqualToString:@""])
    {
        [self showHudFailed:@"请填写用户名"];
        return;
    }
    [dic setObject:nameStr forKey:@"name"];
    if ([passwordStr isEqualToString:@""])
    {
        [self showHudFailed:@"请填写密码"];
        return;
    }
    [dic setObject:passwordStr forKey:@"password"];
    
    if (!self.mobilePhone)
    {
        [self showHudFailed:@"请填写手机号"];
        return;
    }
    
    [dic setObject:self.mobilePhone forKey:@"mobile"];
    if (!self.cityID)
    {
        [self showHudFailed:@"请选择城市"];
        return;
    }
    [dic setObject:self.cityID forKey:@"cityid"];
    
    [self hudShow];
    
    [HttpTool postWithURL:@"user/Register" params:dic success:^(id json) {

        [self hiddleHud];
        if ([[json objectForKey:@"isSuccessful"] boolValue])
        {
            NSMutableDictionary *userInfoDic = [NSMutableDictionary dictionaryWithDictionary:[json objectForKey:@"data"]];
            
            NSArray *allKeys = [userInfoDic allKeys];
            for (NSString *key in allKeys)
            {
                NSString *value = [userInfoDic objectForKey:key];
                if ([value isEqual:[NSNull null]])
                {
                    [userInfoDic setObject:@"" forKey:key];
                }
            }
            [[NSUserDefaults standardUserDefaults] setObject:userInfoDic forKey:@"userInfo"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
        
    } failure:^(NSError *error) {
        [self hiddleHud];
        NSLog(@"%@",[error description]);
    }];
}


@end
