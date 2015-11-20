//
//  BindVipViewController.m
//  joybar
//
//  Created by joybar on 15/11/13.
//  Copyright © 2015年 卢兴. All rights reserved.
//

#import "BindVipViewController.h"

@interface BindVipViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UIButton*authBtn;
    UITextField *registerPhoneText;
    UITextField *registerAuthText;
    
    NSTimer *timer;
    NSInteger timerInterget;
    
}
@property (weak, nonatomic) IBOutlet UITableView *customTableView;

@end

@implementation BindVipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavBarViewAndTitle:@"绑定会员卡"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell =[[UITableViewCell alloc]init];
    UILabel *lable =[[UILabel alloc]initWithFrame:CGRectMake(12, 15, 100, 15)];
    lable.font =[UIFont systemFontOfSize:16];
    [cell addSubview:[self addView]];

    if (indexPath.row ==0) {
      
        lable.text =@"手机号：";
    }
    else{
        lable.text =@"验证码：";
    }

    return cell;
}
-(UIView *)addView
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 90)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    UILabel *line4 = [[UILabel alloc] initWithFrame:CGRectMake(10, 45,kScreenWidth-20, 0.5)];
    line4.backgroundColor = [UIColor lightGrayColor];
    [bgView addSubview:line4];
    
    UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 11, 62, 30)];
    lab1.text = @"手机号：";
    lab1.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:lab1];
    
    
    registerPhoneText = [[UITextField alloc] initWithFrame:CGRectMake(lab1.right, 7, 200, 40)];
    registerPhoneText.delegate = self;
    registerPhoneText.placeholder = @"请输入";
    registerPhoneText.backgroundColor = [UIColor clearColor];
    registerPhoneText.font = [UIFont systemFontOfSize:15];
    registerPhoneText.keyboardType = UIKeyboardTypeNumberPad;
    [bgView addSubview:registerPhoneText];
    
    UILabel *lab2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 47, 62, 40)];
    lab2.text = @"验证码：";
    lab2.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:lab2];
    
    registerAuthText = [[UITextField alloc] initWithFrame:CGRectMake(lab2.right, 47, 150, 40)];
    registerAuthText.placeholder = @"请输入";
    registerAuthText.font = [UIFont systemFontOfSize:15];
    registerAuthText.keyboardType = UIKeyboardTypeNumberPad;
    [bgView addSubview:registerAuthText];
    
    
    UILabel *line5 = [[UILabel alloc] initWithFrame:CGRectMake(registerAuthText.right, 51, 0.5, 32)];
    line5.backgroundColor = [UIColor lightGrayColor];
    [bgView addSubview:line5];
    
    authBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    authBtn.frame = CGRectMake(kScreenWidth-88, 47, 80, 40);
    [authBtn setTitle:@"获取验证码" forState:(UIControlStateNormal)];
    authBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [authBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [authBtn addTarget:self action:@selector(didCilckGetAuthCode) forControlEvents:(UIControlEventTouchUpInside)];
    [bgView addSubview:authBtn];
    
    return bgView;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];
    UILabel *lable =[[UILabel alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth-20, 80)];
    lable.numberOfLines =0;

    lable.text =@"注：若您是金鹰会员，绑定手机号后可享受VIP折扣并使用已有优惠券 若您不是会员，支付后可在个人中心领取金鹰会员卡";
    lable.font = [UIFont systemFontOfSize:14];
    lable.textColor =[UIColor redColor];
    [view addSubview:lable];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 80;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 14;
}
//验证
-(void)didCilckGetAuthCode
{
    if (registerPhoneText.text.length!=11)
    {
        [self showHudFailed:@"请输入正确的手机号码"];
        return;
    }else if(registerAuthText.text.length==0){
        [self showHudFailed:@"请输入验证码"];
        return;
    }
    [authBtn setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];

    timerInterget = 60;
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                             target:self
                                           selector:@selector(checkButtonAction:)
                                           userInfo:nil
                                            repeats:YES];
    [timer fire];
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    [dic setObject:registerPhoneText.text forKey:@"mobile"];
//    [dic setObject:@"2" forKey:@"type"];
//    [HttpTool postWithURL:@"user/SendMobileCode" params:dic isWrite:YES success:^(id json) {
//        
//        if ([[json objectForKey:@"isSuccessful"] boolValue])
//        {
//      
//        }
//        else
//        {
//            [self showHudFailed:[json objectForKey:@"message"]];
//        }
//        
//    } failure:^(NSError *error) {
//        
//        
//    }];
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
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    [dic setObject:registerPhoneText.text forKey:@"mobile"];
//    
//    [HttpTool postWithURL:@"User/BindMobile" params:dic isWrite:YES success:^(id json) {
//        if ([[json objectForKey:@"isSuccessful"] boolValue])
//        {
//            [self showHudSuccess:@"绑定成功"];
//            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[Public getUserInfo]];
//            [dic setObject:@"1" forKey:@"IsBindMobile"];
//            [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"userInfo"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//            
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"bindMobileNot" object:nil];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self.navigationController popViewControllerAnimated:YES];
//            });
//        }
//        else
//        {
//            [self showHudFailed:[json objectForKey:@"message"]];
//        }
//    } failure:^(NSError *error) {
//        
//    }];
}
@end
