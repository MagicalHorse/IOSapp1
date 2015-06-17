//
//  BuyerTicketViewController.m
//  joybar
//
//  Created by 卢兴 on 15/4/16.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "BuyerTicketViewController.h"
#import "BuyerTicketTableViewCell.h"
#import "BuyerTicketDetailsViewController.h"
@interface BuyerTicketViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic ,strong) UILabel *lineLab;
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) NSArray *imageArr;
@property (nonatomic,strong) NSMutableArray *dataArray;
@end

@implementation BuyerTicketViewController

-(NSMutableArray *)dataArray{
    if (_dataArray ==nil) {
        _dataArray =[[NSMutableArray alloc]init];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) style:(UITableViewStyleGrouped)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self addNavBarViewAndTitle:@"任务奖励"];
    self.retBtn.hidden =YES;

    [self setData];

}
-(void)setData{
    [HttpTool postWithURL:@"Promotion/List" params:nil success:^(id json) {
        BOOL  isSuccessful =[[json objectForKey:@"isSuccessful"] boolValue];
        if (isSuccessful) {
            self.dataArray =[json objectForKey:@"data"];
            [self.tableView reloadData];
        }
        
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleIdentify = @"cell";
    BuyerTicketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleIdentify];
    if (cell == nil) {
        cell =[[[NSBundle mainBundle] loadNibNamed:@"BuyerTicketTableViewCell" owner:self options:nil] lastObject];
    }
    if(self.dataArray.count>0){
        NSString *icon=[self.dataArray[indexPath.section]objectForKey:@"icon"];
        NSString *name=[self.dataArray[indexPath.section]objectForKey:@"name"];
        NSString *tip=[self.dataArray[indexPath.section]objectForKey:@"tip"];
        [cell.ticketIcon sd_setImageWithURL:[NSURL URLWithString:icon] placeholderImage:nil];
        cell.ticketTitle.text = name;
        cell.ticketCount.text =tip;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *Id=[[self.dataArray[indexPath.section]objectForKey:@"id"] stringValue];
    NSString *name=[self.dataArray[indexPath.section]objectForKey:@"name"];
    BuyerTicketDetailsViewController *ticket=[[BuyerTicketDetailsViewController alloc]init];
    ticket.Id =Id;
    ticket.Name =name;
    [self.navigationController pushViewController:ticket animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 76;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}


@end
