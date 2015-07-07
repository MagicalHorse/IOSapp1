//
//  CusProLinkViewController.m
//  joybar
//
//  Created by 123 on 15/5/19.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "CusProLinkViewController.h"

@interface CusProLinkViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong) UITableView *tableView;

@property (nonatomic ,strong) NSMutableArray *isSelectArr;

@property (nonatomic ,strong) NSMutableArray *dataArr;

@property (nonatomic ,strong) NSMutableArray *selectProArr;

@end

@implementation CusProLinkViewController

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
    self.isSelectArr = [NSMutableArray array];
    self.dataArr = [NSMutableArray array];
    self.selectProArr = [NSMutableArray array];
    
    
    //tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64-49) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self addNavBarViewAndTitle:self.titleStr];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-49, kScreenWidth, 49)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [bottomView addSubview:line];
    
    UIButton *sureBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    sureBtn.center = CGPointMake(kScreenWidth/2, 25);
    sureBtn.bounds = CGRectMake(0, 0, 90, 30);
    sureBtn.layer.borderWidth = 0.5;
    sureBtn.layer.borderColor = [UIColor orangeColor].CGColor;
    sureBtn.layer.cornerRadius = 3;
    [sureBtn setTitle:@"确定" forState:(UIControlStateNormal)];
    [sureBtn setTitleColor:[UIColor orangeColor] forState:(UIControlStateNormal)];
    sureBtn.titleLabel.font = [UIFont fontWithName:@"youyuan" size:14];
    [sureBtn addTarget:self action:@selector(didCLickMakeSureBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [bottomView addSubview:sureBtn];
    [self getNewProListData];
}

-(void)getNewProListData
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[[Public getUserInfo] objectForKey:@"id"] forKey:@"userid"];
    [dic setObject:@"0" forKey:@"Filter"];
    [dic setObject:@"1" forKey:@"page"];
    [dic setObject:@"10000" forKey:@"pagesize"];
    [self hudShow];
    [HttpTool postWithURL:@"Product/GetUserProductList" params:dic success:^(id json) {
        
        if ([[json objectForKey:@"isSuccessful"] boolValue])
        {
            NSArray *arr = [[json objectForKey:@"data"] objectForKey:@"items"];
            
            [self.dataArr addObjectsFromArray:arr];
            for (int i=0; i<arr.count; i++)
            {
                [self.isSelectArr insertObject:@"0" atIndex:i];
            }
            
            [self.tableView reloadData];
        }
        else
        {
            [self showHudFailed:[json objectForKey:@"message"]];
        }
        [self hiddleHud];
        
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell==nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:iden];
    }
    
    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (self.dataArr.count>0)
    {
        
        NSDictionary *proDic = [self.dataArr objectAtIndex:indexPath.row];
        UIButton *selectBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        selectBtn.frame = CGRectMake(5, 25, 30, 30);
        selectBtn.tag = 1000+indexPath.row;
        if([[self.isSelectArr objectAtIndex:indexPath.row] isEqualToString:@"0"])
        {
            [selectBtn setImage:[UIImage imageNamed:@"圈icon"] forState:(UIControlStateNormal)];
        }
        else
        {
            [selectBtn setImage:[UIImage imageNamed:@"对号icon"] forState:(UIControlStateNormal)];
        }
        [selectBtn addTarget:self action:@selector(didClickSelectProBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        [cell.contentView addSubview:selectBtn];
        
        UIImageView *proImage = [[UIImageView alloc] initWithFrame:CGRectMake(selectBtn.right+5, 5, 70, 70)];
//        proImage.backgroundColor = [UIColor orangeColor];
        NSString *imageURL = [NSString stringWithFormat:@"%@_320x0.jpg",[[proDic objectForKey:@"pic"] objectForKey:@"pic"]];
        [proImage sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:nil];
        [cell.contentView addSubview:proImage];
        
        UILabel *desLab = [[UILabel alloc] initWithFrame:CGRectMake(proImage.right+10, 10, kScreenWidth-140, 40)];
        desLab.text = [proDic objectForKey:@"Name"];
        desLab.numberOfLines = 0;
        desLab.font = [UIFont fontWithName:@"youyuan" size:13];
        desLab.textColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:desLab];
        
        UILabel *priceLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-220, 50, 200, 40)];
        priceLab.text = [NSString stringWithFormat:@"￥%@",[proDic objectForKey:@"Price"]];
        priceLab.font = [UIFont fontWithName:@"youyuan" size:15];
        priceLab.textAlignment = NSTextAlignmentRight;
        priceLab.textColor = [UIColor darkGrayColor];
        [cell.contentView addSubview:priceLab];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

//确定
-(void)didCLickMakeSureBtn:(UIButton *)btn
{
    for (int i=0; i<self.isSelectArr.count; i++)
    {
        NSString *type = [self.isSelectArr objectAtIndex:i];
        NSDictionary *proDic = [self.dataArr objectAtIndex:i];
        if ([type isEqualToString:@"1"])
        {
            [self.selectProArr addObject:proDic];
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"selectProNot" object:self.selectProArr];
//    NSLog(@"%@",self.selectProArr);
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)didClickSelectProBtn:(UIButton *)btn
{
//    [self.isSelectArr setObject:@"1" atIndexedSubscript:btn.tag-1000];
    
    
    NSString *str = [self.isSelectArr objectAtIndex:btn.tag-1000];
    if ([str isEqualToString:@"0"])
    {
        [self.isSelectArr setObject:@"1" atIndexedSubscript:btn.tag-1000];
        [btn setImage:[UIImage imageNamed:@"对号icon"] forState:(UIControlStateNormal)];

    }
    else
    {
        [btn setImage:[UIImage imageNamed:@"圈icon"] forState:(UIControlStateNormal)];
        [self.isSelectArr setObject:@"0" atIndexedSubscript:btn.tag-1000];
    }
    NSLog(@"%@",self.isSelectArr);

}

@end
