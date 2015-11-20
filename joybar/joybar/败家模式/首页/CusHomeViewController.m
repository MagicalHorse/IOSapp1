//
//  CusHomeViewController.m
//  joybar
//
//  Created by 卢兴 on 15/4/16.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "CusHomeViewController.h"
#import "CusHomeTableViewCell.h"
//#import "NSTimer+Addition.h"
#import "CusRProDetailViewController.h"
#import "BaseTableView.h"
#import "Banner.h"
#import "HomeProduct.h"
#import "BaseNavigationController.h"
#import "HomeTableView.h"
#import "YRADScrollView.h"
#import "BannerViewController.h"
#import "CusZProDetailViewController.h"
#import "CusProDetailViewController.h"
#import "LocationViewController.h"
#warning 测试------------------------------------------
#import "CusRProDetailViewController.h"
@interface CusHomeViewController ()<UIScrollViewDelegate,YRADScrollViewDataSource,YRADScrollViewDelegate>

@property (nonatomic ,strong) HomeTableView *homeTableView;
@property (nonatomic ,strong) NSArray *imageArr;
@property (nonatomic ,assign) NSInteger pageNum;

@end

@implementation  CusHomeViewController
{
    YRADScrollView *headerScroll;
    UIView *headerView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _pageNum = 1;
    [self addNavBarViewAndTitle:@"打烊购"];
    self.retBtn.hidden = YES;
    [self initWithTableView];
    
    headerScroll = [[YRADScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth/2)];
    headerScroll.dataSource = self;
    headerScroll.delegate = self;
    //    adScrollView.cycleEnabled = NO;//如果设置为NO，则关闭循环滚动功能。
    [headerView addSubview:headerScroll];
    
    
    UIButton *locationBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    locationBtn.frame = CGRectMake(0, 15, 60, 50);
    [locationBtn setTitle:@"全国" forState:(UIControlStateNormal)];
    [locationBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    locationBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [locationBtn addTarget:self action:@selector(didSelectCity) forControlEvents:(UIControlEventTouchUpInside)];
    [self.navView addSubview:locationBtn];
    
    UIImageView *locationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(locationBtn.right, 15, 15, 15)];
    locationImageView.image = [UIImage imageNamed:@""];
    [self.navView addSubview:locationImageView];
    

    // 搜索按钮
    UIButton *searchBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    searchBtn.frame = CGRectMake(kScreenWidth-54, 10, 64, 64);
    searchBtn.backgroundColor = [UIColor clearColor];
    [searchBtn setImage:[UIImage imageNamed:@"search"] forState:(UIControlStateNormal)];
    [searchBtn addTarget:self action:@selector(didClickSearchBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.navView addSubview:searchBtn];
}

-(void)initWithTableView
{
    //tableView
    self.homeTableView = [[HomeTableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64-49) style:(UITableViewStylePlain)];
    self.homeTableView.backgroundColor = kCustomColor(233, 238, 241);
    [self.view addSubview:self.homeTableView];
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth/2)];
    headerView.backgroundColor = [UIColor whiteColor];
    self.homeTableView.tableHeaderView = headerView;
    self.homeTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    __weak CusHomeViewController *VC = self;
    self.homeTableView.headerRereshingBlock = ^()
    {
        [VC.homeTableView.dataArr removeAllObjects];
    };
    
    self.homeTableView.footerRereshingBlock = ^()
    {
        VC.pageNum++;
    };
}

-(NSUInteger)numberOfViewsForYRADScrollView:(YRADScrollView *)adScrollView
{
    return 4;
}
#pragma mark adViewDelegate
-(void)adScrollView:(YRADScrollView *)adScrollView didClickedAtPage:(NSInteger)pageIndex
{
    Banner *banner = [self.data.Banners objectAtIndex:pageIndex];
    BannerViewController *VC = [[BannerViewController alloc] init];
    VC.link = banner.Link;
    [self.navigationController pushViewController:VC animated:YES];
}

//-(void)adScrollView:(YRADScrollView *)adScrollView didScrollToPage:(NSInteger)pageIndex
//{
//        UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth/2)];
//        imgView.backgroundColor = [UIColor lightGrayColor];
//    [adScrollView addSubview:imgView];
//
//        Banner *banner = [self.dat    a.Banners objectAtIndex:pageIndex];
//        if (banner)
//        {
//            NSString *temp =[NSString stringWithFormat:@"%@",banner.Pic];
//            [imgView sd_setImageWithURL:[NSURL URLWithString:temp] placeholderImage:nil];
//        }
//}

-(UIView *)viewForYRADScrollView:(YRADScrollView *)adScrollView atPage:(NSInteger)pageIndex{
    UIImageView * imgView = [adScrollView dequeueReusableView];//先获取重用池里面的
    if (!imgView)
    {
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth/2)];
    }
    imgView.backgroundColor = [UIColor lightGrayColor];
    
//    Banner *banner = [self.data.Banners objectAtIndex:pageIndex];
//    if (banner)
//    {
//        NSString *temp =[NSString stringWithFormat:@"%@",banner.Pic];
//        [imgView sd_setImageWithURL:[NSURL URLWithString:temp] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
//    }
    
    return imgView;
}

//点击搜索
-(void)didClickSearchBtn
{
//    CusZProDetailViewController *VC = [[CusZProDetailViewController alloc] init];
    CusRProDetailViewController *VC = [[CusRProDetailViewController alloc] init];
        VC.productId = @"12985";

//    CusMarketViewController *VC = [[CusMarketViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
    
}

//定位城市
-(void)didSelectCity
{
    LocationViewController *VC = [[LocationViewController alloc] init];
    [self.navigationController pushViewController: VC animated:YES];
}

@end
