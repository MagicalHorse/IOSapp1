//
//  CusBuyerCircleViewController.m
//  joybar
//
//  Created by 123 on 15/6/6.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "CusBuyerCircleViewController.h"
#import "MyCircleTableView.h"
@interface CusBuyerCircleViewController ()

@property (nonatomic ,strong) MyCircleTableView *myCircleTableView;

@end

@implementation CusBuyerCircleViewController

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
    [self addNavBarViewAndTitle:@"圈子"];
    self.myCircleTableView = [[MyCircleTableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64-49) style:(UITableViewStylePlain)];
    [self.view addSubview:self.myCircleTableView];
    
    __weak CusBuyerCircleViewController *VC = self;
    self.myCircleTableView.headerRereshingBlock = ^()
    {
        [VC.myCircleTableView.dataArr removeAllObjects];
        [VC getMyCircleData:YES];
    };
    
    [self getMyCircleData:NO];

}

-(void)getMyCircleData:(BOOL)isRefresh
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"1" forKey:@"page"];
    [dic setObject:@"10000" forKey:@"pagesize"];
//    if (!isRefresh)
//    {
//        [SVProgressHUD showInView:self.view WithY:64 andHeight:kScreenHeight-64-49];
//    }
    [self hudShow];
    [HttpTool postWithURL:@"Community/GetMyGroup" params:dic success:^(id json) {
        
        if ([[json objectForKey:@"isSuccessful"] boolValue])
        {
            NSArray *arr = [[json objectForKey:@"data"] objectForKey:@"items"];
            //            if(arr.count<7)
            //            {
            //                [self.tableView hiddenFooter:YES];
            //            }
            //            else
            //            {
            //                [self.tableView hiddenFooter:NO];
            //            }
            [self.myCircleTableView.dataArr addObjectsFromArray:arr];
            [self.myCircleTableView endRefresh];
            [self.myCircleTableView reloadData];
//            [SVProgressHUD dismiss];
            NSLog(@"%@",json);
        }
        else
        {
            [self showHudFailed:[json objectForKey:@"message"]];
        }
        [self hiddleHud];

    } failure:^(NSError *error) {
        
    }];
}




@end
