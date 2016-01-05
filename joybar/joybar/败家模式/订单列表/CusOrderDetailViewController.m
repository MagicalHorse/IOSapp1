//
//  CusOrderDetailViewController.m
//  joybar
//
//  Created by 123 on 15/5/28.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "CusOrderDetailViewController.h"
#import "CusOrderDetailTableViewCell.h"
#import "OrderDetailData.h"
#import "CusRefundPriceViewController.h"
#import "AppDelegate.h"
#import "Promotions.h"
#import "CusChatViewController.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "SDWebImageManager.h"
#import "CusRProDetailViewController.h"
#import "CusRefundPriceVipController.h"
#import "CusZProDetailViewController.h"
@interface CusOrderDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UMSocialUIDelegate>

@property (nonatomic ,strong) UITableView *tableView;

@property (nonatomic ,strong) OrderDetailData *detailData;

@property (nonatomic ,strong) NSArray *proArr;
@end

@implementation CusOrderDetailViewController
{
    UIButton *payBtn;
    UIButton *cancelBtn;
    UIButton *shareBtn;
    UILabel *shareLab;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64-49) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = kCustomColor(245, 246, 247);
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addNavBarViewAndTitle:@"订单详情"];
    [self initBottomView];
    [self getData];
}

-(void)getData
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:self.orderId forKey:@"OrderNo"];
    [self hudShow];
    [HttpTool postWithURL:@"Order/GetUserOrderDetailV3" params:dic success:^(id json) {
        
        [self hiddleHud];
        if ([[json objectForKey:@"isSuccessful"] boolValue])
        {
            self.detailData = [OrderDetailData objectWithKeyValues:[json objectForKey:@"data"]];
            self.proArr = [[json objectForKey:@"data"] objectForKey:@"Product"];
            if ([self.detailData.IsShareable boolValue])
            {
                shareBtn.hidden = NO;
                shareLab.hidden = NO;
            }
            else
            {
                shareBtn.hidden = YES;
                shareLab.hidden = YES;
            }
            [self.tableView reloadData];
            /*
             待付款"  0,
             "取消"    -10,
             "已付款"  1,
             "退货处理中"  3,
             "已发货"   15,
             "用户已签收" 16,
             "完成"  18,
             */
            NSString *status = self.detailData.OrderStatus;
            self.userLevel = [NSString stringWithFormat:@"%@",[self.proArr[0] objectForKey:@"UserLevel"]];
            NSString *canRma = self.detailData.CanRma;
            if ([status isEqualToString:@"0"])
            {
                cancelBtn.hidden = YES;
                payBtn.hidden = NO;
            }
            else if ([status isEqualToString:@"1"])
            {
                if ([self.userLevel isEqualToString:@"4"]&&[canRma isEqualToString:@"0"])
                {
                    cancelBtn.hidden = YES;
                    payBtn.hidden = NO;
                    [payBtn setTitle:@"确认提货" forState:(UIControlStateNormal)];
                }
                else
                {
                    cancelBtn.hidden = NO;
                    payBtn.hidden = NO;
                    [cancelBtn setTitle:@"申请退款" forState:(UIControlStateNormal)];
                    [payBtn setTitle:@"确认提货" forState:(UIControlStateNormal)];
                }
            }
            else if ([status isEqualToString:@"16"]||[status isEqualToString:@"15"])
            {
                if ([self.userLevel isEqualToString:@"4"]&&[canRma isEqualToString:@"0"])
                {
                    cancelBtn.hidden = YES;
                    payBtn.hidden = YES;
                }
                else
                {
                    cancelBtn.hidden = YES;
                    payBtn.hidden = NO;
                    [payBtn setTitle:@"申请退款" forState:(UIControlStateNormal)];
                }
            }
            else if ([status isEqualToString:@"3"])
            {
                if ([self.userLevel isEqualToString:@"4"])
                {
                    cancelBtn.hidden = YES;
                    payBtn.hidden = YES;
                }
                else
                {
                    cancelBtn.hidden = YES;
                    payBtn.hidden = NO;
                    [payBtn setTitle:@"撤销退款" forState:(UIControlStateNormal)];
                }
            }
            else if ([status isEqualToString:@"-10"]||[status isEqualToString:@"18"])
            {
                cancelBtn.hidden = YES;
                payBtn.hidden = YES;
            }
            else
            {
                cancelBtn.hidden = YES;
                payBtn.hidden = YES;
            }
        }
        else
        {
            [self showHudFailed:[json objectForKey:@"message"]];
        }
        NSLog(@"%@",[json objectForKey:@"message"]);
    } failure:^(NSError *error) {
        
    }];
}

-(void)initBottomView
{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-49, kScreenWidth, 49)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [bottomView addSubview:line];
    
    UIButton *chatBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    chatBtn.frame = CGRectMake(10, -5, 60, 49);
    [chatBtn setImage:[UIImage imageNamed:@"liaotian"] forState:(UIControlStateNormal)];
    [chatBtn addTarget:self action:@selector(didCLickMakeChatBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [bottomView addSubview:chatBtn];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 28, 60, 20)];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text = @"联系买手";
    lab.font = [UIFont systemFontOfSize:11];
    [bottomView addSubview:lab];
    
    shareBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    shareBtn.frame = CGRectMake(70, -5, 60, 49);
    [shareBtn setImage:[UIImage imageNamed:@"现金分享icon"] forState:(UIControlStateNormal)];
    shareBtn.hidden = YES;
    [shareBtn addTarget:self action:@selector(didCLickShareBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [bottomView addSubview:shareBtn];
    
    shareLab = [[UILabel alloc] initWithFrame:CGRectMake(70, 28, 60, 20)];
    shareLab.textAlignment = NSTextAlignmentCenter;
    shareLab.text = @"现金分享";
    shareLab.hidden = YES;
    shareLab.font = [UIFont systemFontOfSize:11];
    [bottomView addSubview:shareLab];

    payBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    payBtn.frame = CGRectMake(kScreenWidth-90, 10, 70, 30);
    [payBtn setTitle:@"付款" forState:(UIControlStateNormal)];
    payBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [payBtn setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
    payBtn.layer.borderColor = [UIColor redColor].CGColor;
    payBtn.layer.borderWidth = 0.5;
    payBtn.layer.cornerRadius = 3;
    payBtn.hidden = YES;
    [payBtn addTarget:self action:@selector(didClickPayBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [bottomView addSubview:payBtn];
    
    cancelBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    cancelBtn.frame = CGRectMake(payBtn.left-90, 10, 70, 30);
    [cancelBtn setTitle:@"取消订单" forState:(UIControlStateNormal)];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    cancelBtn.layer.borderColor = [UIColor blackColor].CGColor;
    cancelBtn.layer.borderWidth = 0.5;
    cancelBtn.layer.cornerRadius = 3;
    cancelBtn.hidden = YES;
    [cancelBtn addTarget:self action:@selector(didClickCancelBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [bottomView addSubview:cancelBtn];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    if (self.detailData.Promotions.count>0)
//    {
//        return 4;
//    }
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] init];
    header.backgroundColor = kCustomColor(245, 246, 247);
    return header;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0)
    {
        return 4;
    }
    else if (section==1)
    {
        return 3;
    }
    else if (section==3)
    {
        return self.detailData.Promotions.count;
    }
    return self.proArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        static NSString *iden = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
        if (cell==nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:iden];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        for (UIView *view in cell.contentView.subviews)
        {
            [view removeFromSuperview];
        }
        NSArray *arr = @[@"订单编号:",@"订单状态:",@"订单金额:",@"订单日期:"];
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 70, 20)];
        lab.textColor = [UIColor grayColor];
        lab.text = [arr objectAtIndex:indexPath.row];
        lab.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:lab];

        if (self.detailData)
        {
            NSArray *msgArr = @[self.detailData.OrderNo,self.detailData.OrderStatusName,[NSString stringWithFormat:@"￥%@",self.detailData.ActualAmount],self.detailData.CreateDate];
            UILabel *msgLab = [[UILabel alloc] initWithFrame:CGRectMake(lab.right+10, 15, kScreenWidth-110, 20)];
            msgLab.text = [msgArr objectAtIndex:indexPath.row];
            msgLab.font = [UIFont systemFontOfSize:15];
            [cell.contentView addSubview:msgLab];
        }
        
        return cell;
    }
    if (indexPath.section==1)
    {
        static NSString *iden = @"cell1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
        if (cell==nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:iden];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        for (UIView *view in cell.contentView.subviews)
        {
            [view removeFromSuperview];
        }
        
        NSArray *arr = @[@"买手昵称:",@"买手电话:",@"自提地址:"];
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 70, 20)];
        lab.textColor = [UIColor grayColor];
        lab.text = [arr objectAtIndex:indexPath.row];
        lab.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:lab];
        
        if (self.detailData)
        {
            NSArray *msgArr = @[self.detailData.BuyerName,self.detailData.BuyerMobile,self.detailData.PickAddress];
            UILabel *msgLab = [[UILabel alloc] init];
            msgLab.text = [msgArr objectAtIndex:indexPath.row];
            msgLab.font = [UIFont systemFontOfSize:15];
            [cell.contentView addSubview:msgLab];
            if (indexPath.row<2)
            {
                msgLab.frame = CGRectMake(lab.right+10, 15, 170, 20);
            }
            else
            {
                msgLab.numberOfLines = 0;
                CGSize size = [Public getContentSizeWith:[msgArr objectAtIndex:indexPath.row] andFontSize:15 andWidth:kScreenWidth-110];
                msgLab.frame = CGRectMake(lab.right+10, 15, kScreenWidth-110, size.height);
            }
        }
        if (indexPath.row==0)
        {
            UIImageView *headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-50, 5, 40, 40)];
            [headerImage sd_setImageWithURL:[NSURL URLWithString:self.detailData.BuyerLogo] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            headerImage.layer.cornerRadius = headerImage.width/2;
            headerImage.clipsToBounds = YES;
            [cell.contentView addSubview:headerImage];
        }
        if (indexPath.row==1)
        {
            UIButton *phoneBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
            phoneBtn.frame = CGRectMake(kScreenWidth-50, 5, 40, 40);
            [phoneBtn setImage:[UIImage imageNamed:@"dh"] forState:(UIControlStateNormal)];
            [phoneBtn addTarget:self action:@selector(didCLickMakephoneBtn:) forControlEvents:(UIControlEventTouchUpInside)];
            [cell.contentView addSubview:phoneBtn];
        }
        return cell;
    }
    else if(indexPath.section==2)
    {
        static NSString *iden = @"cell2";
        CusOrderDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
        if (cell==nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CusOrderDetailTableViewCell" owner:self options:nil] lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (self.proArr.count>0)
        {
            [cell setData:self.proArr[indexPath.row]];
        }
        return cell;
    }
    else if (indexPath.section==3)
    {
        static NSString *iden = @"cell3";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
        if (cell==nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:iden];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        for (UIView *view in cell.contentView.subviews)
        {
            [view removeFromSuperview];
        }
        if (self.detailData.Promotions.count>0)
        {
            for (int i=0; i<self.detailData.Promotions.count; i++)
            {
                Promotions *promotion = [self.detailData.Promotions objectAtIndex:i];
                
                UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 70, 20)];
                lab.text = promotion.PromotionName;
                lab.font = [UIFont systemFontOfSize:14];
                [cell.contentView addSubview:lab];
                
                UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-215, 15, 200, 20)];
                lab1.textAlignment = NSTextAlignmentRight;
                lab1.text = [NSString stringWithFormat:@"立减 %@元",promotion.Amount];
                lab1.font = [UIFont systemFontOfSize:14];
                [cell.contentView addSubview:lab1];
                
            }
        }
        return cell;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        return 50;
    }
    if (indexPath.section==1)
    {
        if (indexPath.row==2)
        {
            CGSize size = [Public getContentSizeWith:self.detailData.PickAddress andFontSize:15 andWidth:kScreenWidth-110];
            return size.height+30;
        }
        return 50;
    }
    else if (indexPath.section==3)
    {
        return 50;
    }
    return 80;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.detailData)
    {
        return;
    }
    if (indexPath.section==2)
    {
        if ([self.detailData.UserLevel isEqualToString:@"8"])
        {
            CusRProDetailViewController *VC = [[CusRProDetailViewController alloc] init];
            VC.productId = [self.proArr[indexPath.row]objectForKey:@"ProductId"];
            [self.navigationController pushViewController:VC animated:YES];
        }
        else
        {
            CusZProDetailViewController *VC = [[CusZProDetailViewController alloc] init];
            VC.productId = [self.proArr[indexPath.row]objectForKey:@"ProductId"];
            [self.navigationController pushViewController:VC animated:YES];
        }
        
    }
}

//打电话
-(void)didCLickMakephoneBtn:(UIButton *)btn
{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",self.detailData.BuyerMobile];
    //            NSLog(@"str======%@",str);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];

}

//点击私聊
-(void)didCLickMakeChatBtn:(UIButton *)btn
{
    CusChatViewController *VC = [[CusChatViewController alloc] initWithUserId:self.detailData.BuyerId AndTpye:2 andUserName:self.detailData.BuyerName];
    VC.isFrom = isFromPrivateChat;
    [self.navigationController pushViewController:VC animated:YES];
}

//分享
-(void)didCLickShareBtn:(UIButton *)btn
{
    if (![self.detailData.IsShareable boolValue])
    {
        [self showHudFailed:@"未支付或未完成订单不能分享"];
        return;
    }
    
    NSDictionary *userInfo= [Public getUserInfo];
    BOOL bing= [[userInfo objectForKey:@"IsBindWeiXin"]boolValue];
    if (bing) {
        
        [UMSocialWechatHandler setWXAppId:APP_ID appSecret:APP_SECRET url:self.detailData.ShareLink];
        
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.detailData.ProductPic]] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            
            [UMSocialSnsService presentSnsIconSheetView:self
                                                 appKey:@"55d43bf367e58eac01002b7f"
                                              shareText:self.detailData.ShareDesc
                                             shareImage:image
                                        shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline]
                                               delegate:self];
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
    [HttpTool postWithURL:@"User/BindOutSideUser" params:dic isWrite:YES success:^(id json) {
        
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

//实现回调方法（可选）：
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:self.detailData.OrderNo forKey:@"OrderNo"];
        [HttpTool postWithURL:@"Order/CreateShare" params:dic isWrite:YES success:^(id json) {
            
        } failure:^(NSError *error) {
            
        }];
    }
}

//付款
-(void)didClickPayBtn:(UIButton *)btn
{
    if ([btn.titleLabel.text isEqual:@"付款"])
    {
        AppDelegate *app =(AppDelegate *)[UIApplication sharedApplication].delegate;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccessHandle) name:@"PaySuccessNotification" object:nil];
        [app sendPay_demo:self.detailData.OrderNo andName:[self.proArr.firstObject objectForKey:@"ProductName"] andPrice:self.detailData.ActualAmount];
    }
    else if ([btn.titleLabel.text isEqual:@"确认提货"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请确认您与导购处于面对面状态,并确认拿到的商品与购买的商品信息一致,点击确定自提" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
    else if ([btn.titleLabel.text isEqual:@"申请退款"])
    {
        
        if ([self.detailData.OrderStatus isEqualToString:@"1"]&&[self.orderproducttype isEqualToString:@"4"]&&[self.userLevel isEqualToString:@"4"])
        {            
            CusRefundPriceViewController *VC  = [[CusRefundPriceViewController alloc] init];
            VC.orderNo = self.detailData.OrderNo;
            [self.navigationController pushViewController:VC animated:YES];
        }
        else if ([self.userLevel isEqualToString:@"8"]&&([self.detailData.OrderStatus isEqualToString:@"1"]||[self.detailData.OrderStatus isEqualToString:@"16"]||[self.detailData.OrderStatus isEqualToString:@"15"]))
        {
            CusRefundPriceViewController *VC  = [[CusRefundPriceViewController alloc] init];
            VC.orderNo = self.detailData.OrderNo;
            [self.navigationController pushViewController:VC animated:YES];
        }
        else
        {
            CusRefundPriceVipController *VC = [[CusRefundPriceVipController alloc] init];
            VC.orderNo = self.detailData.OrderNo;
            [self.navigationController pushViewController:VC animated:YES];
        }
    }
    else if ([btn.titleLabel.text isEqual:@"撤销退款"])
    {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:self.detailData.OrderNo forKey:@"OrderNo"];
        [self hudShow:@"正在取消"];
        [HttpTool postWithURL:@"Order/CancelRma" params:dic isWrite:YES success:^(id json) {
            
            if ([[json objectForKey:@"isSuccessful"] boolValue])
            {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.delegate refreshOrderList];
                });
            }
            else
            {
                [self showHudFailed:[json objectForKey:@"message"]];
            }
            [self textHUDHiddle];
            
        } failure:^(NSError *error) {
        }];

    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 1:
        {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:self.detailData.OrderNo forKey:@"OrderNo"];
            [self hudShow:@"正在确认提货"];
            [HttpTool postWithURL:@"Order/ConfirmGoods" params:dic isWrite:YES success:^(id json) {
                
                if ([[json objectForKey:@"isSuccessful"] boolValue])
                {
                    [self showHudSuccess:@"提货成功"];
                    [self getData];
                    [self.delegate refreshOrderList];
                }
                else
                {
                    [self showHudFailed:[json objectForKey:@"message"]];
                }
                [self textHUDHiddle];
                
            } failure:^(NSError *error) {
                
            }];
        }
            break;
        default:
            break;
    }
}

//取消订单
-(void)didClickCancelBtn:(UIButton *)btn
{
    if ([btn.titleLabel.text isEqual:@"申请退款"])
    {
        if ([self.detailData.OrderStatus isEqualToString:@"1"]&&[self.orderproducttype isEqualToString:@"4"]&&[self.userLevel isEqualToString:@"4"])
        {
            
            CusRefundPriceViewController *VC  = [[CusRefundPriceViewController alloc] init];
            VC.orderNo = self.detailData.OrderNo;
            [self.navigationController pushViewController:VC animated:YES];
            
        }
        else if ([self.userLevel isEqualToString:@"8"]&&([self.detailData.OrderStatus isEqualToString:@"1"]||[self.detailData.OrderStatus isEqualToString:@"16"]||[self.detailData.OrderStatus isEqualToString:@"15"]))
        {
            CusRefundPriceViewController *VC  = [[CusRefundPriceViewController alloc] init];
            VC.orderNo = self.detailData.OrderNo;
            [self.navigationController pushViewController:VC animated:YES];
        }
        else
        {
            
            CusRefundPriceVipController *VC = [[CusRefundPriceVipController alloc] init];
            VC.orderNo = self.detailData.OrderNo;
            [self.navigationController pushViewController:VC animated:YES];
            
        }
    }
    else if ([btn.titleLabel.text isEqual:@"取消订单"])
    {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:self.detailData.OrderNo forKey:@"OrderNo"];
        [self hudShow:@"正在取消"];
        [HttpTool postWithURL:@"Order/Void" params:dic isWrite:YES success:^(id json) {
            
            if ([[json objectForKey:@"isSuccessful"] boolValue])
            {
                [self getData];
                
                [self.delegate refreshOrderList];
            }
            else
            {
                [self showHudFailed:[json objectForKey:@"message"]];
            }
            [self textHUDHiddle];
            
        } failure:^(NSError *error) {
        }];
    }

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.tableView)
    {
        CGFloat sectionHeaderHeight = 10;
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}

-(void)paySuccessHandle
{
    [self showHudSuccess:@"支付成功"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)returnBtnClicked:(UIButton *)button
{
    if ([self.fromType isEqualToString:@"orderList"])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}


@end
