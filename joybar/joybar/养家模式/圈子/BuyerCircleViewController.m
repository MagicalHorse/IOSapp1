//
//  BuyerCircleViewController.m
//  joybar
//
//  Created by 卢兴 on 15/4/16.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "BuyerCircleViewController.h"
#import "CusMessageTableViewCell.h"
//#import "CusDynamicViewController.h"
#import "BuyerCircleTableViewCell.h"
#import "BuyerFansTableViewCell.h"
#import "CusChatViewController.h"
#import "CusCircleDetailViewController.h"
#import "BuyerSellViewController.h"

@interface BuyerCircleViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) UIScrollView *homeScroll;
@property (nonatomic ,strong) UITableView * firstStroe;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableArray *dataArray1;

@property (nonatomic ,strong) UILabel *lineLab;
@property (nonatomic ,strong) UIScrollView *tempView;
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,assign) CGFloat startX;
@property (nonatomic ,assign) CGFloat endX;
@end

@implementation BuyerCircleViewController

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
-(NSMutableArray *)dataArray1{
    if (_dataArray1 ==nil) {
        _dataArray1 =[[NSMutableArray alloc]init];
    }
    return _dataArray1;
}


-(void)setfirstStroeData
{
    NSMutableDictionary * dict=[[NSMutableDictionary alloc]init];
    [dict setObject:@"1" forKey:@"Page"];
    [dict setObject:@"6" forKey:@"Pagesize"];
    [dict setValue:@"1" forKey:@"status"];

    [HttpTool postWithURL:@"User/GetUserFavoite" params:dict success:^(id json) {
        
        BOOL isSuccessful = [[json objectForKey:@"isSuccessful"] boolValue];
        if (isSuccessful) {
            NSMutableArray *array =[[json objectForKey:@"data"]objectForKey:@"items"];
            self.dataArray1 =array;
            [self.firstStroe reloadData];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",[error description]);
    }];
}
-(void)setData
{
    NSMutableDictionary * dict=[[NSMutableDictionary alloc]init];
    [dict setObject:@"1" forKey:@"Page"];
    [dict setObject:@"10" forKey:@"Pagesize"];
    [HttpTool postWithURL:@"Community/GetBuyerGroups" params:dict success:^(id json) {
        
        BOOL isSuccessful = [[json objectForKey:@"isSuccessful"] boolValue];
        if (isSuccessful) {
            NSMutableArray *array =[[json objectForKey:@"data"]objectForKey:@"items"];
            self.dataArray =array;
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",[error description]);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavBarViewAndTitle:@"好友管理"];
    [self setData];
    _tempView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 40)];
    _tempView.backgroundColor = kCustomColor(251, 250, 250);
    [self.view addSubview:_tempView] ;
    NSArray *nameArr = @[@"我的圈子",@"我的粉丝"];
    for (int i=0; i<2; i++)
    {
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(_tempView.width/2*i, 0, _tempView.width/2, 32)];
        
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
    self.homeScroll.contentSize = CGSizeMake(kScreenWidth*2, 0);
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
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.tag = 1;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = kCustomColor(241, 241, 241);
    self.tableView.tableFooterView =[[UIView alloc]init];
    [self.homeScroll addSubview:self.tableView];
    
   
    
}

#pragma mark tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView.tag==1){
        return self.dataArray.count;
    }else{
        return self.dataArray1.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag ==1) {
        static NSString *simpleIdentify = @"cell";
        BuyerCircleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleIdentify];
        if (cell == nil) {
            cell =[[[NSBundle mainBundle] loadNibNamed:@"BuyerCircleTableViewCell" owner:self options:nil] lastObject];
        }
        if (self.dataArray.count>0) {
            NSString * temp =[NSString stringWithFormat:@"%@_120x0.jpg",[self.dataArray[indexPath.row] objectForKey:@"Logo"]];
            
            [cell.circleImg sd_setImageWithURL:[NSURL URLWithString:temp] placeholderImage:nil];
            cell.CircleTitel.text =[self.dataArray[indexPath.row] objectForKey:@"Name"];
            cell.circleCout.text =[[self.dataArray[indexPath.row] objectForKey:@"UserCount"] stringValue];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;

    }else{
        static NSString *simpleIdentify = @"cell";
        BuyerFansTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleIdentify];
        if (cell == nil) {
            cell =[[[NSBundle mainBundle] loadNibNamed:@"BuyerFansTableViewCell" owner:self options:nil] lastObject];
        }
        if (self.dataArray1.count>0) {
            [cell.fansImg sd_setImageWithURL:[NSURL URLWithString:[self.dataArray1[indexPath.row] objectForKey:@"UserLogo"]] placeholderImage:nil];
            [cell.fansIcon sd_setImageWithURL:[NSURL URLWithString:[self.dataArray1[indexPath.row] objectForKey:@"UserLogo"]] placeholderImage:nil];
            cell.fansTitle.text =[self.dataArray1[indexPath.row] objectForKey:@"UserName"];
            cell.guanzhuLable.text =[[self.dataArray1[indexPath.row] objectForKey:@"FavoiteCount"] stringValue];
             cell.fansiLable.text =[[self.dataArray1[indexPath.row] objectForKey:@"FansCount"] stringValue];
            cell.hostoalBtn.tag =[[self.dataArray1[indexPath.row]objectForKey:@"UserId"]integerValue];
            [cell.hostoalBtn addTarget:self action:@selector(hosClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
-(void)hosClick:(UIButton *)btn{
    BuyerSellViewController *sell =[[BuyerSellViewController alloc]init];
    sell.customerId=@(btn.tag);
    [self.navigationController pushViewController:sell animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag ==2) {
        NSString *userid =[[self.dataArray1[indexPath.row]objectForKey:@"UserId"]stringValue];
        CusChatViewController * chat= [[CusChatViewController alloc]initWithUserId:userid AndTpye:1 andUserName:[self.dataArray1[indexPath.row]objectForKey:@"UserName"] andRoomId:@""];
        chat.isFrom =isFromPrivateChat;
        [self.navigationController pushViewController:chat animated:YES];
    }else{
        CusCircleDetailViewController * detail =[[CusCircleDetailViewController alloc]init];
        detail.circleId = [self.dataArray[indexPath.row]objectForKey:@"Id"];
        [self.navigationController pushViewController:detail animated:YES];

    }
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
    else
    {
        [self scrollToSaid];
    }

}

-(void)didSelect:(UITapGestureRecognizer *)tap
{
    if (tap.view.tag==1000)
    {
        self.homeScroll.contentOffset = CGPointMake(0, 0);
        [self scrollToBuyerStreet];
    }
    else
    {
        self.homeScroll.contentOffset = CGPointMake(kScreenWidth, 0);
        [self scrollToSaid];
    }

}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.startX = scrollView.contentOffset.x;
}
//我的圈子
-(void)scrollToBuyerStreet
{
    UILabel *lab1 = (UILabel *)[_tempView viewWithTag:1000];
    UILabel *lab2 = (UILabel *)[_tempView viewWithTag:1001];
//    UILabel *lab3 = (UILabel *)[_tempView viewWithTag:1002];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.lineLab.center = CGPointMake(lab1.center.x, 38);
    }];
    lab1.textColor = [UIColor orangeColor];
    lab1.font = [UIFont fontWithName:@"youyuan" size:15];
    lab2.textColor = [UIColor grayColor];
    lab2.font = [UIFont fontWithName:@"youyuan" size:13];
//    lab3.textColor = [UIColor grayColor];
//    lab3.font = [UIFont fontWithName:@"youyuan" size:13];
    
}

//我的粉丝
-(void)scrollToSaid
{
    UILabel *lab1 = (UILabel *)[_tempView viewWithTag:1000];
    UILabel *lab2 = (UILabel *)[_tempView viewWithTag:1001];
//    UILabel *lab3 = (UILabel *)[_tempView viewWithTag:1002];
    if (_firstStroe==nil)
    {
        _firstStroe= [[UITableView alloc] init];
        _firstStroe.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight-64-40);
        _firstStroe.backgroundColor = kCustomColor(241, 241, 241);
        _firstStroe.tag=2;
        _firstStroe.dataSource =self;
        _firstStroe.delegate =self;
        _firstStroe.tableFooterView =[[UIView alloc]init];

        [self.homeScroll addSubview:_firstStroe];
        [self setfirstStroeData];
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.lineLab.center = CGPointMake(lab2.center.x, 38);
    }];
    lab2.textColor = [UIColor orangeColor];
    lab2.font = [UIFont fontWithName:@"youyuan" size:15];
    lab1.textColor = [UIColor grayColor];
    lab1.font = [UIFont fontWithName:@"youyuan" size:13];
//    lab3.textColor = [UIColor grayColor];
//    lab3.font = [UIFont fontWithName:@"youyuan" size:13];
    
}

////我的粉丝
//-(void)scrollToMyBuyer
//{
//    UILabel *lab1 = (UILabel *)[_tempView viewWithTag:1000];
//    UILabel *lab2 = (UILabel *)[_tempView viewWithTag:1001];
//    UILabel *lab3 = (UILabel *)[_tempView viewWithTag:1002];
//    if (_sceondStroe==nil)
//    {
//        _sceondStroe= [[CusFansViewController alloc] initIsY];
//        _sceondStroe.view.frame = CGRectMake(kScreenWidth*2, 0, kScreenWidth, kScreenHeight-64);
//        [self.homeScroll addSubview:_sceondStroe.view];
//    }
//    
//    [UIView animateWithDuration:0.25 animations:^{
//        self.lineLab.center = CGPointMake(lab3.center.x, 38);
//    }];
//    lab3.textColor = [UIColor orangeColor];
//    lab3.font = [UIFont fontWithName:@"youyuan" size:15];
//    lab1.textColor = [UIColor grayColor];
//    lab1.font = [UIFont fontWithName:@"youyuan" size:13];
//    lab2.textColor = [UIColor grayColor];
//    lab2.font = [UIFont fontWithName:@"youyuan" size:13];
//    
//}


@end
