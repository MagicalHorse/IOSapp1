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
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.pageNum=1;

    [self setData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavBarViewAndTitle:@""];

    //搜索
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(40, 25, kScreenWidth-80, 30)];
    searchView.backgroundColor = kCustomColor(232, 233, 234);
    searchView.layer.cornerRadius = 3;
    [self.navView addSubview:searchView];
    isRefresh=YES;

    
    
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
    
    
}

-(void)setData{
   
    if (isRefresh) {
        [self showInView:self.view WithPoint:CGPointMake(0, 64) andHeight:kScreenHeight-64];
    }
    NSString *userId =[NSString stringWithFormat:@"%@",[[Public getUserInfo] objectForKey:@"id"]];
    NSMutableDictionary *dict =[[NSMutableDictionary alloc]init];
    [dict setObject:searchText.text forKey:@"key"];
    [dict setValue:[NSString stringWithFormat:@"%ld",(long)self.pageNum] forKey:@"Page"];
    [dict setObject:@"6" forKey:@"Pagesize"];
    [dict setObject:userId forKey:@"userId"];
    [dict setObject:self.longitude forKey:@"longitude"];
    [dict setObject:self.latitude forKey:@"latitude"];
    
    [HttpTool postWithURL:@"v3/searchbuyer" params:dict  success:^(id json) {
        BOOL  isSuccessful =[[json objectForKey:@"isSuccessful"] boolValue];
        if (isSuccessful) {
            NSMutableArray *array =[NSMutableArray arrayWithArray:[[json objectForKey:@"data"]objectForKey:@"items"]];
            for (int i=0; i<array.count; i++) {
                NSMutableDictionary * mDic =[NSMutableDictionary dictionaryWithDictionary:array[i]];
                [mDic setObject:@"0" forKey:@"isTX"];
                [array replaceObjectAtIndex:i withObject:mDic];
                
            }
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

    [searchText resignFirstResponder];
    [self setData];
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
        BOOL isFavite =[[self.dataArray[indexPath.row]objectForKey:@"IsFllowed"]boolValue];
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
            
            
            BOOL isTX =[[self.dataArray[indexPath.row]objectForKey:@"isTX"]boolValue];
            UIButton *btn=  [[UIButton alloc]initWithFrame:CGRectMake((cell.width-100)*0.5, lable.bottom+10, 100, 40)];
            if (isTX) {
                btn.backgroundColor =[UIColor grayColor];
                [btn setTitle:@"已提醒上新" forState:UIControlStateNormal];
                
            }else{
                btn.backgroundColor =[UIColor orangeColor];
                [btn setTitle:@"提醒上新" forState:UIControlStateNormal];
            }
            
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.titleLabel.font =[UIFont systemFontOfSize:13];
            [btn addTarget:self action:@selector(txUptoNew:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag =indexPath.row;
            btn.layer.cornerRadius =3;
            [cell addSubview:btn];
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
    mainStore.userId =[self.dataArray[indexPath.row]objectForKey:@"UserId"];
    mainStore.isCircle = NO;
    [self.navigationController pushViewController:mainStore animated:YES];
}
-(void)guanzhuClick:(UIButton *)btn{
    BOOL tempState =[[self.dataArray[btn.tag-100]objectForKey:@"IsFllowed"]boolValue];
    NSString *buyerId =[self.dataArray[btn.tag-100]objectForKey:@"UserId"];
    
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
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.dataArray[btn.tag-100]];
            if (tempState)
            {
                [dic setObject:@"0" forKey:@"IsFllowed"];
            }
            else
            {
                [dic setObject:@"1" forKey:@"IsFllowed"];
            }
            [self.dataArray removeObject:self.dataArray[btn.tag-100]];
            [self.dataArray insertObject:dic atIndex:btn.tag-100];
            
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
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [searchText resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self setData];
    return YES;
}
-(void)txUptoNew:(UIButton *)btn{
    
    if (!TOKEN)
    {
        [Public showLoginVC:self];
        return;
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    BOOL tempState =[[self.dataArray[btn.tag]objectForKey:@"isTX"]boolValue];
    NSString * userId= [self.dataArray[btn.tag]objectForKey:@"UserId"];
    
    if (!tempState)
    {
        [dic setValue:userId forKey:@"buyerid"];
        [btn setTitle:@"已提醒上新" forState:UIControlStateNormal];
        btn.backgroundColor =[UIColor grayColor];
    }
    else
    {
        return;
    }
    [HttpTool postWithURL:@"BuyerV3/Touch" params:dic isWrite:YES  success:^(id json) {
        
        if ([json objectForKey:@"isSuccessful"])
        {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.dataArray[btn.tag]];
            [dic setObject:@"1" forKey:@"isTX"];
            [self.dataArray removeObject:self.dataArray[btn.tag]];
            [self.dataArray insertObject:dic atIndex:btn.tag];
          
        }
        else
        {
            [self showHudFailed:[json objectForKey:@"message"]];
            [btn setTitle:@"提醒上新" forState:UIControlStateNormal];
            btn.backgroundColor =[UIColor orangeColor];
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
    
}

@end
