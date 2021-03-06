//
//  CusSettingViewController.m
//  joybar
//
//  Created by 123 on 15/5/6.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "BuyerSettingViewController.h"

@interface BuyerSettingViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong) UITableView *tableView;

@end

@implementation BuyerSettingViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addNavBarViewAndTitle:@"设置"];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = kCustomColor(245, 246, 247);

    [self.view addSubview:self.tableView];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor =kCustomColor(245, 246, 247);
    
    if (section==2)
    {
        UIButton *exitBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        exitBtn.frame = CGRectMake(20, 60, kScreenWidth-40, 40);
        [exitBtn setBackgroundColor:kCustomColor(253, 162, 41)];
        [exitBtn setTitle:@"退出登录" forState:(UIControlStateNormal)];
        exitBtn.layer.cornerRadius = 4;
        [exitBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [headerView addSubview:exitBtn];
    }
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0)
    {
        return 0;
    }
    else if (section==2)
    {
        return 180;
    }
    return 20;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==2)
    {
        return 0;
    }
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:iden];
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    if(indexPath.section==2&&indexPath.row==2)
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 600)];
        bgView.backgroundColor = kCustomColor(245, 246, 247);
        [cell.contentView addSubview:bgView];
    }
    NSArray *nameArr = @[@[@"头像",@"昵称"],@[@"账户密码",@"消息免打扰"],@[]];
    cell.textLabel.text = [[nameArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"youyuan" size:18];
    
    if (indexPath.section==0)
    {
        if (indexPath.row==0)
        {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-110, 15, 70, 70)];
            imageView.backgroundColor = [UIColor orangeColor];
            imageView.layer.cornerRadius = imageView.width/2;
            [cell.contentView addSubview:imageView];
        }
        else
        {
            UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-240, 12.5, 200, 30)];
            nameLab.textAlignment = NSTextAlignmentRight;
            nameLab.text = @"小猫猫";
            nameLab.font = [UIFont fontWithName:@"youyuan" size:16];
            nameLab.textColor = [UIColor lightGrayColor];
            [cell.contentView addSubview:nameLab];
        }
    }
    return cell;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0&&indexPath.row==0)
    {
        return 100;
    }
    else if (indexPath.section==2&&indexPath.row==2)
    {
        return 200;
    }
    return 55;
}

@end
