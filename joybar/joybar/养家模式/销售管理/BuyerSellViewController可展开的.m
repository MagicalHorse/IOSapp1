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
#import "Store.h"
#import "Order.h"
#import "Orders.h"


@interface BuyerSellViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>{
}
@property (nonatomic ,strong) UIScrollView *homeScroll;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic ,strong) UILabel *lineLab;
@property (nonatomic ,strong) UIView *tempView;
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,assign) CGFloat startX;
@property (nonatomic ,assign) CGFloat endX;
@property (nonatomic,strong) NSMutableArray *dataSource;
@end

@implementation BuyerSellViewController


-(NSMutableArray *)dataSource{
    if (_dataSource ==nil) {
        _dataSource = [[NSMutableArray alloc]init];
        NSDictionary *dict =@{
                              @"Orders" : @[
                                      @{
                                          @"OrderId" : @"23827087020",
                                          @"StoreCount" : @"3",
                                          
                                          
                                          @"Stores" : @[@{@"text" : @"今天天气真不错1",},
                                                        @{@"text" : @"明天去旅游了1"}],
                                          },
                                      
                                      @{
                                          @"OrderId" : @"23827087021",
                                          @"StoreCount" : @"1",
                                          @"Stores" : @[@{@"text" : @"今天天气真不错2",},
                                                        @{@"text" : @"明天去旅游了2"}],
                                          
                                          }
                                      
                                      ]
                              };
        Orders *orders = [Orders objectWithKeyValues :dict];
        for (Order * r in orders.Orders) {
            [_dataSource addObject:r];
        }
        return _dataSource;
    }
    return _dataSource;
}

-(instancetype)init{
    if (self = [super init]) {
        NSDictionary *dic = @{@"isAttached":@(NO)};
        self.dataArray = [[NSMutableArray alloc]init];
        for (int i=0; i<self.dataSource.count; i++) {
            [self.dataArray addObject:dic];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavBarViewAndTitle:@"销售管理"];
    _tempView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 40)];
    _tempView.backgroundColor = kCustomColor(251, 250, 250);
    [self.view addSubview:_tempView] ;
    NSArray *nameArr = @[@"全部订单",@"待发货",@"待收货",@"专柜自提",@"售后中心"];
    for (int i=0; i<5; i++)
    {
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(_tempView.width/5*i, 0, _tempView.width/5, 35)];
        
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
    self.homeScroll.contentSize = CGSizeMake(kScreenWidth*5, 0);
    self.homeScroll.alwaysBounceVertical = NO;
    self.homeScroll.pagingEnabled = YES;
    self.homeScroll.delegate = self;
    self.homeScroll.directionalLockEnabled = YES;
    self.homeScroll.showsHorizontalScrollIndicator = NO;
    self.homeScroll.bounces = NO;
    self.homeScroll.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.homeScroll];
    
    //tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-49-40) style:(UITableViewStyleGrouped)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tag = 1;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.homeScroll addSubview:self.tableView];
    
}

#pragma mark tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    

    BOOL isAttached=  [[self.dataArray[section] objectForKey:@"isAttached"] boolValue];
    if (isAttached){
        
        return  [self.dataArray[section] count];
    }
    return 1;

    
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        static NSString *CellIdentifier = @"cell";
        
        BuyerStoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell =[[[NSBundle mainBundle] loadNibNamed:@"BuyerStoreTableViewCell" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
        
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    Order *o =self.dataSource[section];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 54)];
    view.backgroundColor = [UIColor whiteColor];

    
    UILabel *orderLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, 60, 16)];
    orderLabel.text = @"订单号:";
    orderLabel.font = [UIFont fontWithName:@"youyuan" size:16];
    [view addSubview:orderLabel];
    
    UILabel *orderNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 15, 150, 15)];
    orderNumLabel.text = o.OrderId;
    orderNumLabel.font = [UIFont fontWithName:@"youyuan" size:15];
    [view addSubview:orderNumLabel];
    
    UILabel *orderSLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-60, 15, 60, 16)];
    orderSLabel.text = @"未发货";
    orderSLabel.textColor =[UIColor redColor];
    orderSLabel.font = [UIFont fontWithName:@"youyuan" size:16];
    [view addSubview:orderSLabel];
    
    UIView *viewLine = [[UIView alloc]initWithFrame:CGRectMake(15, orderSLabel.bottom+14.5, kScreenWidth-30, 1)];
    viewLine.backgroundColor = kCustomColor(240, 240, 240);
    [view addSubview:viewLine];

    
    return view;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    
    CGFloat viewY=0;
    Order *o =self.dataSource[section];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, viewY)];

    if ([o.StoreCount integerValue] >1) {
        viewY= 94;
        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(0, viewY-26-40, kScreenWidth, 40)];
        btn.tag =section;
        btn.titleLabel.font =[UIFont fontWithName:@"youyuan" size:13];
        [btn setTitle:@"显示其余数量" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(showCountClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
    }else{
        viewY =49;
    }
    
    view.backgroundColor = [UIColor whiteColor];
    UILabel *cooutLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 12, 60, 12)];
    cooutLabel.text = @"共3件商品:";
    cooutLabel.font = [UIFont fontWithName:@"youyuan" size:12];
    [view addSubview:cooutLabel];
    
    UILabel *orderPLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-85, 12, 80, 13)];
    orderPLabel.textAlignment = NSTextAlignmentRight;
    orderPLabel.text = @"￥1200.00";
    orderPLabel.textColor =[UIColor redColor];
    orderPLabel.font = [UIFont fontWithName:@"youyuan" size:13];
    [view addSubview:orderPLabel];
    
    UILabel *orderPTLabel = [[UILabel alloc]initWithFrame:CGRectMake(orderPLabel.left-20, 12, 30, 11)];
    orderPTLabel.textAlignment = NSTextAlignmentRight;
    orderPTLabel.text = @"实付:";
    orderPTLabel.font = [UIFont fontWithName:@"youyuan" size:11];
    [view addSubview:orderPTLabel];
    
    UIView *viewBg = [[UIView alloc]initWithFrame:CGRectMake(0, viewY-12, kScreenWidth, 14)];
    viewBg.backgroundColor = kCustomColor(237, 237, 237);
    [view addSubview:viewBg];
    

    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectio{
    return 54;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    Order *o =self.dataSource[section];

    if ([o.StoreCount integerValue] >1) {
        return 94;
    }
    return 49;
}



-(void)showCountClick:(UIButton *)btn{
    
    Order *o =self.dataSource[btn.tag];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:btn.tag];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([[self.dataArray[indexPath.section]objectForKey:@"isAttached"]boolValue]) {
        // 关闭附加cell
        
        NSDictionary *dic = @{@"isAttached":@(NO)};
        self.dataArray[(indexPath.section)] = dic;
     
        [self.tableView reloadData];
    }
    else{
        
        
        NSDictionary *dic = @{@"isAttached":@(YES)};
        self.dataArray[indexPath.section] = dic; // 打开附加cell
        
        
        NSMutableDictionary *tempDic =[NSMutableDictionary dictionaryWithDictionary:self.dataArray[indexPath.section]];
        self.dataArray[indexPath.section] =tempDic;
        
        for (int i =0; i<[o.StoreCount integerValue]; i++) {
            [self.tableView beginUpdates];
            [tempDic setObject:@"1" forKey:[NSString stringWithFormat:@"%d",i]];
            [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
            [self.tableView endUpdates];
        }
        
        
    }

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
    else if(scrollView.contentOffset.x==kScreenWidth*3)
    {
        
        [self scrollToMyBuyer1];
    }
    else
    {
        
        [self scrollToMyBuyer2];
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
        self.homeScroll.contentOffset = CGPointMake(kScreenWidth, 0);
        [self scrollToMyBuyer];
    }
    else if(tap.view.tag==1003)
    {
        self.homeScroll.contentOffset = CGPointMake(kScreenWidth, 0);
        [self scrollToMyBuyer1];
    }
    else
    {
        self.homeScroll.contentOffset = CGPointMake(kScreenWidth, 0);
        [self scrollToMyBuyer2];
    }
}



//买手街
-(void)scrollToBuyerStreet
{
    UILabel *lab1 = (UILabel *)[_tempView viewWithTag:1000];
    UILabel *lab2 = (UILabel *)[_tempView viewWithTag:1001];
    UILabel *lab3 = (UILabel *)[_tempView viewWithTag:1002];
    UILabel *lab4 = (UILabel *)[_tempView viewWithTag:1003];
    UILabel *lab5 = (UILabel *)[_tempView viewWithTag:1004];

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
    lab5.textColor = [UIColor grayColor];
    lab5.font = [UIFont fontWithName:@"youyuan" size:13];
    
}

//TA们说
-(void)scrollToSaid
{
    UILabel *lab1 = (UILabel *)[_tempView viewWithTag:1000];
    UILabel *lab2 = (UILabel *)[_tempView viewWithTag:1001];
    UILabel *lab3 = (UILabel *)[_tempView viewWithTag:1002];
    UILabel *lab4 = (UILabel *)[_tempView viewWithTag:1003];
    UILabel *lab5 = (UILabel *)[_tempView viewWithTag:1004];

//    if (centerVC==nil)
//    {
//        centerVC= [[CusCenterViewController alloc] init];
//        centerVC.view.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight-64);
//        [self.homeScroll addSubview:centerVC.view];
//    }
    
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
    lab5.textColor = [UIColor grayColor];
    lab5.font = [UIFont fontWithName:@"youyuan" size:13];
    
}

-(void)scrollToMyBuyer
{
    UILabel *lab1 = (UILabel *)[_tempView viewWithTag:1000];
    UILabel *lab2 = (UILabel *)[_tempView viewWithTag:1001];
    UILabel *lab3 = (UILabel *)[_tempView viewWithTag:1002];
    UILabel *lab4 = (UILabel *)[_tempView viewWithTag:1003];
    UILabel *lab5 = (UILabel *)[_tempView viewWithTag:1004];

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
    lab5.textColor = [UIColor grayColor];
    lab5.font = [UIFont fontWithName:@"youyuan" size:13];
    
}
-(void)scrollToMyBuyer1
{
    UILabel *lab1 = (UILabel *)[_tempView viewWithTag:1000];
    UILabel *lab2 = (UILabel *)[_tempView viewWithTag:1001];
    UILabel *lab3 = (UILabel *)[_tempView viewWithTag:1002];
    UILabel *lab4 = (UILabel *)[_tempView viewWithTag:1003];
    UILabel *lab5 = (UILabel *)[_tempView viewWithTag:1004];

    [UIView animateWithDuration:0.1 animations:^{
        self.lineLab.center = CGPointMake(lab4.center.x, 38);
    }];
    lab4.textColor = [UIColor orangeColor];
    lab4.font = [UIFont fontWithName:@"youyuan" size:15];
    lab5.textColor = [UIColor grayColor];
    lab5.font = [UIFont fontWithName:@"youyuan" size:13];
    lab3.textColor = [UIColor grayColor];
    lab3.font = [UIFont fontWithName:@"youyuan" size:13];
    lab2.textColor = [UIColor grayColor];
    lab2.font = [UIFont fontWithName:@"youyuan" size:13];
    lab1.textColor = [UIColor grayColor];
    lab1.font = [UIFont fontWithName:@"youyuan" size:13];
    
}


-(void)scrollToMyBuyer2
{
    UILabel *lab1 = (UILabel *)[_tempView viewWithTag:1000];
    UILabel *lab2 = (UILabel *)[_tempView viewWithTag:1001];
    UILabel *lab3 = (UILabel *)[_tempView viewWithTag:1002];
    UILabel *lab4 = (UILabel *)[_tempView viewWithTag:1003];
    UILabel *lab5 = (UILabel *)[_tempView viewWithTag:1004];

    [UIView animateWithDuration:0.1 animations:^{
        self.lineLab.center = CGPointMake(lab5.center.x, 38);
    }];
    lab5.textColor = [UIColor orangeColor];
    lab5.font = [UIFont fontWithName:@"youyuan" size:15];
    lab4.textColor = [UIColor grayColor];
    lab4.font = [UIFont fontWithName:@"youyuan" size:13];
    lab3.textColor = [UIColor grayColor];
    lab3.font = [UIFont fontWithName:@"youyuan" size:13];
    lab2.textColor = [UIColor grayColor];
    lab2.font = [UIFont fontWithName:@"youyuan" size:13];
    lab1.textColor = [UIColor grayColor];
    lab1.font = [UIFont fontWithName:@"youyuan" size:13];
    
}


@end
