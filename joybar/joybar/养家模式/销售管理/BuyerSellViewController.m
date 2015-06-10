//
//  BuyerSellViewController.m
//  joybar
//
//  Created by liyu on 15/5/5.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "BuyerSellViewController.h"
#import "BuyerHomeTableViewCell.h"
#import "BuyerSellTableViewCell.h"
#import "BuyerStoreTableViewCell.h"
#import "MJExtension.h"
#import "Product.h"
#import "Order.h"
#import "Orders.h"
#import "Parameter.h"
#import "BueryStoreDetailsController.h"

@interface BuyerSellViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>{
}
@property (nonatomic ,strong) UIScrollView *homeScroll;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic ,strong) UILabel *lineLab;
@property (nonatomic ,strong) UIView *tempView;
@property (nonatomic ,strong) UITableView *tableView1;
@property (nonatomic ,strong) UITableView *tableView2;
@property (nonatomic ,strong) UITableView *tableView3;
@property (nonatomic ,strong) UITableView *tableView4;
@property (nonatomic ,assign) CGFloat startX;
@property (nonatomic ,assign) CGFloat endX;
@end

@implementation BuyerSellViewController
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
-(void)setData:(Parameter *)param andType:(int)type
{
    NSMutableDictionary * dict=[[NSMutableDictionary alloc]init];
    [dict setObject:param.page forKey:@"Page"];
    [dict setObject:param.pageSzie forKey:@"Pagesize"];
    if (type ==3) {
        [dict setObject:@"3" forKey:@"OrderProductType"];
    }else if(type ==2){
        [dict setObject:@"0" forKey:@"Status"];

    }else if(type ==4){
        [dict setObject:@"3" forKey:@"Status"];
    }
    [HttpTool postWithURL:@"Order/GetOrderList" params:dict success:^(id json) {
        
        BOOL isSuccessful = [[json objectForKey:@"isSuccessful"] boolValue];
        if (isSuccessful) {
            NSMutableArray *array =[json objectForKey:@"data"];
          Orders *order = [Orders objectWithKeyValues :array];
        _dataArray = order.orderlist;
        }
        if (type ==1) {
            [self.tableView1 reloadData];
        }else if(type ==2){
            [self.tableView2 reloadData];
        }
        else if(type ==3){
            [self.tableView3 reloadData];
        }else if(type ==4){
            [self.tableView4 reloadData];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",[error description]);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setData:[[Parameter alloc]initWith:@"1" andPageSize:@"10"] andType:1];
    [self addNavBarViewAndTitle:@"销售管理"];
    _tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 40)];
    _tempView.backgroundColor = kCustomColor(251, 250, 250);
    [self.view addSubview:_tempView] ;
    NSArray *nameArr = @[@"全部订单",@"待付款",@"专柜自提",@"售后中心"];
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
    
    self.homeScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64+40, kScreenWidth, kScreenHeight-64)];
    self.homeScroll.contentSize = CGSizeMake(kScreenWidth*4, 0);
    self.homeScroll.alwaysBounceVertical = NO;
    self.homeScroll.pagingEnabled = YES;
    self.homeScroll.delegate = self;
    self.homeScroll.directionalLockEnabled = YES;
    self.homeScroll.showsHorizontalScrollIndicator = NO;
    self.homeScroll.bounces = NO;
    [self.view addSubview:self.homeScroll];
    
    //tableView
    self.tableView1= [[UITableView alloc]init];
    self.tableView1.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-104);
    self.tableView1.tag = 1;
    self.tableView1.delegate = self;
    self.tableView1.dataSource = self;
    self.tableView1.restorationIdentifier =@"cell";
    self.tableView1.backgroundColor = kCustomColor(237, 237, 237);
    _tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.homeScroll addSubview:self.tableView1];


}

#pragma mark tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    Order *order = self.dataArray[indexPath.section];
    Product * product =[order.Products firstObject];
    BuyerStoreTableViewCell *cell;
    if (tableView.tag ==1) {
        static NSString *CellIdentifier = @"cell1";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    }else if (tableView.tag==2) {
        static NSString *CellIdentifier = @"cell2";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }else if (tableView.tag==3) {
        static NSString *CellIdentifier = @"cell3";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }else if (tableView.tag==4) {
        static NSString *CellIdentifier = @"cell4";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    
    if (cell == nil) {
        cell =[[[NSBundle mainBundle] loadNibNamed:@"BuyerStoreTableViewCell" owner:self options:nil] lastObject];
    }
    cell.titleView.text =product.BrandName;
    cell.detileView.text =product.Name;
    cell.noView.text =[product.StoreItemNo stringValue];
    cell.priceView.text =[NSString stringWithFormat:@"%@%@",@"￥",product.Price];
    cell.countView.text =[NSString stringWithFormat:@"%@%@",@"x",product.Count];
    cell.guigeView.text =[NSString stringWithFormat:@"%@%@",@"规格：",product.SizeName];
    cell.picView.clipsToBounds =YES;
    NSString * temp =[NSString stringWithFormat:@"%@_120x0.jpg",product.Picture ];
    [cell.picView sd_setImageWithURL:[NSURL URLWithString:temp] placeholderImage:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Order *order = self.dataArray[indexPath.section];
    BueryStoreDetailsController *details=[[BueryStoreDetailsController alloc]initWithCode:order.OrderNo];
    [self.navigationController pushViewController:details animated:YES];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 54)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *orderLabel = [[UILabel alloc]init];
    Order *o = self.dataArray[section];
    if (tableView.tag>3) {
        orderLabel.text = @"退货单号:";
        orderLabel.frame =CGRectMake(15, 15, 75, 16);
    }else{
        orderLabel.text = @"订单号:";
        orderLabel.frame =CGRectMake(15, 15, 60, 16);
    }
    orderLabel.font = [UIFont fontWithName:@"youyuan" size:16];
    [view addSubview:orderLabel];
    
    UILabel *orderNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(orderLabel.right, 16, 150, 15)];
    orderNumLabel.font = [UIFont fontWithName:@"youyuan" size:15];
    orderNumLabel.text =o.OrderNo;
    [view addSubview:orderNumLabel];
    
    UILabel *orderSLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-135, 14, 120, 16)];
    orderSLabel.textAlignment =NSTextAlignmentRight;
    orderSLabel.text = o.StatusName;
    orderSLabel.textColor =[UIColor redColor];
    orderSLabel.font = [UIFont fontWithName:@"youyuan" size:16];
    [view addSubview:orderSLabel];
    
    UIView *viewLine = [[UIView alloc]initWithFrame:CGRectMake(15, orderSLabel.bottom+14.5, kScreenWidth-30, 1)];
    viewLine.backgroundColor = kCustomColor(240, 240, 240);
    [view addSubview:viewLine];

    return view;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    Order *o = self.dataArray[section];
    CGFloat viewY=0;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, viewY)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *cooutLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 65, 13)];
    
    CGFloat fuhaoX;
    if (tableView.tag>3) {
        fuhaoX = cooutLabel.center.x+25;
    }else{
        fuhaoX = cooutLabel.center.x;
    }
    
    UILabel *fuhaoL=[[UILabel alloc]initWithFrame:CGRectMake(fuhaoX, 12, 20, 13)];
    fuhaoL.text =@"￥";
    [view addSubview:fuhaoL];

    UILabel *orderPLabel1 = [[UILabel alloc]init];
    UILabel *orderPTLabel = [[UILabel alloc]init];
    UILabel *orderPLabel = [[UILabel alloc]init];

    if (tableView.tag >3) {
        if ([o.Status isEqualToNumber:@(3)]) {
            viewY= 100;
            UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(0, viewY-26-40+5.5, kScreenWidth, 40)];
            btn.tag =section;
            btn.titleLabel.font =[UIFont fontWithName:@"youyuan" size:13];
            [btn setTitle:@"确认退款" forState:UIControlStateNormal];
            [btn setTitleColor:kCustomColor(41, 121, 222) forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont fontWithName:@"youyuan" size:17];
            [btn addTarget:self action:@selector(showCountClick:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:btn];
            
            UIView * v1=[[UIView alloc]initWithFrame:CGRectMake(0, btn.top, kScreenWidth, 0.5)];
            v1.backgroundColor =[UIColor lightGrayColor];
            [view addSubview:v1];
            UIView * v2=[[UIView alloc]initWithFrame:CGRectMake(0, btn.bottom, kScreenWidth, 0.5)];
            v2.backgroundColor =[UIColor lightGrayColor];
            [view addSubview:v2];

        }else{
            viewY= 55;
            cooutLabel.text = @"佣金:";
            orderPTLabel.text = @"实付:";
            orderPLabel.textColor =[UIColor redColor];
        }
        cooutLabel.text = @"退还佣金:";
        orderPTLabel.text = @"退款:";
        orderPLabel.textColor =[UIColor blackColor];
    }else{
        
        viewY =55;
        cooutLabel.text = @"佣金:";
        orderPTLabel.text = @"实付:";
        orderPLabel.textColor =[UIColor redColor];
    }
    
    cooutLabel.font = [UIFont fontWithName:@"youyuan" size:13];
    [view addSubview:cooutLabel];
    
    orderPLabel.text = [o.InCome stringValue];
    CGSize size= [Public getContentSizeWith:orderPLabel.text andFontSize:18 andHigth:18];
    orderPLabel.frame =CGRectMake(fuhaoL.right, 8, size.width, size.height);
    [view addSubview:orderPLabel];
    
    orderPLabel1.text =[NSString stringWithFormat:@"%@%@",@"￥", [o.Amount stringValue]];
    CGSize s= [Public getContentSizeWith:orderPLabel1.text andFontSize:18 andHigth:18];
    orderPLabel1.frame =CGRectMake(kScreenWidth-s.width-10, 8, s.width, s.height);
    [view addSubview:orderPLabel1];

    orderPTLabel.frame=CGRectMake(orderPLabel1.left-40, 10, 40, 13);
    orderPTLabel.font = [UIFont fontWithName:@"youyuan" size:13];
    [view addSubview:orderPTLabel];
    
    UIView *viewBg = [[UIView alloc]initWithFrame:CGRectMake(0, viewY-20, kScreenWidth, 20)];
    viewBg.backgroundColor =  kCustomColor(237, 237, 237);
    [view addSubview:viewBg];
    
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectio{
    return 54;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    Order *o = self.dataArray[section];
    if (tableView.tag  >3&&[o.Status isEqualToNumber:@(3)]) {
        return 100;
    }
    return 55;
}


-(void)showCountClick:(UIButton *)btn{
    
//    orderlist *o =self.dataArray[btn.tag];
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 101;
}
#pragma mark ScrollViewDeletegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.startX = scrollView.contentOffset.x;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    self.endX = scrollView.contentOffset.x;
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    
    self.endX = scrollView.contentOffset.x;
    
    if (self.startX-self.endX==0)
    {
        return;
    }
    if (scrollView.contentOffset.x==0)
    {
        [self scrollToBuyerStreet];
    }
    else if(scrollView.contentOffset.x==kScreenWidth)
    {
        [self scrollToSaid];
    }
    
    else if(scrollView.contentOffset.x==kScreenWidth*2)
    {
        [self scrollToMyBuyer];
    }
    else
    {
        [self scrollToMyBuyer1];
    }
    
}

-(void)didSelect:(UITapGestureRecognizer *)tap
{
    if (tap.view.tag==1000)
    {
        self.homeScroll.contentOffset = CGPointMake(0, 0);
        [self scrollToBuyerStreet];
    }
    else if(tap.view.tag==1001)
    {
        self.homeScroll.contentOffset = CGPointMake(kScreenWidth, 0);
        [self scrollToSaid];
    }
    else if(tap.view.tag==1002)
    {
        self.homeScroll.contentOffset = CGPointMake(kScreenWidth*2, 0);
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
    _tableView1.restorationIdentifier =@"cell1";

    self.dataArray =nil;
    [self setData:[[Parameter alloc]initWith:@"1" andPageSize:@"10"] andType:1];
    
}

//待付款
-(void)scrollToSaid
{
    UILabel *lab1 = (UILabel *)[_tempView viewWithTag:1000];
    UILabel *lab2 = (UILabel *)[_tempView viewWithTag:1001];
    UILabel *lab3 = (UILabel *)[_tempView viewWithTag:1002];
    UILabel *lab4 = (UILabel *)[_tempView viewWithTag:1003];
   
    _tableView2= [[UITableView alloc] init];
    _tableView2.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight-104);
    [self.homeScroll addSubview:_tableView2];
    _tableView2.delegate =self;
    _tableView2.dataSource=self;
    _tableView2.tag=2;
    _tableView2.backgroundColor = kCustomColor(237, 237, 237);
    self.dataArray =nil;
    [self setData:[[Parameter alloc]initWith:@"1" andPageSize:@"10"] andType:2];
    _tableView2.restorationIdentifier =@"cell2";
    _tableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    _tableView3= [[UITableView alloc] init];
    _tableView3.frame = CGRectMake(kScreenWidth*2, 0, kScreenWidth, kScreenHeight-104);
    [self.homeScroll addSubview:_tableView3];
    _tableView3.delegate =self;
    _tableView3.dataSource=self;
    _tableView3.tag=3;
    _tableView3.backgroundColor = kCustomColor(237, 237, 237);
    _tableView3.restorationIdentifier =@"cell3";
    _tableView3.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.dataArray =nil;
    [self setData:[[Parameter alloc]initWith:@"1" andPageSize:@"10"] andType:3];

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
    
    _tableView4= [[UITableView alloc] init];
    _tableView4.frame = CGRectMake(kScreenWidth*3, 0, kScreenWidth, kScreenHeight-104);
    [self.homeScroll addSubview:_tableView4];
    _tableView4.delegate =self;
    _tableView4.dataSource=self;
    _tableView4.tag=4;
    _tableView4.backgroundColor = kCustomColor(237, 237, 237);
    _tableView4.restorationIdentifier =@"cell4";
    self.dataArray =nil;
    [self setData:[[Parameter alloc]initWith:@"1" andPageSize:@"10"] andType:4];
    _tableView4.separatorStyle = UITableViewCellSeparatorStyleNone;

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
