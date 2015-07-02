//
//  CusSettingViewController.m
//  joybar
//
//  Created by 123 on 15/5/6.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "CusSettingViewController.h"
#import "ChangePasswordViewController.h"
#import "BuyerOpenMessageViewController.h"
#import "CusAboutViewController.h"
#import "AppDelegate.h"
#import "UMSocialWechatHandler.h"
#import "UMSocial.h"
#import "CusBindMobileViewController.h"
@interface CusSettingViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>

@property (nonatomic ,strong) UITableView *tableView;

@end

@implementation CusSettingViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.backgroundColor = kCustomColor(245, 246, 247);
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = kCustomColor(245, 246, 247);
    [self.view addSubview:self.tableView];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addNavBarViewAndTitle:@"设置"];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bindMoblieHandle) name:@"bindMobileNot" object:nil];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"bindMobileNot" object:self];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor =kCustomColor(245, 246, 247);
    
    if (section==3)
    {
        UIButton *exitBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        exitBtn.frame = CGRectMake(20, 20, kScreenWidth-40, 40);
        [exitBtn setBackgroundColor:kCustomColor(253, 162, 41)];
        [exitBtn setTitle:@"退出登录" forState:(UIControlStateNormal)];
        exitBtn.layer.cornerRadius = 4;
        [exitBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [exitBtn addTarget:self action:@selector(didClickExitBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        [headerView addSubview:exitBtn];
    }
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0)
    {
        return 0;
    }
    else if (section==3)
    {
        return 180;
    }
    return 20;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==3)
    {
        return 0;
    }
    else if (section==2)
    {
        return 1;
    }
    else if (section==1)
    {
        return 4;
    }
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
//    if (cell==nil)
//    {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:iden];
//    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    
    NSArray *nameArr = @[@[@"头像",@"昵称"],@[@"账户密码",@"消息免打扰",@"手机号绑定",@"微信绑定"],@[@"关于我们"]];
    cell.textLabel.text = [[nameArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"youyuan" size:18];

    if (indexPath.section==0)
    {
        if (indexPath.row==0)
        {
            UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-110, 15, 70, 70)];
            [headImageView sd_setImageWithURL:[NSURL URLWithString:[[Public getUserInfo] objectForKey:@"logo"]] placeholderImage:nil];
            headImageView.clipsToBounds = YES;
            
            headImageView.layer.cornerRadius = headImageView.width/2;
            [cell.contentView addSubview:headImageView];
        }
        else
        {
            UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-240, 12.5, 200, 30)];
            nameLab.textAlignment = NSTextAlignmentRight;
            nameLab.text =[[Public getUserInfo] objectForKey:@"nickname"];
            nameLab.font = [UIFont fontWithName:@"youyuan" size:16];
            nameLab.textColor = [UIColor lightGrayColor];
            [cell.contentView addSubview:nameLab];
        }
    }
    if(indexPath.section==1)
    {
//        if (indexPath.row==2)
//        {
//            cell.accessoryType = UITableViewCellAccessoryNone;
//            
//            UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 600)];
//            bgView.backgroundColor = kCustomColor(245, 246, 247);
//            [cell.contentView addSubview:bgView];
//        }
        
        if (indexPath.row==2)
        {
        
            UILabel *lab =[[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-70, 17, 50, 20)];
            lab.text = @"已绑定";
            lab.font = [UIFont fontWithName:@"youyuan" size:14];
            lab.textColor = [UIColor lightGrayColor];
            [cell.contentView addSubview:lab];
            if ([[[Public getUserInfo] objectForKey:@"IsBindMobile"] boolValue])
            {
                lab.hidden = NO;
            }
            else
            {
                lab.hidden = YES;
            }
        }
        else if (indexPath.row==3)
        {
            UILabel *lab =[[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-70, 17, 50, 20)];
            lab.text = @"已绑定";
            lab.font = [UIFont fontWithName:@"youyuan" size:14];
            lab.textColor = [UIColor lightGrayColor];
            [cell.contentView addSubview:lab];
            
            if ([[[Public getUserInfo] objectForKey:@"IsBindWeiXin"] boolValue])
            {
                lab.hidden = NO;
            }
            else
            {
                lab.hidden = YES;
            }
        }
    }
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0&&indexPath.row==0)
    {
        return 100;
    }
    else if (indexPath.section==3&&indexPath.row==2)
    {
        return 200;
    }
    return 55;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1&&indexPath.row==0)
    {
        ChangePasswordViewController *VC = [[ChangePasswordViewController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }
    else if(indexPath.section==1&&indexPath.row==1)
    {
        BuyerOpenMessageViewController * message =[[BuyerOpenMessageViewController alloc]init];
        [self.navigationController pushViewController:message animated:YES];

    }
    else if (indexPath.section==1&&indexPath.row==2)
    {
        if (![[[Public getUserInfo] objectForKey:@"IsBindMobile"] boolValue])
        {
           //手机号绑定
            CusBindMobileViewController *VC = [[CusBindMobileViewController alloc] init];
            [self.navigationController pushViewController:VC animated:YES];
        }
    }
    else if (indexPath.section==1&&indexPath.row==3)
    {
          //微信绑定
        if (![[[Public getUserInfo] objectForKey:@"IsBindWeiXin"] boolValue])
        {
            [self bindWX];
        }
    }
    else if(indexPath.section==0&&indexPath.row==0)
    {
        
    }else if(indexPath.section==0&&indexPath.row==1){
        
    }
    else if (indexPath.section==2)
    {
        CusAboutViewController *VC = [[CusAboutViewController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }
}

-(void)didClickExitBtn:(UIButton *)btn
{
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定退出" otherButtonTitles: nil];
    [action showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {
//        [Public showLoginVC:self];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"userInfo"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        AppDelegate *ad= (AppDelegate *)[UIApplication sharedApplication].delegate;
        CusTabBarViewController *tab = [[CusTabBarViewController alloc] init];
        ad.window.rootViewController =tab;
    }
}

//微信登陆
-(void)bindWX
{
    [UMSocialWechatHandler setWXAppId:APP_ID appSecret:APP_SECRET url:@"http://www.umeng.com/social"];
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:UMShareToWechatSession];
            
            [self hudShow:@"正在绑定..."];
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
            
            [self showHudSuccess:@"绑定成功"];
            [self.tableView reloadData];
        }
        else
        {
            [self showHudFailed:[json objectForKey:@"message"]];
        }
        
    } failure:^(NSError *error) {
        [self showHudFailed:@"请求失败"];
    }];
    
}

-(void)bindMoblieHandle
{
    [self.tableView reloadData];
}

@end
