//
//  LocationViewController.m
//  joybar
//
//  Created by 123 on 15/11/20.
//  Copyright © 2015年 卢兴. All rights reserved.
//

#import "LocationViewController.h"

@interface LocationViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong) UITableView *tableView;

@property (nonatomic ,strong) NSArray *cityArr;

@end

@implementation LocationViewController

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
    [self addNavBarViewAndTitle:@"选择城市"];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self getCityList];
    
}

-(void)getCityList
{
    [HttpTool postWithURL:@"Common/GetAllShoopingCity" params:nil success:^(id json) {
        
        if ([[json objectForKey:@"isSuccessful"] boolValue])
        {
            self.cityArr = [json objectForKey:@"data"];
            [self.tableView reloadData];
        }
        else
        {
            [self showHudFailed:[json objectForKey:@"message"]];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0)
    {
        return 1;
    }
    return self.cityArr.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *arr = @[@"当前定位城市",@"当前已开通Shopping的城市"];
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = kCustomColor(241, 241, 241);
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth-20, 35)];
    lab.text = arr[section];
    lab.textColor = [UIColor grayColor];
    lab.font = [UIFont systemFontOfSize:14];
    [headerView addSubview:lab];
    
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell==nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:iden];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section==0)
    {
        cell.textLabel.text = self.locationCityName;
    }
    
    if (indexPath.section==1)
    {
        cell.textLabel.text = [[self.cityArr objectAtIndex:indexPath.row] objectForKey:@"Name"];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section==0)
//    {
//        return;
//    }
    NSString *cityName;
    NSString *cityId;
    if (indexPath.section==0)
    {
        cityName = self.locationCityName;
        cityId = self.locationCityId;
    }
    else
    {
         cityName =[[self.cityArr objectAtIndex:indexPath.row] objectForKey:@"Name"];
         cityId = [[self.cityArr objectAtIndex:indexPath.row] objectForKey:@"Id"];
    }
    if(self.handleCityName)
    {
        self.handleCityName(cityName,cityId);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
