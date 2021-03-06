//
//  MakeSureOrderViewController.m
//  joybar
//
//  Created by 123 on 15/5/28.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "MakeSureOrderViewController.h"
#import "CusOrderProTableViewCell.h"
@interface MakeSureOrderViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (nonatomic ,strong) UITableView *tableView;

@end

@implementation MakeSureOrderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initBottomView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64-49) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = kCustomColor(245, 246, 247);
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self addNavBarViewAndTitle:@"确认订单"];

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
    sureBtn.titleLabel.font = [UIFont fontWithName:@"youyuan" size:14];
    [sureBtn addTarget:self action:@selector(didCLickMakeSureBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [bottomView addSubview:sureBtn];
    
    UILabel *priceLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, kScreenWidth-80, 20)];
    priceLab.textAlignment = NSTextAlignmentRight;
    CGFloat price = [self.detailData.Price floatValue]*[self.buyNum floatValue];
    NSLog(@"%f",price);
    priceLab.text = [NSString stringWithFormat:@"合计: ￥%.2f",price];
    priceLab.textColor = [UIColor redColor];
    priceLab.font = [UIFont fontWithName:@"youyuan" size:16];
    [bottomView addSubview:priceLab];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
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
        lab.font = [UIFont fontWithName:@"youyuan" size:15];
        [cell.contentView addSubview:lab];
        
        NSArray *msgArr = @[self.detailData.ProductName,self.detailData.BuyerMobile,self.detailData.PickAddress];
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
        
        if (indexPath.row==0)
        {
            UIImageView *headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-50, 5, 40, 40)];
            headerImage.backgroundColor = [UIColor orangeColor];
            headerImage.layer.cornerRadius = headerImage.width/2;
            [headerImage sd_setImageWithURL:[NSURL URLWithString:self.detailData.BuyerLogo] placeholderImage:nil];
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
    else
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
        [cell setData:self.detailData];
        return cell;
        
    }
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
    return 150;
}

//确认
-(void)didCLickMakeSureBtn:(UIButton *)btn
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:self.detailData.ProductId forKey:@"ProductId"];
    [dic setValue:self.buyNum forKey:@"Count"];
    [dic setValue:self.sizeId forKey:@"SizeId"];
    [HttpTool postWithURL:@"Order/CreateOrder" params:dic success:^(id json) {
        
        if ([[json objectForKey:@"isSuccessful"] boolValue])
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else
        {
            
        }
        NSLog(@"%@",[json objectForKey:@"message"]);
        
    } failure:^(NSError *error) {
        
    }];
}

//打电话
-(void)didCLickMakephoneBtn:(UIButton *)btn
{
    
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


@end
