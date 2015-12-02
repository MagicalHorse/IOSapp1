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
#import "AppDelegate.h"
#import "HistorySearchViewController.h"
#import <MapKit/MapKit.h>
#warning 测试------------------------------------------
#import "CusRProDetailViewController.h"
#import "CusHomeStoreViewController.h"
#import "CusMainStoreViewController.h"
@interface CusHomeViewController ()<UIScrollViewDelegate,YRADScrollViewDataSource,YRADScrollViewDelegate,CLLocationManagerDelegate,MKReverseGeocoderDelegate>

@property (nonatomic ,strong) HomeTableView *homeTableView;
@property (nonatomic ,strong) NSArray *imageArr;
@property (nonatomic ,assign) NSInteger pageNum;

@property (nonatomic ,strong) NSMutableArray *bannerArr;
@property (nonatomic ,strong) NSMutableArray *homeArr;

@property (strong, nonatomic) CLLocationManager* locationManager;
@property (nonatomic ,strong) NSString *longitude;
@property (nonatomic ,strong) NSString *latitude;

@property (nonatomic ,strong) NSDictionary *localtionDic;


@end

@implementation  CusHomeViewController
{
    YRADScrollView *headerScroll;
    UIView *headerView;
    UIButton *locationBtn;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.bannerArr = [NSMutableArray array];
    self.homeArr = [NSMutableArray array];
    _pageNum = 1;
    [self addNavBarViewAndTitle:@"打烊购"];
    self.retBtn.hidden = YES;
    [self initWithTableView];
    
    headerScroll = [[YRADScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth/2)];
    headerScroll.dataSource = self;
    headerScroll.delegate = self;
    //    adScrollView.cycleEnabled = NO;//如果设置为NO，则关闭循环滚动功能。
    [headerView addSubview:headerScroll];
    
    locationBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    locationBtn.frame = CGRectMake(0, 15, 60, 50);
    [locationBtn setTitle:@"全国" forState:(UIControlStateNormal)];
    [locationBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    locationBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [locationBtn addTarget:self action:@selector(didSelectCity) forControlEvents:(UIControlEventTouchUpInside)];
    [self.navView addSubview:locationBtn];
    
    UIImageView *locationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(locationBtn.right-5, 38, 12, 7)];
    locationImageView.image = [UIImage imageNamed:@"下拉"];
    [self.navView addSubview:locationImageView];

    // 搜索按钮
    UIButton *searchBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    searchBtn.frame = CGRectMake(kScreenWidth-54, 10, 64, 64);
    searchBtn.backgroundColor = [UIColor clearColor];
    [searchBtn setImage:[UIImage imageNamed:@"search"] forState:(UIControlStateNormal)];
    [searchBtn addTarget:self action:@selector(didClickSearchBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.navView addSubview:searchBtn];
    [self startLocation];
}

//开始定位
-(void)startLocation
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 10.0f;
    [self.locationManager startUpdatingLocation];
//    [self hudShow:@"正在定位"];
    //在ios 8.0下要授权
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [_locationManager requestWhenInUseAuthorization];  //调用了这句,就会弹出允许框了.
    }
}


-(void)initWithTableView
{
    //tableView
    self.homeTableView = [[HomeTableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64-49) style:(UITableViewStylePlain)];
    self.homeTableView.backgroundColor = kCustomColor(233, 238, 241);
    [self.view addSubview:self.homeTableView];
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth/2)];
    headerView.backgroundColor = [UIColor clearColor];
    self.homeTableView.tableHeaderView = headerView;
    self.homeTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    __weak CusHomeViewController *VC = self;
    self.homeTableView.headerRereshingBlock = ^()
    {
        VC.pageNum = 1;
        [VC.homeTableView.dataArr removeAllObjects];
        [VC getHomeData];
    };
    
    self.homeTableView.footerRereshingBlock = ^()
    {
        VC.pageNum++;
        [VC getHomeData];
    };
}

-(void)getBannerData
{
    [HttpTool postWithURL:@"v3/BannerSubject" params:nil success:^(id json) {
        
        if ([[json objectForKey:@"isSuccessful"] boolValue])
        {
            NSDictionary *dic = [json objectForKey:@"data"];
            NSArray *arr = [dic objectForKey:@"Banners"];
            [self.bannerArr addObjectsFromArray:arr];
            [headerScroll reloadData];
        }
        else
        {
            [self showHudFailed:[json objectForKey:@"message"]];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)getHomeData
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[self.localtionDic objectForKey:@"Id"] forKey:@"CityId"];
    [dic setObject:[NSString stringWithFormat:@"%ld",(long)self.pageNum] forKey:@"Page"];
    [dic setObject:@"6" forKey:@"PageSize"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"] forKey:@"longitude"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"] forKey:@"latitude"];
    [HttpTool postWithURL:@"v3/index" params:dic success:^(id json) {
        if ([[json objectForKey:@"isSuccessful"] boolValue])
        {
            NSArray *arr = [[json objectForKey:@"data"] objectForKey:@"items"];
            if (arr.count<6)
            {
                [self.homeTableView hiddenFooter:YES];
            }
            else
            {
                [self.homeTableView hiddenFooter:NO];
            }
            [self.homeTableView.dataArr addObjectsFromArray:arr];
            [self.homeTableView reloadData];
        }
        else
        {
            [self showHudFailed:[json objectForKey:@"message"]];
        }
        [self.homeTableView endRefresh];

    } failure:^(NSError *error) {
        [self.homeTableView endRefresh];

    }];
}

-(NSUInteger)numberOfViewsForYRADScrollView:(YRADScrollView *)adScrollView
{
    return self.bannerArr.count;
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

-(UIView *)viewForYRADScrollView:(YRADScrollView *)adScrollView atPage:(NSInteger)pageIndex
{
    
    UIImageView * imgView = [adScrollView dequeueReusableView];//先获取重用池里面的
    if (!imgView)
    {
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth/2)];
    }
    imgView.backgroundColor = [UIColor lightGrayColor];
    
    NSDictionary *dic = [self.bannerArr objectAtIndex:pageIndex];
    if (dic)
    {
        NSString *imageUrl = [dic objectForKey:@"Pic"];
        [imgView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    }
    return imgView;
}

//点击搜索
-(void)didClickSearchBtn
{
    
    
//    CusZProDetailViewController *VC = [[CusZProDetailViewController alloc] init];
//    CusRProDetailViewController *VC = [[CusRProDetailViewController alloc] init];
//        VC.productId = @"12985";
    
//    CusHomeStoreViewController *VC = [[CusHomeStoreViewController alloc] init];
//    VC.userId =@"840";
    NSString *cityId = [self.localtionDic objectForKey:@"Id"];
    HistorySearchViewController *search =[[HistorySearchViewController alloc]init];
    search.cityId =cityId; //城市id
    search.cusSearchType =1; //全局搜索1
    //经纬度
    search.latitude=  [[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"];
    search.longitude= [[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"];
    [self.navigationController pushViewController:search animated:YES];
    
    
   
    
}

//定位城市
-(void)didSelectCity
{
    LocationViewController *VC = [[LocationViewController alloc] init];
    VC.locationCityName = [self.localtionDic objectForKey:@"Name"];
    [self.navigationController pushViewController: VC animated:YES];
    VC.handleCityName = ^(NSString *cityName)
    {
        [locationBtn setTitle:cityName forState:(UIControlStateNormal)];
    };
}

//定位代理经纬度回调
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{

    [_locationManager stopUpdatingLocation];
    NSLog(@"location ok");
    
    NSLog(@"%@",[NSString stringWithFormat:@"经度:%3.5f\n纬度:%3.5f",newLocation.coordinate.latitude,newLocation.coordinate.longitude]);
    

    NSString *latitude =[NSString stringWithFormat:@"%f",newLocation.coordinate.latitude];
    NSString *longitude =[NSString stringWithFormat:@"%f",newLocation.coordinate.longitude];
    
    [[NSUserDefaults standardUserDefaults] setObject:longitude forKey:@"longitude"];
    [[NSUserDefaults standardUserDefaults] setObject:latitude forKey:@"latitude"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    
    MKReverseGeocoder *geocoder = [[MKReverseGeocoder alloc]initWithCoordinate:newLocation.coordinate];
    geocoder.delegate = self;
    [geocoder start];

}

-(void)reverseGeocoder:(MKReverseGeocoder *)geocoder
      didFindPlacemark:(MKPlacemark *)placemark
{
    [self textHUDHiddle];
    [locationBtn setTitle:placemark.locality forState:(UIControlStateNormal)];
    [self getBannerData];
    [self getCityInfo];

}

-(void)getCityInfo
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"] forKey:@"longitude"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"] forKey:@"latitude"];
    
    [HttpTool postWithURL:@"Common/GetCityByCoord" params:dic success:^(id json) {
        if ([[json objectForKey:@"isSuccessful"] boolValue])
        {
            self.localtionDic = [json objectForKey:@"data"];
            [[NSUserDefaults standardUserDefaults] setObject:[self.localtionDic objectForKey:@"Id"] forKey:@"cityId"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self getHomeData];
        }
        else
        {
            [self showHudFailed:[json objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"定位失败" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重新定位", nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        [self.locationManager startUpdatingLocation];
    }
}

@end
