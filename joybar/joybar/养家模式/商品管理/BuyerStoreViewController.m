//
//  BuyerStoreViewController.m
//  joybar
//
//  Created by liyu on 15/5/8.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "BuyerStoreViewController.h"
#import "BuyerSellTableViewCell.h"
#import "Parameter.h"
#import "BuerySotres.h"
#import "Store.h"
#import "MJExtension.h"
#import "BuyerIssueViewController.h"


@interface BuyerStoreViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    int type;
    BOOL isRefresh;
    
}
@property (nonatomic ,strong) BaseTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic ,strong) UILabel *lineLab;
@property (nonatomic ,strong) UIScrollView *tempView;
@property (nonatomic ,assign)NSInteger pageNum;
@end

@implementation BuyerStoreViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    type=1;
    [self addNavBarViewAndTitle:@"商品管理"];
    _tempView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 40)];
    _tempView.backgroundColor = kCustomColor(251, 250, 250);
    [self.view addSubview:_tempView] ;
    NSArray *nameArr = @[@"在线商品",@"即将下线",@"下线商品"];
    for (int i=0; i<3; i++)
    {
       UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(_tempView.width/3*i, 0, _tempView.width/3, 32)];
        lab.userInteractionEnabled = YES;
        lab.font = [UIFont fontWithName:@"youyuan" size:13];
        lab.backgroundColor = [UIColor clearColor];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = [UIColor grayColor];
        lab.text = [nameArr objectAtIndex:i];
        lab.tag=1000+i;
        [_tempView addSubview:lab];
        if (i==0)
        {
            lab.textColor = [UIColor orangeColor];
            lab.font = [UIFont fontWithName:@"youyuan" size:15];
            
            self.lineLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _tempView.width/3-30, 3)];
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
    self.tableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, 104, kScreenWidth, kScreenHeight-64-40) style:(UITableViewStyleGrouped)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.pageNum=1;
    isRefresh =YES;
    self.tableView.tableFooterView =[[UIView alloc]init];
    __weak BuyerStoreViewController *VC = self;
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
    self.tableView.backgroundColor = kCustomColor(241, 241, 241);
    
}
-(NSMutableArray *)dataArray{
    
    if (_dataArray ==nil) {
        _dataArray =[[NSMutableArray alloc]init];
    }
    return _dataArray;
}

-(void)setData
{

    if (isRefresh) {
        [SVProgressHUD showInView:self.view WithY:64+40 andHeight:kScreenHeight-64-40];
    }
    NSMutableDictionary * dict=[[NSMutableDictionary alloc]init];
    [dict setValue:[NSString stringWithFormat:@"%ld",(long)self.pageNum] forKey:@"Page"];
    [dict setObject:@"6" forKey:@"Pagesize"];
    if (type ==1) {
        [dict setObject:@"1" forKey:@"Status"];
    }else if(type ==2){
        [dict setObject:@"2" forKey:@"Status"];
        
    }else if(type ==0){
        [dict setObject:@"0" forKey:@"Status"];
    }
    [HttpTool postWithURL:@"Product/GetBuyerProductList" params:dict success:^(id json) {
        
        BOOL isSuccessful = [[json objectForKey:@"isSuccessful"] boolValue];
        if (isSuccessful) {
            NSMutableArray *array =[json objectForKey:@"data"];
            BuerySotres *stores = [BuerySotres objectWithKeyValues :array];
            if(stores.items.count<6)
            {
                [self.tableView hiddenFooter:YES];
            }
            else
            {
                [self.tableView hiddenFooter:NO];
            }
            if (self.pageNum==1) {
                [self.dataArray removeAllObjects];
                [self.dataArray addObjectsFromArray:stores.items];
            }else{
                [self.dataArray addObjectsFromArray:stores.items];
            }
        }else{
            self.dataArray=nil;
            [self showHudFailed:@"加载失败"];
        }
        [self.tableView reloadData];
        [SVProgressHUD dismiss];
        [self.tableView endRefresh];
        isRefresh =NO;
    } failure:^(NSError *error) {
        [self.tableView endRefresh];
        [SVProgressHUD dismiss];
    }];

}

#pragma mark tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    BuyerSellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell =[[[NSBundle mainBundle] loadNibNamed:@"BuyerSellTableViewCell" owner:self options:nil] lastObject];
    }
    if(self.dataArray.count>0){
        Store * store =[self.dataArray objectAtIndex:indexPath.section];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSString * temp =[NSString stringWithFormat:@"%@_120x0.jpg",store.Pic];
        [cell.StoreImgView sd_setImageWithURL:[NSURL URLWithString:temp] placeholderImage:nil];
        cell.StoreName.text =store.BrandName;
        cell.StoreDetails.text =store.ProductName;
        cell.StoreNo.text =store.StoreItemNo;
        cell.StorePirce.text =[NSString stringWithFormat:@"￥%@",[store.Price stringValue]];
        cell.StoreTime.text =store.ExpireTime;
        cell.downBtn.tag =indexPath.section;
        
        cell.shareBtn.tag =indexPath.section;
        [cell.shareBtn addTarget:self action:@selector(shareClcke:) forControlEvents:UIControlEventTouchUpInside];
        cell.sbBtn.tag =indexPath.section;
        
        if (type ==0) {
            [cell.sbBtn setTitle:@"删除" forState:UIControlStateNormal];
            [cell.sbBtn addTarget:self action:@selector(sbDelClcke:) forControlEvents:UIControlEventTouchUpInside];
            [cell.downBtn setTitle:@"上架" forState:UIControlStateNormal];
            [cell.downBtn addTarget:self action:@selector(downOnClcke:) forControlEvents:UIControlEventTouchUpInside];
            
        }else{
            [cell.sbBtn addTarget:self action:@selector(sbClcke:) forControlEvents:UIControlEventTouchUpInside];
            [cell.downBtn addTarget:self action:@selector(downClcke:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        cell.cyBtn.tag =indexPath.section;
        [cell.cyBtn addTarget:self action:@selector(cyClcke:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

-(void)downOnClcke:(UIButton *)btn{
    Store *st=[self.dataArray objectAtIndex:btn.tag];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict setObject:st.ProductId forKey:@"Id"];
    [dict setObject:@"1" forKey:@"Status"];
    [HttpTool postWithURL:@"Product/OnLine" params:dict success:^(id json) {
        BOOL isSuccessful = [[json objectForKey:@"isSuccessful"] boolValue];
        if (isSuccessful) {
            [self.dataArray addObject:st];
            [self.tableView reloadData];
        }
        NSLog(@"%@",[json objectForKey:@"message"]);
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];

}
-(void)sbDelClcke:(UIButton *)btn{
    
    Store *st=[self.dataArray objectAtIndex:btn.tag];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict setObject:st.ProductId forKey:@"id"];
    [HttpTool postWithURL:@"Product/Delete" params:dict success:^(id json) {
        BOOL isSuccessful = [[json objectForKey:@"isSuccessful"] boolValue];
        if (isSuccessful) {
            [self.dataArray removeObject:st];
            [self.tableView reloadData];
        }else{
            [self showHudFailed:[json objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}
-(void)downClcke:(UIButton *)btn{

    Store *st=[self.dataArray objectAtIndex:btn.tag];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict setObject:st.ProductId forKey:@"Id"];
    [dict setObject:@"0" forKey:@"Status"];
    [HttpTool postWithURL:@"Product/OnLine" params:dict success:^(id json) {
        BOOL isSuccessful = [[json objectForKey:@"isSuccessful"] boolValue];
        if (isSuccessful) {
            [self.dataArray removeObject:st];
            [self.tableView reloadData];
        }else{
            [self showHudFailed:[json objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}
//分享
-(void)shareClcke:(UIButton *)btn{
 
    
}
//修改
-(void)sbClcke:(UIButton *)btn{
    Store *st=[self.dataArray objectAtIndex:btn.tag];
    BuyerIssueViewController *issue =[[BuyerIssueViewController alloc]init];
    issue.productId=st.ProductId;
    [self.navigationController pushViewController:issue animated:YES];
    
}
//复制
-(void)cyClcke:(UIButton *)btn{
    
    Store *st=[self.dataArray objectAtIndex:btn.tag];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict setObject:st.ProductId forKey:@"productId"];
    [dict setObject:@"0" forKey:@"Status"];
    [HttpTool postWithURL:@"Product/Copy" params:dict success:^(id json) {
        BOOL isSuccessful = [[json objectForKey:@"isSuccessful"] boolValue];
        if (isSuccessful) {
            [self.dataArray insertObject:st atIndex:0];
            [self.tableView reloadData];
        }else{
            [self showHudFailed:[json objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 165;
}

-(void)didSelect:(UITapGestureRecognizer *)tap
{
    if (tap.view.tag==1000)
    {
        self.pageNum=1;
        type=1;
        isRefresh=YES;
        [SVProgressHUD dismiss];
        [self scrollToBuyerStreet];
    }
    else if(tap.view.tag==1001)
    {
        self.pageNum=1;
        type=2;
        isRefresh=YES;
        [SVProgressHUD dismiss];

        [self scrollToSaid];
    }
    else
    {
        self.pageNum=1;
        type=0;
        isRefresh=YES;
        [SVProgressHUD dismiss];

        [self scrollToMyBuyer];
    }
}

//在线商品
-(void)scrollToBuyerStreet
{
    UILabel *lab1 = (UILabel *)[_tempView viewWithTag:1000];
    UILabel *lab2 = (UILabel *)[_tempView viewWithTag:1001];
    UILabel *lab3 = (UILabel *)[_tempView viewWithTag:1002];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.lineLab.center = CGPointMake(lab1.center.x, 38);
    }];
    lab1.textColor = [UIColor orangeColor];
    lab1.font = [UIFont fontWithName:@"youyuan" size:15];
    lab2.textColor = [UIColor grayColor];
    lab2.font = [UIFont fontWithName:@"youyuan" size:13];
    lab3.textColor = [UIColor grayColor];
    lab3.font = [UIFont fontWithName:@"youyuan" size:13];

    [self setData];

}

//即将下线
-(void)scrollToSaid
{
    UILabel *lab1 = (UILabel *)[_tempView viewWithTag:1000];
    UILabel *lab2 = (UILabel *)[_tempView viewWithTag:1001];
    UILabel *lab3 = (UILabel *)[_tempView viewWithTag:1002];
    
    
    [UIView animateWithDuration:0.25 animations:^{
        self.lineLab.center = CGPointMake(lab2.center.x, 38);
    }];
    lab2.textColor = [UIColor orangeColor];
    lab2.font = [UIFont fontWithName:@"youyuan" size:15];
    lab1.textColor = [UIColor grayColor];
    lab1.font = [UIFont fontWithName:@"youyuan" size:13];
    lab3.textColor = [UIColor grayColor];
    lab3.font = [UIFont fontWithName:@"youyuan" size:13];
    [self setData];

}


-(void)scrollToMyBuyer
{
    UILabel *lab1 = (UILabel *)[_tempView viewWithTag:1000];
    UILabel *lab2 = (UILabel *)[_tempView viewWithTag:1001];
    UILabel *lab3 = (UILabel *)[_tempView viewWithTag:1002];

    [UIView animateWithDuration:0.25 animations:^{
        self.lineLab.center = CGPointMake(lab3.center.x, 38);
    }];
    lab3.textColor = [UIColor orangeColor];
    lab3.font = [UIFont fontWithName:@"youyuan" size:15];
    lab1.textColor = [UIColor grayColor];
    lab1.font = [UIFont fontWithName:@"youyuan" size:13];
    lab2.textColor = [UIColor grayColor];
    lab2.font = [UIFont fontWithName:@"youyuan" size:13];
    [self setData];

}

@end
