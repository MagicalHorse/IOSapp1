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
#import "CusSettingViewController.h"
#import "CusCollectionViewController.h"
#import "BueryAuthViewController.h"
#import "MineData.h"
#import "CusAttentionViewController.h"
#import "CusFansViewController.h"
#import "CusBuyerCircleViewController.h"
@interface CusMineViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
@property (nonatomic,strong)UIViewController* vcview;

@property (nonatomic ,strong) UITableView *tableView;

@property (nonatomic ,strong) MineData *mineData;

@property (nonatomic ,strong) UIImageView *bgImageView;


@end

@implementation CusMineViewController
{
    UIImageView *headImage;
    UILabel *namelab;
    UIView *tempView;
}
-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
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
    
    UIView*bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 300-15)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.shadowOpacity = 0.5;
    self.tableView.tableHeaderView = bgView;
    
    self.bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    self.bgImageView.image = [UIImage imageNamed:@"bgImage.png"];
    [bgView addSubview:self.bgImageView];
    
    UIImageView *circleImage = [[UIImageView alloc] init];
    circleImage.center = CGPointMake(kScreenWidth/2, 110);
    circleImage.bounds = CGRectMake(0, 0, 75, 75);
    circleImage.layer.borderWidth = 0.5;
    circleImage.layer.cornerRadius = circleImage.width/2;
    circleImage.layer.borderColor = [UIColor whiteColor].CGColor;
    circleImage.backgroundColor = [UIColor clearColor];
    [bgView addSubview:circleImage];
    
    headImage = [[UIImageView alloc] init];
    headImage.center = CGPointMake(circleImage.center.x, circleImage.center.y);
    headImage.bounds = CGRectMake(0, 0, 65, 65);
    headImage.layer.cornerRadius = headImage.width/2;
    headImage.clipsToBounds = YES;
    [bgView addSubview:headImage];
    
    namelab =[[UILabel alloc] init];
    namelab.center = CGPointMake(headImage.center.x, circleImage.bottom+15);
    namelab.bounds = CGRectMake(0, 0, 150, 150);
    namelab.textColor = [UIColor whiteColor];
    namelab.textAlignment = NSTextAlignmentCenter;
    namelab.font = [UIFont systemFontOfSize:18];
    [bgView addSubview:namelab];
    
    tempView = [[UIView alloc] init];
    tempView.center = CGPointMake(kScreenWidth/2, self.bgImageView.bottom+43);
    tempView.bounds = CGRectMake(0, 0, kScreenWidth-60, 70);
    tempView.backgroundColor = [UIColor clearColor];
    [bgView addSubview:tempView];
    
    NSArray *nameArr = @[@"关注",@"粉丝",@"圈子"];
    NSArray *numArr ;
    numArr = @[@"0",@"0",@"0"];
    for (int i=0; i<3; i++)
    {
        UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        btn.center = CGPointMake(tempView.width/3*i+tempView.width/6, 35);
        btn.bounds = CGRectMake(0, 0, 70, 70);
        btn.adjustsImageWhenHighlighted = NO;
        [btn setImage:[UIImage imageNamed:@"圆.png"] forState:(UIControlStateNormal)];
        btn.tag = 1000+i;
        [btn addTarget:self action:@selector(didClickBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        [tempView addSubview:btn];
        
        UILabel *numLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 30, 13)];
        numLab.font = [UIFont systemFontOfSize:12];
        numLab.textColor = [UIColor darkGrayColor];
        numLab.textAlignment = NSTextAlignmentCenter;
        numLab.text = [numArr objectAtIndex:i];
        numLab.tag = 100+i;
        [btn addSubview:numLab];
        
        UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(20, numLab.bottom, 30, 20)];
        nameLab.font = [UIFont systemFontOfSize:14];
        nameLab.textColor = [UIColor grayColor];
        nameLab.text = [nameArr objectAtIndex:i];
        nameLab.textAlignment = NSTextAlignmentCenter;
        [btn addSubview:nameLab];
    }
    
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
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [HttpTool postWithURL:@"user/GetmyInfo" params:nil success:^(id json) {
        
        if ([[json objectForKey:@"isSuccessful"] boolValue])
        {
            self.mineData = [MineData objectWithKeyValues:[json objectForKey:@"data"]];
            
               NSArray *numArr = @[self.mineData.FollowingCount,self.mineData.FollowerCount,self.mineData.CommunityCount];
            for (int i=0; i<numArr.count; i++)
            {
                UIButton *btn = (UIButton *)[tempView viewWithTag:i+1000];
                UILabel *lab = (UILabel *)[btn viewWithTag:100+i];
                lab.text = [numArr objectAtIndex:i];
            }
            NSString *url = [[Public getUserInfo] objectForKey:@"logo"];
            [headImage sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            namelab.text = [[Public getUserInfo] objectForKey:@"nickname"];

            [self.tableView reloadData];
        }
        else
        {
            [self showHudFailed:[json objectForKey:@"message"]];
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
    } failure:^(NSError *error) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
        [cell setData:self.mineData andIndexPath:indexPath];
    }

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
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
    if (indexPath.row==1)
    {
        CusCollectionViewController *VC = [[CusCollectionViewController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }
    if (indexPath.row==2)
    {
        NSString *AuditStatus = [NSString stringWithFormat:@"%@",[[Public getUserInfo] objectForKey:@"AuditStatus"]];
        if ([AuditStatus isEqualToString:@"1"]) //==1 通过
        {
            [UIApplication sharedApplication].keyWindow.rootViewController = [[BuyerTabBarViewController alloc]init];
        }
        else if ([AuditStatus isEqualToString:@"-1"])
        {
            [self showHudFailed:@"亲您提交的信息有误,请您重新提交"];

            //被拒绝
        }
        else if ([AuditStatus isEqualToString:@"-2"])
        {
            BueryAuthViewController * b =[[BueryAuthViewController alloc]init];
            [self.navigationController pushViewController:b animated:YES];
        }
        else if ([AuditStatus isEqualToString:@"0"])
        {
            [self showHudFailed:@"亲不用急,正在审核中"];
            //正在申请中
        }
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    CusMineFirstTableViewCell  *cell = (CusMineFirstTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if (scrollView.contentOffset.y<0)
    {
        self.bgImageView.frame = CGRectMake(scrollView.contentOffset.y, scrollView.contentOffset.y, kScreenWidth-2*scrollView.contentOffset.y, 200-scrollView.contentOffset.y);
    }

}

//点击设置
-(void)didClickSettingBtn
{
    CusSettingViewController *VC = [[CusSettingViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 300-15;
//}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    
//    return bgView;
//
//}

-(void)didClickBtn:(UIButton *)btn
{
    switch (btn.tag)
    {
        case 1000:
        {
            CusAttentionViewController *VC = [[CusAttentionViewController alloc] init];
            VC.userId = [[Public getUserInfo] objectForKey:@"id"];
            [self.navigationController pushViewController:VC animated:YES];
        }
            
            break;
            
        case 1001:
        {
            CusFansViewController *VC = [[CusFansViewController alloc] init];
            VC.titleStr = @"粉丝";
            VC.userId = [[Public getUserInfo] objectForKey:@"id"];
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
            
        case 1002:
        {
            CusBuyerCircleViewController *VC = [[CusBuyerCircleViewController alloc] init];
            VC.userId = [[Public getUserInfo] objectForKey:@"id"];
            
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
            
        default:
            break;
    }

}
@end
