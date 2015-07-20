//
//  BuyerMessageViewController.m
//  joybar
//
//  Created by joybar on 15/6/8.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "BuyerOpenMessageViewController.h"

@interface BuyerOpenMessageViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *tableView;

@end

@implementation BuyerOpenMessageViewController
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
    [self addNavBarViewAndTitle:@"消息免打扰"];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = kCustomColor(245, 246, 247);
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    
    if (indexPath.row==0)
    {
       cell.textLabel.text =@"开启";
    }
    else if(indexPath.row==1)
    {
        cell.textLabel.text =@"只在夜间开启";

    }else{
        cell.textLabel.text =@"关闭";
    }
  
    return cell;
}



@end
