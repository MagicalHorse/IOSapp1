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
@interface CusOrderDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong) UITableView *tableView;

@property (nonatomic ,strong) OrderDetailData *detailData;

@end

@implementation CusOrderDetailViewController
{
    UIButton *payBtn;
    UIButton *cancelBtn;
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
    [HttpTool postWithURL:@"Order/GetUserOrderDetail" params:dic success:^(id json) {
        
        if ([json objectForKey:@"isSuccessful"])
        {
            self.detailData = [OrderDetailData objectWithKeyValues:[json objectForKey:@"data"]];
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
            if ([status isEqualToString:@"0"])
            {
                cancelBtn.hidden = YES;
                payBtn.hidden = NO;
            }
            else if ([status isEqualToString:@"1"])
            {
                cancelBtn.hidden = NO;
                payBtn.hidden = NO;
                [cancelBtn setTitle:@"申请退款" forState:(UIControlStateNormal)];
                [payBtn setTitle:@"确认提货" forState:(UIControlStateNormal)];
            }
            else if ([status isEqualToString:@"16"]||[status isEqualToString:@"15"])
            {
                cancelBtn.hidden = YES;
                payBtn.hidden = NO;
                [payBtn setTitle:@"申请退款" forState:(UIControlStateNormal)];
            }
            else if ([status isEqualToString:@"3"])
            {
                cancelBtn.hidden = YES;
                payBtn.hidden = NO;
                [payBtn setTitle:@"撤销退款" forState:(UIControlStateNormal)];
            }
            else if ([status isEqualToString:@"-10"]||[status isEqualToString:@"18"])
            {
                cancelBtn.hidden = YES;
                payBtn.hidden = YES;
            }
        }
        else
        {
            
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
    lab.font = [UIFont fontWithName:@"youyuan" size:11];
    [bottomView addSubview:lab];
    
    UIButton *shareBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    shareBtn.frame = CGRectMake(100, -5, 60, 49);
    [shareBtn setImage:[UIImage imageNamed:@"现金分享icon"] forState:(UIControlStateNormal)];
    [shareBtn addTarget:self action:@selector(didCLickMakeChatBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [bottomView addSubview:shareBtn];
    
    UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(100, 28, 60, 20)];
    lab1.textAlignment = NSTextAlignmentCenter;
    lab1.text = @"现金分享";
    lab1.font = [UIFont fontWithName:@"youyuan" size:11];
    [bottomView addSubview:lab1];

    payBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    payBtn.frame = CGRectMake(kScreenWidth-90, 10, 70, 30);
    [payBtn setTitle:@"付款" forState:(UIControlStateNormal)];
    payBtn.titleLabel.font = [UIFont fontWithName:@"youyuan" size:14];
    [payBtn setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
    payBtn.layer.borderColor = [UIColor redColor].CGColor;
    payBtn.layer.borderWidth = 0.5;
    payBtn.layer.cornerRadius = 3;
    [payBtn addTarget:self action:@selector(didClickPayBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [bottomView addSubview:payBtn];
    
    cancelBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    cancelBtn.frame = CGRectMake(payBtn.left-90, 10, 70, 30);
    [cancelBtn setTitle:@"取消订单" forState:(UIControlStateNormal)];
    cancelBtn.titleLabel.font = [UIFont fontWithName:@"youyuan" size:14];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    cancelBtn.layer.borderColor = [UIColor blackColor].CGColor;
    cancelBtn.layer.borderWidth = 0.5;
    cancelBtn.layer.cornerRadius = 3;
    [cancelBtn addTarget:self action:@selector(didClickCancelBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [bottomView addSubview:cancelBtn];

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
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
    return 1;
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
        lab.font = [UIFont fontWithName:@"youyuan" size:15];
        [cell.contentView addSubview:lab];

        if (self.detailData)
        {
            NSArray *msgArr = @[self.detailData.OrderNo,self.detailData.OrderStatusName,[NSString stringWithFormat:@"￥%@",self.detailData.OrderAmount],self.detailData.CreateDate];
            UILabel *msgLab = [[UILabel alloc] initWithFrame:CGRectMake(lab.right+10, 15, kScreenWidth-110, 20)];
            msgLab.text = [msgArr objectAtIndex:indexPath.row];
            msgLab.font = [UIFont fontWithName:@"youyuan" size:15];
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
        
        NSArray *arr = @[@"买手账号:",@"买手电话:",@"自提地址:"];
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 70, 20)];
        lab.textColor = [UIColor grayColor];
        lab.text = [arr objectAtIndex:indexPath.row];
        lab.font = [UIFont fontWithName:@"youyuan" size:15];
        [cell.contentView addSubview:lab];
        
        if (self.detailData)
        {
            NSArray *msgArr = @[self.detailData.BuyerName,self.detailData.BuyerMobile,self.detailData.PickAddress];
            UILabel *msgLab = [[UILabel alloc] init];
            msgLab.text = [msgArr objectAtIndex:indexPath.row];
            msgLab.font = [UIFont fontWithName:@"youyuan" size:15];
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
            [headerImage sd_setImageWithURL:[NSURL URLWithString:self.detailData.BuyerLogo] placeholderImage:nil];
            headerImage.layer.cornerRadius = headerImage.width/2;
            headerImage.clipsToBounds = YES;
            [cell.contentView addSubview:headerImage];
        }
        if (indexPath.row==1)
        {
            UIButton *phoneBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
            phoneBtn.frame = CGRectMake(kScreenWidth-50, 5, 40, 40);
            [phoneBtn setImage:[UIImage imageNamed:@"电话icon"] forState:(UIControlStateNormal)];
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
        
        [cell setData:self.detailData];
        
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
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 70, 20)];
        lab.text = @"打烊购:";
        lab.font = [UIFont fontWithName:@"youyuan" size:14];
        [cell.contentView addSubview:lab];
        
        UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-215, 15, 200, 20)];
        lab1.textAlignment = NSTextAlignmentRight;
        lab1.text = @"立减 30.00元";
        lab1.font = [UIFont fontWithName:@"youyuan" size:14];
        [cell.contentView addSubview:lab1];
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
    
}

//付款
-(void)didClickPayBtn:(UIButton *)btn
{
    if ([btn.titleLabel.text isEqual:@"付款"])
    {
        AppDelegate *app =(AppDelegate *)[UIApplication sharedApplication].delegate;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccessHandle) name:@"PaySuccessNotification" object:nil];
        [app sendPay_demo:self.detailData.OrderNo andName:self.detailData.ProductName andPrice:self.detailData.OrderAmount];
    }
    else if ([btn.titleLabel.text isEqual:@"确认提货"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请确认您与导购处于面对面状态,并确认拿到的商品与购买的商品信息一致,点击确定自提" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
    else if ([btn.titleLabel.text isEqual:@"申请退款"])
    {
        CusRefundPriceViewController *VC  = [[CusRefundPriceViewController alloc] init];
        VC.proImageStr = self.detailData.ProductPic;
        VC.proNameStr = self.detailData.ProductName;
        VC.proNumStr = self.detailData.ProductCount;
        VC.proPriceStr = self.detailData.Price;
        VC.proSizeStr = [NSString stringWithFormat:@"%@:%@",self.detailData.SizeName,self.detailData.SizeValue];
        [self.navigationController pushViewController:VC animated:YES];
    }
    else if ([btn.titleLabel.text isEqual:@"撤销退款"])
    {
        
    }
}

//取消订单
-(void)didClickCancelBtn:(UIButton *)btn
{
    
    if ([btn.titleLabel.text isEqual:@"申请退款"])
    {
        CusRefundPriceViewController *VC  = [[CusRefundPriceViewController alloc] init];
        VC.proImageStr = self.detailData.ProductPic;
        VC.proNameStr = self.detailData.ProductName;
        VC.proNumStr = self.detailData.ProductCount;
        VC.proPriceStr = self.detailData.Price;
        VC.proSizeStr = [NSString stringWithFormat:@"%@:%@",self.detailData.SizeName,self.detailData.SizeValue];
         [self.navigationController pushViewController:VC animated:YES];
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



@end
