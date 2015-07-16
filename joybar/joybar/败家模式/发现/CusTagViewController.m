//
//  CusTagViewController.m
//  joybar
//
//  Created by 123 on 15/4/28.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "CusTagViewController.h"
#import "CusTagTableViewCell.h"
@interface CusTagViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (nonatomic ,strong) BaseTableView *tableView;

@property (nonatomic ,strong) NSMutableArray *tagArr;

@property (nonatomic ,assign) BOOL scrollDown;
@property (nonatomic ,assign) NSInteger pageNum;

@end


@implementation CusTagViewController
{
    CGFloat contentOffsetY;
    
    CGFloat oldContentOffsetY;
    
    CGFloat newContentOffsetY;
    int currentMaxDisplayedCell;
    
    int currentMaxDisplayedSection;

    

}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    currentMaxDisplayedSection = 0;
    currentMaxDisplayedCell = 0;
    self.pageNum = 1;
    self.tagArr = [NSMutableArray array];
    
    self.view.backgroundColor = kCustomColor(234, 239, 239);
    self.tableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) style:(UITableViewStylePlain)];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 5, 0);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self addNavBarViewAndTitle:self.BrandName];
    
    __weak CusTagViewController *VC = self;
    self.tableView.headerRereshingBlock = ^()
    {
        [VC.tableView.dataArr removeAllObjects];
        VC.pageNum = 1;
        [VC getData:YES];
    };
    self.tableView.footerRereshingBlock = ^()
    {
        VC.pageNum++;
        [VC getData:YES];
    };
    
    [self getData:NO];

}

-(void)getData:(BOOL)isRefresh
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.BrandId forKey:@"BrandId"];
    [dic setObject:[NSString stringWithFormat:@"%ld",(long)self.pageNum] forKey:@"Page"];
    [dic setObject:@"24" forKey:@"PageSize"];
    [self hudShow];
    [HttpTool postWithURL:@"Product/GetProductListByBrandId" params:dic success:^(id json) {
        
        [self hiddleHud];
        if ([[json objectForKey:@"isSuccessful"] boolValue])
        {
            NSArray *arr = [[json objectForKey:@"data"] objectForKey:@"items"];
            
            if (arr.count<24)
            {
                [self.tableView hiddenFooter:YES];
            }
            else
            {
                [self.tableView hiddenFooter:NO];
            }
            [self.tagArr addObjectsFromArray:arr];
            [self.tableView reloadData];
        }
        else
        {
            [self showHudFailed:[json objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {

        [self hiddleHud];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tagArr.count/3+self.tagArr.count%3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden = @"cell";
    CusTagTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell==nil)
    {
        cell = [[CusTagTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:iden];
    }
    cell.contentView.backgroundColor =kCustomColor(234, 239, 239);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (self.tagArr.count>0)
    {
        NSRange range = NSMakeRange(indexPath.row*3, 3);
        if (self.tagArr.count%3==1 && (indexPath.row == self.tagArr.count/3 + self.tagArr.count%3 - 1))
        {
            range = NSMakeRange(indexPath.row*3, 1);
        }
        
        NSArray *arr  =[self.tagArr subarrayWithRange:range];
        cell.currentMaxDisplayedRow = currentMaxDisplayedCell;
        cell.dataArray = arr;
        [cell setData:arr andIndexPath:indexPath];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (kScreenWidth-20)/3+5;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
