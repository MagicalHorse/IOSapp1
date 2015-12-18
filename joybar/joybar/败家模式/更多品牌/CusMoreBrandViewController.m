//
//  CusFindViewController.m
//  joybar
//
//  Created by 卢兴 on 15/4/16.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "CusMoreBrandViewController.h"
#import "CusFindSearchViewController.h"
#import "CusBrandDetailViewController.h"
#import "MoreBrandTableView.h"
#import "NearData.h"
#import "AppDelegate.h"
@interface CusMoreBrandViewController ()<UIScrollViewDelegate,UITextFieldDelegate>

@property (nonatomic ,strong) MoreBrandTableView *findTableView;
@property (nonatomic ,strong) NSMutableArray *findArr;
@property (nonatomic ,assign) NSInteger pageNum;

@end

@implementation CusMoreBrandViewController
{
    UIView *tempView;
    UITextField *search;
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addNavBarViewAndTitle:@""];
    
    UIView *temp = [[UIView alloc] init];
    temp.center = CGPointMake(kScreenWidth/2, 64/2+10);
    temp.bounds = CGRectMake(0, 0, kScreenWidth-100, 30);
    temp.backgroundColor = kCustomColor(238, 238, 238);
    [self.navView addSubview:temp];
    
    
    search = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, temp.width-10, temp.height)];
    search.placeholder = @"  搜索品牌";
    search.borderStyle = UITextBorderStyleNone;
    search.layer.cornerRadius = 3;
    search.delegate = self;
    search.layer.masksToBounds = YES;
    search.font = [UIFont systemFontOfSize:14];
    search.backgroundColor = kCustomColor(238, 238, 238);
    search.returnKeyType = UIReturnKeySearch;
    [temp addSubview:search];
    
    UIButton *searchBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    searchBtn.frame = CGRectMake(kScreenWidth-54, 10, 64, 64);
    searchBtn.backgroundColor = [UIColor clearColor];
    [searchBtn setImage:[UIImage imageNamed:@"search"] forState:(UIControlStateNormal)];
    [searchBtn addTarget:self action:@selector(didClickSearchBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.navView addSubview:searchBtn];
    self.pageNum = 1;
    [self initWithFindTableView];
    [self getFindData:NO andSearchStr:@""];
    
}

//品牌
-(void)initWithFindTableView
{
    //tableView
    self.findTableView = [[MoreBrandTableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) style:(UITableViewStylePlain)];
    
    [self.view addSubview:self.findTableView];
    
    __weak CusMoreBrandViewController *VC = self;
    self.findTableView.headerRereshingBlock = ^()
    {
        [VC.findTableView.dataArr removeAllObjects];
        VC.pageNum=1;
        [VC getFindData:YES andSearchStr:@""];
    };
    self.findTableView.footerRereshingBlock = ^()
    {
        VC.pageNum++;
        [VC getFindData:YES andSearchStr:@""];
    };
}

-(void)getFindData:(BOOL)isRefresh andSearchStr:(NSString *)str
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.storeId forKey:@"StoreId"];
    [dic setValue:str forKey:@"BrandName"];
    [dic setValue:[NSString stringWithFormat:@"%ld",(long)self.pageNum] forKey:@"page"];
    [dic setValue:@"20" forKey:@"pagesize"];
    if (!isRefresh)
    {
        [self activityDismiss];
        [self showInView:self.view WithPoint:CGPointMake(0, 0) andHeight:kScreenHeight-64-49];
    }
    [HttpTool postWithURL:@"v3/storebrand" params:dic success:^(id json) {
        
        if ([[json objectForKey:@"isSuccessful"] boolValue])
        {
            NSArray *arr = [[json objectForKey:@"data"] objectForKey:@"items"];
            if (arr.count<20)
            {
                [self.findTableView hiddenFooter:YES];
            }
            else
            {
                [self.findTableView hiddenFooter:NO];
            }
            [self.findTableView.dataArr addObjectsFromArray:arr];
            [self.findTableView reloadData];
        }
        else
        {
            [self showHudFailed:[json objectForKey:@"message"]];
        }
        [self.findTableView endRefresh];
        [self activityDismiss];
        
    } failure:^(NSError *error) {
        [self.findTableView endRefresh];
        [self activityDismiss];
    }];
}

//点击搜索
-(void)didClickSearch
{
    CusFindSearchViewController *VC = [[CusFindSearchViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.pageNum=1;
    [self.findTableView.dataArr removeAllObjects];
    [self getFindData:NO andSearchStr:textField.text];
    [self.view endEditing:YES];
    return YES;
}

//搜索
-(void)didClickSearchBtn
{
    self.pageNum=1;
    [self.findTableView.dataArr removeAllObjects];
    [self getFindData:NO andSearchStr:search.text];
    [self.view endEditing:YES];
}

@end