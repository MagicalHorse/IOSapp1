//
//  BuyerComeInDscViewController.m
//  joybar
//
//  Created by joybar on 15/6/6.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "BuyerComeInDscViewController.h"
#import "BuyerComeInDesTableViewCell.h"

@interface BuyerComeInDscViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    int type;
    BOOL isRefresh;
}

@property (nonatomic ,strong) UILabel *lineLab;
@property (nonatomic ,strong) UIView *tempView;
@property (nonatomic ,strong) BaseTableView *tableView;
@property (nonatomic ,strong) NSMutableArray *dataArray;
@property (nonatomic,assign)NSInteger pageNum;

@end

@implementation BuyerComeInDscViewController

-(NSMutableArray *)dataArray{
    if (_dataArray ==nil) {
        _dataArray =[[NSMutableArray alloc]init];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    type=1;
    [self addNavBarViewAndTitle:@"收益明细"];
    _tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 40)];
    _tempView.backgroundColor = kCustomColor(251, 250, 250);
    [self.view addSubview:_tempView] ;
    NSArray *nameArr = @[@"可提现",@"冻结中",@"失效"];
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
    
    //tableView
    self.tableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, 104, kScreenWidth, kScreenHeight-104) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView =[[UIView alloc]init];
    self.tableView.backgroundColor =kCustomColor(237,237,237);
    isRefresh=YES;
    
    __weak BuyerComeInDscViewController *VC = self;
    self.tableView.headerRereshingBlock = ^()
    {
        if (VC.dataArray.count>0) {
            VC.dataArray =nil;
        }
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

-(void)setData
{
    if (isRefresh) {
        [self showInView:self.view WithPoint:CGPointMake(0, 64+40) andHeight:kScreenHeight-64-40];
    }
    NSMutableDictionary * dict=[[NSMutableDictionary alloc]init];
    [dict setObject:@"1" forKey:@"Page"];
    [dict setObject:@"6" forKey:@"Pagesize"];
    if (type ==1) {
        [dict setObject:@"3" forKey:@"IncomeStatus"];
    }else if(type ==2){
        [dict setObject:@"1" forKey:@"IncomeStatus"];
    }else if(type ==3){
        [dict setObject:@"2" forKey:@"IncomeStatus"];
    }
    [HttpTool postWithURL:@"Assistant/GetIncomeInfo" params:dict success:^(id json) {
        
        BOOL isSuccessful = [[json objectForKey:@"isSuccessful"] boolValue];
        if (isSuccessful) {
            NSArray *arr =[[json objectForKey:@"data"]objectForKey:@"items"];
            if(arr.count<10)
            {
                [self.tableView hiddenFooter:YES];
            }
            else
            {
                [self.tableView hiddenFooter:NO];
            }
            if (self.pageNum==1) {
                [self.dataArray removeAllObjects];
                [self.dataArray addObjectsFromArray:arr];
            }else{
                [self.dataArray addObjectsFromArray:arr];
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
    static NSString *simpleIdentify = @"cell";
    BuyerComeInDesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleIdentify];
    if (cell == nil) {
        
        cell =[[[NSBundle mainBundle] loadNibNamed:@"BuyerComeInDesTableViewCell" owner:self options:nil] lastObject];
    }
    if (self.dataArray.count>0) {
        cell.desPrice.text =[[self.dataArray[indexPath.row]objectForKey:@"income_amount"]stringValue];
        cell.dscNo.text =[self.dataArray[indexPath.row]objectForKey:@"order_no"];
        cell.desSoure.text =[self.dataArray[indexPath.row]objectForKey:@"status_show"];
        cell.dseOrderPrice.text =[[self.dataArray[indexPath.row]objectForKey:@"amount"]stringValue];
        cell.dscTime.text =[self.dataArray[indexPath.row]objectForKey:@"create_date"];
        cell.dscState.text =[self.dataArray[indexPath.row]objectForKey:@"orderstatus_s"];

    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 105;
}



-(void)didSelect:(UITapGestureRecognizer *)tap
{
    if (tap.view.tag==1000)
    {
        [self activityDismiss];

        type=1;
        isRefresh=YES;
        [self scrollToBuyerStreet];
    }
    else if(tap.view.tag==1001)
    {
        [self activityDismiss];
        isRefresh=YES;
        type=2;
        [self scrollToSaid];
    }
    else
    {
        [self activityDismiss];
        isRefresh=YES;
        type=3;
        [self scrollToMyBuyer];
    }
}


//可提现
-(void)scrollToBuyerStreet
{
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
    self.dataArray =nil;
    [self setData];

}

//冻结中
-(void)scrollToSaid
{
    UILabel *lab1 = (UILabel *)[_tempView viewWithTag:1000];
    UILabel *lab2 = (UILabel *)[_tempView viewWithTag:1001];
    UILabel *lab3 = (UILabel *)[_tempView viewWithTag:1002];
 
    
    [UIView animateWithDuration:0.25 animations:^{
        self.lineLab.center = CGPointMake(lab2.center.x, 38);
    }];
    lab2.textColor = [UIColor orangeColor];
    lab2.font = [UIFont fontWithName:@"youyuan" size:15];
    lab1.textColor = [UIColor grayColor];
    lab1.font = [UIFont fontWithName:@"youyuan" size:13];
    lab3.textColor = [UIColor grayColor];
    lab3.font = [UIFont fontWithName:@"youyuan" size:13];
    self.dataArray =nil;
    [self setData];

}

//失效
-(void)scrollToMyBuyer
{
    UILabel *lab1 = (UILabel *)[_tempView viewWithTag:1000];
    UILabel *lab2 = (UILabel *)[_tempView viewWithTag:1001];
    UILabel *lab3 = (UILabel *)[_tempView viewWithTag:1002];
   
    
    [UIView animateWithDuration:0.25 animations:^{
        self.lineLab.center = CGPointMake(lab3.center.x, 38);
    }];
    lab3.textColor = [UIColor orangeColor];
    lab3.font = [UIFont fontWithName:@"youyuan" size:15];
    lab1.textColor = [UIColor grayColor];
    lab1.font = [UIFont fontWithName:@"youyuan" size:13];
    lab2.textColor = [UIColor grayColor];
    lab2.font = [UIFont fontWithName:@"youyuan" size:13];
    self.dataArray =nil;
    [self setData];

}

@end
