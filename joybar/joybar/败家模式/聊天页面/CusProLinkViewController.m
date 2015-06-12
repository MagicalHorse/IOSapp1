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
    
    self.dataArr = [NSMutableArray arrayWithArray:@[@"1",@"2",@"3",@"4",@"1",@"2",@"3",@"4",@"1",@"2",@"3",@"4",@"1",@"2",@"3",@"4",@"1",@"2",@"3",@"4"]];
    self.isSelectArr = [NSMutableArray arrayWithArray:@[@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0"]];
    
    //tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64-49) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
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
}

#pragma mark tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
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
    proImage.backgroundColor = [UIColor orangeColor];
    [cell.contentView addSubview:proImage];
    
    UILabel *desLab = [[UILabel alloc] initWithFrame:CGRectMake(proImage.right+10, 10, kScreenWidth-140, 40)];
    desLab.text = @"阿打算打算的阿萨德啊实打实大声道阿萨德爱上的";
    desLab.numberOfLines = 0;
    desLab.font = [UIFont fontWithName:@"youyuan" size:13];
    desLab.textColor = [UIColor lightGrayColor];
    [cell.contentView addSubview:desLab];
    
    UILabel *priceLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-220, 50, 200, 40)];
    priceLab.text = @"￥123456";
    priceLab.font = [UIFont fontWithName:@"youyuan" size:15];
    priceLab.textAlignment = NSTextAlignmentRight;
    priceLab.textColor = [UIColor darkGrayColor];
    [cell.contentView addSubview:priceLab];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}


//确定
-(void)didCLickMakeSureBtn:(UIButton *)btn
{
    
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
