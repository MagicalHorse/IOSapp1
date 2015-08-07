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
#import "BueryStoreDetailsController.h"
#import "AppDelegate.h"
#import "payRequsestHandler.h"

@interface BuyerSellViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    BOOL isRefresh;
    int type;
}
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic ,strong) UILabel *lineLab;
@property (nonatomic ,strong) UIView *tempView;
@property (nonatomic ,strong) BaseTableView *tableView;
@property (nonatomic ,assign) NSInteger pageNum;

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
-(void)setData
{
    if (isRefresh) {
        [self showInView:self.view WithPoint:CGPointMake(0, 64+40) andHeight:kScreenHeight-64-40];

    }
    NSMutableDictionary * dict=[[NSMutableDictionary alloc]init];
    [dict setValue:[NSString stringWithFormat:@"%ld",(long)self.pageNum] forKey:@"Page"];
    [dict setObject:@"6" forKey:@"Pagesize"];
    if (self.customerId) {
        [dict setObject:self.customerId forKey:@"CustomerId"];
    }
    if (type ==1) {
        [dict setObject:@"0" forKey:@"Status"];
    }else if(type ==2){
        [dict setObject:@"1" forKey:@"Status"];

    }else if(type ==3){
        [dict setObject:@"2" forKey:@"Status"];
    }
    else if(type ==4){
        [dict setObject:@"3" forKey:@"Status"];
    }
    [HttpTool postWithURL:@"Order/GetOrderList" params:dict success:^(id json) {
        
        BOOL isSuccessful = [[json objectForKey:@"isSuccessful"] boolValue];
        if (isSuccessful) {
            NSMutableArray *array =[json objectForKey:@"data"];
            Orders *order = [Orders objectWithKeyValues :array];

            if(order.orderlist.count<6)
            {
                [self.tableView hiddenFooter:YES];
            }
            else
            {
                [self.tableView hiddenFooter:NO];
            }
            if (self.pageNum==1) {
                [self.dataArray removeAllObjects];
                [self.dataArray addObjectsFromArray:order.orderlist];
            }else{
                [self.dataArray addObjectsFromArray:order.orderlist];
            }
            
        }else{
            self.dataArray=nil;
            [self showHudFailed:@"加载失败"];
        }
        [self.tableView reloadData];
        [self activityDismiss];
        [self.tableView endRefresh];
        isRefresh =NO;
        
    } failure:^(NSError *error) {
        [self.tableView endRefresh];
        [self activityDismiss];
    }];
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.customTitle.length>0) {
        [self addNavBarViewAndTitle:@"订单管理"];
    }else{
        [self addNavBarViewAndTitle:@"销售管理"];
    }
    _tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 40)];
    _tempView.backgroundColor = kCustomColor(251, 250, 250);
    [self.view addSubview:_tempView] ;
    NSArray *nameArr = @[@"全部订单",@"待付款",@"专柜自提",@"售后中心"];
    for (int i=0; i<4; i++)
    {
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(_tempView.width/4*i, 0, _tempView.width/4, 35)];
        
        lab.userInteractionEnabled = YES;
        lab.font = [UIFont systemFontOfSize:13];
        lab.backgroundColor = [UIColor clearColor];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = [UIColor grayColor];
        lab.text = [nameArr objectAtIndex:i];
        lab.tag=1000+i;
        [_tempView addSubview:lab];
        if (i==0)
        {
            lab.textColor = [UIColor orangeColor];
            lab.font = [UIFont systemFontOfSize:15];
            
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
    self.tableView= [[BaseTableView alloc]initWithFrame:CGRectMake(0, 64+40, kScreenWidth, kScreenHeight-104) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = kCustomColor(237, 237, 237);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.pageNum=1;
    type =1;
    isRefresh=YES;
    
    __weak BuyerSellViewController *VC = self;
    self.tableView.headerRereshingBlock = ^()
    {
        VC.pageNum=1;
        [VC setData];
    };
    self.tableView.footerRereshingBlock = ^()
    {
        VC.pageNum++;
        [VC setData];
    };
    
    [self setData];

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
    static NSString *CellIdentifier = @"cell";
    BuyerStoreTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell =[[[NSBundle mainBundle] loadNibNamed:@"BuyerStoreTableViewCell" owner:self options:nil] lastObject];
    }
    if(self.dataArray.count>0){
    Order *order = self.dataArray[indexPath.section];
    Product * product =[order.Products firstObject];
    
    cell.titleView.text =product.BrandName;
    cell.detileView.text =product.Name;
    cell.noView.text =product.StoreItemNo ;
    cell.priceView.text =[NSString stringWithFormat:@"%@%@",@"￥",product.Price];
    cell.countView.text =[NSString stringWithFormat:@"%@%@",@"x",product.Count];
    cell.guigeView.text =[NSString stringWithFormat:@"%@%@",@"规格：",product.SizeName];
    cell.picView.clipsToBounds =YES;
    NSString * temp =[NSString stringWithFormat:@"%@",product.Picture ];
    [cell.picView sd_setImageWithURL:[NSURL URLWithString:temp] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    }
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
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    view.backgroundColor = [UIColor whiteColor];
    
        UIView *viewBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
        viewBg.backgroundColor =  kCustomColor(237, 237, 237);
        [view addSubview:viewBg];

    
    UILabel *orderLabel = [[UILabel alloc]init];
    Order *o = self.dataArray[section];
    if ([o.Status isEqualToNumber:@(3)]) {
        orderLabel.text = @"退货单号:";
        orderLabel.frame =CGRectMake(15, 35, 75, 16);
    }else{
        orderLabel.text = @"订单号:";
        orderLabel.frame =CGRectMake(15, 35, 60, 16);
    }
    orderLabel.font = [UIFont systemFontOfSize:16];
    [view addSubview:orderLabel];
    
    UILabel *orderNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(orderLabel.right, 36, 150, 15)];
    orderNumLabel.font = [UIFont systemFontOfSize:15];
    orderNumLabel.text =o.OrderNo;
    [view addSubview:orderNumLabel];
    
    UILabel *orderSLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-135, 34, 120, 16)];
    orderSLabel.textAlignment =NSTextAlignmentRight;
    orderSLabel.text = o.StatusName;
    orderSLabel.textColor =[UIColor redColor];
    orderSLabel.font = [UIFont systemFontOfSize:16];
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
    
    UILabel *cooutLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 22, 65, 13)];
    
    CGFloat fuhaoX;
    if ([o.Status isEqualToNumber:@(3)]) {
        fuhaoX = cooutLabel.center.x+25;
    }else{
        fuhaoX = cooutLabel.center.x;
    }
    
    UILabel *fuhaoL=[[UILabel alloc]initWithFrame:CGRectMake(fuhaoX, 22, 20, 13)];
    fuhaoL.text =@"￥";
    [view addSubview:fuhaoL];

    UILabel *orderPLabel1 = [[UILabel alloc]init];
    UILabel *orderPTLabel = [[UILabel alloc]init];
    UILabel *orderPLabel = [[UILabel alloc]init];

   
    if ([o.Status isEqualToNumber:@(3)]) {
        viewY= 100;
        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(0, viewY-46, kScreenWidth, 45)];
        btn.tag =section;
        btn.titleLabel.font =[UIFont systemFontOfSize:13];
        if (o.IsGoodsPick) {
            [btn setTitle:@"充值并退款" forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];

        }else{
            [btn setTitle:@"确认退款" forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(showCountClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        [btn setTitleColor:kCustomColor(41, 121, 222) forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:17];
        [view addSubview:btn];
        
        UIView * v1=[[UIView alloc]initWithFrame:CGRectMake(0, btn.top, kScreenWidth, 0.5)];
        v1.backgroundColor =[UIColor lightGrayColor];
        [view addSubview:v1];
        UIView * v2=[[UIView alloc]initWithFrame:CGRectMake(0, btn.bottom, kScreenWidth, 0.5)];
        v2.backgroundColor =[UIColor lightGrayColor];
        [view addSubview:v2];
        cooutLabel.text = @"退还佣金:";
        orderPTLabel.text = @"退款:";
        orderPLabel.textColor =[UIColor blackColor];
        
    }else{

        cooutLabel.text = @"佣金:";
        orderPTLabel.text = @"实付:";
        orderPLabel.textColor =[UIColor redColor];
    }
    

    cooutLabel.font = [UIFont systemFontOfSize:13];
    [view addSubview:cooutLabel];
    
    orderPLabel.text = [o.InCome stringValue];
    CGSize size= [Public getContentSizeWith:orderPLabel.text andFontSize:18 andHigth:18];
    orderPLabel.frame =CGRectMake(fuhaoL.right, 18, size.width, size.height);
    [view addSubview:orderPLabel];
    
    orderPLabel1.text =[NSString stringWithFormat:@"%@%@",@"￥", [o.Amount stringValue]];
    CGSize s= [Public getContentSizeWith:orderPLabel1.text andFontSize:18 andHigth:18];
    orderPLabel1.frame =CGRectMake(kScreenWidth-s.width-10, 18, s.width, s.height);
    [view addSubview:orderPLabel1];

    orderPTLabel.frame=CGRectMake(orderPLabel1.left-40, 22, 40, 13);
    orderPTLabel.font = [UIFont systemFontOfSize:13];
    [view addSubview:orderPTLabel];
    
    
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   
    return 64;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    Order *o = self.dataArray[section];
    if ([o.Status isEqualToNumber:@(3)]) {
        return 100;
    }
    return 55;
}


-(void)showCountClick:(UIButton *)btn{
    
    [self hudShow:@"正在处理"];
    Order *o =self.dataArray[btn.tag];
    if (o.OrderNo) {
        NSMutableDictionary *dict=[NSMutableDictionary dictionary];
        [dict setObject:o.OrderNo forKey:@"OrderNo"];
        [HttpTool postWithURL:@"Order/RMAConfirm" params:dict success:^(id json) {
            BOOL isSuccessful = [[json objectForKey:@"isSuccessful"] boolValue];
            if (isSuccessful) {
                [self.dataArray removeObject:o];
                [self.tableView reloadData];
            }else{
                [self showHudFailed:[json objectForKey:@"message"]];
            }
            [self textHUDHiddle];
        } failure:^(NSError *error) {
            [self showHudFailed:@"处理失败"];
            [self textHUDHiddle];
        }];
    }else{
        [self showHudFailed:@"订单编号不存在"];
    }

}
-(void)onClick:(UIButton *)btn{
    
    Order *o =self.dataArray[btn.tag];
    Product * product =[o.Products firstObject];
    
    if (o) {
        AppDelegate *app =(AppDelegate *)[UIApplication sharedApplication].delegate;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccessHandle:) name:@"PaySuccessNotification" object:o];
        [app sendPay_demo:o.RmaNo andName:product.Name andPrice:[o.GoodsAmount stringValue] andExtend:@"payment/PayAndDoRmaResult"];
        
    }else{
        [self showHudFailed:@"订单编号不存在"];
    }
}

-(void)paySuccessHandle:(NSNotification *)notification
{
    [self showHudSuccess:@"支付成功"];

}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PaySuccessNotification" object:nil];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 101;
}



-(void)didSelect:(UITapGestureRecognizer *)tap
{
    if (tap.view.tag==1000)
    {
        [self activityDismiss];
        [self scrollToBuyerStreet];
    }
    else if(tap.view.tag==1001)
    {
        [self activityDismiss];
        [self scrollToSaid];
    }
    else if(tap.view.tag==1002)
    {
        [self activityDismiss];
        [self scrollToMyBuyer];
    }
    else
    {
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
    lab1.font = [UIFont systemFontOfSize:15];
    lab2.textColor = [UIColor grayColor];
    lab2.font = [UIFont systemFontOfSize:13];
    lab3.textColor = [UIColor grayColor];
    lab3.font = [UIFont systemFontOfSize:13];
    lab4.textColor = [UIColor grayColor];
    lab4.font = [UIFont systemFontOfSize:13];
    self.pageNum=1;
    type=1;
    isRefresh =YES;
    [self setData];
    
}

//待付款
-(void)scrollToSaid
{
    UILabel *lab1 = (UILabel *)[_tempView viewWithTag:1000];
    UILabel *lab2 = (UILabel *)[_tempView viewWithTag:1001];
    UILabel *lab3 = (UILabel *)[_tempView viewWithTag:1002];
    UILabel *lab4 = (UILabel *)[_tempView viewWithTag:1003];
   
    [UIView animateWithDuration:0.1 animations:^{
        self.lineLab.center = CGPointMake(lab2.center.x, 38);
    }];
    lab2.textColor = [UIColor orangeColor];
    lab2.font = [UIFont systemFontOfSize:15];
    lab1.textColor = [UIColor grayColor];
    lab1.font = [UIFont systemFontOfSize:13];
    lab3.textColor = [UIColor grayColor];
    lab3.font = [UIFont systemFontOfSize:13];
    lab4.textColor = [UIColor grayColor];
    lab4.font = [UIFont systemFontOfSize:13];
    isRefresh =YES;
    self.pageNum=1;
    type=2;
    [self setData];

    
}
//专柜自提
-(void)scrollToMyBuyer
{
    UILabel *lab1 = (UILabel *)[_tempView viewWithTag:1000];
    UILabel *lab2 = (UILabel *)[_tempView viewWithTag:1001];
    UILabel *lab3 = (UILabel *)[_tempView viewWithTag:1002];
    UILabel *lab4 = (UILabel *)[_tempView viewWithTag:1003];

    [UIView animateWithDuration:0.1 animations:^{
        self.lineLab.center = CGPointMake(lab3.center.x, 38);
    }];
    lab3.textColor = [UIColor orangeColor];
    lab3.font = [UIFont systemFontOfSize:15];
    lab4.textColor = [UIColor grayColor];
    lab4.font = [UIFont systemFontOfSize:13];
    lab2.textColor = [UIColor grayColor];
    lab2.font = [UIFont systemFontOfSize:13];
    lab1.textColor = [UIColor grayColor];
    lab1.font = [UIFont systemFontOfSize:13];
    isRefresh =YES;
    self.pageNum=1;
    type=3;
    [self setData];

    
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
    lab4.font = [UIFont systemFontOfSize:15];
    lab3.textColor = [UIColor grayColor];
    lab3.font = [UIFont systemFontOfSize:13];
    lab2.textColor = [UIColor grayColor];
    lab2.font = [UIFont systemFontOfSize:13];
    lab1.textColor = [UIColor grayColor];
    lab1.font = [UIFont systemFontOfSize:13];;
    isRefresh=YES;
    self.pageNum=1;
    type=4;
    [self setData];

    
}





@end
