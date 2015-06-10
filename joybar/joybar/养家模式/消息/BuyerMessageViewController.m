//
//  BuyerMessageViewController.m
//  joybar
//
//  Created by 卢兴 on 15/4/16.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "BuyerMessageViewController.h"
#import "CusMessageTableViewCell.h"
//#import "CusDynamicViewController.h"
@interface BuyerMessageViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) UIScrollView *messageScroll;

@property (nonatomic ,strong) UITableView *tableView;

@property (nonatomic ,strong) UILabel *lineLab;

@property (nonatomic ,assign) CGFloat startX;
@property (nonatomic ,assign) CGFloat endX;

//@property (nonatomic ,strong) CusDynamicViewController *dynamicVC;


@end

@implementation BuyerMessageViewController
{
    UIView *tempView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addNavBarViewAndTitle:@""];
    
    tempView = [[UIView alloc] initWithFrame:CGRectMake(75, 0, kScreenWidth-150, 64)];
    tempView.backgroundColor = [UIColor clearColor];
    tempView.center = self.navView.center;
    [self.navView addSubview:tempView];
    
    NSArray *nameArr = @[@"消息",@"动态"];
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
    self.retBtn.hidden = YES;
    
    self.messageScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64)];
    self.messageScroll.contentSize = CGSizeMake(kScreenWidth*2, 0);
    self.messageScroll.alwaysBounceVertical = NO;
    self.messageScroll.pagingEnabled = YES;
    self.messageScroll.delegate = self;
    self.messageScroll.directionalLockEnabled = YES;
    self.messageScroll.showsHorizontalScrollIndicator = NO;
    self.messageScroll.bounces = NO;
    self.messageScroll.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.messageScroll];
    
    //tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-49) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.messageScroll addSubview:self.tableView];
}

#pragma mark tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden = @"cell";
    CusMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell==nil)
    {
        cell = [[CusMessageTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:iden];
    }
    
    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setData:nil];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
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
        self.messageScroll.contentOffset = CGPointMake(0, 0);
        
        [self scrollToMessage];
    }
    else
    {
        [self scrollToDynamic];
    }
}
-(void)didSelect:(UITapGestureRecognizer *)tap
{
    if (tap.view.tag==1000)
    {
        self.messageScroll.contentOffset = CGPointMake(0, 0);
        [self scrollToMessage];
    }
    else
    {
        self.messageScroll.contentOffset = CGPointMake(kScreenWidth, 0);
        [self scrollToDynamic];
    }
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.startX = scrollView.contentOffset.x;
}

//推荐圈子
-(void)scrollToMessage
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

//我的圈子
-(void)scrollToDynamic
{
    UILabel *lab1 = (UILabel *)[tempView viewWithTag:1000];
    UILabel *lab2 = (UILabel *)[tempView viewWithTag:1001];
    
//    if (self.dynamicVC==nil)
//    {
//        self.dynamicVC= [[CusDynamicViewController alloc] init];
//        self.dynamicVC.view.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight-64);
//        [self.messageScroll addSubview:self.dynamicVC.view];
//    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.lineLab.center = CGPointMake(lab2.center.x, 63);
    }];
    lab2.textColor = [UIColor orangeColor];
    lab2.font = [UIFont fontWithName:@"youyuan" size:17];
    lab1.textColor = [UIColor grayColor];
    lab1.font = [UIFont fontWithName:@"youyuan" size:15];
    
}


@end
