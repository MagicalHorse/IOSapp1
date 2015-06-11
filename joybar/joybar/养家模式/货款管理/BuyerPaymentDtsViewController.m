//
//  BuyerPaymentDtsViewController.m
//  joybar
//
//  Created by joybar on 15/6/10.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "BuyerPaymentDtsViewController.h"
#import "BuyerPaymentTableViewCell.h"

@interface BuyerPaymentDtsViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    int tpye;
}
@property (nonatomic ,strong) UIScrollView *homeScroll;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic ,strong) UILabel *lineLab;
@property (nonatomic ,strong) UIView *tempView;
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) UITableView *tableView1;


@end

@implementation BuyerPaymentDtsViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

-(NSMutableArray *)dataArray{
    
    if (_dataArray ==nil) {
        _dataArray =[[NSMutableArray alloc]init];
    }
    return _dataArray;
}
-(void)setData :(int)type
{
    NSMutableDictionary * dict=[[NSMutableDictionary alloc]init];
    [dict setObject:@(1) forKey:@"Page"];
    [dict setObject:@(6) forKey:@"Pagesize"];
    if (type ==3) {
        [dict setObject:@"3" forKey:@"OrderProductType"];
    }else if(type ==2){
        [dict setObject:@"0" forKey:@"Status"];
        
    }else if(type ==4){
        [dict setObject:@"3" forKey:@"Status"];
    }
    [HttpTool postWithURL:@"Order/GetOrderList" params:dict success:^(id json) {
        
//        BOOL isSuccessful = [[json objectForKey:@"isSuccessful"] boolValue];
//        if (isSuccessful) {
//            NSMutableArray *array =[json objectForKey:@"data"];
//            Orders *order = [Orders objectWithKeyValues :array];
//            _dataArray = order.orderlist;
//        }
        [self.tableView reloadData];

    } failure:^(NSError *error) {
        NSLog(@"%@",[error description]);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setData:1];
    _tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 40)];
    _tempView.backgroundColor = kCustomColor(251, 250, 250);
    [self.view addSubview:_tempView] ;
    NSArray *nameArr = @[@"可提现",@"冻结中",@"已提现",@"退款"];
    for (int i=0; i<4; i++)
    {
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(_tempView.width/4*i, 0, _tempView.width/4, 35)];
        
        lab.userInteractionEnabled = YES;
        lab.font = [UIFont fontWithName:@"youyuan" size:13];
        lab.backgroundColor = [UIColor clearColor];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = [UIColor grayColor];
        lab.text = [nameArr objectAtIndex:i];
        lab.tag=1000+i;
        tpye=i;
        [_tempView addSubview:lab];
        if (i==0)
        {
            lab.textColor = [UIColor orangeColor];
            lab.font = [UIFont fontWithName:@"youyuan" size:15];
            
            self.lineLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _tempView.width/5, 3)];
            self.lineLab.center = CGPointMake(lab.center.x, 38);
            self.lineLab.backgroundColor = [UIColor orangeColor];
            [_tempView addSubview:self.lineLab];
        }
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelect:)];
        [lab addGestureRecognizer:tap];
       
    }
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 39+64-0.5, kScreenWidth, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lineView];
    
    
    //tableView
    self.tableView= [[UITableView alloc]init];
    self.tableView.frame = CGRectMake(0, 64+40, kScreenWidth, kScreenHeight-64-49-40);
    self.tableView.tag = 1;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.restorationIdentifier =@"cell";
    self.tableView.backgroundColor = kCustomColor(241, 241, 241);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(0, kScreenHeight-49, kScreenWidth, 49)];
    [btn setTitle:@"提现货款" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    btn.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:btn];
    
    [self addNavBarViewAndTitle:@"货款收支"];

}

#pragma mark tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    Order *order = self.dataArray[indexPath.section];
//    Product * product =[order.Products firstObject];
    static NSString *CellIdentifier = @"cell1";
    BuyerPaymentTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (tableView.tag ==1) {
//        static NSString *CellIdentifier = @"cell1";
//        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//        
//    }else if (tableView.tag==2) {
//        static NSString *CellIdentifier = @"cell2";
//        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    }else if (tableView.tag==3) {
//        static NSString *CellIdentifier = @"cell3";
//        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    }else if (tableView.tag==4) {
//        static NSString *CellIdentifier = @"cell4";
//        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    }
    
    if (cell == nil) {
        cell =[[[NSBundle mainBundle] loadNibNamed:@"BuyerPaymentTableViewCell" owner:self options:nil] lastObject];
    }
//    cell.titleView.text =product.BrandName;
//    cell.detileView.text =product.Name;
//    cell.noView.text =[product.StoreItemNo stringValue];
//    cell.priceView.text =[NSString stringWithFormat:@"%@%@",@"￥",product.Price];
//    cell.countView.text =[NSString stringWithFormat:@"%@%@",@"x",product.Count];
//    cell.guigeView.text =[NSString stringWithFormat:@"%@%@",@"规格：",product.SizeName];
//    cell.picView.clipsToBounds =YES;
//    NSString * temp =[NSString stringWithFormat:@"%@_120x0.jpg",product.Picture ];
//    [cell.picView sd_setImageWithURL:[NSURL URLWithString:temp] placeholderImage:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    Order *order = self.dataArray[indexPath.section];
//    BueryStoreDetailsController *details=[[BueryStoreDetailsController alloc]initWithCode:order.OrderNo];
//    [self.navigationController pushViewController:details animated:YES];
}







-(void)showCountClick:(UIButton *)btn{
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(void)didSelect:(UITapGestureRecognizer *)tap
{
    if (tap.view.tag==1000)
    {
        [self scrollToBuyerStreet];
    }
    else if(tap.view.tag==1001)
    {
        [self scrollToSaid];
    }
    else if(tap.view.tag==1002)
    {
        [self scrollToMyBuyer];
    }
    else
    {
        self.homeScroll.contentOffset = CGPointMake(kScreenWidth*3, 0);
        [self scrollToMyBuyer1];
    }
}

//全部订单
-(void)scrollToBuyerStreet
{
    UILabel *lab1 = (UILabel *)[_tempView viewWithTag:1000];
    UILabel *lab2 = (UILabel *)[_tempView viewWithTag:1001];
    UILabel *lab3 = (UILabel *)[_tempView viewWithTag:1002];
    UILabel *lab4 = (UILabel *)[_tempView viewWithTag:1003];
    
    [UIView animateWithDuration:0.1 animations:^{
        self.lineLab.center = CGPointMake(lab1.center.x, 38);
    }];
    lab1.textColor = [UIColor orangeColor];
    lab1.font = [UIFont fontWithName:@"youyuan" size:15];
    lab2.textColor = [UIColor grayColor];
    lab2.font = [UIFont fontWithName:@"youyuan" size:13];
    lab3.textColor = [UIColor grayColor];
    lab3.font = [UIFont fontWithName:@"youyuan" size:13];
    lab4.textColor = [UIColor grayColor];
    lab4.font = [UIFont fontWithName:@"youyuan" size:13];
    
    self.dataArray =nil;
    [self.tableView1 removeFromSuperview];
    self.tableView1 =nil;
//    [self setData:[[Parameter alloc]initWith:@"1" andPageSize:@"10"] andType:1];
    
}

//待付款
-(void)scrollToSaid
{
    UILabel *lab1 = (UILabel *)[_tempView viewWithTag:1000];
    UILabel *lab2 = (UILabel *)[_tempView viewWithTag:1001];
    UILabel *lab3 = (UILabel *)[_tempView viewWithTag:1002];
    UILabel *lab4 = (UILabel *)[_tempView viewWithTag:1003];
    
    if (self.tableView1 ==nil) {
        self.tableView1= [[UITableView alloc] init];
        self.tableView1.frame = CGRectMake(0, 64+40, kScreenWidth, kScreenHeight-64-40);
        self.tableView1.dataSource=self;
        self.tableView1.delegate =self;
        self.tableView1.tag = 2;
        self.tableView1.tableFooterView =[[UIView alloc]init];
        
        [self.view addSubview:self.tableView1];
    }
    
    

    

    [UIView animateWithDuration:0.1 animations:^{
        self.lineLab.center = CGPointMake(lab2.center.x, 38);
    }];
    lab2.textColor = [UIColor orangeColor];
    lab2.font = [UIFont fontWithName:@"youyuan" size:15];
    lab1.textColor = [UIColor grayColor];
    lab1.font = [UIFont fontWithName:@"youyuan" size:13];
    lab3.textColor = [UIColor grayColor];
    lab3.font = [UIFont fontWithName:@"youyuan" size:13];
    lab4.textColor = [UIColor grayColor];
    lab4.font = [UIFont fontWithName:@"youyuan" size:13];
    
}
//专柜自提
-(void)scrollToMyBuyer
{
    UILabel *lab1 = (UILabel *)[_tempView viewWithTag:1000];
    UILabel *lab2 = (UILabel *)[_tempView viewWithTag:1001];
    UILabel *lab3 = (UILabel *)[_tempView viewWithTag:1002];
    UILabel *lab4 = (UILabel *)[_tempView viewWithTag:1003];
   
    
    self.dataArray =nil;
//    [self setData:[[Parameter alloc]initWith:@"1" andPageSize:@"10"] andType:3];
    
    [UIView animateWithDuration:0.1 animations:^{
        self.lineLab.center = CGPointMake(lab3.center.x, 38);
    }];
    lab3.textColor = [UIColor orangeColor];
    lab3.font = [UIFont fontWithName:@"youyuan" size:15];
    lab4.textColor = [UIColor grayColor];
    lab4.font = [UIFont fontWithName:@"youyuan" size:13];
    lab2.textColor = [UIColor grayColor];
    lab2.font = [UIFont fontWithName:@"youyuan" size:13];
    lab1.textColor = [UIColor grayColor];
    lab1.font = [UIFont fontWithName:@"youyuan" size:13];
    
    
}
//售后中心
-(void)scrollToMyBuyer1
{
    UILabel *lab1 = (UILabel *)[_tempView viewWithTag:1000];
    UILabel *lab2 = (UILabel *)[_tempView viewWithTag:1001];
    UILabel *lab3 = (UILabel *)[_tempView viewWithTag:1002];
    UILabel *lab4 = (UILabel *)[_tempView viewWithTag:1003];
    
    
    [UIView animateWithDuration:0.1 animations:^{
        self.lineLab.center = CGPointMake(lab4.center.x, 38);
    }];
    lab4.textColor = [UIColor orangeColor];
    lab4.font = [UIFont fontWithName:@"youyuan" size:15];
    lab3.textColor = [UIColor grayColor];
    lab3.font = [UIFont fontWithName:@"youyuan" size:13];
    lab2.textColor = [UIColor grayColor];
    lab2.font = [UIFont fontWithName:@"youyuan" size:13];
    lab1.textColor = [UIColor grayColor];
    lab1.font = [UIFont fontWithName:@"youyuan" size:13];
    
}

@end
