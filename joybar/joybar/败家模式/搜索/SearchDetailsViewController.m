//
//  SearchDetailsViewController.m
//  joybar
//
//  Created by joybar on 15/11/20.
//  Copyright © 2015年 卢兴. All rights reserved.
//

#import "SearchDetailsViewController.h"
#import "CusBueryTableViewCell.h"
#import "CusBrandTableViewCell.h"
#import "CusShoppingTableViewCell.h"
#import "CusShopTableViewCell.h"

@interface SearchDetailsViewController()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) NSMutableArray *searchArr;
@property (nonatomic ,strong) UILabel *lineLab;
@property (nonatomic ,strong) UIView *tempView;
@end

@implementation SearchDetailsViewController
{
    UITextField *searchText;
    int searchTyep;
    int type;
}

//-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self)
//    {
//        self.hidesBottomBarWhenPushed = YES;
//    }
//    return self;
//}
-(NSMutableArray*)searchArr{
    if (_searchArr ==nil) {
        _searchArr =[[NSMutableArray alloc]init];
    }
    return _searchArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavBarViewAndTitle:@""];
    searchTyep =0;
    type=1;
    //搜索
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(40, 25, kScreenWidth-80, 30)];
    searchView.backgroundColor = kCustomColor(232, 233, 234);
    searchView.layer.cornerRadius = 3;
    [self.navView addSubview:searchView];
    
   
    
    searchText = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, searchView.width-50, 30)];
    searchText.placeholder = @"请输入搜索内容";
    searchText.borderStyle = UITextBorderStyleNone;
    searchText.delegate = self;
    searchText.returnKeyType = UIReturnKeySearch;
    searchText.font = [UIFont systemFontOfSize:14];
    [searchView addSubview:searchText];
    
    UIButton *cancelBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    cancelBtn.frame = CGRectMake(kScreenWidth-35, 25, 30, 30);
    [cancelBtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelBtn addTarget:self action:@selector(didClickCancelBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.navView addSubview:cancelBtn];
    
    //tab
    _tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 40)];
    _tempView.backgroundColor = kCustomColor(251, 250, 250);
    [self.view addSubview:_tempView] ;
    NSArray *nameArr;
    int length;
    if (searchTyep ==0) {
        nameArr= @[@"商品",@"品牌",@"买手",@"商场"];
        length=4;
    }else{
        nameArr= @[@"商品",@"品牌",@"买手"];
        length=3;
    }
    for (int i=0; i<length; i++)
    {
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(_tempView.width/length*i, 0, _tempView.width/length, 35)];
        
        lab.userInteractionEnabled = YES;
        lab.font = [UIFont systemFontOfSize:13];
        lab.backgroundColor = [UIColor clearColor];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = [UIColor grayColor];
        lab.text = [nameArr objectAtIndex:i];
        lab.tag=1000+i;
        [_tempView addSubview:lab];
        if (i==0)
        {
            lab.textColor = [UIColor orangeColor];
            lab.font = [UIFont systemFontOfSize:15];
            
            self.lineLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _tempView.width/5, 3)];
            self.lineLab.center = CGPointMake(lab.center.x, 38);
            self.lineLab.backgroundColor = [UIColor orangeColor];
            [_tempView addSubview:self.lineLab];
        }
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelect:)];
        [lab addGestureRecognizer:tap];
    }
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 39+64-0.5, kScreenWidth, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lineView];

    
    //tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, lineView.bottom, kScreenWidth, kScreenHeight-lineView.bottom) style:(UITableViewStylePlain)];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView =[[UIView alloc]init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.tableView.backgroundColor =kCustomColor(228, 234, 238);
}

-(void)didSelect:(UITapGestureRecognizer *)tap
{
    if (tap.view.tag==1000)
    {
//        [self activityDismiss];
        [self scrollToBuyerStreet];
    }
    else if(tap.view.tag==1001)
    {
//        [self activityDismiss];
        [self scrollToSaid];
    }
    else if(tap.view.tag==1002)
    {
//        [self activityDismiss];
        [self scrollToMyBuyer];
    }
    else
    {
        [self scrollToMyBuyer1];
    }
}

//商品
-(void)scrollToBuyerStreet
{
    UILabel *lab1 = (UILabel *)[_tempView viewWithTag:1000];
    UILabel *lab2 = (UILabel *)[_tempView viewWithTag:1001];
    UILabel *lab3 = (UILabel *)[_tempView viewWithTag:1002];
    UILabel *lab4 = (UILabel *)[_tempView viewWithTag:1003];
    
    [UIView animateWithDuration:0.1 animations:^{
        self.lineLab.center = CGPointMake(lab1.center.x, 38);
    }];
    lab1.textColor = [UIColor orangeColor];
    lab1.font = [UIFont systemFontOfSize:15];
    lab2.textColor = [UIColor grayColor];
    lab2.font = [UIFont systemFontOfSize:13];
    lab3.textColor = [UIColor grayColor];
    lab3.font = [UIFont systemFontOfSize:13];
    lab4.textColor = [UIColor grayColor];
    lab4.font = [UIFont systemFontOfSize:13];
//    self.pageNum=1;
    type=1;
    [self.tableView reloadData];

//    isRefresh =YES;
//    [self setData];
//    
}

//待付款
-(void)scrollToSaid
{
    UILabel *lab1 = (UILabel *)[_tempView viewWithTag:1000];
    UILabel *lab2 = (UILabel *)[_tempView viewWithTag:1001];
    UILabel *lab3 = (UILabel *)[_tempView viewWithTag:1002];
    UILabel *lab4 = (UILabel *)[_tempView viewWithTag:1003];
    
    [UIView animateWithDuration:0.1 animations:^{
        self.lineLab.center = CGPointMake(lab2.center.x, 38);
    }];
    lab2.textColor = [UIColor orangeColor];
    lab2.font = [UIFont systemFontOfSize:15];
    lab1.textColor = [UIColor grayColor];
    lab1.font = [UIFont systemFontOfSize:13];
    lab3.textColor = [UIColor grayColor];
    lab3.font = [UIFont systemFontOfSize:13];
    lab4.textColor = [UIColor grayColor];
    lab4.font = [UIFont systemFontOfSize:13];
//    isRefresh =YES;
//    self.pageNum=1;
    type=2;
    [self.tableView reloadData];

//    [self setData];
    
    
}
//专柜自提
-(void)scrollToMyBuyer
{
    UILabel *lab1 = (UILabel *)[_tempView viewWithTag:1000];
    UILabel *lab2 = (UILabel *)[_tempView viewWithTag:1001];
    UILabel *lab3 = (UILabel *)[_tempView viewWithTag:1002];
    UILabel *lab4 = (UILabel *)[_tempView viewWithTag:1003];
    
    [UIView animateWithDuration:0.1 animations:^{
        self.lineLab.center = CGPointMake(lab3.center.x, 38);
    }];
    lab3.textColor = [UIColor orangeColor];
    lab3.font = [UIFont systemFontOfSize:15];
    lab4.textColor = [UIColor grayColor];
    lab4.font = [UIFont systemFontOfSize:13];
    lab2.textColor = [UIColor grayColor];
    lab2.font = [UIFont systemFontOfSize:13];
    lab1.textColor = [UIColor grayColor];
    lab1.font = [UIFont systemFontOfSize:13];
//    isRefresh =YES;
//    self.pageNum=1;
    type=3;
    [self.tableView reloadData];

//    [self setData];
    
    
}
//售后中心
-(void)scrollToMyBuyer1
{
    UILabel *lab1 = (UILabel *)[_tempView viewWithTag:1000];
    UILabel *lab2 = (UILabel *)[_tempView viewWithTag:1001];
    UILabel *lab3 = (UILabel *)[_tempView viewWithTag:1002];
    UILabel *lab4 = (UILabel *)[_tempView viewWithTag:1003];
    
    [UIView animateWithDuration:0.1 animations:^{
        self.lineLab.center = CGPointMake(lab4.center.x, 38);
    }];
    lab4.textColor = [UIColor orangeColor];
    lab4.font = [UIFont systemFontOfSize:15];
    lab3.textColor = [UIColor grayColor];
    lab3.font = [UIFont systemFontOfSize:13];
    lab2.textColor = [UIColor grayColor];
    lab2.font = [UIFont systemFontOfSize:13];
    lab1.textColor = [UIColor grayColor];
    lab1.font = [UIFont systemFontOfSize:13];
    
//    isRefresh=YES;
//    self.pageNum=1;
    type=4;
//    [self setData];
    [self.tableView reloadData];
    
    
}

-(void)didClickCancelBtn
{

}
#pragma mark tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (type ==1) {
        static NSString *iden = @"cell1";
        CusShoppingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
        if (cell == nil) {
            cell =[[[NSBundle mainBundle] loadNibNamed:@"CusShoppingTableViewCell" owner:self options:nil] lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }else if(type ==2){
        static NSString *iden = @"cell2";
        CusBrandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];

        if (cell == nil) {
            cell =[[[NSBundle mainBundle] loadNibNamed:@"CusBrandTableViewCell" owner:self options:nil] lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if(type ==3){
        static NSString *iden = @"cell3";
        CusBueryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];

        if (cell == nil) {
            cell =[[[NSBundle mainBundle] loadNibNamed:@"CusBueryTableViewCell" owner:self options:nil] lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else if(type ==4){
        static NSString *iden = @"cell4";
        CusShopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
        
        if (cell == nil) {
            cell =[[[NSBundle mainBundle] loadNibNamed:@"CusShopTableViewCell" owner:self options:nil] lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    return nil;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (searchText.text.length==0) {
        [self showHudFailed:@"请输入搜索内容"];
        return NO;
    }
   
    return YES;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (type ==1) {
        return 150;
    }else if (type ==2){
        return 90;
    }else if (type ==3){
        return 200;
    }
    return 80;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [searchText resignFirstResponder];
}

@end
