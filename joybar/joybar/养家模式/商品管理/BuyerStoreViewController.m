//
//  BuyerStoreViewController.m
//  joybar
//
//  Created by liyu on 15/5/8.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "BuyerStoreViewController.h"
#import "BuyerSellTableViewCell.h"
#import "Parameter.h"
#import "BuerySotres.h"
#import "Store.h"
#import "MJExtension.h"


@interface BuyerStoreViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    int type;
}
@property (nonatomic ,strong) UIScrollView *homeScroll;
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic ,strong) UILabel *lineLab;
@property (nonatomic ,strong) UIScrollView *tempView;
@property (nonatomic ,assign) CGFloat startX;
@property (nonatomic ,assign) CGFloat endX;
@end

@implementation BuyerStoreViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    type=1;
    [self addNavBarViewAndTitle:@"商品管理"];
    _tempView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 40)];
    _tempView.backgroundColor = kCustomColor(251, 250, 250);
    [self.view addSubview:_tempView] ;
    NSArray *nameArr = @[@"在线商品",@"即将下线",@"下线商品"];
    for (int i=0; i<3; i++)
    {
       UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(_tempView.width/3*i, 0, _tempView.width/3, 32)];
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
            
            self.lineLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _tempView.width/3-30, 3)];
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
    self.homeScroll.contentSize = CGSizeMake(kScreenWidth*3, 0);
    self.homeScroll.alwaysBounceVertical = NO;
    self.homeScroll.pagingEnabled = YES;
    self.homeScroll.delegate = self;
    self.homeScroll.directionalLockEnabled = YES;
    self.homeScroll.showsHorizontalScrollIndicator = NO;
    self.homeScroll.bounces = NO;
    self.homeScroll.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.homeScroll];
    
    //tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-40) style:(UITableViewStylePlain)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.homeScroll addSubview:self.tableView];
    [self setData:[[Parameter alloc]initWith:@"1" andPageSize:@"10"]];
    self.tableView.backgroundColor = kCustomColor(241, 241, 241);
}
-(NSMutableArray *)dataArray1{
    
    if (_dataArray ==nil) {
        _dataArray =[[NSMutableArray alloc]init];
    }
    return _dataArray;
}

-(void)setData:(Parameter *)param
{
    NSMutableDictionary * dict=[[NSMutableDictionary alloc]init];
    [dict setObject:param.page forKey:@"Page"];
    [dict setObject:param.pageSzie forKey:@"Pagesize"];
    if (type ==1) {
        [dict setObject:@"1" forKey:@"Status"];
    }else if(type ==2){
        [dict setObject:@"2" forKey:@"Status"];
        
    }else if(type ==0){
        [dict setObject:@"0" forKey:@"Status"];
    }
    [HttpTool postWithURL:@"Product/GetBuyerProductList" params:dict success:^(id json) {
        
        BOOL isSuccessful = [[json objectForKey:@"isSuccessful"] boolValue];
        if (isSuccessful) {
            NSMutableArray *array =[json objectForKey:@"data"];
            BuerySotres *stores = [BuerySotres objectWithKeyValues :array];
            _dataArray =nil;
            if (type ==1) {
                _dataArray = stores.items;
            }else if(type ==2){
                _dataArray = stores.items;
            }else if(type ==0){
                _dataArray = stores.items;
            }
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",[error description]);
    }];
}

#pragma mark tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Store * store =[self.dataArray objectAtIndex:indexPath.row];
    static NSString *CellIdentifier = @"cell";
    BuyerSellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell =[[[NSBundle mainBundle] loadNibNamed:@"BuyerSellTableViewCell" owner:self options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString * temp =[NSString stringWithFormat:@"%@_120x0.jpg",store.Pic];

    [cell.StoreImgView sd_setImageWithURL:[NSURL URLWithString:temp] placeholderImage:nil];
    cell.StoreName.text =store.BrandName;
    cell.StoreDetails.text =store.ProductName;
    cell.StoreNo.text =[store.StoreItemNo stringValue];
    cell.StorePirce.text =[store.Price stringValue];
    cell.StoreTime.text =store.ExpireTime;
    cell.downBtn.tag =indexPath.row;
    
    cell.shareBtn.tag =indexPath.row;
    [cell.shareBtn addTarget:self action:@selector(shareClcke:) forControlEvents:UIControlEventTouchUpInside];
    cell.sbBtn.tag =indexPath.row;
    
    if (type ==0) {
        [cell.sbBtn setTitle:@"删除" forState:UIControlStateNormal];
        [cell.sbBtn addTarget:self action:@selector(sbDelClcke:) forControlEvents:UIControlEventTouchUpInside];
        [cell.downBtn setTitle:@"上架" forState:UIControlStateNormal];
        [cell.downBtn addTarget:self action:@selector(downOnClcke:) forControlEvents:UIControlEventTouchUpInside];

    }else{
        [cell.sbBtn addTarget:self action:@selector(sbClcke:) forControlEvents:UIControlEventTouchUpInside];
        [cell.downBtn addTarget:self action:@selector(downClcke:) forControlEvents:UIControlEventTouchUpInside];

    }
    
    cell.cyBtn.tag =[store.ProductId intValue];
    [cell.cyBtn addTarget:self action:@selector(cyClcke:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
-(void)downOnClcke:(UIButton *)btn{
    Store *st=[self.dataArray objectAtIndex:btn.tag];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict setObject:@(btn.tag) forKey:@"Id"];
    [dict setObject:@"1" forKey:@"Status"];
    [HttpTool postWithURL:@"Product/OnLine" params:dict success:^(id json) {
        BOOL isSuccessful = [[json objectForKey:@"isSuccessful"] boolValue];
        if (isSuccessful) {
            [self.dataArray addObject:st];
            [self.tableView reloadData];
        }
        NSLog(@"%@",[json objectForKey:@"message"]);
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];

}
-(void)sbDelClcke:(UIButton *)btn{
    
    Store *st=[self.dataArray objectAtIndex:btn.tag];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict setObject:st.ProductId forKey:@"id"];
    [HttpTool postWithURL:@"Product/Delete" params:dict success:^(id json) {
        BOOL isSuccessful = [[json objectForKey:@"isSuccessful"] boolValue];
        if (isSuccessful) {
            [self.dataArray removeObject:st];
            [self.tableView reloadData];
        }
        NSLog(@"%@",[json objectForKey:@"message"]);
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}
-(void)downClcke:(UIButton *)btn{

    Store *st=[self.dataArray objectAtIndex:btn.tag];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict setObject:st.ProductId forKey:@"Id"];
    [dict setObject:@"0" forKey:@"Status"];
    [HttpTool postWithURL:@"Product/OnLine" params:dict success:^(id json) {
        BOOL isSuccessful = [[json objectForKey:@"isSuccessful"] boolValue];
        if (isSuccessful) {
            [self.dataArray removeObject:st];
            [self.tableView reloadData];
        }
        NSLog(@"%@",[json objectForKey:@"message"]);
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}
-(void)shareClcke:(UIButton *)btn{
    
}
-(void)sbClcke:(UIButton *)btn{
    
}
-(void)cyClcke:(UIButton *)btn{
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180;
}


#pragma mark ScrollViewDeletegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
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
    else
    {
        [self scrollToMyBuyer];
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
    else
    {
        self.homeScroll.contentOffset = CGPointMake(kScreenWidth*2, 0);
        [self scrollToMyBuyer];
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.startX = scrollView.contentOffset.x;
}
//在线商品
-(void)scrollToBuyerStreet
{
    type =1;
    UILabel *lab1 = (UILabel *)[_tempView viewWithTag:1000];
    UILabel *lab2 = (UILabel *)[_tempView viewWithTag:1001];
    UILabel *lab3 = (UILabel *)[_tempView viewWithTag:1002];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.lineLab.center = CGPointMake(lab1.center.x, 38);
    }];
    lab1.textColor = [UIColor orangeColor];
    lab1.font = [UIFont fontWithName:@"youyuan" size:15];
    lab2.textColor = [UIColor grayColor];
    lab2.font = [UIFont fontWithName:@"youyuan" size:13];
    lab3.textColor = [UIColor grayColor];
    lab3.font = [UIFont fontWithName:@"youyuan" size:13];
    _tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-40);

    [self setData:[[Parameter alloc]initWith:@"1" andPageSize:@"10"]];

}

//即将下线
-(void)scrollToSaid
{
    type =2;
    UILabel *lab1 = (UILabel *)[_tempView viewWithTag:1000];
    UILabel *lab2 = (UILabel *)[_tempView viewWithTag:1001];
    UILabel *lab3 = (UILabel *)[_tempView viewWithTag:1002];
    
    _tableView.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight-64-40);
    [self setData:[[Parameter alloc]initWith:@"1" andPageSize:@"10"]];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.lineLab.center = CGPointMake(lab2.center.x, 38);
    }];
    lab2.textColor = [UIColor orangeColor];
    lab2.font = [UIFont fontWithName:@"youyuan" size:15];
    lab1.textColor = [UIColor grayColor];
    lab1.font = [UIFont fontWithName:@"youyuan" size:13];
    lab3.textColor = [UIColor grayColor];
    lab3.font = [UIFont fontWithName:@"youyuan" size:13];

}


-(void)scrollToMyBuyer
{
    type =0;

    UILabel *lab1 = (UILabel *)[_tempView viewWithTag:1000];
    UILabel *lab2 = (UILabel *)[_tempView viewWithTag:1001];
    UILabel *lab3 = (UILabel *)[_tempView viewWithTag:1002];
  
    _tableView.frame = CGRectMake(kScreenWidth*2, 0, kScreenWidth, kScreenHeight-64-40);
    [self setData:[[Parameter alloc]initWith:@"1" andPageSize:@"10"]];

    [UIView animateWithDuration:0.25 animations:^{
        self.lineLab.center = CGPointMake(lab3.center.x, 38);
    }];
    lab3.textColor = [UIColor orangeColor];
    lab3.font = [UIFont fontWithName:@"youyuan" size:15];
    lab1.textColor = [UIColor grayColor];
    lab1.font = [UIFont fontWithName:@"youyuan" size:13];
    lab2.textColor = [UIColor grayColor];
    lab2.font = [UIFont fontWithName:@"youyuan" size:13];
}

@end
