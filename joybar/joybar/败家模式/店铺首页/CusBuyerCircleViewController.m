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
@property (nonatomic ,assign) NSInteger pageNum;

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

-(void)viewWillAppear:(BOOL)animated
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.pageNum = 1;
    self.myCircleTableView = [[MyCircleTableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) style:(UITableViewStylePlain)];
    [self.view addSubview:self.myCircleTableView];
    
    __weak CusBuyerCircleViewController *VC = self;
    self.myCircleTableView.headerRereshingBlock = ^()
    {
        VC.pageNum = 1;
        [VC.myCircleTableView.dataArr removeAllObjects];
        [VC getMyCircleData:YES];
    };
    
    self.myCircleTableView.footerRereshingBlock =^()
    {
        VC.pageNum++;
        [VC getMyCircleData:YES];
    };
    [self getMyCircleData:NO];
    
}

-(void)getMyCircleData:(BOOL)isRefresh
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[NSString stringWithFormat:@"%ld",(long)self.pageNum] forKey:@"page"];
    [dic setObject:@"10" forKey:@"pagesize"];
    [dic setObject:self.userId forKey:@"UserId"];
    [self hudShow];
    [HttpTool postWithURL:@"Community/GetUserGroups" params:dic success:^(id json) {
        
        if ([[json objectForKey:@"isSuccessful"] boolValue])
        {
            NSArray *arr = [[json objectForKey:@"data"] objectForKey:@"items"];
            if(arr.count<10)
            {
                [self.myCircleTableView hiddenFooter:YES];
            }
            else
            {
                [self.myCircleTableView hiddenFooter:NO];
            }
            [self.myCircleTableView.dataArr addObjectsFromArray:arr];
            [self.myCircleTableView endRefresh];
            [self.myCircleTableView reloadData];
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
