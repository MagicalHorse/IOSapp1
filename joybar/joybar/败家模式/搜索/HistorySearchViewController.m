//
//  HistorySearchViewController.m
//  joybar
//
//  Created by joybar on 15/11/19.
//  Copyright © 2015年 卢兴. All rights reserved.
//

#import "HistorySearchViewController.h"
#import "SearchDetailsViewController.h"
#import "FindBueryViewController.h"

@interface HistorySearchViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) NSMutableDictionary *searchArr;
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
-(NSMutableDictionary*)searchArr{
    if (_searchArr ==nil) {
        _searchArr =[[NSMutableDictionary alloc]init];
    }
    return _searchArr;
}
-(void)getSearchArray{
    NSMutableDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"searchArr"];
    
    
    for (NSString *dict in dic.allKeys) {
        [self.searchArr setValue:[dic objectForKey:dict] forKey:dict];
    }
    
   
    
   //(NSMutableArray *)[[dic reverseObjectEnumerator] allObjects];
    [self.tableView reloadData];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self getSearchArray];
    if (self.searchArr.count ==0) {
        self.tableView.tableFooterView =[[UIView alloc]init];
        self.tableView.tableHeaderView =[[UIView alloc]init];
    }else{
        self.tableView.tableFooterView =[self tableViewFootView];
        self.tableView.tableHeaderView =[self tableViewHeadView];
    }

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
//    [searchText addTarget:self action:@selector(textChage:) forControlEvents:UIControlEventEditingChanged];
    
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

}

-(UIView *)tableViewFootView{
    
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    UIView * bgView =[[UIView alloc]initWithFrame:CGRectMake(17, view.top, kScreenWidth-18, 0.5)];
    [view addSubview:bgView];

    UIButton *btn =[[UIButton alloc]initWithFrame:CGRectMake((kScreenWidth-120)*0.5, bgView.bottom+8, 120, 34)];
    btn.layer.borderWidth =1;
    btn.layer.borderColor= [UIColor orangeColor].CGColor;
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius =2.5;

    [btn setTitle:@"清除搜索历史" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clearData) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font =[UIFont systemFontOfSize:16];
    bgView.backgroundColor =[UIColor lightGrayColor];
    [view addSubview:btn];
    return view;

    
}
-(UIView *)tableViewHeadView{
     UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    UILabel *lable =[[UILabel alloc]initWithFrame:CGRectMake(17, 0, kScreenWidth-20, 39)];
    lable.text =@"搜索历史";
    lable.textColor =[UIColor lightGrayColor];
    lable.font =[UIFont systemFontOfSize:15];
    [view addSubview:lable];
    
    UIView * bgView =[[UIView alloc]initWithFrame:CGRectMake(17, lable.bottom, kScreenWidth-18, 0.5)];
    bgView.backgroundColor =[UIColor lightGrayColor];
    [view addSubview:bgView];
    return view;
}
-(void)clearData{
    self.searchArr =nil ;
    [[NSUserDefaults standardUserDefaults] setObject:self.searchArr forKey:@"searchArr"];
    [self.tableView reloadData];
    if (self.searchArr.count ==0) {
        self.tableView.tableFooterView =[[UIView alloc]init];
        self.tableView.tableHeaderView =[[UIView alloc]init];

    }else{
        self.tableView.tableFooterView =[self tableViewFootView];
        self.tableView.tableHeaderView =[self tableViewHeadView];

    }

}
-(void)initsearchArr :(NSMutableDictionary *)array{
   
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
    if (self.searchArr.count>0) {
        cell.textLabel.text =[self.searchArr objectForKey:[NSString stringWithFormat:@"%ld",indexPath.row]];

    }
    return cell;
}

//-(void)textChage:(UITextField *)textField{
//    
//    NSString *text =textField.text;
//    if (text.length>0) {
//        NSMutableDictionary *showDict=[NSMutableDictionary dictionary];
//        int  i =0;
//        for (NSString *str in self.searchArr.allValues) {
//            
//            if([text rangeOfString:str].location !=NSNotFound)
//            {
//               
//                [showDict setValue:str forKey:[NSString stringWithFormat:@"%d",i]];
//                i++;
//            }
//        }
//        if (showDict.count>0) {
//            self.searchArr =showDict;
//        }
//        [self.tableView reloadData];
//    }
//    
//}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    if (searchText.text.length==0) {
        [self showHudFailed:@"请输入搜索内容"];
        return NO;
    }
    
    if ([self.clickType isEqualToString:@"FindShopGuideViewController"]) {
        FindBueryViewController *find =[[FindBueryViewController alloc]init];
        find.serachText =textField.text;
        [self.navigationController pushViewController:find animated:YES];
        
    }else{
        
        SearchDetailsViewController *details= [[SearchDetailsViewController alloc]init];
        details.cityId =self.cityId; //城市id
        //    经纬度
        details.latitude= self.latitude;
        details.longitude= self.longitude;
        //    details.cityId=@"0";
        //    details.latitude= @"116.315811";
        //    details.longitude= @"39.961441";
        
        NSMutableDictionary * temp =[NSMutableDictionary dictionary];
        
        for (NSString * str in self.searchArr.allValues) {
            if ([textField.text isEqualToString:str]) {
                details.serachText = searchText.text;
                [self.navigationController pushViewController:details animated:YES];
                return YES;
            }
        }
        
        
        [temp setValue:textField.text forKey:@"0"];
        
        for (int i=0; i<self.searchArr.count; i++) {
            if (i ==9) {
                break;
            }
            
            [temp setValue:[self.searchArr objectForKey:[NSString stringWithFormat:@"%d",i]] forKey:[NSString stringWithFormat:@"%d",i+1]];
        }
        [self initsearchArr: temp];
        
        
        
        details.serachText = searchText.text;
        [self.navigationController pushViewController:details animated:YES];
    }
    
    return YES;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    [searchText resignFirstResponder];
    
    if ([self.clickType isEqualToString:@"FindShopGuideViewController"]) {
        FindBueryViewController *find =[[FindBueryViewController alloc]init];
        find.serachText =[self.searchArr objectForKey:[NSString stringWithFormat:@"%ld",indexPath.row]];
        [self.navigationController pushViewController:find animated:YES];
        
    }else{
    
        SearchDetailsViewController *details= [[SearchDetailsViewController alloc]init];
        details.serachText = [self.searchArr objectForKey:[NSString stringWithFormat:@"%ld",indexPath.row]];
        //    details.cityId =self.cityId; //城市id
        //经纬度
        //    details.latitude= self.latitude;
        //    details.longitude= self.longitude;
        details.cityId=@"0";
        details.latitude= @"116.315811";
        details.longitude= @"39.961441";
        
        [self.navigationController pushViewController:details animated:YES];
    }
    
    
   

}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [searchText resignFirstResponder];
}
@end
