//
//  FindBueryViewController.m
//  joybar
//
//  Created by joybar on 15/12/1.
//  Copyright © 2015年 卢兴. All rights reserved.
//

#import "FindBueryViewController.h"
#import "CusBueryTableViewCell.h"
#import "CusMainStoreViewController.h"
#import "CusZProDetailViewController.h"
#import "CusRProDetailViewController.h"

@interface FindBueryViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic ,strong) BaseTableView *tableView;
@property (nonatomic ,strong) NSMutableArray *dataArray;
@property (nonatomic ,assign) NSInteger pageNum;
@end

@implementation FindBueryViewController
{
    UITextField *searchText;
    BOOL isRefresh;
}


-(NSMutableArray*)dataArray{
    if (_dataArray ==nil) {
        _dataArray =[[NSMutableArray alloc]init];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavBarViewAndTitle:@""];
    isRefresh=YES;

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
    if (self.serachText.length>0) {
        searchText.text =self.serachText;
    }
    
    UIButton *cancelBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    cancelBtn.frame = CGRectMake(kScreenWidth-35, 25, 30, 30);
    [cancelBtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelBtn addTarget:self action:@selector(didClickCancelBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.navView addSubview:cancelBtn];
    
    //tableView
    self.tableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) style:(UITableViewStylePlain)];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView =[[UIView alloc]init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor =kCustomColor(228, 234, 238);
    
    self.pageNum=1;
    self.tableView.tableFooterView =[[UIView alloc]init];
    __weak FindBueryViewController *VC = self;
    self.tableView.headerRereshingBlock = ^()
    {
        if (VC.dataArray.count>0) {
            VC.dataArray =nil;
        }
        VC.pageNum=1;
        [VC setData];
    };
    self.tableView.footerRereshingBlock = ^()
    {
        VC.pageNum++;
        [VC setData];
    };
    
    [self setData];
}

-(void)setData{
    if (searchText.text.length==0) {
        [HUD showHudFailed:@"请输入搜索关键字"];
        return;
    }
    
    if (isRefresh) {
        [self showInView:self.view WithPoint:CGPointMake(0, 64) andHeight:kScreenHeight-64];
    }
    
    NSString *userId =[NSString stringWithFormat:@"%@",[[Public getUserInfo] objectForKey:@"id"]];
    NSMutableDictionary *dict =[[NSMutableDictionary alloc]init];
    //    [dict setObject:searchText.text forKey:@"key"];
    [dict setObject:@"" forKey:@"key"];
    
    [dict setValue:[NSString stringWithFormat:@"%ld",(long)self.pageNum] forKey:@"Page"];
    [dict setObject:@"6" forKey:@"Pagesize"];
    [dict setObject:userId forKey:@"userId"];
    [dict setObject:self.longitude forKey:@"longitude"];
    [dict setObject:self.latitude forKey:@"latitude"];
    
    [HttpTool postWithURL:@"v3/searchbuyer" params:dict  success:^(id json) {
        BOOL  isSuccessful =[[json objectForKey:@"isSuccessful"] boolValue];
        if (isSuccessful) {
            NSMutableArray *array =[[json objectForKey:@"data"]objectForKey:@"items"];
            
            isRefresh =NO;
            if (array.count<6) {
                [self.tableView hiddenFooter:YES];
            }
            else
            {
                [self.tableView hiddenFooter:NO];
            }
            if (self.pageNum==1) {
                [self.dataArray removeAllObjects];
                [self.dataArray addObjectsFromArray:array];
            }else{
                [self.dataArray addObjectsFromArray:array];
            }
        }else{
            [self showHudFailed:[json objectForKey:@"message"]];
        }
        [self.tableView endRefresh];
        [self.tableView reloadData];
        [self activityDismiss];
        
    } failure:^(NSError *error) {
        [self showHudFailed:@"服务器正在维护,请稍后再试"];
        [self.tableView endRefresh];
        [self activityDismiss];
    }];
}
-(void)didClickCancelBtn{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *iden = @"cell";
    CusBueryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    
    if (cell == nil) {
        cell =[[[NSBundle mainBundle] loadNibNamed:@"CusBueryTableViewCell" owner:self options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.dataArray.count>0) {
        
        [cell.iconView sd_setImageWithURL:[NSURL URLWithString:[self.dataArray[indexPath.row]objectForKey:@"Logo"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        cell.shopName.text = [self.dataArray[indexPath.row]objectForKey:@"Nickname"];
        cell.addressLab.text =[self.dataArray[indexPath.row]objectForKey:@"BrandName"];
        cell.bgView.tag =indexPath.row+10;
        NSArray *array =[self.dataArray[indexPath.row]objectForKey:@"Products"];
        if (array.count>0) {
            if(array.count ==2){
                cell.shopBtn1.hidden =NO;
                cell.shopBtn2.hidden =YES;
                
                [cell.shopBtn sd_setImageWithURL:[NSURL URLWithString:[array[0]objectForKey:@"Pic"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                [cell.shopBtn1 sd_setImageWithURL:[NSURL URLWithString:[array[1]objectForKey:@"Pic"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                UITapGestureRecognizer *proTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(did1ClickProView:)];
                [cell.shopBtn addGestureRecognizer:proTap];
                proTap.view.tag =[[array[0]objectForKey:@"ProductId"] integerValue] ;
                
                UITapGestureRecognizer *proTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(did2ClickProView:)];
                [cell.shopBtn1 addGestureRecognizer:proTap1];
                proTap1.view.tag =[[array[1]objectForKey:@"ProductId"] integerValue];

                
                
            }else if(array.count ==3){
                cell.shopBtn1.hidden =NO;
                cell.shopBtn2.hidden =NO;
                [cell.shopBtn sd_setImageWithURL:[NSURL URLWithString:[array[0]objectForKey:@"Pic"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                [cell.shopBtn1 sd_setImageWithURL:[NSURL URLWithString:[array[1]objectForKey:@"Pic"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                [cell.shopBtn2 sd_setImageWithURL:[NSURL URLWithString:[array[2]objectForKey:@"Pic"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                UITapGestureRecognizer *proTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(did1ClickProView:)];
                [cell.shopBtn addGestureRecognizer:proTap];
                proTap.view.tag =[[array[0]objectForKey:@"ProductId"] integerValue];
                
                UITapGestureRecognizer *proTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(did2ClickProView:)];
                [cell.shopBtn1 addGestureRecognizer:proTap1];
                proTap1.view.tag =[[array[1]objectForKey:@"ProductId"] integerValue];
                
                UITapGestureRecognizer *proTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(did3ClickProView:)];
                [cell.shopBtn2 addGestureRecognizer:proTap2];
                proTap2.view.tag =[[array[2]objectForKey:@"ProductId"] integerValue];
                
            }else{
                cell.shopBtn1.hidden =YES;
                cell.shopBtn2.hidden =YES;
                
                [cell.shopBtn sd_setImageWithURL:[NSURL URLWithString:[array[0]objectForKey:@"Pic"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                [cell.shopBtn sd_setImageWithURL:[NSURL URLWithString:[array[0]objectForKey:@"Pic"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                UITapGestureRecognizer *proTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(did1ClickProView:)];
                [cell.shopBtn addGestureRecognizer:proTap];
                proTap.view.tag =[[array[0]objectForKey:@"ProductId"] integerValue];

            }
        }
        
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 200;
}
-(void)did1ClickProView:(UITapGestureRecognizer *)tap{
    
    NSInteger tag= [tap.view superview].tag-10;
    NSString *Userleave = [NSString stringWithFormat:@"%@",[self.dataArray[tag]objectForKey:@"Userleave"]];
    if ([Userleave isEqualToString:@"8"])
    {
        //认证买手
        CusRProDetailViewController *VC = [[CusRProDetailViewController alloc] init];
        VC.productId = [NSString stringWithFormat:@"%ld", tap.view.tag];
        [self.navigationController pushViewController:VC animated:YES];
        
    }
    else
    {
        CusZProDetailViewController *VC = [[CusZProDetailViewController alloc] init];
        VC.productId = [NSString stringWithFormat:@"%ld", tap.view.tag];
        [self.navigationController pushViewController:VC animated:YES];
    }
    
}
-(void)did2ClickProView:(UITapGestureRecognizer *)tap{
    
    NSInteger tag= [tap.view superview].tag-10;
    NSString *Userleave = [NSString stringWithFormat:@"%@",[self.dataArray[tag]objectForKey:@"Userleave"]];
    if ([Userleave isEqualToString:@"8"])
    {
        //认证买手
        CusRProDetailViewController *VC = [[CusRProDetailViewController alloc] init];
        VC.productId = [NSString stringWithFormat:@"%ld", tap.view.tag];
        [self.navigationController pushViewController:VC animated:YES];
        
    }
    else
    {
        CusZProDetailViewController *VC = [[CusZProDetailViewController alloc] init];
        VC.productId = [NSString stringWithFormat:@"%ld", tap.view.tag];
        [self.navigationController pushViewController:VC animated:YES];
    }
    
}
-(void)did3ClickProView:(UITapGestureRecognizer *)tap{
    
    NSInteger tag= [tap.view superview].tag-10;
    NSString *Userleave = [NSString stringWithFormat:@"%@",[self.dataArray[tag]objectForKey:@"Userleave"]];
    if ([Userleave isEqualToString:@"8"])
    {
        //认证买手
        CusRProDetailViewController *VC = [[CusRProDetailViewController alloc] init];
        VC.productId = [NSString stringWithFormat:@"%ld", tap.view.tag];
        [self.navigationController pushViewController:VC animated:YES];
        
    }
    else
    {
        CusZProDetailViewController *VC = [[CusZProDetailViewController alloc] init];
        VC.productId = [NSString stringWithFormat:@"%ld", tap.view.tag];
        [self.navigationController pushViewController:VC animated:YES];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CusMainStoreViewController * mainStore =[[CusMainStoreViewController alloc]init];
    mainStore.userId =[self.dataArray[indexPath.row]objectForKey:@"BuyerId"];
    mainStore.isCircle = NO;
    [self.navigationController pushViewController:mainStore animated:YES];
}
@end
