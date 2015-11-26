//
//  HistorySearchViewController.m
//  joybar
//
//  Created by joybar on 15/11/19.
//  Copyright © 2015年 卢兴. All rights reserved.
//

#import "HistorySearchViewController.h"
#import "SearchDetailsViewController.h"

@interface HistorySearchViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) NSMutableArray *searchArr;
@end

@implementation HistorySearchViewController
{
    UITextField *searchText;
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
-(NSMutableArray*)searchArr{
    if (_searchArr ==nil) {
        _searchArr =[[NSMutableArray alloc]init];
    }
    return _searchArr;
}
-(void)getSearchArray{
    NSMutableArray *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"searchArr"];
    
    self.searchArr =  dic;//(NSMutableArray *)[[dic reverseObjectEnumerator] allObjects];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavBarViewAndTitle:@""];
    self.retBtn.hidden = YES;
    
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(15, 25, kScreenWidth-70, 30)];
    searchView.backgroundColor = kCustomColor(225, 227, 229);
    searchView.layer.cornerRadius = 3;
    [self.navView addSubview:searchView];
    
    UIImageView  *searchImage = [[UIImageView alloc] initWithFrame:CGRectMake(6, 6, 17, 17)];
    searchImage.image = [UIImage imageNamed:@"search"];
    [searchView addSubview:searchImage];
    
    searchText = [[UITextField alloc] initWithFrame:CGRectMake(searchImage.right+10, 0, searchView.width-50, 30)];
    searchText.placeholder = @"请输入搜索内容";
    searchText.borderStyle = UITextBorderStyleNone;
    searchText.delegate = self;
    searchText.returnKeyType = UIReturnKeySearch;
    searchText.font = [UIFont systemFontOfSize:14];
    [searchView addSubview:searchText];
    
    UIButton *cancelBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    cancelBtn.frame = CGRectMake(kScreenWidth-50, 25, 50, 30);
    cancelBtn.backgroundColor = [UIColor clearColor];
    [cancelBtn setTitle:@"取消" forState:(UIControlStateNormal)];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelBtn addTarget:self action:@selector(didClickCancelBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.navView addSubview:cancelBtn];
    
    //tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) style:(UITableViewStylePlain)];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView =[[UIView alloc]init];
    [self getSearchArray];
}

-(void)initsearchArr :(NSMutableArray *)array{
   
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"searchArr"];
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"searchArr"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


-(void)didClickCancelBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchArr.count;
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
    
    cell.textLabel.text =self.searchArr[indexPath.row];
    return cell;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    if (searchText.text.length==0) {
        [self showHudFailed:@"请输入搜索内容"];
        return NO;
    }
    NSMutableArray *array =[NSMutableArray arrayWithArray:self.searchArr];
    if (array.count==10) {
        [array removeObjectAtIndex:0];
    }
    [array addObject:searchText.text];
    [self initsearchArr: array];
   SearchDetailsViewController *details= [[SearchDetailsViewController alloc]init];
    details.serachText = searchText.text;
    [self.navigationController pushViewController:details animated:YES];
    return YES;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [searchText resignFirstResponder];
}
@end
