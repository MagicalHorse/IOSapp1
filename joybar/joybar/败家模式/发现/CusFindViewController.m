//
//  CusFindViewController.m
//  joybar
//
//  Created by 卢兴 on 15/4/16.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "CusFindViewController.h"
#import "CusFindSearchViewController.h"
#import "CusTagViewController.h"
#import "FindData.h"
#import "FindTableView.h"
#import "NearTableView.h"
#import "NearData.h"
@interface CusFindViewController ()<UIScrollViewDelegate>

@property (nonatomic ,strong) UIScrollView *scroll;
@property (nonatomic ,strong) FindTableView *findTableView;
@property (nonatomic ,strong) NearTableView *nearTableView;
@property (nonatomic ,strong) UILabel *lineLab;
@property (nonatomic ,assign) CGFloat startX;
@property (nonatomic ,assign) CGFloat endX;
@property (nonatomic ,strong) NSMutableArray *findArr;
@property (nonatomic ,assign) NSInteger pageNum;
@property (nonatomic ,assign) NSInteger nearPageNum;
@property (nonatomic ,strong) FindData *findData;

@end

@implementation CusFindViewController
{
    UIView *tempView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pageNum = 1;
    self.nearPageNum = 1;
    self.scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64)];
    self.scroll.contentSize = CGSizeMake(kScreenWidth*2, 0);
    self.scroll.alwaysBounceVertical = NO;
    self.scroll.pagingEnabled = YES;
    self.scroll.delegate = self;
    self.scroll.directionalLockEnabled = YES;
    self.scroll.showsHorizontalScrollIndicator = NO;
    self.scroll.bounces = NO;
    self.scroll.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scroll];
    
    [self initWithFindTableView];
    [self initWithNearTableView];
    [self initWithNavView];
    [self getFindData:NO];
    

}
-(void)initWithFindTableView
{
    //tableView
    self.findTableView = [[FindTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-49) style:(UITableViewStylePlain)];
    [self.scroll addSubview:self.findTableView];
    
    __weak CusFindViewController *VC = self;
    self.findTableView.headerRereshingBlock = ^()
    {
        [VC.findTableView.dataArr removeAllObjects];
        VC.pageNum=1;
        [VC getFindData:YES];
    };
    self.findTableView.footerRereshingBlock = ^()
    {
        VC.pageNum++;
        [VC getFindData:YES];
    };
}

-(void)initWithNearTableView
{
    self.nearTableView = [[NearTableView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight-64-49) style:(UITableViewStylePlain)];
    [self.scroll addSubview:self.nearTableView];
    __weak CusFindViewController *VC = self;
    self.nearTableView.headerRereshingBlock = ^()
    {
        [VC.nearTableView.dataArr removeAllObjects];
        VC.nearPageNum=1;
        [VC getNearData:YES];
    };
    self.nearTableView.footerRereshingBlock = ^()
    {
        VC.nearPageNum++;
        [VC getNearData:YES];
    };
}

-(void)initWithNavView
{
    [self addNavBarViewAndTitle:@""];
    self.retBtn.hidden = YES;
    self.findArr = [NSMutableArray array];
    UIButton *searchBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    searchBtn.frame = CGRectMake(kScreenWidth-54, 10, 64, 64);
    searchBtn.backgroundColor = [UIColor clearColor];
    [searchBtn setImage:[UIImage imageNamed:@"search"] forState:(UIControlStateNormal)];
    [searchBtn addTarget:self action:@selector(didClickSearch) forControlEvents:(UIControlEventTouchUpInside)];
    [self.navView addSubview:searchBtn];
    
    tempView = [[UIView alloc] initWithFrame:CGRectMake(75, 0, kScreenWidth-150, 64)];
    tempView.backgroundColor = [UIColor clearColor];
    tempView.center = self.navView.center;
    [self.navView addSubview:tempView];
    
    NSArray *nameArr = @[@"品牌",@"同城"];
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

}

-(void)getFindData:(BOOL)isRefresh
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[NSString stringWithFormat:@"%ld",(long)self.pageNum] forKey:@"page"];
    [dic setValue:@"6" forKey:@"pagesize"];
    if (!isRefresh)
    {
        [self showInView:self.scroll WithPoint:CGPointMake(0, 0) andHeight:kScreenHeight-64-49];
    }
    [HttpTool postWithURL:@"Product/GetBrandProductList" params:dic success:^(id json) {
        
        if ([[json objectForKey:@"isSuccessful"] boolValue])
        {
            NSDictionary *dic = [json objectForKey:@"data"];
            
            self.findData = [FindData objectWithKeyValues:dic];
            
            if (self.findData.items.count<6)
            {
                [self.findTableView hiddenFooter:YES];
            }
            else
            {
                [self.findTableView hiddenFooter:NO];
            }
            
            [self.findTableView.dataArr addObjectsFromArray:self.findData.items];
            
            [self.findTableView reloadData];
            
        }
        [self.findTableView reloadData];
        [self.findTableView endRefresh];
        [self activityDismiss];
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)getNearData:(BOOL)isRefresh
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[NSString stringWithFormat:@"%ld",(long)self.nearPageNum] forKey:@"page"];
    [dic setValue:@"6" forKey:@"pagesize"];
    [dic setValue:@"0" forKey:@"CityId"];
    if (!isRefresh)
    {
        [self showInView:self.scroll WithPoint:CGPointMake(kScreenWidth, 0) andHeight:kScreenHeight-64-49];
    }
    [HttpTool postWithURL:@"Product/GetCityProductList" params:dic success:^(id json) {
        
        if ([[json objectForKey:@"isSuccessful"] boolValue])
        {
            NSDictionary *dic = [json objectForKey:@"data"];
            
            NearData *nearData = [NearData objectWithKeyValues:dic];
            
            if (nearData.items.count<6)
            {
                [self.nearTableView hiddenFooter:YES];
            }
            else
            {
                [self.nearTableView hiddenFooter:NO];
            }
            
            [self.nearTableView.dataArr addObjectsFromArray:nearData.items];
            
            [self.nearTableView reloadData];
        }
        [self.nearTableView reloadData];
        [self.nearTableView endRefresh];
        [self activityDismiss];
        
    } failure:^(NSError *error) {
        
    }];

}


#pragma mark ScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.endX = scrollView.contentOffset.x;
    
    if (self.startX-self.endX==0)
    {
        return;
    }
    if (scrollView.contentOffset.x==0)
    {
        self.scroll.contentOffset = CGPointMake(0, 0);
        
        [self scrollToFirst];
    }
    else
    {
        [self scrollToSecond];
    }
}
-(void)didSelect:(UITapGestureRecognizer *)tap
{
    if (tap.view.tag==1000)
    {
        self.scroll.contentOffset = CGPointMake(0, 0);
        [self scrollToFirst];
    }
    else
    {
        self.scroll.contentOffset = CGPointMake(kScreenWidth, 0);
        [self scrollToSecond];
    }
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.startX = scrollView.contentOffset.x;
}

//品牌
-(void)scrollToFirst
{
    [self activityDismiss];
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

//同城
-(void)scrollToSecond
{
    [self activityDismiss];
    if (self.nearTableView.dataArr.count==0)
    {
        [self getNearData:NO];
    }
    UILabel *lab1 = (UILabel *)[tempView viewWithTag:1000];
    UILabel *lab2 = (UILabel *)[tempView viewWithTag:1001];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.lineLab.center = CGPointMake(lab2.center.x, 63);
    }];
    lab2.textColor = [UIColor orangeColor];
    lab2.font = [UIFont fontWithName:@"youyuan" size:17];
    lab1.textColor = [UIColor grayColor];
    lab1.font = [UIFont fontWithName:@"youyuan" size:15];
}

//点击搜索
-(void)didClickSearch
{
    CusFindSearchViewController *VC = [[CusFindSearchViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

@end