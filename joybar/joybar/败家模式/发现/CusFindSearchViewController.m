//
//  CusFindSearchViewController.m
//  joybar
//
//  Created by 123 on 15/5/8.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "CusFindSearchViewController.h"

@interface CusFindSearchViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic ,strong) UIView *line;

@property (nonatomic ,strong) NSMutableArray *btnArr;

@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,assign) NSInteger selectBtnIndex;
@end

@implementation CusFindSearchViewController

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
    self.btnArr = [NSMutableArray array];
    self.selectBtnIndex = 0;
    [self addNavBarViewAndTitle:@""];
    self.retBtn.hidden = YES;
    
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(15, 25, kScreenWidth-70, 30)];
    searchView.backgroundColor = kCustomColor(225, 227, 229);
    searchView.layer.cornerRadius = 3;
    [self.navView addSubview:searchView];
    
    UIImageView  *searchImage = [[UIImageView alloc] initWithFrame:CGRectMake(6, 6, 17, 17)];
    searchImage.image = [UIImage imageNamed:@"search"];
    [searchView addSubview:searchImage];
    
    UITextField *searchText = [[UITextField alloc] initWithFrame:CGRectMake(searchImage.right+10, 0, searchView.width-50, 30)];
    searchText.placeholder = @"请输入品牌或者其他标签";
    searchText.borderStyle = UITextBorderStyleNone;
    searchText.delegate = self;
    searchText.returnKeyType = UIReturnKeySearch;
    searchText.font = [UIFont fontWithName:@"youyuan" size:14];
    [searchView addSubview:searchText];
    
    UIButton *cancelBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    cancelBtn.frame = CGRectMake(kScreenWidth-50, 25, 50, 30);
    cancelBtn.backgroundColor = [UIColor clearColor];
    [cancelBtn setTitle:@"取消" forState:(UIControlStateNormal)];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    cancelBtn.titleLabel.font = [UIFont fontWithName:@"youyuan" size:15];
    [cancelBtn addTarget:self action:@selector(didClickCancelBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.navView addSubview:cancelBtn];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 40)];
    headerView.backgroundColor = kCustomColor(235, 238, 240);
    [self.view addSubview:headerView];
    NSArray *arr = @[@"品牌",@"买手"];
    
    for (int i=0; i<arr.count; i++)
    {
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        button.frame = CGRectMake(kScreenWidth/arr.count*i, 0, kScreenWidth/arr.count, 40);
        [button setTitle:[arr objectAtIndex:i] forState:(UIControlStateNormal)];
        [button setTitleColor:[UIColor darkGrayColor] forState:(UIControlStateNormal)];
        button.titleLabel.font = [UIFont fontWithName:@"youyuan" size:15];
        [button addTarget:self action:@selector(didClickBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        button.tag = 1000+i;
        [headerView addSubview:button];
        if (i==0)
        {
            [button setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        }
        [self.btnArr addObject:button];
    }
    
    self.line = [[UIView alloc] initWithFrame:CGRectMake(20, 39, kScreenWidth/arr.count-40, 1)];
    self.line.backgroundColor = [UIColor darkGrayColor];
    [headerView addSubview:self.line];
    
    //tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+40, kScreenWidth, kScreenHeight-64-40) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];

}

-(void)didClickBtn:(UIButton *)btn
{
    [UIView animateWithDuration:0.25 animations:^{
        self.line.frame = CGRectMake(kScreenWidth/2*(btn.tag-1000)+20, 39, kScreenWidth/2-40, 1);
    }];
    
    for (UIButton *button in self.btnArr)
    {
        if (button==btn)
        {
            [button setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        }
        else
        {
            [button setTitleColor:[UIColor darkGrayColor] forState:(UIControlStateNormal)];
        }
    }
    
    switch (btn.tag)
    {
        case 1000:
        {
            self.selectBtnIndex = 0;
        }
            break;
        case 1001:
        {
            self.selectBtnIndex = 1;
        }
            break;
//        case 1002:
//        {
//            self.selectBtnIndex = 2;
//        }
//            break;
        default:
            break;
    }
    
    [self.tableView reloadData];
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
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 80, kScreenWidth, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [cell.contentView addSubview:lineView];
    if (self.selectBtnIndex==0)
    {
        UIImageView *proImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
        proImage.backgroundColor = [UIColor orangeColor];
        [cell.contentView addSubview:proImage];
        
        UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(proImage.right+10, 30, 250, 20)];
        nameLab.text = @"NEW BALANCE";
        nameLab.textColor = [UIColor grayColor];
        nameLab.font = [UIFont fontWithName:@"youyuan" size:15];
        [cell.contentView addSubview:nameLab];
    }
//    else if (self.selectBtnIndex==1)
//    {
//        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 250, 20)];
//        lab.text = @"NEW BALANCE";
//        lab.textColor = [UIColor grayColor];
//        lab.font = [UIFont fontWithName:@"youyuan" size:15];
//        [cell.contentView addSubview:lab];
//    }
    else
    {
        UIImageView *proImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
        proImage.backgroundColor = [UIColor orangeColor];
        proImage.layer.cornerRadius = proImage.width/2;
        [cell.contentView addSubview:proImage];
        
        UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(proImage.right+10, 30, 250, 20)];
        nameLab.text = @"小猫猫";
        nameLab.textColor = [UIColor grayColor];
        nameLab.font = [UIFont fontWithName:@"youyuan" size:15];
        [cell.contentView addSubview:nameLab];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(void)didClickCancelBtn:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

@end
