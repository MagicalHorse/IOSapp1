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

@interface BuyerComeOutViewController ()<UITextFieldDelegate,UIActionSheetDelegate>
- (IBAction)btnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *priceField;
@property (weak, nonatomic) IBOutlet UILabel *priceLable;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (nonatomic ,strong)UIView *bgView;
@property (nonatomic ,strong) UIView *tempView;
@property (nonatomic ,strong)UIButton *cancleBtn;
@property (nonatomic ,strong) UIImageView *codeImage;

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
        
        [self hudShow:@"正在处理"];
        [HttpTool postWithURL:@"User/GetUserFlowStatus" params:nil success:^(id json) {
            BOOL isSuccessful = [[json objectForKey:@"isSuccessful"]boolValue];
            if (isSuccessful) {
                BOOL isFlow =[[[json objectForKey:@"data"]objectForKey:@"IsFlow"]boolValue];

                if (isFlow) {
                    
                    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
                    
                    [dict setObject:self.priceField.text forKey:@"Amount"];
                    [HttpTool postWithURL:@"Assistant/Income_Request_RedPack" params:dict isWrite:YES success:^(id json) {
                        BOOL isSuccessful = [[json objectForKey:@"isSuccessful"] boolValue];
                        if (isSuccessful) {
                            
                            BuyerComeInSubmitViewController * sb=[[BuyerComeInSubmitViewController alloc]init];
                            [self.navigationController pushViewController:sb animated:YES];        }else{
                                [self showHudFailed:[json objectForKey:@"message"]];
                            }
                        
                    } failure:^(NSError *error) {
                        
                    }];
                    
                }else{
                    _btn.userInteractionEnabled =NO;
                    NSData *data =[NSData dataWithContentsOfURL:[NSURL URLWithString:[[json objectForKey:@"data"] objectForKey:@"QRCode"]]]
                    ;
                    [self addBigView:[UIImage imageWithData:data] AndTile:[[json objectForKey:@"data"] objectForKey:@"Name"]];
                }
                
            }else{
                [self showHudFailed:[json objectForKey:@"message"]];
            }
            [self textHUDHiddle];
        } failure:^(NSError *error) {
            [self showHudFailed:@"服务器正在维护,请稍后再试"];
            [self textHUDHiddle];
        }];
        
    }else{
        
    
        [UMSocialWechatHandler setWXAppId:APP_ID appSecret:APP_SECRET url:nil];
        
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
        
        snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
            
            if (response.responseCode == UMSResponseCodeSuccess) {
                
                UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:UMShareToWechatSession];
                
//                NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
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
-(void)addBigView:(UIImage*)img AndTile :(NSString *)title
{
    _tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _tempView.hidden = NO;
    _tempView.alpha =0.6 ;
    _tempView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_tempView];
    
    _bgView = [[UIView alloc] init];
    _bgView.center = CGPointMake(kScreenWidth/2, kScreenHeight/2);
    _bgView.bounds = CGRectMake(0, 0, kScreenWidth-50, (kScreenWidth-50)*1.50);
    _bgView.layer.cornerRadius = 4;
    _bgView.backgroundColor = kCustomColor(245, 246, 247);
    _bgView.hidden = NO;
    _bgView.userInteractionEnabled = YES;
    [self.view addSubview:_bgView];
    
    _cancleBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _cancleBtn.center = CGPointMake(kScreenWidth-25, _bgView.top);
    _cancleBtn.bounds = CGRectMake(0, 0, 50, 50);
    _cancleBtn.hidden = NO;
    [_cancleBtn setImage:[UIImage imageNamed:@"叉icon"] forState:(UIControlStateNormal)];
    [_cancleBtn addTarget:self action:@selector(didClickHiddenView:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_cancleBtn];
    
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(35, 20, _bgView.width-70, 60)];
    titleLab.text = @"请先关注买手公众号，关注后，返回货款收支页面即可提款货款";
    titleLab.font = [UIFont systemFontOfSize:16];
    titleLab.numberOfLines =0;
    [_bgView addSubview:titleLab];
    
    UILabel *numLab = [[UILabel alloc] initWithFrame:CGRectMake(titleLab.left, titleLab.bottom+2, titleLab.width, 14)];
    numLab.text = title;
    numLab.font = [UIFont systemFontOfSize:12];
    numLab.textColor = [UIColor lightGrayColor];
    numLab.textAlignment =NSTextAlignmentCenter;
    [_bgView addSubview:numLab];
    
    _codeImage = [[UIImageView alloc] initWithFrame:CGRectMake(35, numLab.bottom+10, _bgView.width-70, _bgView.width-70)];
    _codeImage.image =img;
    _codeImage.userInteractionEnabled =YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(codeImageDidSelect:)];
    [_codeImage addGestureRecognizer:tap];
    [_bgView addSubview:_codeImage];
    
    UILabel *bottomLab = [[UILabel alloc] initWithFrame:CGRectMake(35, _codeImage.bottom+10, _bgView.width-70, 60)];
    bottomLab.text = @"点击二维码，保存至手机，进入微信扫一扫点击右上角相册选择二维码";
    bottomLab.font = [UIFont systemFontOfSize:16];
    bottomLab.numberOfLines =0;
    [_bgView addSubview:bottomLab];
    
    
}
-(void)codeImageDidSelect:(UITapGestureRecognizer *)tap{
    UIActionSheet *action= [[UIActionSheet alloc] initWithTitle:@"保存到相册"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
    
    [action showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex ==0) {
        UIImageWriteToSavedPhotosAlbum([_codeImage image], nil, nil,nil);
        [self showHudSuccess:@"保存成功"];
    }
}
-(void)didClickHiddenView:(UIButton *)btn
{
    btn.hidden = YES;
    _bgView.transform = CGAffineTransformMakeScale(1, 1);
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         _bgView.transform = CGAffineTransformMakeScale(0.001, 0.001);
                         _bgView.alpha = 0.6;
                     }completion:^(BOOL finish){
                         _tempView.hidden = YES;
                         _bgView.hidden = YES;
                         self.btn.userInteractionEnabled =YES;
                         
                     }];
    
}

-(void)WXLogin:(NSString *)str
{
    NSMutableDictionary *dic =[NSMutableDictionary dictionary];
    [dic setObject:str forKey:@"json"];
    [dic setObject:APP_ID forKey:@"appid"];
    [HttpTool postWithURL:@"User/OutSiteLogin" params:dic isWrite:YES success:^(id json) {
        
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
