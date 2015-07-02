//
//  CusOrderListTableViewCell.m
//  joybar
//
//  Created by 123 on 15/5/15.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "CusOrderListTableViewCell.h"
#import "CusRefundPriceViewController.h"
#import "AppDelegate.h"
@implementation CusOrderListTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.refundBtn.layer.borderColor = [UIColor orangeColor].CGColor;
    self.refundBtn.layer.borderWidth = 0.5;
    self.refundBtn.layer.cornerRadius =  3;
    self.payBtn.layer.borderWidth = 0.5;
    self.payBtn.layer.borderColor = [UIColor orangeColor].CGColor;
    self.payBtn.layer.cornerRadius = 3;
}

-(void)setData
{
    self.nameLab.text = self.orderListItem.BuyerName;
    self.orderStatusLab.text = self.orderListItem.OrderStatusStr;
    self.locationLab.text = self.orderListItem.Address;
    self.proNameLab.text = self.orderListItem.Product.Name;
    self.numLab.text = [NSString stringWithFormat:@"x%@",self.orderListItem.OrderProductCount];
    self.proNameLab.text = [NSString stringWithFormat:@"共%@件商品",self.orderListItem.OrderProductCount];
    self.priceLab.text = [NSString stringWithFormat:@"￥%@",self.orderListItem.Product.Price];
    self.payPriceLab.text =[NSString stringWithFormat:@"￥%@",self.orderListItem.Amount];
    self.sizeLab.text = self.orderListItem.Product.Productdesc;
    NSString *tempUrl = [NSString stringWithFormat:@"%@_120x0.jpg",self.orderListItem.Product.Image];
    [self.proImageView sd_setImageWithURL:[NSURL URLWithString:tempUrl] placeholderImage:nil];
    self.proImageView.clipsToBounds = YES;
    NSString *status = self.orderListItem.OrderStatus;
    /*
     待付款"  0,
     "取消"    -10,
     "已付款"  1,
     "退货处理中"  3,
     "已发货"   15,
     "用户已签收" 16,
     "完成"  18,
     "全部退货" 19,
    */
    if ([status isEqualToString:@"0"])
    {
        self.refundBtn.hidden = YES;
        self.payBtn.hidden = NO;
    }
    else if ([status isEqualToString:@"1"])
    {
        self.refundBtn.hidden = NO;
        self.payBtn.hidden = NO;
        [self.refundBtn setTitle:@"申请退款" forState:(UIControlStateNormal)];
        [self.payBtn setTitle:@"确认提货" forState:(UIControlStateNormal)];
    }
    else if ([status isEqualToString:@"16"]||[status isEqualToString:@"15"])
    {
        self.refundBtn.hidden = YES;
        self.payBtn.hidden = NO;
        [self.payBtn setTitle:@"申请退款" forState:(UIControlStateNormal)];
    }
    else if ([status isEqualToString:@"3"])
    {
        self.refundBtn.hidden = YES;
        self.payBtn.hidden = YES;
//        [self.payBtn setTitle:@"撤销退款" forState:(UIControlStateNormal)];
    }
//    else ([status isEqualToString:@"-10"]||[status isEqualToString:@"18"])
    else
    {
        self.refundBtn.hidden = YES;
        self.payBtn.hidden = YES;
    }
}

- (IBAction)didClickRefundBtn:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    if ([btn.titleLabel.text isEqual:@"申请退款"])
    {
        CusRefundPriceViewController *VC  = [[CusRefundPriceViewController alloc] init];
        VC.proImageStr = self.orderListItem.Product.Image;
        VC.proNameStr = self.orderListItem.Product.Name;
        VC.proNumStr = self.orderListItem.OrderProductCount;
        VC.proPriceStr = self.orderListItem.Product.Price;
        VC.proSizeStr = self.orderListItem.Product.Productdesc;
        VC.orderNum = self.orderListItem.OrderNo;
        [self.viewController.navigationController pushViewController:VC animated:YES];
    }
}

- (IBAction)didClickPayBtn:(id)sender
{
    UIButton *btn = (UIButton *)sender;

    if ([btn.titleLabel.text isEqual:@"付款"])
    {
        AppDelegate *app =(AppDelegate *)[UIApplication sharedApplication].delegate;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccessHandle) name:@"PaySuccessNotification" object:nil];
        [app sendPay_demo:self.orderListItem.OrderNo andName:self.orderListItem.Product.Name andPrice:self.orderListItem.Amount];
    }
    else if ([btn.titleLabel.text isEqual:@"确认提货"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请确认您与导购处于面对面状态,并确认拿到的商品与购买的商品信息一致,点击确定自提" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
    else if ([btn.titleLabel.text isEqual:@"申请退款"])
    {
        CusRefundPriceViewController *VC  = [[CusRefundPriceViewController alloc] init];
        VC.proImageStr = self.orderListItem.Product.Image;
        VC.proNameStr = self.orderListItem.Product.Name;
        VC.proNumStr = self.orderListItem.OrderProductCount;
        VC.proPriceStr = self.orderListItem.Product.Price;
        VC.proSizeStr = self.orderListItem.Product.Productdesc;
        VC.orderNum = self.orderListItem.OrderNo;
        [self.viewController.navigationController pushViewController:VC animated:YES];
    }
    else if ([btn.titleLabel.text isEqual:@"撤销退款"])
    {
        
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 1:
        {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:self.orderListItem.OrderNo forKey:@"OrderNo"];
            [self hudShowWithText:@"正在确认提货"];
            [HttpTool postWithURL:@"Order/ConfirmGoods" params:dic success:^(id json) {
                
                if ([[json objectForKey:@"isSuccessful"] boolValue])
                {
                    [self showHudSuccess:@"提货成功"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        [self.delegate orderListDelegate];
                    });
                }
                else
                {
                    [self showHudFailed:[json objectForKey:@"message"]];
                }
                [self textHUDHiddle];
                
            } failure:^(NSError *error) {
                [self showHudFailed:@"请求失败"];
            }];
        }
            break;
        default:
            break;
    }
}

-(void) onResp:(BaseResp*)resp
{
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;
    
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    }
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:
            {
                strMsg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
                alert.tag = 100;
                [alert show];
            }
                break;
            case WXErrCodeUserCancel:
            {
                
            }
                break;
            default:
                //                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                //                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
    }
}

-(void)paySuccessHandle
{
    [self showHudSuccess:@"支付成功"];
    [self.delegate orderListDelegate];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PaySuccessNotification" object:nil];
}

@end
