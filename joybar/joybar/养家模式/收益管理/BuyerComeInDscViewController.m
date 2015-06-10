//
//  BuyerComeInDscViewController.m
//  joybar
//
//  Created by joybar on 15/6/6.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "BuyerComeInDscViewController.h"
#import "BuyerComeInDesTableViewCell.h"

@interface BuyerComeInDscViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) UIScrollView *homeScroll;
@property (nonatomic ,strong) UITableView * firstStroe;
@property (nonatomic ,strong) UITableView * sceondStroe;

@property (nonatomic ,strong) UILabel *lineLab;
@property (nonatomic ,strong) UIView *tempView;
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,assign) CGFloat startX;
@property (nonatomic ,assign) CGFloat endX;
@end

@implementation BuyerComeInDscViewController


- (void)viewDidLoad {
    [super viewDidLoad];
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
    self.tableView.tag = 1;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.homeScroll addSubview:self.tableView];
    self.tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView =[[UIView alloc]init];
    self.tableView.backgroundColor =kCustomColor(237,237,237);

}

#pragma mark tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleIdentify = @"cell";
    BuyerComeInDesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleIdentify];
    if (cell == nil) {
        
        cell =[[[NSBundle mainBundle] loadNibNamed:@"BuyerComeInDesTableViewCell" owner:self options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 105;
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
    
}

//冻结中
-(void)scrollToSaid
{
    UILabel *lab1 = (UILabel *)[_tempView viewWithTag:1000];
    UILabel *lab2 = (UILabel *)[_tempView viewWithTag:1001];
    UILabel *lab3 = (UILabel *)[_tempView viewWithTag:1002];
    if (_firstStroe==nil)
    {
        _firstStroe= [[UITableView alloc] init];
        _firstStroe.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight-64-40-49);
        
        [self.homeScroll addSubview:_firstStroe];
        _firstStroe.dataSource=self;
        _firstStroe.delegate =self;
        _sceondStroe.tag = 2;
        _firstStroe.tableFooterView =[[UIView alloc]init];
        
        
    }
    
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

//失效
-(void)scrollToMyBuyer
{
    UILabel *lab1 = (UILabel *)[_tempView viewWithTag:1000];
    UILabel *lab2 = (UILabel *)[_tempView viewWithTag:1001];
    UILabel *lab3 = (UILabel *)[_tempView viewWithTag:1002];
    if (_sceondStroe==nil)
    {
        _sceondStroe= [[UITableView alloc] init];
        
        _sceondStroe.frame = CGRectMake(kScreenWidth*2, 0, kScreenWidth, kScreenHeight-64-40-49);
        [self.homeScroll addSubview:_sceondStroe];
        _sceondStroe.dataSource=self;
        _sceondStroe.delegate =self;
        _sceondStroe.tag = 3;
        _sceondStroe.tableFooterView =[[UIView alloc]init];
        
        
    }
    
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
