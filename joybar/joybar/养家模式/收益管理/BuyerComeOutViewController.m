//
//  BuyerComeOutViewController.m
//  joybar
//
//  Created by joybar on 15/6/3.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "BuyerComeOutViewController.h"
#import "BuyerComeInSubmitViewController.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"

@interface BuyerComeOutViewController ()<UITextFieldDelegate>
- (IBAction)btnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *priceField;
@property (weak, nonatomic) IBOutlet UILabel *priceLable;

@end

@implementation BuyerComeOutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =kCustomColor(241, 241, 241);
    NSString *temp;
    if (self.price.length>0) {
        temp =self.price;
    }else{
        self.price =@"0.00";
    }
    self.priceLable.text = [NSString stringWithFormat:@"可提现的收益%@元",temp];
    [self addNavBarViewAndTitle:@"申请提现"];
}

- (IBAction)btnClick:(UIButton *)sender {
    
    if (self.priceField.text.length==0) {
        [self showHudFailed:@"请输入金额"];
        return;
    }
    
    NSDictionary *userInfo= [Public getUserInfo];
    BOOL bing= [[userInfo objectForKey:@"IsBindWeiXin"]boolValue];
    if (bing) {
        NSMutableDictionary *dict=[NSMutableDictionary dictionary];
        
        [dict setObject:self.priceField.text forKey:@"Amount"];
        [HttpTool postWithURL:@"Assistant/Income_Request_RedPack" params:dict success:^(id json) {
            BOOL isSuccessful = [[json objectForKey:@"isSuccessful"] boolValue];
            if (isSuccessful) {
                
                BuyerComeInSubmitViewController * sb=[[BuyerComeInSubmitViewController alloc]init];
                [self.navigationController pushViewController:sb animated:YES];        }else{
                    [self showHudFailed:[json objectForKey:@"message"]];
                }
            
        } failure:^(NSError *error) {
            
        }];
    }else{
        
    
        [UMSocialWechatHandler setWXAppId:APP_ID appSecret:APP_SECRET url:nil];
        
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
        
        snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
            
            if (response.responseCode == UMSResponseCodeSuccess) {
                
                UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:UMShareToWechatSession];
                
                NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
                [self hudShow:@"正在登录..."];
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",snsAccount.accessToken,snsAccount.openId]];
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                    
                    NSString *str1 = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    [self WXLogin:str1];
                }];
                
                
            }
        });
        
    }

}

-(void)WXLogin:(NSString *)str
{
    NSMutableDictionary *dic =[NSMutableDictionary dictionary];
    [dic setObject:str forKey:@"json"];
    [dic setObject:APP_ID forKey:@"appid"];
    [HttpTool postWithURL:@"User/OutSiteLogin" params:dic success:^(id json) {
        
        [self textHUDHiddle];
        if([[json objectForKey:@"isSuccessful"] boolValue])
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
        else
        {
            [self showHudFailed:[json objectForKey:@"message"]];
        }
        
    } failure:^(NSError *error) {
    }];
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.priceField resignFirstResponder];
}
@end
