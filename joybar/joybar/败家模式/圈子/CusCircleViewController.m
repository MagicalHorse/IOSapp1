//
//  CusCircleViewController.m
//  joybar
//
//  Created by 卢兴 on 15/4/16.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "CusCircleViewController.h"
#import "CusCircleDetailViewController.h"
#import "CircleTableView.h"
#import "MyCircleTableView.h"
@interface CusCircleViewController ()

@property (nonatomic ,strong) UIScrollView *circleScroll;

//navigationbar上的横线

@property (nonatomic ,strong) UILabel *lineLab;

@property (nonatomic ,strong) CircleTableView *circleTableView;
@property (nonatomic ,strong) MyCircleTableView *myCircleTableView;

@property (nonatomic ,assign) CGFloat startX;
@property (nonatomic ,assign) CGFloat endX;

@property (nonatomic ,assign) NSInteger pageNum;


@end

@implementation CusCircleViewController
{
    UIView *tempView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.circleScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64)];
    self.circleScroll.contentSize = CGSizeMake(kScreenWidth*2, 0);
    self.circleScroll.alwaysBounceVertical = NO;
    self.circleScroll.pagingEnabled = YES;
    self.circleScroll.delegate = self;
    self.circleScroll.directionalLockEnabled = YES;
    self.circleScroll.showsHorizontalScrollIndicator = NO;
    self.circleScroll.bounces = NO;
    self.circleScroll.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.circleScroll];
    
    [self initWithCircleTableView];
    
    [self initWithNavView];
    [self getCircleData:NO];
}

-(void)initWithCircleTableView
{
    //tableView
    self.circleTableView = [[CircleTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-49) style:(UITableViewStylePlain)];
    [self.circleScroll addSubview:self.circleTableView];
    
    __weak CusCircleViewController *VC = self;
    self.circleTableView.headerRereshingBlock = ^()
    {
        [VC.circleTableView.dataArr removeAllObjects];
        VC.pageNum = 1;
        [VC getCircleData:YES];
    };
    self.circleTableView.footerRereshingBlock = ^()
    {
        VC.pageNum++;
        [VC getCircleData:YES];
    };

}

-(void)initWithMyCircleTalbeView
{
    self.myCircleTableView = [[MyCircleTableView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight-64-49) style:(UITableViewStylePlain)];
    [self.circleScroll addSubview:self.myCircleTableView];
    
    __weak CusCircleViewController *VC = self;
    self.myCircleTableView.headerRereshingBlock = ^()
    {
        [VC.myCircleTableView.dataArr removeAllObjects];
        VC.pageNum = 1;
        [VC getMyCircleData:YES];
    };
}

-(void)initWithNavView
{
    [self addNavBarViewAndTitle:@""];
    self.pageNum = 1;
    
//    UIButton *searchBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    searchBtn.frame = CGRectMake(-10, 10, 64, 64);
//    searchBtn.backgroundColor = [UIColor clearColor];
//    [searchBtn setImage:[UIImage imageNamed:@"search"] forState:(UIControlStateNormal)];
//    [searchBtn addTarget:self action:@selector(didClickSearchBtn) forControlEvents:(UIControlEventTouchUpInside)];
//    [self.navView addSubview:searchBtn];
    
    tempView = [[UIView alloc] initWithFrame:CGRectMake(75, 0, kScreenWidth-150, 64)];
    tempView.backgroundColor = [UIColor clearColor];
    tempView.center = self.navView.center;
    [self.navView addSubview:tempView];
    
    NSArray *nameArr = @[@"推荐圈子",@"我的圈子"];
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

}

-(void)getCircleData:(BOOL)isRefresh
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[NSString stringWithFormat:@"%ld",(long)self.pageNum] forKey:@"page"];
    [dic setObject:@"6" forKey:@"pagesize"];
    if (!isRefresh)
    {
        [SVProgressHUD showInView:self.view WithY:64 andHeight:kScreenHeight-64-49];
    }
    [HttpTool postWithURL:@"Community/GetRecommendGroup" params:dic success:^(id json) {
        
        if ([[json objectForKey:@"isSuccessful"] boolValue])
        {
            NSArray *arr = [[json objectForKey:@"data"] objectForKey:@"items"];
            if(arr.count<6)
            {
                [self.circleTableView hiddenFooter:YES];
            }
            else
            {
                [self.circleTableView hiddenFooter:NO];
            }
            [self.circleTableView.dataArr addObjectsFromArray:arr];
            [self.circleTableView reloadData];
        }
        [self.circleTableView endRefresh];
        [SVProgressHUD dismiss];
        NSLog(@"%@",json);

    } failure:^(NSError *error) {
        
    }];
}

-(void)getMyCircleData:(BOOL)isRefresh
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[NSString stringWithFormat:@"%ld",(long)self.pageNum] forKey:@"page"];
    [dic setObject:@"10000" forKey:@"pagesize"];
    if (!isRefresh)
    {
        [SVProgressHUD showInView:self.view WithY:64 andHeight:kScreenHeight-64-49];
    }
    [HttpTool postWithURL:@"Community/GetMyGroup" params:dic success:^(id json) {
        
        if ([[json objectForKey:@"isSuccessful"] boolValue])
        {
            NSArray *arr = [[json objectForKey:@"data"] objectForKey:@"items"];
            [self.myCircleTableView.dataArr addObjectsFromArray:arr];
            [self.myCircleTableView endRefresh];
            [self.myCircleTableView reloadData];
            [SVProgressHUD dismiss];
        }
    } failure:^(NSError *error) {
        
    }];
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
        [self scrollToRecommendCircle];
    }
    else
    {
        [self scrollToMyCircle];
    }
}

-(void)didSelect:(UITapGestureRecognizer *)tap
{
    if (tap.view.tag==1000)
    {
        self.circleScroll.contentOffset = CGPointMake(0, 0);
        [self scrollToRecommendCircle];
    }
    else
    {
        self.circleScroll.contentOffset = CGPointMake(kScreenWidth, 0);
        [self scrollToMyCircle];
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.startX = scrollView.contentOffset.x;
}

//点击搜索
-(void)didClickSearchBtn
{

}
//推荐圈子
-(void)scrollToRecommendCircle
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
    self.circleScroll.contentOffset = CGPointMake(0, 0);
}

//我的圈子
-(void)scrollToMyCircle
{
    if (!self.myCircleTableView)
    {
        [self initWithMyCircleTalbeView];
    }
    if (self.myCircleTableView.dataArr.count==0)
    {
        [self getMyCircleData:NO];
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

@end
