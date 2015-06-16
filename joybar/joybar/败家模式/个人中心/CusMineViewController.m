//
//  CusMineViewController.m
//  joybar
//
//  Created by 卢兴 on 15/4/16.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "CusMineViewController.h"
#import "AppDelegate.h"
#import "BuyerTabBarViewController.h"
#import "CusMineFirstTableViewCell.h"
#import "CusMineSecTableViewCell.h"
#import "CusSettingViewController.h"
#import "CusCollectionViewController.h"
#import "BueryAuthViewController.h"
#import "MineData.h"
@interface CusMineViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
@property (nonatomic,strong)UIViewController* vcview;

@property (nonatomic ,strong) UITableView *tableView;

@property (nonatomic ,strong) MineData *mineData;

@end

@implementation CusMineViewController

-(void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self getMineData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-49) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    UIButton *messageBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    messageBtn.frame = CGRectMake(kScreenWidth-50, 30, 64, 64);
    messageBtn.backgroundColor = [UIColor clearColor];
    [messageBtn addTarget:self action:@selector(didClickSettingBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:messageBtn];
    
    UIImageView *messageImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    messageImg.image = [UIImage imageNamed:@"设置.png"];
    [messageBtn addSubview:messageImg];
    self.navView.hidden = YES;
    
}

-(void)getMineData
{
    [HttpTool postWithURL:@"user/GetmyInfo" params:nil success:^(id json) {
        
        if ([[json objectForKey:@"isSuccessful"] boolValue])
        {
            self.mineData = [MineData objectWithKeyValues:[json objectForKey:@"data"]];
            [self.tableView reloadData];
        }
        NSLog(@"%@",json);
        
    } failure:^(NSError *error) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {
        static NSString *iden = @"cell";
        CusMineFirstTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
        if (cell==nil)
        {
            cell = [[CusMineFirstTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:iden];
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        for (UIView *view in cell.contentView.subviews)
        {
            [view removeFromSuperview];
        }
        cell.backgroundColor = kCustomColor(245, 246, 247);
        if (self.mineData)
        {
            [cell setData:self.mineData];
        }
        return cell;
    }
    else if (indexPath.row==1)
    {
        static NSString *iden = @"cell1";
        CusMineSecTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
        if (cell==nil)
        {
            cell = [[CusMineSecTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:iden];
        }
        for (UIView *view in cell.contentView.subviews)
        {
            [view removeFromSuperview];
        }

        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = kCustomColor(245, 246, 247);
        if (self.mineData)
        {
            [cell setData:self.mineData];
        }
        return cell;
    }
    else
    {
        static NSString *iden = @"cell2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
        if (cell==nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:iden];
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        for (UIView *view in cell.contentView.subviews)
        {
            [view removeFromSuperview];
        }
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 49, kScreenWidth, 0.5)];
        line.backgroundColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:line];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        NSArray *arr = @[@"我的收藏",@"我要养家"];
        cell.textLabel.text = [arr objectAtIndex:indexPath.row-2];
        cell.textLabel.font = [UIFont fontWithName:@"youyuan" size:14];

        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {
        return 300;
    }
    else if (indexPath.row==1)
    {
        return 100;
    }
    else
    {
        return 50;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==2)
    {
        CusCollectionViewController *VC = [[CusCollectionViewController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }
    if (indexPath.row==3)
    {
        NSString *AuditStatus = [NSString stringWithFormat:@"%@",[[Public getUserInfo] objectForKey:@"AuditStatus"]];
        if ([AuditStatus isEqualToString:@"1"])
        {
            [UIApplication sharedApplication].keyWindow.rootViewController = [[BuyerTabBarViewController alloc]init];
        }
        else if ([AuditStatus isEqualToString:@"-1"])
        {
            //被拒绝
        }
        else if ([AuditStatus isEqualToString:@"-2"])
        {
            BueryAuthViewController * b =[[BueryAuthViewController alloc]init];
            [self.navigationController pushViewController:b animated:YES];
        }
        else if ([AuditStatus isEqualToString:@"0"])
        {
            //正在申请中
            
        }
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CusMineFirstTableViewCell  *cell = (CusMineFirstTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if (scrollView.contentOffset.y<0)
    {
        cell.bgImageView.frame = CGRectMake(scrollView.contentOffset.y, scrollView.contentOffset.y, kScreenWidth-2*scrollView.contentOffset.y, 200-scrollView.contentOffset.y);
    }
}

//点击设置
-(void)didClickSettingBtn
{
    CusSettingViewController *VC = [[CusSettingViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}
@end
