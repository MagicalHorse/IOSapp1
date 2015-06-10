//
//  BuyerPaymentViewController.m
//  joybar
//
//  Created by joybar on 15/6/10.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "BuyerPaymentViewController.h"

@interface BuyerPaymentViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSDictionary *dataArray;
@end

@implementation BuyerPaymentViewController
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
-(NSDictionary *)dataArray{
    if (_dataArray ==nil) {
        _dataArray =[[NSDictionary alloc]init];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavBarViewAndTitle:@"货款管理"];
    self.view.backgroundColor = kCustomColor(241, 241, 241);
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 79, kScreenWidth, kScreenHeight-79-49) style:(UITableViewStylePlain)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight =50;
    self.tableView.tableFooterView =[[UIView alloc]init];
    [self.view addSubview:self.tableView];
    
    UIButton *btn =[[UIButton alloc]initWithFrame:CGRectMake(0, kScreenHeight-49, kScreenWidth, 49)];
    [btn setTitle:@"货款收支" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnclick) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:btn];
    
    self.tableView.backgroundColor = kCustomColor(241, 241, 241);
    [self setData];
}

-(void)setData{
    [HttpTool postWithURL:@"Buyer/PaymentGoods" params:nil success:^(id json) {
        BOOL isSuccessful = [[json objectForKey:@"isSuccessful"] boolValue];
        if (isSuccessful) {
            self.dataArray =[json objectForKey:@"data"];
            [self.tableView reloadData];
        }

    } failure:^(NSError *error) {
        NSLog(@"%@",[error description]);
    }];
}
-(void)btnclick{
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =[[UITableViewCell alloc]init];
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    if (indexPath.row ==0) {
        UILabel * lable =[[UILabel alloc]initWithFrame:CGRectMake(60, 18, 60, 14)];
        lable.text =@"总货款:";
        lable.font =[UIFont fontWithName:@"youyuan" size:14];
        [cell addSubview:lable];
        
        UILabel * lablePrice =[[UILabel alloc]initWithFrame:CGRectMake(lable.right, 15, 200, 20)];
        if ([self.dataArray objectForKey:@"TotalAmount"]) {
            lablePrice.text =[NSString stringWithFormat:@"￥%@",[self.dataArray objectForKey:@"TotalAmount"]];
        }else{
            lablePrice.text =@"￥0.00";
        }
        lablePrice.font =[UIFont fontWithName:@"youyuan" size:20];
        [cell addSubview:lablePrice];
       

    }else if(indexPath.row ==1){
        UILabel * lable =[[UILabel alloc]initWithFrame:CGRectMake(15, 15, 150, 14)];
        lable.font =[UIFont fontWithName:@"youyuan" size:14];
        [cell addSubview:lable];
        
       UIView * view= [[UIView alloc]initWithFrame:CGRectMake(15, 35, 5, 5)];
        view.backgroundColor =[UIColor orangeColor];
        [cell addSubview:view];
        
       
        if ([self.dataArray objectForKey:@"PickedPercent"]) {
            lable.text =[NSString stringWithFormat:@"已提现货款 %@％",[self.dataArray objectForKey:@"PickedPercent"]];
            
            [UIView animateWithDuration:1.5 animations:^{
                
                view.frame =CGRectMake(15, 35, (kScreenWidth-30)*[[self.dataArray objectForKey:@"PickedPercent"] integerValue]*0.01, 5);
            }];
        }else{
            lable.text =@"已提现货款0.00";
        }

        UILabel * labPrice =[[UILabel alloc]initWithFrame:CGRectMake(cell.right-215, 15, 200, 14)];
        labPrice.textAlignment =NSTextAlignmentRight;
        if ([self.dataArray objectForKey:@"PickedAmount"]) {
             labPrice.text =[NSString stringWithFormat:@"￥%@",[self.dataArray objectForKey:@"PickedAmount"]];
        }else{
            labPrice.text =@"￥0.00";
        }
        labPrice.font =[UIFont fontWithName:@"youyuan" size:14];
        [cell addSubview:labPrice];

    
    }else if(indexPath.row ==2){
        
        
        UILabel * lable =[[UILabel alloc]initWithFrame:CGRectMake(15, 15, 150, 14)];
        lable.font =[UIFont fontWithName:@"youyuan" size:14];
        [cell addSubview:lable];
        
        UIView * view= [[UIView alloc]initWithFrame:CGRectMake(15, 35, 5, 5)];
        view.backgroundColor =[UIColor orangeColor];
        [cell addSubview:view];
        
        if ([self.dataArray objectForKey:@"CanPickPercent"]) {
            lable.text =[NSString stringWithFormat:@"可提现货款 %@％",[self.dataArray objectForKey:@"CanPickPercent"]];
            
            [UIView animateWithDuration:1.5 animations:^{
                
                view.frame =CGRectMake(15, 35, (kScreenWidth-30)*[[self.dataArray objectForKey:@"CanPickPercent"] integerValue]*0.01, 5);
            }];
        }else{
            lable.text =@"可提现货款0.00";
        }
        
        UILabel * labPrice =[[UILabel alloc]initWithFrame:CGRectMake(cell.right-215, 15, 200, 14)];
        labPrice.textAlignment =NSTextAlignmentRight;
        if ([self.dataArray objectForKey:@"CanPickAmount"]) {
             labPrice.text =[NSString stringWithFormat:@"￥%@",[self.dataArray objectForKey:@"CanPickAmount"]];
        }else{
            labPrice.text =@"￥0.00";
        }
        labPrice.font =[UIFont fontWithName:@"youyuan" size:14];
        [cell addSubview:labPrice];
        
    }else if(indexPath.row ==3){
        UILabel * lable =[[UILabel alloc]initWithFrame:CGRectMake(15, 15, 150, 14)];
        lable.font =[UIFont fontWithName:@"youyuan" size:14];
        [cell addSubview:lable];
        
        UIView * view= [[UIView alloc]initWithFrame:CGRectMake(15, 35, 5, 5)];
        view.backgroundColor =[UIColor orangeColor];
        [cell addSubview:view];
        
        
        if ([self.dataArray objectForKey:@"FrozenPercent"]) {
            lable.text =[NSString stringWithFormat:@"冻结货款 %@％",[self.dataArray objectForKey:@"FrozenPercent"]];
            
            [UIView animateWithDuration:1.5 animations:^{
                
                view.frame =CGRectMake(15, 35, (kScreenWidth-30)*[[self.dataArray objectForKey:@"FrozenPercent"] integerValue]*0.01, 5);
            }];
        }else{
            lable.text =@"冻结货款0.00";
        }
        
        
        UILabel * labPrice =[[UILabel alloc]initWithFrame:CGRectMake(cell.right-215, 15, 200, 14)];
        labPrice.textAlignment =NSTextAlignmentRight;
        if ([self.dataArray objectForKey:@"FrozenAmount"]) {
             labPrice.text =[NSString stringWithFormat:@"￥%@",[self.dataArray objectForKey:@"FrozenAmount"]];
        }else{
            labPrice.text =@"￥0.00";
        }
        labPrice.font =[UIFont fontWithName:@"youyuan" size:14];
        [cell addSubview:labPrice];
        
    }else if(indexPath.row ==4){
        UILabel * lable =[[UILabel alloc]initWithFrame:CGRectMake(15, 15, 150, 14)];
        lable.font =[UIFont fontWithName:@"youyuan" size:14];
        [cell addSubview:lable];
        
        UIView * view= [[UIView alloc]initWithFrame:CGRectMake(15, 35, 5, 5)];
        view.backgroundColor =[UIColor orangeColor];
        [cell addSubview:view];
        
        
        if ([self.dataArray objectForKey:@"RmaPercent"]) {
            lable.text =[NSString stringWithFormat:@"退款 %@％",[self.dataArray objectForKey:@"RmaPercent"]];
            
            [UIView animateWithDuration:1.5 animations:^{
                
                view.frame =CGRectMake(15, 35, (kScreenWidth-30)*[[self.dataArray objectForKey:@"RmaPercent"] integerValue]*0.01, 5);
            }];
        }else{
            lable.text =@"退款0.00";
        }
        
        
        UILabel * labPrice =[[UILabel alloc]initWithFrame:CGRectMake(cell.right-215, 15, 200, 14)];
        labPrice.textAlignment =NSTextAlignmentRight;
        if ([self.dataArray objectForKey:@"RmaAmount"]) {
            labPrice.text =[NSString stringWithFormat:@"￥%@",[self.dataArray objectForKey:@"RmaAmount"]];
        }else{
            labPrice.text =@"￥0.00";
        }
        labPrice.font =[UIFont fontWithName:@"youyuan" size:14];
        [cell addSubview:labPrice];
    }
    
    return cell;
}


@end
