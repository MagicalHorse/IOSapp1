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
#import "CusZProDetailViewController.h"
#import "CusRProDetailViewController.h"
#import "CusBrandDetailViewController.h"
#import "CusMarketViewController.h"
#import "CusMainStoreViewController.h"
#import "BaseNavigationController.h"
#import "LoginAndRegisterViewController.h"

@interface SearchDetailsViewController()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic ,strong) BaseTableView *tableView;
@property (nonatomic ,strong) NSMutableArray *searchArr;
@property (nonatomic ,strong) NSMutableArray *searchArr1;
@property (nonatomic ,strong) NSMutableArray *searchArr2;
@property (nonatomic ,strong) NSMutableArray *searchArr3;

@property (nonatomic ,strong) UILabel *lineLab;
@property (nonatomic ,strong) UIView *tempView;
@property (nonatomic ,assign) NSInteger pageNum;
@end

@implementation SearchDetailsViewController
{
    UITextField *searchText;
    int type;
    BOOL isRefresh;
}


-(NSMutableArray*)searchArr{
    if (_searchArr ==nil) {
        _searchArr =[[NSMutableArray alloc]init];
    }
    return _searchArr;
}
-(NSMutableArray*)searchArr1{
    if (_searchArr1 ==nil) {
        _searchArr1 =[[NSMutableArray alloc]init];
    }
    return _searchArr1;
}
-(NSMutableArray*)searchArr2{
    if (_searchArr2 ==nil) {
        _searchArr2 =[[NSMutableArray alloc]init];
    }
    return _searchArr2;
}
-(NSMutableArray*)searchArr3{
    if (_searchArr3 ==nil) {
        _searchArr3 =[[NSMutableArray alloc]init];
    }
    return _searchArr3;
}

-(void)setData{
    if (searchText.text.length==0) {
        
        searchText.text =@"";
    }
    
    if (isRefresh) {
        [self showInView:self.view WithPoint:CGPointMake(0, 64+40) andHeight:kScreenHeight-64-40];
    }else{
        [self hudShow:@"正在加载"];
    }
    
    NSString *userId =[NSString stringWithFormat:@"%@",[[Public getUserInfo] objectForKey:@"id"]];
    NSString *url;
    NSMutableDictionary *dict =[[NSMutableDictionary alloc]init];
    [dict setObject:searchText.text forKey:@"key"];

    [dict setObject:self.cityId forKey:@"ciryId"];
    if (self.storeId) {
        [dict setObject:self.storeId forKey:@"StoreId"];
    }
    [dict setValue:[NSString stringWithFormat:@"%ld",(long)self.pageNum] forKey:@"Page"];
    [dict setObject:@"6" forKey:@"Pagesize"];
    if (type ==1) {
        url =@"v3/searchproduct";
        [dict setObject:userId forKey:@"userId"];
        [dict setObject:@"5" forKey:@"SortType"];

    }else if(type ==2){
        url =@"v3/searchBrand";
        
    }else if(type ==3){
        url =@"v3/searchbuyer";
        [dict setObject:userId forKey:@"userId"];
        if (self.longitude) {
            [dict setObject:self.longitude forKey:@"longitude"];
        }
        if (self.latitude) {
            [dict setObject:self.latitude forKey:@"latitude"];
        }
    }else if(type ==4){
        url =@"v3/searchstore";
        [dict setObject:self.longitude forKey:@"longitude"];
        [dict setObject:self.latitude forKey:@"latitude"];
       
    }
    
    [HttpTool postWithURL:url params:dict isWrite:NO  success:^(id json) {
        BOOL  isSuccessful =[[json objectForKey:@"isSuccessful"] boolValue];
        if (isSuccessful) {
            NSMutableArray *array =[[json objectForKey:@"data"]objectForKey:@"items"];
            if (type==1) {
                if (array.count<6) {
                    [self.tableView hiddenFooter:YES];
                }
                else
                {
                    [self.tableView hiddenFooter:NO];
                }
                if (self.pageNum==1) {
                    [self.searchArr removeAllObjects];
                    [self.searchArr addObjectsFromArray:array];
                }else{
                    [self.searchArr addObjectsFromArray:array];
                }
                
            }else if(type ==2){
                if (array.count<6) {
                    [self.tableView hiddenFooter:YES];
                }
                else
                {
                    [self.tableView hiddenFooter:NO];
                }
                if (self.pageNum==1) {
                    [self.searchArr1 removeAllObjects];
                    [self.searchArr1 addObjectsFromArray:array];
                }else{
                    [self.searchArr1 addObjectsFromArray:array];
                }

            }else if(type ==3){

                if (array.count<6) {
                    [self.tableView hiddenFooter:YES];
                }
                else
                {
                    [self.tableView hiddenFooter:NO];
                }
                if (self.pageNum==1) {
                    [self.searchArr2 removeAllObjects];
                    [self.searchArr2 addObjectsFromArray:array];
                }else{
                    [self.searchArr2 addObjectsFromArray:array];
                }

            }else if(type ==4){
                if (array.count<6) {
                    [self.tableView hiddenFooter:YES];
                }
                else
                {
                    [self.tableView hiddenFooter:NO];
                }
                if (self.pageNum==1) {
                    [self.searchArr3 removeAllObjects];
                    [self.searchArr3 addObjectsFromArray:array];
                }else{
                    [self.searchArr3 addObjectsFromArray:array];
                }
            }
            
        }else{
            if (type==1) {
                self.searchArr =nil;
            }else if(type ==2){
                self.searchArr1 =nil;
            }else if(type ==3){
                self.searchArr2 =nil;
            }else if(type ==4){
                self.searchArr3 =nil;
            }
            [self showHudFailed:[json objectForKey:@"message"]];
        }
        isRefresh =NO;
        [self textHUDHiddle];
        [self.tableView endRefresh];
        [self.tableView reloadData];
        [self activityDismiss];

    } failure:^(NSError *error) {
        [self textHUDHiddle];
        [self showHudFailed:@"服务器正在维护,请稍后再试"];
        [self.tableView endRefresh];
        [self activityDismiss];
        isRefresh =NO;
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavBarViewAndTitle:@""];
    type=1;
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
    
    //tab
    _tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 40)];
    _tempView.backgroundColor = kCustomColor(251, 250, 250);
    [self.view addSubview:_tempView] ;
    NSArray *nameArr;
    int length;
    if (self.cusSearchType ==1) {
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
    self.tableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, lineView.bottom, kScreenWidth, kScreenHeight-lineView.bottom) style:(UITableViewStylePlain)];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView =[[UIView alloc]init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor =kCustomColor(228, 234, 238);
    
    self.pageNum=1;
    self.tableView.tableFooterView =[[UIView alloc]init];
    __weak SearchDetailsViewController *VC = self;
    self.tableView.headerRereshingBlock = ^()
    {
        if (VC.searchArr.count>0) {
            VC.searchArr =nil;
        }else if(VC.searchArr1.count>0) {
            VC.searchArr1 =nil;
        }else if(VC.searchArr2.count>0) {
            VC.searchArr2 =nil;
        }else if(VC.searchArr3.count>0) {
            VC.searchArr3 =nil;
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

-(void)didSelect:(UITapGestureRecognizer *)tap
{
    [self activityDismiss];
    if (tap.view.tag==1000)
    {
        type=1;
      
        self.pageNum=1;
        [self setData];
        [self scrollToBuyerStreet];
    }
    else if(tap.view.tag==1001)
    {
        type=2;
        self.pageNum=1;
        [self setData];
        [self scrollToSaid];
    }
    else if(tap.view.tag==1002)
    {
        type=3;
        self.pageNum=1;
        [self setData];
        [self scrollToMyBuyer];
    }
    else
    {
        type=4;
        self.pageNum=1;
        [self setData];
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
   
    
    
}

-(void)didClickCancelBtn
{
    [searchText resignFirstResponder];
    [self setData];

}
#pragma mark tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (type ==1) {
       return self.searchArr.count;
    }else if(type ==2){
        return self.searchArr1.count;
    }
    else if(type ==3){
        return self.searchArr2.count;
    }
    else if(type ==4){
        return self.searchArr3.count;
    }
    return 0;
}

-(void)chBtnClick:(UIButton *)btn{

    
    NSDictionary *dicUser = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    if (!dicUser)
    {
        LoginAndRegisterViewController *VC = [[LoginAndRegisterViewController alloc] init];
        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:VC];
        [self presentViewController:nav animated:YES completion:nil];
        return;
    }
    
    BOOL tempState =[[self.searchArr[btn.tag]objectForKey:@"IsFavorite"]boolValue];
    NSString *stroeId =[self.searchArr[btn.tag]objectForKey:@"ProductId"];

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:stroeId forKey:@"Id"];
    if (tempState)
    {
        [dic setValue:@"0" forKey:@"Status"];
        btn.selected = NO;
    }
    else
    {
        [dic setValue:@"1" forKey:@"Status"];
        btn.selected = YES;

    }
    [HttpTool postWithURL:@"Product/Favorite" params:dic isWrite:YES  success:^(id json) {
        
        if ([json objectForKey:@"isSuccessful"])
        {
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.searchArr[btn.tag]];
            if (tempState)
            {
                [dic setObject:@"0" forKey:@"IsFavorite"];
            }
            else
            {
                [dic setObject:@"1" forKey:@"IsFavorite"];
            }
            [self.searchArr removeObject:self.searchArr[btn.tag]];
            [self.searchArr insertObject:dic atIndex:btn.tag];
        }
        else
        {
            [self showHudFailed:[json objectForKey:@"message"]];
        }
        
    } failure:^(NSError *error) {
    }];
    
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
        if (self.searchArr.count>0) {
            [cell.shopIconView sd_setImageWithURL:[NSURL URLWithString:[self.searchArr[indexPath.row]objectForKey:@"Pic"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            cell.priceLab.text =[[self.searchArr[indexPath.row]objectForKey:@"Price"] stringValue];
            BOOL isFavite =[[self.searchArr[indexPath.row]objectForKey:@"IsFavorite"]boolValue];
            if (isFavite) {
                cell.chCBtn.selected =YES;
            }else{
                cell.chCBtn.selected =NO;
            }
            cell.chCBtn.tag =indexPath.row;
            [cell.chCBtn addTarget:self action:@selector(chBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            cell.desLab.text =[self.searchArr[indexPath.row]objectForKey:@"ProductName"];
        }
        
    
        return cell;

    }else if(type ==2){
        static NSString *iden = @"cell2";
        CusBrandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];

        if (cell == nil) {
            cell =[[[NSBundle mainBundle] loadNibNamed:@"CusBrandTableViewCell" owner:self options:nil] lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.searchArr1.count>0) {
            [cell.iconView sd_setImageWithURL:[NSURL URLWithString:[self.searchArr1[indexPath.row]objectForKey:@"Pic"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            cell.decLab.text =[self.searchArr1[indexPath.row]objectForKey:@"BrandName"];

        }
        
        return cell;
    }
    else if(type ==3){
        static NSString *iden = @"cell3";
        CusBueryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];

        if (cell == nil) {
            cell =[[[NSBundle mainBundle] loadNibNamed:@"CusBueryTableViewCell" owner:self options:nil] lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.searchArr2.count>0) {
            
            [cell.iconView sd_setImageWithURL:[NSURL URLWithString:[self.searchArr2[indexPath.row]objectForKey:@"Logo"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            cell.shopName.text = [self.searchArr2[indexPath.row]objectForKey:@"Nickname"];
            cell.addressLab.text =[self.searchArr2[indexPath.row]objectForKey:@"BrandName"];
            BOOL isFavite =[[self.searchArr2[indexPath.row]objectForKey:@"IsFllowed"]boolValue];
            if (isFavite) {
                cell.guanzhuBtn.selected =YES;
                cell.guanzhuBtn.backgroundColor =[UIColor whiteColor];
                cell.guanzhuBtn.layer.borderWidth=1;
                cell.guanzhuBtn.layer.borderColor =[UIColor lightGrayColor].CGColor;
                [cell.guanzhuBtn setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
            }else{
                cell.guanzhuBtn.selected =NO;
                cell.guanzhuBtn.backgroundColor =[UIColor orangeColor];
                [cell.guanzhuBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
            
            [cell.guanzhuBtn addTarget:self action:@selector(guanzhuClick:) forControlEvents:UIControlEventTouchUpInside];
            cell.guanzhuBtn.tag =indexPath.row +100;
            NSArray *array =[self.searchArr2[indexPath.row]objectForKey:@"Products"];
            cell.bgView.tag =indexPath.row +10;
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
                    UITapGestureRecognizer *proTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(did1ClickProView:)];
                    [cell.shopBtn addGestureRecognizer:proTap];
                    proTap.view.tag =[[array[0]objectForKey:@"ProductId"] integerValue];


                }
            }else{
                cell.shopBtn.hidden =YES;
                cell.shopBtn1.hidden =YES;
                cell.shopBtn2.hidden =YES;
                UILabel *lable =[[UILabel alloc]initWithFrame:CGRectMake(0, cell.shopBtn.top+10, cell.width, 20)];
                lable.text =@"店铺什么都没有，戳一下，提醒上新~";
                lable.textAlignment =NSTextAlignmentCenter;
                lable.font =[UIFont systemFontOfSize:13];
                lable.textColor =[UIColor grayColor];
                [cell addSubview:lable];
                
              UIButton *btn=  [[UIButton alloc]initWithFrame:CGRectMake((cell.width-100)*0.5, lable.bottom+10, 100, 40)];
        
                btn.backgroundColor =[UIColor orangeColor];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [btn setTitle:@"提醒上新" forState:UIControlStateNormal];
                btn.titleLabel.font =[UIFont systemFontOfSize:13];
                [btn addTarget:self action:@selector(txUptoNew:) forControlEvents:UIControlEventTouchUpInside];
                btn.tag =[[self.searchArr2[indexPath.row]objectForKey:@"UserId"]integerValue];
                [cell addSubview:btn];
            }
        }
        
        return cell;
        
    }else if(type ==4){
        static NSString *iden = @"cell4";
        CusShopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
        
        if (cell == nil) {
            cell =[[[NSBundle mainBundle] loadNibNamed:@"CusShopTableViewCell" owner:self options:nil] lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.searchArr3.count>0) {
            [cell.iconView sd_setImageWithURL:[NSURL URLWithString:[self.searchArr3[indexPath.row]objectForKey:@"StoreLogo"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            cell.shopName.text =[self.searchArr3[indexPath.row]objectForKey:@"StoreName"];
            cell.addressLab.text =[self.searchArr3[indexPath.row]objectForKey:@"StoreLocation"];
            NSString *tempJu= [Public getDistanceWithLocation:[self.longitude doubleValue] and:[self.latitude doubleValue] and:[[self.searchArr3[indexPath.row]objectForKey:@"Lat"] doubleValue] and:[[self.searchArr3[indexPath.row]objectForKey:@"Lon"] doubleValue]];
            double juli =[tempJu doubleValue] *0.001;
            cell.juliView.text = [NSString stringWithFormat:@"%.2fkm",juli];
        }
        return cell;
    }
    
    return nil;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self setData];
    return YES;
}

-(void)txUptoNew:(UIButton *)btn{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[NSString stringWithFormat:@"%d",btn.tag] forKey:@"buyerid"];
    [HttpTool postWithURL:@"BuyerV3/Touch" params:dic isWrite:YES  success:^(id json) {
        
        if ([json objectForKey:@"isSuccessful"])
        {
            [btn setTitle:@"已提醒上新" forState:UIControlStateNormal];
        }
        else
        {
            [self showHudFailed:[json objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        
    }];

    
}
-(void)guanzhuClick:(UIButton *)btn{
    
    NSDictionary *dicUser = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    if (!dicUser)
    {
        LoginAndRegisterViewController *VC = [[LoginAndRegisterViewController alloc] init];
        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:VC];
        [self presentViewController:nav animated:YES completion:nil];
        return;
    }


    BOOL tempState =[[self.searchArr2[btn.tag-100]objectForKey:@"IsFllowed"]boolValue];
    NSString *buyerId =[self.searchArr2[btn.tag-100]objectForKey:@"UserId"];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:buyerId forKey:@"FavoriteId"];
    if (tempState)
    {
        [dic setValue:@"0" forKey:@"Status"];
        btn.selected = NO;
    }
    else
    {
        [dic setValue:@"1" forKey:@"Status"];
        btn.selected = YES;
    }
    [HttpTool postWithURL:@"User/Favoite" params:dic isWrite:YES  success:^(id json) {
        
        if ([json objectForKey:@"isSuccessful"])
        {
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.searchArr2[btn.tag-100]];
            if (tempState)
            {
                [dic setObject:@"0" forKey:@"IsFllowed"];
            }
            else
            {
                [dic setObject:@"1" forKey:@"IsFllowed"];
            }
            [self.searchArr2 removeObject:self.searchArr2[btn.tag-100]];
            [self.searchArr2 insertObject:dic atIndex:btn.tag-100];
            
        }
        else
        {
            [self showHudFailed:[json objectForKey:@"message"]];
        }
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        [self.tableView reloadData];
    }];

    
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
    
    
    if (type ==1) {
        NSString *Userleave = [NSString stringWithFormat:@"%@",[self.searchArr[indexPath.row]objectForKey:@"Userleave"]];

        if ([Userleave isEqualToString:@"8"])
        {
            CusZProDetailViewController *VC = [[CusZProDetailViewController alloc] init];
            VC.productId = [self.searchArr[indexPath.row]objectForKey:@"ProductId"];
            [self.navigationController pushViewController:VC animated:YES];
        }
        else
        {
            //认证买手
            CusRProDetailViewController *VC = [[CusRProDetailViewController alloc] init];
            VC.productId = [self.searchArr[indexPath.row]objectForKey:@"ProductId"];
            [self.navigationController pushViewController:VC animated:YES];
        }
    }else if(type ==2){
        CusBrandDetailViewController *VC = [[CusBrandDetailViewController alloc] init];
        VC.BrandId = [self.searchArr1[indexPath.row] objectForKey:@"BrandId"];
        VC.BrandName = [self.searchArr1[indexPath.row] objectForKey:@"BrandName"];
        if (self.storeId) {
            VC.storeId =self.storeId;
        }else{
            VC.storeId =@"0";
        }
        if (self.cityId) {
            VC.cityId =self.cityId;

        }else{
            VC.cityId =@"0";
        }
        [self.navigationController pushViewController:VC animated:YES];
        
    }else if(type ==3){
        

        CusMainStoreViewController * mainStore =[[CusMainStoreViewController alloc]init];
        mainStore.userId =[self.searchArr2[indexPath.row]objectForKey:@"UserId"];
        mainStore.isCircle = NO;
        [self.navigationController pushViewController:mainStore animated:YES];
    
    }else if(type ==4){
        CusMarketViewController *VC = [[CusMarketViewController alloc] init];
        //商场
        VC.titleName =[self.searchArr3[indexPath.row]objectForKey:@"StoreName"];
        VC.storeId = [self.searchArr3[indexPath.row] objectForKey:@"StoreId"];
        [self.navigationController pushViewController:VC animated:YES];
    }
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [searchText resignFirstResponder];
}


-(void)did1ClickProView:(UITapGestureRecognizer *)tap{

    NSInteger tag= [tap.view superview].tag-10;
    NSString *Userleave = [NSString stringWithFormat:@"%@",[self.searchArr2[tag]objectForKey:@"Userleave"]];
    if ([Userleave isEqualToString:@"4"])
    {
        //认证买手
        CusRProDetailViewController *VC = [[CusRProDetailViewController alloc] init];
        VC.productId = [NSString stringWithFormat:@"%d", tap.view.tag];
        [self.navigationController pushViewController:VC animated:YES];
        
    }
    else
    {
        CusZProDetailViewController *VC = [[CusZProDetailViewController alloc] init];
        VC.productId = [NSString stringWithFormat:@"%d", tap.view.tag];
        [self.navigationController pushViewController:VC animated:YES];
    }
    
}
-(void)did2ClickProView:(UITapGestureRecognizer *)tap{
    
    NSInteger tag= [tap.view superview].tag-10;
    NSString *Userleave = [NSString stringWithFormat:@"%@",[self.searchArr2[tag]objectForKey:@"Userleave"]];
    if ([Userleave isEqualToString:@"4"])
    {
        //认证买手
        CusRProDetailViewController *VC = [[CusRProDetailViewController alloc] init];
        VC.productId = [NSString stringWithFormat:@"%d", tap.view.tag];
        [self.navigationController pushViewController:VC animated:YES];
        
    }
    else
    {
        CusZProDetailViewController *VC = [[CusZProDetailViewController alloc] init];
        VC.productId = [NSString stringWithFormat:@"%d", tap.view.tag];
        [self.navigationController pushViewController:VC animated:YES];
    }
    
}
-(void)did3ClickProView:(UITapGestureRecognizer *)tap{
    
    NSInteger tag= [tap.view superview].tag-10;
    NSString *Userleave = [NSString stringWithFormat:@"%@",[self.searchArr2[tag]objectForKey:@"Userleave"]];
    if ([Userleave isEqualToString:@"4"])
    {
        //认证买手
        CusRProDetailViewController *VC = [[CusRProDetailViewController alloc] init];
        VC.productId = [NSString stringWithFormat:@"%d", tap.view.tag];
        [self.navigationController pushViewController:VC animated:YES];
        
    }
    else
    {
        CusZProDetailViewController *VC = [[CusZProDetailViewController alloc] init];
        VC.productId = [NSString stringWithFormat:@"%d", tap.view.tag];
        [self.navigationController pushViewController:VC animated:YES];
    }
}


@end
