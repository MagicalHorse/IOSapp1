//
//  CusMineViewController.m
//  joybar
//
//  Created by 卢兴 on 15/4/16.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "CusMineViewController.h"
#import "AppDelegate.h"
#import "BuyerTabBarViewController.h"
#import "CusMineFirstTableViewCell.h"
#import "CusSettingViewController.h"
#import "CusCollectionViewController.h"
#import "BueryAuthViewController.h"
#import "MineData.h"
#import "CusAttentionViewController.h"
#import "CusFansViewController.h"
#import "CusBuyerCircleViewController.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
@interface CusMineViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UIActionSheetDelegate>
@property (nonatomic,strong)UIViewController* vcview;

@property (nonatomic ,strong) UITableView *tableView;

@property (nonatomic ,strong) MineData *mineData;

@property (nonatomic ,strong) UIImageView *bgImageView;
@property (nonatomic ,strong)UIView *bgView;
@property (nonatomic ,strong) UIView *tempView;
@property (nonatomic ,strong)UIButton *cancleBtn;
@property (nonatomic ,strong) UIImageView *codeImage;
@property (nonatomic ,strong) UIButton *btn;

@end

@implementation CusMineViewController
{
    UIImageView *headImage;
    UILabel *namelab;
    UIView *tempView;
}
-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    [self getMineData];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-49) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    UIView*bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    bgView.backgroundColor = [UIColor orangeColor];
    bgView.layer.shadowOpacity = 0.5;
    self.tableView.tableHeaderView = bgView;
    
    self.bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    self.bgImageView.image = [UIImage imageNamed:@"bgImage.png"];
    [bgView addSubview:self.bgImageView];
    
    UIImageView *circleImage = [[UIImageView alloc] init];
    circleImage.center = CGPointMake(kScreenWidth/2, 110);
    circleImage.bounds = CGRectMake(0, 0, 75, 75);
    circleImage.layer.borderWidth = 0.5;
    circleImage.layer.cornerRadius = circleImage.width/2;
    circleImage.layer.borderColor = [UIColor whiteColor].CGColor;
    circleImage.backgroundColor = [UIColor clearColor];
    [bgView addSubview:circleImage];
    
    headImage = [[UIImageView alloc] init];
    headImage.center = CGPointMake(circleImage.center.x, circleImage.center.y);
    headImage.bounds = CGRectMake(0, 0, 65, 65);
    headImage.layer.cornerRadius = headImage.width/2;
    headImage.clipsToBounds = YES;
    [bgView addSubview:headImage];
    
    namelab =[[UILabel alloc] init];
    namelab.center = CGPointMake(headImage.center.x, circleImage.bottom+15);
    namelab.bounds = CGRectMake(0, 0, 150, 20);
    namelab.textColor = [UIColor whiteColor];
    namelab.textAlignment = NSTextAlignmentCenter;
    namelab.font = [UIFont systemFontOfSize:18];
    [bgView addSubview:namelab];
    
    UILabel *locationLab = [[UILabel alloc] initWithFrame:CGRectMake(0, namelab.bottom+5, kScreenWidth, 20)];
    locationLab.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"cityName"];
    locationLab.textAlignment = NSTextAlignmentCenter;
    locationLab.font = [UIFont systemFontOfSize:13];
    locationLab.textColor = [UIColor whiteColor];
    [bgView addSubview:locationLab];
    
//    tempView = [[UIView alloc] init];
//    tempView.center = CGPointMake(kScreenWidth/2, self.bgImageView.bottom+43);
//    tempView.bounds = CGRectMake(0, 0, kScreenWidth-60, 70);
//    tempView.backgroundColor = [UIColor clearColor];
//    [bgView addSubview:tempView];
    
//    NSArray *nameArr = @[@"关注",@"粉丝",@"圈子"];
//    NSArray *numArr ;
//    numArr = @[@"0",@"0",@"0"];
//    for (int i=0; i<3; i++)
//    {
//        UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
//        btn.center = CGPointMake(tempView.width/3*i+tempView.width/6, 35);
//        btn.bounds = CGRectMake(0, 0, 70, 70);
//        btn.adjustsImageWhenHighlighted = NO;
//        [btn setImage:[UIImage imageNamed:@"圆.png"] forState:(UIControlStateNormal)];
//        btn.tag = 1000+i;
//        [btn addTarget:self action:@selector(didClickBtn:) forControlEvents:(UIControlEventTouchUpInside)];
//        [tempView addSubview:btn];
//        
//        UILabel *numLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 30, 13)];
//        numLab.font = [UIFont systemFontOfSize:12];
//        numLab.textColor = [UIColor darkGrayColor];
//        numLab.textAlignment = NSTextAlignmentCenter;
//        numLab.text = [numArr objectAtIndex:i];
//        numLab.tag = 100+i;
//        [btn addSubview:numLab];
//        
//        UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(20, numLab.bottom, 30, 20)];
//        nameLab.font = [UIFont systemFontOfSize:14];
//        nameLab.textColor = [UIColor grayColor];
//        nameLab.text = [nameArr objectAtIndex:i];
//        nameLab.textAlignment = NSTextAlignmentCenter;
//        [btn addSubview:nameLab];
//    }
    
    UIButton *messageBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    messageBtn.frame = CGRectMake(kScreenWidth-50, 30, 64, 64);
    messageBtn.backgroundColor = [UIColor clearColor];
    [messageBtn addTarget:self action:@selector(didClickSettingBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:messageBtn];
    
    UIImageView *messageImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    messageImg.image = [UIImage imageNamed:@"设置.png"];
    [messageBtn addSubview:messageImg];
    self.navView.hidden = YES;
    
}

-(void)getMineData
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [HttpTool postWithURL:@"user/GetmyInfo" params:nil success:^(id json) {
        
        if ([[json objectForKey:@"isSuccessful"] boolValue])
        {
            self.mineData = [MineData objectWithKeyValues:[json objectForKey:@"data"]];
            
               NSArray *numArr = @[self.mineData.FollowingCount,self.mineData.FollowerCount,self.mineData.CommunityCount];
            for (int i=0; i<numArr.count; i++)
            {
                UIButton *btn = (UIButton *)[tempView viewWithTag:i+1000];
                UILabel *lab = (UILabel *)[btn viewWithTag:100+i];
                lab.text = [numArr objectAtIndex:i];
            }
            NSString *url = [[Public getUserInfo] objectForKey:@"logo"];
            [headImage sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            namelab.text = [[Public getUserInfo] objectForKey:@"nickname"];

            [self.tableView reloadData];
        }
        else
        {
            [self showHudFailed:[json objectForKey:@"message"]];
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
    } failure:^(NSError *error) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden = @"cell";
    CusMineFirstTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell==nil)
    {
        cell = [[CusMineFirstTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:iden];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    cell.backgroundColor = kCustomColor(245, 246, 247);

    if (self.mineData)
    {
        [cell setData:self.mineData andIndexPath:indexPath];
    }

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {
        return 100;
    }
    else
    {
        return 50;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==1)
    {
        CusAttentionViewController *VC = [[CusAttentionViewController alloc] init];
        VC.userId = [[Public getUserInfo] objectForKey:@"id"];
        [self.navigationController pushViewController:VC animated:YES];
    }
    if (indexPath.row==2)
    {
        CusBuyerCircleViewController *VC = [[CusBuyerCircleViewController alloc] init];
        VC.userId = [[Public getUserInfo] objectForKey:@"id"];
        
        [self.navigationController pushViewController:VC animated:YES];

    }
    
    if (indexPath.row==3)
    {
        CusCollectionViewController *VC = [[CusCollectionViewController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }
    if (indexPath.row==4)
    {
        [self hudShow:@"正在加载"];
        [HttpTool postWithURL:@"User/CheckBuyerStatus" params:nil success:^(id json) {
            
            BOOL  isSuccessful =[[json objectForKey:@"isSuccessful"] boolValue];
            if (isSuccessful) {
                NSString *AuditStatus = [NSString stringWithFormat:@"%@",[[json objectForKey:@"data"] objectForKey:@"Status"]];
                if ([AuditStatus isEqualToString:@"1"]) //==1 通过
                {
                    [self btnClick];
                    
                }
                else if ([AuditStatus isEqualToString:@"-1"])
                {
                    [self showHudFailed: [[json objectForKey:@"data"] objectForKey:@"Message"]];//被拒绝
                }
                
                else if ([AuditStatus isEqualToString:@"0"])
                {
                    BueryAuthViewController *auth =[[BueryAuthViewController alloc]init];
                    [self.navigationController pushViewController:auth animated:YES];
                }else if([AuditStatus isEqualToString:@"-2"]){
                    
                }
            }else{
                [self showHudFailed:[json objectForKey:@"message"]];
            }
            [self textHUDHiddle];
        } failure:^(NSError *error) {
            [self textHUDHiddle];
            [self showHudFailed:@"服务器异常,请稍后再试"];

        }];
        
        
        
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
//点叉
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
-(void)btnClick{
    
    NSDictionary *dict= [Public getUserInfo];
  
        BOOL bing= [[dict objectForKey:@"IsBindWeiXin"]boolValue];
        if (bing) {
            //先判断有没有关注
            [self hudShow:@"正在处理"];
            [HttpTool postWithURL:@"User/GetUserFlowStatus" params:nil success:^(id json) {
                BOOL isSuccessful = [[json objectForKey:@"isSuccessful"]boolValue];
                if (isSuccessful) {
                    BOOL isFlow =[[[json objectForKey:@"data"]objectForKey:@"IsFlow"]boolValue];
                    
                    if (isFlow) {
                        [UIApplication sharedApplication].keyWindow.rootViewController =
                        [[BuyerTabBarViewController alloc]init];
                    }else{
                        _btn.userInteractionEnabled =NO;
                        NSData *data =[NSData dataWithContentsOfURL:[NSURL URLWithString:[[json objectForKey:@"data"] objectForKey:@"QRCode"]]];
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
                    
                    //                    NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
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
    [HttpTool postWithURL:@"User/BindOutSideUser" params:dic isWrite:YES  success:^(id json) {
        
        [self textHUDHiddle];
        if([[json objectForKey:@"isSuccessful"] boolValue])
        {
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"]];
            [dic setObject:@"1" forKey:@"IsBindWeiXin"];
            [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"userInfo"];
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

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    CusMineFirstTableViewCell  *cell = (CusMineFirstTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if (scrollView.contentOffset.y<0)
    {
        self.bgImageView.frame = CGRectMake(scrollView.contentOffset.y, scrollView.contentOffset.y, kScreenWidth-2*scrollView.contentOffset.y, 200-scrollView.contentOffset.y);
    }
}

//点击设置
-(void)didClickSettingBtn
{
    CusSettingViewController *VC = [[CusSettingViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 300-15;
//}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    
//    return bgView;
//
//}

-(void)didClickBtn:(UIButton *)btn
{
    switch (btn.tag)
    {
        case 1000:
        {
            CusAttentionViewController *VC = [[CusAttentionViewController alloc] init];
            VC.userId = [[Public getUserInfo] objectForKey:@"id"];
            [self.navigationController pushViewController:VC animated:YES];
        }
            
            break;
            
        case 1001:
        {
            CusFansViewController *VC = [[CusFansViewController alloc] init];
            VC.titleStr = @"粉丝";
            VC.userId = [[Public getUserInfo] objectForKey:@"id"];
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
            
        case 1002:
        {
            CusBuyerCircleViewController *VC = [[CusBuyerCircleViewController alloc] init];
            VC.userId = [[Public getUserInfo] objectForKey:@"id"];
            
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
            
        default:
            break;
    }

}
@end
