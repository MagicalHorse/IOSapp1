//
//  CusOrderListViewController.m
//  joybar
//
//  Created by 123 on 15/5/15.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "CusOrderListViewController.h"
#import "CusOrderListTableViewCell.h"
#import "CusOrderDetailViewController.h"
#import "OrderListData.h"
#import "CusRefundPriceViewController.h"
#import "CusAppealViewController.h"

@interface CusOrderListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) UIView *line;

@property (nonatomic ,strong) NSMutableArray *btnArr;

@property (nonatomic ,strong) UITableView *tableView;

@property (nonatomic ,strong) OrderListData *orderListData;

@end

@implementation CusOrderListViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.btnArr = [NSMutableArray array];
    
    self.view.backgroundColor = kCustomColor(243, 247, 248);
    
    UIView *headerBar = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 40)];
    headerBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headerBar];
    
    NSArray *arr = @[@"全部",@"待付款",@"专柜自提",@"售后"];
    self.line = [[UIView alloc] init];
    self.line.backgroundColor = [UIColor orangeColor];
    [headerBar addSubview:self.line];
    
    for (int i=0; i<arr.count; i++)
    {
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        button.frame = CGRectMake(kScreenWidth/arr.count*i, 0, kScreenWidth/arr.count, 40);
        [button setTitle:[arr objectAtIndex:i] forState:(UIControlStateNormal)];
        [button setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
        button.titleLabel.font = [UIFont fontWithName:@"youyuan" size:14];
        button.tag = 1000+i;
        [button addTarget:self action:@selector(didClickOrderBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        [headerBar addSubview:button];
        if (i==self.btnIndex)
        {
            [button setTitleColor:[UIColor orangeColor] forState:(UIControlStateNormal)];
            self.line.frame = CGRectMake(5+kScreenWidth/4*i, 38, kScreenWidth/arr.count-10, 2);
        }
        [self.btnArr addObject:button];
    }
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+40, kScreenWidth, kScreenHeight-64-40)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = kCustomColor(242, 244, 245);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    [self addNavBarViewAndTitle:@"我的订单"];

    
    [self getData:[NSString stringWithFormat:@"%ld",self.btnIndex]];
    self.line.frame = CGRectMake(5+kScreenWidth/4*self.btnIndex, 38, kScreenWidth/4-10, 2);
}

-(void)getData:(NSString *)status
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:@"1" forKey:@"Page"];
    [dic setValue:@"10000" forKey:@"Pagesize"];
    [dic setValue:status forKey:@"State"];
    [HttpTool postWithURL:@"Order/GetOrderListByState" params:dic success:^(id json) {
        
        if ([[json objectForKey:@"isSuccessful"] boolValue])
        {
            self.orderListData = [OrderListData objectWithKeyValues:[json objectForKey:@"data"]];
            
            [self.tableView reloadData];
        }
        else
        {
            
        }
        
    } failure:^(NSError *error) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.orderListData.items.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden = @"cell";
    CusOrderListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell==nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CusOrderListTableViewCell" owner:self options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.orderListItem = [self.orderListData.items objectAtIndex:indexPath.row];
    [cell setData];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 210;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    CusOrderDetailViewController *VC = [[CusOrderDetailViewController alloc] init];
//    OrderListItem *item = [self.orderListData.items objectAtIndex:indexPath.row];
//    VC.orderId = item.OrderNo;
//    [self.navigationController pushViewController:VC animated:YES];
    
//    CusRefundPriceViewController *VC = [[CusRefundPriceViewController alloc] init];
//    [self.navigationController pushViewController:VC animated:YES];
    CusAppealViewController *VC = [[CusAppealViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}
-(void)didClickOrderBtn:(UIButton *)btn
{
    NSInteger index = btn.tag-1000;
    self.line.frame = CGRectMake(5+kScreenWidth/4*index, 38, kScreenWidth/4-10, 2);
    for (UIButton *button in self.btnArr)
    {
        if (button==btn)
        {
            [button setTitleColor:[UIColor orangeColor] forState:(UIControlStateNormal)];
        }
        else
        {
            [button setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
        }
    }

    switch (btn.tag)
    {
        case 1000:
        {
            //全部
            
            [self getData:@"0"];
        }
            break;
        case 1001:
        {
            //待付款
            [self getData:@"1"];

        }
            break;
        case 1002:
        {
            //专柜自提
            [self getData:@"2"];

        }
            break;
        case 1003:
        {
            //售后
            [self getData:@"3"];

        }
            break;

        default:
            break;
    }
}

@end
