//
//  LoginAndRegisterViewController.m
//  joybar
//
//  Created by 123 on 15/4/16.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "LoginAndRegisterViewController.h"
#import "WriteInfoViewController.h"
#import "FindPasswordViewController.h"
#import "UMSocialWechatHandler.h"
#include "CusTabBarViewController.h"
#include "APService.h"
@interface LoginAndRegisterViewController ()

@property (nonatomic ,strong) UIImageView *markImg;


@end

@implementation LoginAndRegisterViewController
{
    UIView *bgView;
    UIScrollView *scroll;
    UIButton *authBtn;
    //注册手机号
    UITextField *registerPhoneText;
    UITextField *registerAuthText;
    UITextField *loginPhoneText;
    UITextField *loginAuthText;
    NSTimer *timer;
    NSInteger timerInterget;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight/4+30)];
    bgView.backgroundColor = kCustomColor(234, 134, 87);
    [self.view addSubview:bgView];
    
    UIImageView *logoImg = [[UIImageView alloc] init];
    logoImg.center = CGPointMake(kScreenWidth/2, bgView.height/2-20);
    logoImg.bounds = CGRectMake(0, 0, 65, 65);
    logoImg.layer.masksToBounds = YES;
    logoImg.image = [UIImage imageNamed:@"logo"];
    logoImg.layer.cornerRadius = logoImg.size.width/2;
    [bgView addSubview:logoImg];

    scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, bgView.bottom, kScreenWidth, kScreenHeight-bgView.height)];
    scroll.contentSize = CGSizeMake(kScreenWidth*2, 0);
    scroll.alwaysBounceVertical = NO;
    scroll.pagingEnabled = YES;
    scroll.delegate = self;
    scroll.directionalLockEnabled = YES;
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.bounces = NO;
    [self.view addSubview:scroll];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didCLickScroll)];
    [scroll addGestureRecognizer:tap];
    
    [self addLoginView];
    [self addRegisterView];
    
    [self addNavBarViewAndTitle:@""];
    self.navView.layer.borderColor = [UIColor clearColor].CGColor;
    self.navView.backgroundColor = [UIColor clearColor];
    self.lineView.hidden = YES;
}

-(void)returnBtnClicked:(UIButton *)button
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];

}

#pragma mark ScrollViewDeletegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.x==0)
    {
        self.markImg.center = CGPointMake(kScreenWidth/4, bgView.bottom-4);
        self.markImg.bounds = CGRectMake(0, 0, 20, 11);
    }
    else
    {
        self.markImg.center = CGPointMake(kScreenWidth/4*3, bgView.bottom-4);
        self.markImg.bounds = CGRectMake(0, 0, 20, 11);
    }
}

-(void)didSelect:(UITapGestureRecognizer *)tap
{
    if (tap.view.tag==1000)
    {
        self.markImg.center = CGPointMake(kScreenWidth/4, bgView.bottom-4);
        self.markImg.bounds = CGRectMake(0, 0, 20, 11);
        scroll.contentOffset = CGPointMake(0, 0);

    }
    else
    {
        self.markImg.center = CGPointMake(kScreenWidth/4*3, bgView.bottom-4);
        self.markImg.bounds = CGRectMake(0, 0, 20, 11);
        scroll.contentOffset = CGPointMake(kScreenWidth, 0);

    }
}


-(void)addLoginView
{
    NSArray *nameArr = @[@"账户登录",@"注册"];
    for (int i=0; i<2; i++)
    {
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/2*i, bgView.bottom-50, kScreenWidth/2, 50)];
        lab.userInteractionEnabled = YES;
        lab.font = [UIFont systemFontOfSize:17];
        lab.backgroundColor = [UIColor clearColor];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = [UIColor whiteColor];
        lab.text = [nameArr objectAtIndex:i];
        lab.tag=1000+i;
        [bgView addSubview:lab];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelect:)];
        [lab addGestureRecognizer:tap];
    }
    
    self.markImg = [[UIImageView alloc] init];
    self.markImg.center = CGPointMake(kScreenWidth/4, bgView.bottom-4);
    self.markImg.bounds = CGRectMake(0, 0, 20, 11);
    self.markImg.image = [UIImage imageNamed:@"xiaosanjiao.png"];
    [bgView addSubview:self.markImg];
    
    UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 55,kScreenWidth-20, 0.5)];
    line1.backgroundColor = [UIColor lightGrayColor];
    [scroll addSubview:line1];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 14, 30, 30)];
    lab.text = @"+86";
    lab.backgroundColor = [UIColor clearColor];
    lab.font = [UIFont systemFontOfSize:16];
    [scroll addSubview:lab];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(lab.right+5, 12, 0.5, 34)];
    line2.backgroundColor = [UIColor lightGrayColor];
    [scroll addSubview:line2];
    
    loginPhoneText = [[UITextField alloc] initWithFrame:CGRectMake(line2.right+15, 9, 200, 40)];
    loginPhoneText.placeholder = @"请输入您的手机号码";
    loginPhoneText.font = [UIFont systemFontOfSize:16];
    loginPhoneText.keyboardType = UIKeyboardTypeDefault;
    loginPhoneText.backgroundColor = [UIColor clearColor];
    [scroll addSubview:loginPhoneText];
    
    UILabel *line3 = [[UILabel alloc] initWithFrame:CGRectMake(10, line2.bottom+60, kScreenWidth-20, 0.5)];
    line3.backgroundColor = [UIColor lightGrayColor];
    [scroll addSubview:line3];
    
    loginAuthText = [[UITextField alloc] initWithFrame:CGRectMake(10, 60, kScreenWidth-100, 40)];
    loginAuthText.placeholder = @"请输入您的密码";
    loginAuthText.font = [UIFont systemFontOfSize:16];
//    loginAuthText.keyboardType = UIKeyboardTypeNumberPad;
    loginAuthText.secureTextEntry = YES;
    [scroll addSubview:loginAuthText];
    
    UIButton *loginBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    loginBtn.frame = CGRectMake(10, loginAuthText.bottom+20, kScreenWidth-20, 45);
    loginBtn.backgroundColor = kCustomColor(234, 134, 87);
    [loginBtn setTitle:@"登录" forState:(UIControlStateNormal)];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    //    loginBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    loginBtn.layer.cornerRadius = 3;
    [loginBtn addTarget:self action:@selector(didClickLogin) forControlEvents:(UIControlEventTouchUpInside)];
    [scroll addSubview:loginBtn];
    
    UILabel *forgetPassword = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-80, 60, 100, 40)];
    forgetPassword.text = @"忘记密码了 ?";
    forgetPassword.userInteractionEnabled = YES;
    forgetPassword.textColor = kCustomColor(122, 226, 220);
    forgetPassword.backgroundColor = [UIColor clearColor];
    forgetPassword.font = [UIFont systemFontOfSize:12];
    forgetPassword.textAlignment = NSTextAlignmentLeft;
    [scroll addSubview:forgetPassword];
    
    UITapGestureRecognizer *forgetTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didClickForgetPassword)];
    [forgetPassword addGestureRecognizer:forgetTap];
    
    //第三方登录
    UILabel *line7 = [[UILabel alloc] initWithFrame:CGRectMake(40, loginBtn.bottom+60, (kScreenWidth-100-65)/2, 0.5)];
    line7.backgroundColor = [UIColor lightGrayColor];
    [scroll addSubview:line7];
    UILabel *disanfang = [[UILabel alloc] initWithFrame:CGRectMake(line7.right+10, loginBtn.bottom+50, 65, 20)];
    disanfang.text = @"第三方登录";
    disanfang.font = [UIFont systemFontOfSize:13];
    [scroll addSubview:disanfang];
    
    UILabel *line8 = [[UILabel alloc] initWithFrame:CGRectMake(disanfang.right+10, loginBtn.bottom+60, line7.width, 0.5)];
    line8.backgroundColor = [UIColor lightGrayColor];
    [scroll addSubview:line8];
    
    UIButton *WXLoginBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    WXLoginBtn.center = CGPointMake(kScreenWidth/2, disanfang.bottom+40);
    WXLoginBtn.bounds = CGRectMake(0, 0, 50, 50);
    [WXLoginBtn setBackgroundImage:[UIImage imageNamed:@"微信"] forState:(UIControlStateNormal)];
    [WXLoginBtn addTarget:self action:@selector(didCLickWXLogin) forControlEvents:(UIControlEventTouchUpInside)];
    [scroll addSubview:WXLoginBtn];
}

-(void)addRegisterView
{
    //注册
    UILabel *line4 = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth+10, 55,kScreenWidth-20, 0.5)];
    line4.backgroundColor = [UIColor lightGrayColor];
    [scroll addSubview:line4];
    
    UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth+10, 14, 30, 30)];
    lab1.text = @"+86";
    lab1.font = [UIFont systemFontOfSize:16];
    [scroll addSubview:lab1];
    
    UILabel *line5 = [[UILabel alloc] initWithFrame:CGRectMake(45+kScreenWidth, 12, 0.5, 34)];
    line5.backgroundColor = [UIColor lightGrayColor];
    [scroll addSubview:line5];
    
    registerPhoneText = [[UITextField alloc] initWithFrame:CGRectMake(line5.right+15, 9, 200, 40)];
    registerPhoneText.delegate = self;
    registerPhoneText.placeholder = @"请输入您的手机号码";
    registerPhoneText.backgroundColor = [UIColor clearColor];
    registerPhoneText.font = [UIFont systemFontOfSize:16];
    registerPhoneText.keyboardType = UIKeyboardTypeNumberPad;
    [scroll addSubview:registerPhoneText];
    
    UILabel *line6 = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth+10, line5.bottom+60, kScreenWidth-20, 0.5)];
    line6.backgroundColor = [UIColor lightGrayColor];
    [scroll addSubview:line6];
    
    registerAuthText = [[UITextField alloc] initWithFrame:CGRectMake(kScreenWidth+10, 60, 200, 40)];
    registerAuthText.placeholder = @"请输入短信验证码";
    registerAuthText.font = [UIFont systemFontOfSize:16];
    registerAuthText.keyboardType = UIKeyboardTypeNumberPad;
    [scroll addSubview:registerAuthText];
    
    UILabel *authCodeLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth*2-80, 60, 100, 40)];
    authCodeLab.text = @"验证并登陆>";
    authCodeLab.userInteractionEnabled = YES;
    authCodeLab.textColor = kCustomColor(122, 226, 220);
    authCodeLab.backgroundColor = [UIColor clearColor];
    authCodeLab.font = [UIFont systemFontOfSize:12];
    authCodeLab.textAlignment = NSTextAlignmentLeft;
    [scroll addSubview:authCodeLab];
    
    UITapGestureRecognizer *authTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didClickAuthCode)];
    [authCodeLab addGestureRecognizer:authTap];
    
    authBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    authBtn.frame = CGRectMake(kScreenWidth*2-75, 10, 132/2, 56/1.8);
    [authBtn setTitle:@"验证" forState:(UIControlStateNormal)];
    authBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    authBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    authBtn.layer.cornerRadius = authBtn.height/2;
    authBtn.backgroundColor = [UIColor redColor];
    [authBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [authBtn addTarget:self action:@selector(didCilckGetAuthCode:) forControlEvents:(UIControlEventTouchUpInside)];
    authBtn.hidden = YES;
    [scroll addSubview:authBtn];
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

//点击登录
-(void)didClickLogin
{
    [loginAuthText resignFirstResponder];
    [loginPhoneText resignFirstResponder];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (loginPhoneText.text.length!=11)
    {
        [self showHudFailed:@"请输入正确的手机号码"];
        return;
    }
    
    [dic setObject:loginPhoneText.text forKey:@"mobile"];
    [dic setObject:loginAuthText.text forKey:@"password"];
    [self hudShow:@"正在登录"];
    [HttpTool postWithURL:@"user/Login" params:dic success:^(id json) {
        if ([[json objectForKey:@"isSuccessful"] boolValue])
        {
            
            [self connectSocket];
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
            NSString *userId =[NSString stringWithFormat:@"%@",[userInfoDic objectForKey:@"id"]];
            [APService setAlias:userId callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
        else
        {
            [self showHudFailed:[json objectForKey:@"message"]];
        }
        [self textHUDHiddle];
    } failure:^(NSError *error) {
        [self textHUDHiddle];
    }];
}
- (void)tagsAliasCallback:(int)iResCode
                     tags:(NSSet *)tags
                    alias:(NSString *)alias {
    NSString *callbackString =
    [NSString stringWithFormat:@"%d, \ntags: %@, \nalias: %@\n", iResCode,tags,alias];
    NSLog(@"TagsAlias回调:%@", callbackString);
}


//点击忘记密码
-(void)didClickForgetPassword
{
    FindPasswordViewController *VC = [[FindPasswordViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

//验证并登陆
-(void)didClickAuthCode
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:registerPhoneText.text forKey:@"mobile"];
    [dic setValue:registerAuthText.text forKey:@"code"];
    [self hudShow:@"正在验证"];
    [HttpTool postWithURL:@"user/VerifyCode" params:dic success:^(id json) {

        BOOL isSuccess = [[json objectForKey:@"isSuccessful"]boolValue];
        if(isSuccess)
        {
            WriteInfoViewController *VC = [[WriteInfoViewController alloc] init];
            VC.mobilePhone = registerPhoneText.text;
            [self.navigationController pushViewController:VC animated:YES];
        }
        else
        {
            [self showHudFailed:[json objectForKey:@"message"]];
        }
        [self textHUDHiddle];
        
    } failure:^(NSError *error) {
    }];
}

//获取验证码
-(void)didCilckGetAuthCode:(UIButton *)btn
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (registerPhoneText.text.length!=11)
    {
        [self showHudFailed:@"请输入正确的手机号码"];
        return;
    }
    [dic setValue:registerPhoneText.text forKey:@"mobile"];
    [dic setValue:@"0" forKey:@"type"];
    [self hudShowWithText:@"正在获取验证码"];
    [HttpTool postWithURL:@"user/SendMobileCode" params:dic success:^(id json) {
        
        NSDictionary *jsonDic = json;
        
        if ([[jsonDic objectForKey:@"isSuccessful"] boolValue])
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
        [self textHUDHiddle];
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


//微信登陆
-(void)didCLickWXLogin
{
    [self hudShow:@"正在登录..."];
    [UMSocialWechatHandler setWXAppId:APP_ID appSecret:APP_SECRET url:nil];

    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:UMShareToWechatSession];
            
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid ,snsAccount.accessToken,snsAccount.iconURL);

            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",snsAccount.accessToken,snsAccount.openId]];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                
                NSString *str1 = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                [self WXLogin:str1];
            }];
            
            
        }
    });
}

-(void)WXLogin:(NSString *)str
{
    NSMutableDictionary *dic =[NSMutableDictionary dictionary];
    [dic setValue:str forKey:@"json"];
    [dic setValue:APP_ID forKey:@"appid"];
    [HttpTool postWithURL:@"User/OutSiteLogin" params:dic success:^(id json) {
        
        [self textHUDHiddle];
        if([[json objectForKey:@"isSuccessful"] boolValue])
        {
            [self connectSocket];
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
            NSString *userId =[NSString stringWithFormat:@"%@",[userInfoDic objectForKey:@"id"]];
            [APService setAlias:userId callbackSelector:nil object:self];

            [self.navigationController dismissViewControllerAnimated:YES completion:nil];

        }
        else
        {
            [self showHudFailed:[json objectForKey:@"message"]];
        }
        
    } failure:^(NSError *error) {
    }];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(void)didCLickScroll
{
    [scroll endEditing:YES];
}

-(void)connectSocket
{
    NSString *userid = [NSString stringWithFormat:@"%@",[[Public getUserInfo] objectForKey:@"id"]];
    NSString *urlStr;
    if (userid)
    {
        urlStr = [NSString stringWithFormat:@"%@?userid=%@",SocketUrl,userid];
    }
    else
    {
        urlStr = [NSString stringWithFormat:@"%@?userid=%@",SocketUrl,@"0"];
    }

    [SIOSocket socketWithHost:urlStr response:^(SIOSocket *socket) {
        [SocketManager socketManager].socket = socket;
        [socket on: @"connect" callback: ^(SIOParameterArray *args) {
            [socket emit:@"online" args:@[userid]];
            NSLog(@"connnection is success:%@",[args description]);
        }];
    }];
}


@end
