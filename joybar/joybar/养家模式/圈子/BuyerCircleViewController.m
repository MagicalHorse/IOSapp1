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
#import "BuyerAddCircleViewController.h"

@interface BuyerCircleViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    BOOL isRefresh;
    int type;
}
@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic ,strong) UILabel *lineLab;
@property (nonatomic ,strong) UIScrollView *tempView;
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) UITableView *fansTableView;
@property (nonatomic ,strong)UIButton *searchBtn;

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

-(void)setData
{
    if (isRefresh) {
        [self showInView:self.view WithPoint:CGPointMake(0,104) andHeight:kScreenHeight-104];
    }
    NSMutableDictionary * dict=[[NSMutableDictionary alloc]init];
    NSString *url;
    if (type ==1) {
        url=@"Community/GetBuyerGroups";

    }else{
        url=@"User/GetUserFavoite";
        [dict setValue:@"1" forKey:@"status"];
        [dict setObject:[[Public getUserInfo] objectForKey:@"id"] forKey:@"userId"];
        [dict setObject:[[Public getUserInfo] objectForKey:@"id"]forKey:@"currentUserId"];

    }
    [dict setObject:@"1" forKey:@"Page"];
    
    

    [dict setObject:@"1000000" forKey:@"Pagesize"];
    [HttpTool postWithURL:url params:dict success:^(id json) {
        
        BOOL isSuccessful = [[json objectForKey:@"isSuccessful"] boolValue];
        if (isSuccessful) {
            NSMutableArray *array =[[json objectForKey:@"data"]objectForKey:@"items"];
            self.dataArray =array;
        }else{
            self.dataArray=nil;
            [self showHudFailed:@"加载失败"];
        }
        if(type==1){
            [self.tableView reloadData];

        }else{
            [self.fansTableView reloadData];

        }
        [self activityDismiss];
        isRefresh =NO;
    } failure:^(NSError *error) {
        [self activityDismiss];
        isRefresh =NO;    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    
    NSString *isUpdate =[Common getUserDefaultKeyName:@"privateOrGroup"];
    if ([isUpdate isEqualToString:@"1"]) {
        //tableView
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+40, kScreenWidth, kScreenHeight-64-40) style:(UITableViewStylePlain)];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tableView.tag = 1;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.backgroundColor = kCustomColor(241, 241, 241);
        self.tableView.tableFooterView =[[UIView alloc]init];
        [self.view addSubview:self.tableView];
        isRefresh=YES;
        type=1;
        [self setData];
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavBarViewAndTitle:@"社交管理"];
    
    _tempView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 40)];
    _tempView.backgroundColor = kCustomColor(251, 250, 250);
    [self.view addSubview:_tempView] ;
    NSArray *nameArr = @[@"我的圈子",@"我的粉丝"];
    for (int i=0; i<2; i++)
    {
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(_tempView.width/2*i, 0, _tempView.width/2, 32)];
        
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
    
    //rightbtn
    _searchBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _searchBtn.frame = CGRectMake(kScreenWidth-64, 10, 64, 64);
    [_searchBtn setImage:[UIImage imageNamed:@"tianjia-1"] forState:UIControlStateNormal];
    [_searchBtn addTarget:self action:@selector(addCircle) forControlEvents:(UIControlEventTouchUpInside)];
    [self.navView addSubview:_searchBtn];
    
    //tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+40, kScreenWidth, kScreenHeight-64-40) style:(UITableViewStylePlain)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.tag = 1;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = kCustomColor(241, 241, 241);
    self.tableView.tableFooterView =[[UIView alloc]init];
    [self.view addSubview:self.tableView];
    isRefresh=YES;
    type=1;
    [self setData];
  
}

#pragma mark tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (type ==1 &&tableView.tag==1) {
        static NSString *simpleIdentify = @"cell";
        BuyerCircleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleIdentify];
        if (cell == nil) {
            cell =[[[NSBundle mainBundle] loadNibNamed:@"BuyerCircleTableViewCell" owner:self options:nil] lastObject];
        }
        if (self.dataArray.count>0) {
            NSString * temp =[NSString stringWithFormat:@"%@",[self.dataArray[indexPath.row] objectForKey:@"Logo"]];
            
            [cell.circleImg sd_setImageWithURL:[NSURL URLWithString:temp] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            cell.circleImg.layer.cornerRadius = cell.circleImg.width/2;
            cell.circleImg.clipsToBounds =YES;
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
        if (self.dataArray.count>0) {
            [cell.fansImg sd_setImageWithURL:[NSURL URLWithString:[self.dataArray[indexPath.row] objectForKey:@"UserLogo"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
//            [cell.fansIcon sd_setImageWithURL:[NSURL URLWithString:[self.dataArray[indexPath.row] objectForKey:@"UserLogo"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            cell.fansTitle.text =[self.dataArray[indexPath.row] objectForKey:@"UserName"];
            cell.guanzhuLable.text =[[self.dataArray[indexPath.row] objectForKey:@"FavoiteCount"] stringValue];
             cell.fansiLable.text =[[self.dataArray[indexPath.row] objectForKey:@"FansCount"] stringValue];
            cell.hostoalBtn.tag =[[self.dataArray[indexPath.row]objectForKey:@"UserId"]integerValue];
            [cell.hostoalBtn addTarget:self action:@selector(hosClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
-(void)hosClick:(UIButton *)btn{
    BuyerSellViewController *sell =[[BuyerSellViewController alloc]init];
    sell.customerId=@(btn.tag);
    sell.customTitle =@"......";
    [self.navigationController pushViewController:sell animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *userid;
    NSString *name;
    CusChatViewController * chat;
    if (type ==2 &&tableView.tag==2) {
        userid =[[self.dataArray[indexPath.row]objectForKey:@"UserId"]stringValue];
        name =[self.dataArray[indexPath.row]objectForKey:@"UserName"];
        chat= [[CusChatViewController alloc]initWithUserId:userid AndTpye:1 andUserName:name];
        chat.isFrom =isFromPrivateChat;
        [Common saveUserDefault:@"2" keyName:@"privateOrGroup"];
    }else{
       
        userid =[[self.dataArray[indexPath.row]objectForKey:@"Id"]stringValue];
        name =[self.dataArray[indexPath.row]objectForKey:@"Name"];
        chat = [[CusChatViewController alloc]initWithUserId:userid AndTpye:1 andUserName:name];
        chat.circleId =userid;
        chat.isFrom =isFromGroupChat;
        [Common saveUserDefault:@"1" keyName:@"privateOrGroup"];

    }
    [self.navigationController pushViewController:chat animated:YES];

}

-(void)addCircle{
    BuyerAddCircleViewController *addCircle=[[BuyerAddCircleViewController alloc]init];
    [self.navigationController pushViewController:addCircle animated:YES];
}

-(void)didSelect:(UITapGestureRecognizer *)tap
{
    if (tap.view.tag==1000)
    {
        self.searchBtn.hidden=NO;
        [self activityDismiss];
        isRefresh =YES;
        type=1;
        [self scrollToBuyerStreet];
    }
    else
    {
        self.searchBtn.hidden=YES;
        [self activityDismiss];
        isRefresh =YES;
        type=2;
        [self scrollToSaid];
    }

}


//我的圈子
-(void)scrollToBuyerStreet
{
    self.dataArray=nil;
    [self.fansTableView removeFromSuperview];

    UILabel *lab1 = (UILabel *)[_tempView viewWithTag:1000];
    UILabel *lab2 = (UILabel *)[_tempView viewWithTag:1001];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+40, kScreenWidth, kScreenHeight-64-40) style:(UITableViewStylePlain)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.tag = 1;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = kCustomColor(241, 241, 241);
    self.tableView.tableFooterView =[[UIView alloc]init];
    [self.view addSubview:self.tableView];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.lineLab.center = CGPointMake(lab1.center.x, 38);
    }];
    lab1.textColor = [UIColor orangeColor];
    lab1.font = [UIFont systemFontOfSize:15];
    lab2.textColor = [UIColor grayColor];
    lab2.font = [UIFont systemFontOfSize:13];
    [self setData];
}

//我的粉丝
-(void)scrollToSaid
{
    self.dataArray=nil;
    [self.tableView removeFromSuperview];

    UILabel *lab1 = (UILabel *)[_tempView viewWithTag:1000];
    UILabel *lab2 = (UILabel *)[_tempView viewWithTag:1001];
 
    _fansTableView= [[UITableView alloc] init];
    _fansTableView.frame = CGRectMake(0, 64+40, kScreenWidth, kScreenHeight-64-40);
    _fansTableView.backgroundColor = kCustomColor(241, 241, 241);
    _fansTableView.tag=2;
    _fansTableView.dataSource =self;
    _fansTableView.delegate =self;
    _fansTableView.tableFooterView =[[UIView alloc]init];
    [self.view addSubview:_fansTableView];
    [UIView animateWithDuration:0.25 animations:^{
        self.lineLab.center = CGPointMake(lab2.center.x, 38);
    }];
    lab2.textColor = [UIColor orangeColor];
    lab2.font = [UIFont systemFontOfSize:15];
    lab1.textColor = [UIColor grayColor];
    lab1.font = [UIFont systemFontOfSize:13];
    [self setData];
    
}




@end
