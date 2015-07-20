//
//  MakeSureOrderViewController.m
//  joybar
//
//  Created by 123 on 15/5/28.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "MakeSureOrderViewController.h"
#import "CusOrderProTableViewCell.h"
#import "PayOrderViewController.h"
@interface MakeSureOrderViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UITextFieldDelegate>

@property (nonatomic ,strong) UITableView *tableView;

@property (nonatomic ,strong) NSDictionary *priceDic;

@end

@implementation MakeSureOrderViewController
{
    UITextField *phoneText;
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
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickTableView)];
    [self.tableView addGestureRecognizer:tap];
    [self addNavBarViewAndTitle:@"确认订单"];
    
    [self getPrice];
}

-(void)getPrice
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.detailData.ProductId forKey:@"ProductId"];
    [dic setObject:self.buyNum forKey:@"Quantity"];
    [HttpTool postWithURL:@"Product/ComputeAmount" params:dic success:^(id json) {
        
        if ([[json objectForKey:@"isSuccessful"] boolValue])
        {
            self.priceDic = [json objectForKey:@"data"];
            [self initBottomView];
            [self.tableView reloadData];
        }
        else
        {
            
        }
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
    
    UIButton *sureBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    sureBtn.frame = CGRectMake(kScreenWidth-70, 10, 60, 30);
    sureBtn.layer.cornerRadius = 3;
    sureBtn.backgroundColor = [UIColor orangeColor];
    [sureBtn setTitle:@"确认" forState:(UIControlStateNormal)];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [sureBtn addTarget:self action:@selector(didCLickMakeSureBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [bottomView addSubview:sureBtn];
    
    UILabel *priceLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, kScreenWidth-80, 20)];
    priceLab.textAlignment = NSTextAlignmentRight;
//    CGFloat price = [self.detailData.Price floatValue]*[self.buyNum floatValue];
//    NSLog(@"%f",price);
    priceLab.text = [NSString stringWithFormat:@"合计: ￥%@",[self.priceDic objectForKey:@"saletotalamount"]];
    priceLab.textColor = [UIColor redColor];
    priceLab.font = [UIFont systemFontOfSize:16];
    [bottomView addSubview:priceLab];
    
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
        
        NSArray *arr = @[@"买手账号:",@"买手电话:",@"自提地址:"];
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 70, 20)];
        lab.textColor = [UIColor grayColor];
        lab.text = [arr objectAtIndex:indexPath.row];
        lab.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:lab];
        
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
        
        if (indexPath.row==0)
        {
            UIImageView *headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-50, 5, 40, 40)];
            headerImage.backgroundColor = [UIColor orangeColor];
            headerImage.layer.cornerRadius = headerImage.width/2;
            [headerImage sd_setImageWithURL:[NSURL URLWithString:self.detailData.BuyerLogo] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
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
    else if(indexPath.section==1)
    {
        static NSString *iden = @"cell1";
        CusOrderProTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
        if (cell==nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CusOrderProTableViewCell" owner:self options:nil] lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.buyNum=self.buyNum;
        cell.sizeName = self.sizeName;
        cell.priceDic = self.priceDic;
        [cell setData:self.detailData];
        return cell;
        
    }
    else if(indexPath.section==2)
    {
        static NSString *iden = @"cell2";
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
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 70, 20)];
        lab.text = @"提货电话:";
        lab.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:lab];
        
        phoneText = [[UITextField alloc] initWithFrame:CGRectMake(lab.right, 15, kScreenWidth-100, 30)];
        phoneText.borderStyle = UITextBorderStyleNone;
        phoneText.layer.borderColor = [UIColor grayColor].CGColor;
        phoneText.keyboardType = UIKeyboardTypeNumberPad;
        phoneText.layer.borderWidth =0.5;
        phoneText.layer.cornerRadius = 3;
        phoneText.placeholder = @" 未填写";
        phoneText.font = [UIFont systemFontOfSize:14];
        phoneText.delegate =self;
        [cell.contentView addSubview:phoneText];
        
        UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(phoneText.left, phoneText.bottom+5, 200, 20)];
        lab1.text = @"*输入您的手机, 方便买手找到你";
        lab1.textColor = [UIColor orangeColor];
        lab1.font = [UIFont systemFontOfSize:11];
        [cell.contentView addSubview:lab1];
        
        return cell;

    }
    else if(indexPath.section==3)
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
        lab.text = self.detailData.Promotion.Name;
        lab.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:lab];
        
        UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-215, 15, 200, 20)];
        lab1.textAlignment = NSTextAlignmentRight;
        lab1.text = [NSString stringWithFormat:@"立减 %@",[self.priceDic objectForKey:@"discountamount"]];
        lab1.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:lab1];

        return cell;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        if (indexPath.row==2)
        {
            CGSize size = [Public getContentSizeWith:self.detailData.ProductName andFontSize:15 andWidth:kScreenWidth-110];
            
            return size.height+30;
        }
        return 50;
    }
    else if (indexPath.section==1)
    {
        return 150;
    }
    else if (indexPath.section==2)
    {
        return 80;
    }
    return 50;
}

//确认
-(void)didCLickMakeSureBtn:(UIButton *)btn
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:self.detailData.ProductId forKey:@"ProductId"];
    [dic setValue:self.buyNum forKey:@"Count"];
    [dic setValue:self.sizeId forKey:@"SizeId"];
    if ([phoneText.text isEqualToString:@""])
    {
        [self showHudFailed:@"请填写提货电话"];
        return;
    }
    [dic setValue:phoneText.text forKey:@"mobile"];
    [self hudShow:@"正在提交订单"];
    [HttpTool postWithURL:@"Order/CreateOrder" params:dic success:^(id json) {
        
        if ([[json objectForKey:@"isSuccessful"] boolValue])
        {
            PayOrderViewController *VC = [[PayOrderViewController alloc] init];
            VC.proName = self.detailData.ProductName;
            VC.proPrice =[[json objectForKey:@"data"] objectForKey:@"ActualAmount"];
            VC.orderNum = [[json objectForKey:@"data"] objectForKey:@"OrderNo"];
            [self showHudSuccess:@"提交成功"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self.navigationController pushViewController:VC animated:YES];
                
            });
        }
        else
        {
            [self showHudFailed:[json objectForKey:@"message"]];
        }
        NSLog(@"%@",[json objectForKey:@"message"]);
        [self textHUDHiddle];
        
    } failure:^(NSError *error) {
        
    }];
}

//打电话
-(void)didCLickMakephoneBtn:(UIButton *)btn
{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",self.detailData.BuyerMobile];
    //            NSLog(@"str======%@",str);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.tableView)
    {
        [self.tableView endEditing:YES];
        CGFloat sectionHeaderHeight = 10;
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0)
        {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        }
        else if (scrollView.contentOffset.y>=sectionHeaderHeight)
        {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}

-(void)didClickTableView
{
    [self.tableView endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return YES;
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.30];
    CGRect rect = self.view.frame;
    rect.origin.y = -120;
    self.view.frame = rect;
    [UIView commitAnimations];
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.30];
    CGRect rect = self.view.frame;
    rect.origin.y = 0;
    self.view.frame = rect;
    [UIView commitAnimations];
    
    [textField resignFirstResponder];
    return  YES;

}

@end
