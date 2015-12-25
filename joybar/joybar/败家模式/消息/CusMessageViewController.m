//
//  MessageViewController.m
//  joybar
//
//  Created by 123 on 15/4/22.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "CusMessageViewController.h"
#import "CusMessageTableViewCell.h"
#import "CusChatViewController.h"
#import "MessageTableView.h"
@interface CusMessageViewController ()<UIScrollViewDelegate>
@property (nonatomic ,strong) MessageTableView *msgTableView;
@end

@implementation CusMessageViewController
{
    UIView *tempView;
}
-(void)receiveMessage
{
    [self getMessageList];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //tableView
    self.msgTableView = [[MessageTableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64-49) style:(UITableViewStylePlain)];
    [self.view addSubview:self.msgTableView];
    __weak CusMessageViewController *VC = self;
    self.msgTableView.headerRereshingBlock=^()
    {
        [VC getMessageList];
    };
    [self initWithNavView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.msgTableView.dataArr removeAllObjects];
    [self getMessageList];
}
-(void)getMessageList
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"1" forKey:@"page"];
    [dic setObject:@"100000" forKey:@"pagesize"];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [HttpTool postWithURL:@"Community/GetMessagesList" params:dic success:^(id json) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self.msgTableView hiddenFooter:YES];
        [self.msgTableView.dataArr removeAllObjects];

        if([[json objectForKey:@"isSuccessful"] boolValue])
        {
            NSArray *arr = [[json objectForKey:@"data"] objectForKey:@"items"];
            [self.msgTableView.dataArr addObjectsFromArray:arr];
        }
        else
        {
            [self showHudFailed:[json objectForKey:@"message"]];
        }
        [self.msgTableView endRefresh];
        [self.msgTableView reloadData];
        
    } failure:^(NSError *error) {
        [self.msgTableView endRefresh];
    }];
}
-(void)initWithNavView
{
    [self addNavBarViewAndTitle:@"消息"];

    self.retBtn.hidden = YES;
}



@end
