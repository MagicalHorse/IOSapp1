//
//  CusFansViewController.m
//  joybar
//
//  Created by 123 on 15/5/12.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "CusFansViewController.h"
#import "CusFansTableViewCell.h"
#import "FansItems.h"
#import "CusChatViewController.h"
@interface CusFansViewController ()<UITableViewDelegate,UITableViewDataSource>{
    int isY;
    FansItems *fansItems;
    
}
@end

@implementation CusFansViewController

-(CusFansViewController *)initIsY{
    if (self = [super init]) {
        isY =1;
    }
    return self;
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
    self.pageNum = 1;
    self.fanArr = [NSMutableArray array];

    CGFloat y=0;
    if (isY==1) {
        y=0;
    }else{
        y=64;
    }
    self.tableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, y, kScreenWidth, kScreenHeight-64) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    __weak CusFansViewController *VC = self;
    self.tableView.headerRereshingBlock = ^{
    
        [VC.fanArr removeAllObjects];
        VC.pageNum = 1;
        [VC getData];
        
    
    };
    self.tableView.footerRereshingBlock = ^{
        VC.pageNum++;
        [VC getData];
    };
    
    [self addNavBarViewAndTitle:self.titleStr];
    
    [self getData];


}

-(void)getData
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[NSString stringWithFormat:@"%ld",(long)self.pageNum] forKey:@"page"];
    [dic setValue:@"6" forKey:@"pagesize"];
    [dic setValue:@"1" forKey:@"status"];
    [self hudShow];
    [HttpTool postWithURL:@"User/GetUserFavoite" params:dic success:^(id json) {
        
        if ([[json objectForKey:@"isSuccessful"] boolValue])
        {
           fansItems = [FansItems objectWithKeyValues:[json objectForKey:@"data"]];
            
            if (fansItems.items.count<6)
            {
                [self.tableView hiddenFooter:YES];
            }
            else
            {
                [self.tableView hiddenFooter:NO];
            }
            [self.fanArr addObjectsFromArray:fansItems.items];
            [self.tableView reloadData];
            [self.tableView endRefresh];
        }
        else
        {
            [self showHudFailed:[json objectForKey:@"message"]];
        }
        [self hiddleHud];
        
    } failure:^(NSError *error) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.fanArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden = @"cell";
    CusFansTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell==nil)
    {
        cell = [[CusFansTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:iden];
    }
    
    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    FansModel *fan = [fansItems.items objectAtIndex:indexPath.row];
    [cell setData:fan];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FansModel *fan = [fansItems.items objectAtIndex:indexPath.row];
    CusChatViewController *VC = [[CusChatViewController alloc] initWithUserId:fan.UserId AndTpye:2 andUserName:fan.UserName andRoomId:@""];
    VC.isFrom = isFromPrivateChat;
    [self.navigationController pushViewController:VC animated:YES];
}

@end
