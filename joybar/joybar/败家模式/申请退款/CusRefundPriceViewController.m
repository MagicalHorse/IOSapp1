//
//  CusRefundPriceViewController.m
//  joybar
//
//  Created by 123 on 15/6/15.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "CusRefundPriceViewController.h"
#import "RefundTableViewCell.h"
#import "RefundTableViewCell2.h"
@interface CusRefundPriceViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (nonatomic ,assign) NSInteger priceNum;

@property (nonatomic ,strong) UITableView *tableView;

@property (nonatomic ,strong) NSMutableArray *proArr;

@property (nonatomic ,strong) NSString *price;

@property (nonatomic ,strong) NSDictionary *orderDic;

@end

@implementation CusRefundPriceViewController
{
    UILabel *buyNumLab;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.proArr = [NSMutableArray array];
    
    self.priceNum = 0;

    [self addNavBarViewAndTitle:@"申请退款"];
    self.view.backgroundColor = kCustomColor(240, 241, 242);
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self getProData];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-49, kScreenWidth, 49)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.center = CGPointMake(kScreenWidth/2, bottomView.height/2);
    btn.bounds = CGRectMake(0, 0, 80, 30);
    btn.layer.borderWidth = 0.5;
    btn.layer.borderColor = [UIColor redColor].CGColor;
    [btn setTitle:@"提交申请" forState:(UIControlStateNormal)];
    btn.layer.cornerRadius = 3;
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(didClickRefundBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [bottomView addSubview:btn];
}


//提交申请
-(void)didClickRefundBtn
{
    RefundTableViewCell2 *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.proArr.count inSection:0]];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[self.orderDic objectForKey:@"OrderNo"] forKey:@"OrderNo"];
    NSString *price = [self.orderDic objectForKey:@"ActualAmount"];
    if([price floatValue]==0)
    {
        [self showHudFailed:@"退款金额不能为0"];
        return;
    }
    [dic setObject:@"0" forKey:@"Count"];
    if ([cell.refundTextView.text isEqualToString:@""])
    {
        [self showHudFailed:@"请填写退款理由"];
        
        return;
    }
    [dic setObject:cell.refundTextView.text forKey:@"Reason"];
    
    [self hudShow:@"正在申请退款..."];
    [HttpTool postWithURL:@"Order/Apply_Rma" params:dic isWrite:YES success:^(id json) {
       
        if([[json objectForKey:@"isSuccessful"] boolValue])
        {
            [self showHudSuccess:@"申请退款成功"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refundNotification" object:self userInfo:nil];
            });
        }
        else
        {
            [self showHudFailed:[json objectForKey:@"message"]];
        }
        [self textHUDHiddle];
    } failure:^(NSError *error) {
    }];
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.30];
    CGRect rect = self.view.frame;
    rect.origin.y = -160;
    self.view.frame = rect;
    [UIView commitAnimations];
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.30];
    CGRect rect = self.view.frame;
    rect.origin.y = 0;
    self.view.frame = rect;
    [UIView commitAnimations];
}


-(void)getProData
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:self.orderNo forKey:@"OrderNo"];
    [self hudShow];
    [HttpTool postWithURL:@"Order/GetUserOrderDetailV3" params:dic success:^(id json) {
        
        [self hiddleHud];
        if ([[json objectForKey:@"isSuccessful"] boolValue])
        {
            self.price = [NSString stringWithFormat:@"%@",[[json objectForKey:@"data"] objectForKey:@"ActualAmount"]];
            self.orderDic = [json objectForKey:@"data"];
            NSArray *arr = [[json objectForKey:@"data"] objectForKey:@"Product"];
            [self.proArr addObjectsFromArray:arr];
            
            [self.tableView reloadData];
        }
        else
        {
            [self showHudFailed:[json objectForKey:@"message"]];
        }
        NSLog(@"%@",[json objectForKey:@"message"]);
    } failure:^(NSError *error) {
        
    }];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.proArr.count+1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row<self.proArr.count)
    {
        static NSString *iden = @"cell";
        RefundTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
        if (cell==nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"RefundTableViewCell" owner:self options:nil].lastObject;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setData:self.proArr[indexPath.row]];
        return cell;
    }
    else
    {
        static NSString *iden = @"cell1";
        RefundTableViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:iden];
        if (cell==nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"RefundTableViewCell2" owner:self options:nil].lastObject;
        }
        cell.backgroundColor = kCOLOR(244);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([self.price isEqualToString:@""])
        {
            cell.refundPrice.text = [NSString stringWithFormat:@"￥%@",@"0"];
        }
        else
        {
            cell.refundPrice.text = [NSString stringWithFormat:@"￥%@",self.price];
        }
        
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row<self.proArr.count)
    {
        return 94;
    }
    else
    {
        return 267;
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    RefundTableViewCell2 *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.proArr.count inSection:0]];
    [cell.refundTextView resignFirstResponder];
}

@end
