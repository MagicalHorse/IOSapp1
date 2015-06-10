//
//  BuyerTicketViewController.m
//  joybar
//
//  Created by 卢兴 on 15/4/16.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "BuyerTicketViewController.h"
#import "BuyerTicketTableViewCell.h"
#import "BuyerHistoryViewController.h"
@interface BuyerTicketViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic ,strong) UIScrollView *homeScroll;
@property (nonatomic ,strong) UILabel *lineLab;
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,assign) CGFloat startX;
@property (nonatomic ,assign) CGFloat endX;
@property (nonatomic ,strong) NSArray *imageArr;

@property (nonatomic,strong)BuyerHistoryViewController*centerVC;
@property (nonatomic,strong)UIView * headerView;
@end

@implementation BuyerTicketViewController
{
    UIView *tempView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addNavBarViewAndTitle:@""];
    self.retBtn.hidden = YES;
    tempView = [[UIView alloc] initWithFrame:CGRectMake(50, 0, kScreenWidth-100, 64)];
    tempView.backgroundColor = [UIColor clearColor];
    tempView.center = self.navView.center;
    [self.navView addSubview:tempView];
    
    NSArray *nameArr = @[@"红榜",@"历史"];
    for (int i=0; i<2; i++)
    {
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(tempView.width/2*i, 18, tempView.width/2, 50)];
        lab.userInteractionEnabled = YES;
        lab.font = [UIFont fontWithName:@"youyuan" size:15];
        lab.backgroundColor = [UIColor clearColor];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = [UIColor grayColor];
        lab.text = [nameArr objectAtIndex:i];
        lab.tag=1000+i;
        [tempView addSubview:lab];
        if (i==0)
        {
            lab.textColor = [UIColor orangeColor];
            lab.font = [UIFont fontWithName:@"youyuan" size:17];
            
            self.lineLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 3)];
            self.lineLab.center = CGPointMake(lab.center.x, 63);
            self.lineLab.backgroundColor = [UIColor orangeColor];
            [tempView addSubview:self.lineLab];
        }
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelect:)];
        [lab addGestureRecognizer:tap];
    }
    
    self.homeScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64)];
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
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-49) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView =  [[UIView alloc]initWithFrame:CGRectZero];

    //    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.homeScroll addSubview:self.tableView];
}


#pragma mark tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleIdentify = @"cell";
    BuyerTicketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleIdentify];
    if (cell == nil) {
        cell =[[[NSBundle mainBundle] loadNibNamed:@"BuyerTicketTableViewCell" owner:self options:nil] lastObject];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 80;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    _headerView = [[UIView alloc] init];
    _headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel * labText = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 17)];
    labText.font = [UIFont systemFontOfSize:14];
    labText.text =@"欧美高端女包";
    labText.font = [UIFont fontWithName:@"youyuan" size:15];

    [_headerView addSubview:labText];
    
    UILabel * labText2 = [[UILabel alloc]init];
    labText2.text =@"19999";

    CGSize size = [self getContentSizeWith:labText2.text];
    
    labText2.frame = CGRectMake(labText.left, labText.top+35, size.width, 23);
    
    labText2.textColor = [UIColor redColor];
    labText2.font = [UIFont fontWithName:@"Helvetica-Bold" size:23];
    [_headerView addSubview:labText2];
    
    UILabel * labText3 = [[UILabel alloc]initWithFrame:CGRectMake(labText2.right+8, labText2.top+6, 50, 17)];
    labText3.text =@"排名";
    labText3.textColor = kCustomColor(127, 127, 127);
    labText3.font = [UIFont fontWithName:@"youyuan" size:11];

    [_headerView addSubview:labText3];
    
    UIView * v = [[UIView alloc]initWithFrame:CGRectMake(0, labText3.bottom+4, kScreenWidth, 12)];
    v.backgroundColor = kCustomColor(237, 237, 237);
    [_headerView addSubview:v];

    //分割线
    UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 72-0.5, kScreenWidth, 0.5)];
    lineView1.backgroundColor = [UIColor lightGrayColor];
    [_headerView addSubview:lineView1];

    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 84-0.5, kScreenWidth, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [_headerView addSubview:lineView];
    
    //右头像
    UIImageView * imgView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-70, 5, 60, 60)];
    imgView.backgroundColor = [UIColor redColor];
    [_headerView addSubview:imgView];
    //销售额
    UILabel * labText4 = [[UILabel alloc]initWithFrame:CGRectMake(imgView.left-50, 53, 100, 14)];
    labText4.text =@"销售额";
    labText4.textColor = kCustomColor(127, 127, 127);
    labText4.font = [UIFont fontWithName:@"youyuan" size:11];
    [_headerView addSubview:labText4];
    //￥销售额
    UILabel * labText5 = [[UILabel alloc]initWithFrame:CGRectMake(labText4.left-45, 47, 60, 23)];

    labText5.text =@"8973";
//    labText5.textColor = kCustomColor(127, 127, 127);
    labText5.font = [UIFont fontWithName:@"youyuan" size:22];
    [_headerView addSubview:labText5];


    return _headerView;
}

-(CGSize)getContentSizeWith:(NSString *)content
{
    CGSize size = [content sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:23] constrainedToSize:CGSizeMake(kScreenWidth, 23) lineBreakMode:NSLineBreakByWordWrapping];
    return size;
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
    
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.startX = scrollView.contentOffset.x;
}

//红榜
-(void)scrollToBuyerStreet
{
    UILabel *lab1 = (UILabel *)[tempView viewWithTag:1000];
    UILabel *lab2 = (UILabel *)[tempView viewWithTag:1001];
    [UIView animateWithDuration:0.25 animations:^{
        self.lineLab.center = CGPointMake(lab1.center.x, 63);
    }];
    lab1.textColor = [UIColor orangeColor];
    lab1.font = [UIFont fontWithName:@"youyuan" size:17];
    lab2.textColor = [UIColor grayColor];
    lab2.font = [UIFont fontWithName:@"youyuan" size:15];
}

//历史
-(void)scrollToSaid
{
    UILabel *lab1 = (UILabel *)[tempView viewWithTag:1000];
    UILabel *lab2 = (UILabel *)[tempView viewWithTag:1001];
    
      self.centerVC= [[BuyerHistoryViewController alloc] init];
        self.centerVC.view.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight-64);
        [self.homeScroll addSubview:self.centerVC.view];
    
    
    [UIView animateWithDuration:0.25 animations:^{
        self.lineLab.center = CGPointMake(lab2.center.x, 63);
    }];
    lab2.textColor = [UIColor orangeColor];
    lab2.font = [UIFont fontWithName:@"youyuan" size:17];
    lab1.textColor = [UIColor grayColor];
    lab1.font = [UIFont fontWithName:@"youyuan" size:15];
}
@end
