//
//  MakeSureVipOrderViewController.m
//  joybar
//
//  Created by joybar on 15/11/19.
//  Copyright © 2015年 卢兴. All rights reserved.
//

#import "MakeSureVipOrderViewController.h"
#import "CusOrderProTableViewCell.h"
#import "PayOrderViewController.h"
#import "BindVipViewController.h"
#import "ChooesVipViewController.h"
#import "CusVipOrderProTableViewCell.h"
@interface MakeSureVipOrderViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UITextFieldDelegate>

@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) NSDictionary *priceDic;
@property (nonatomic ,strong)NSMutableArray *datas;

@property (nonatomic ,strong) NSArray *VIPCardArr;
@property (nonatomic ,strong) NSString *cardNum;

@property (nonatomic ,strong) NSMutableArray *btnArr;

@property (nonatomic ,strong) NSString *needInvoice;
@property (nonatomic ,strong) NSMutableArray *tempArr;

@end

@implementation MakeSureVipOrderViewController
{
    UITextField *phoneText;
    UITextField *desText;
    BOOL IsBingVip;
    BOOL IsShowVip;
    //vip最终优惠价格
    double vipPrice;
    //打烊购最终优惠价格
    double dayanggouPrice;
    //应付金额
    double finishPrice;
    UILabel *priceLable;
    UIView *btnBgview;
}

-(NSMutableArray *)datas{
    if (_datas ==nil) {
        _datas = [[NSMutableArray alloc]init];
    }
    return _datas;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.needInvoice = @"0";
    self.btnArr = [NSMutableArray array];
    self.tempArr = [NSMutableArray array];
    [self.tempArr addObjectsFromArray:@[@"0",@"0",@"0"]];
    //打烊购优惠价格
    double dayanggou = ([self.detailData.Price doubleValue]*[self.buyNum doubleValue])*[self.detailData.DaYangGouDis.discount doubleValue];
    
    //打烊购最大折扣金额
    double maxamount = [self.detailData.DaYangGouDis.maxamount doubleValue];
    if (maxamount>dayanggou)
    {
        dayanggouPrice = dayanggou;
    }
    else
    {
        dayanggouPrice = maxamount;
    }
    
    //应付金额
    finishPrice = [self.detailData.Price doubleValue]*[self.buyNum doubleValue]-dayanggouPrice;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64-49) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = kCustomColor(245, 246, 247);
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addNavBarViewAndTitle:@"确认订单"];
    IsShowVip = NO;
    IsBingVip = [self.detailData.IsJoinDeiscount boolValue];
    [self getPrice];
}



-(void)getPrice
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.detailData.ProductId forKey:@"ProductId"];
    [dic setObject:self.buyNum forKey:@"Quantity"];
    [HttpTool postWithURL:@"Product/ComputeAmount" params:dic success:^(id json) {
        
        if ([[json objectForKey:@"isSuccessful"] boolValue])
        {
            self.priceDic = [json objectForKey:@"data"];
            [self initBottomView];
            [self.tableView reloadData];
        }
        else
        {
            
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)initBottomView
{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-49, kScreenWidth, 49)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [bottomView addSubview:line];
    
    UIButton *sureBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    sureBtn.frame = CGRectMake(kScreenWidth-90, 10, 80, 30);
    sureBtn.layer.cornerRadius = 3;
    sureBtn.backgroundColor = [UIColor orangeColor];
    [sureBtn setTitle:@"确认付款" forState:(UIControlStateNormal)];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [sureBtn addTarget:self action:@selector(didCLickMakeSureBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [bottomView addSubview:sureBtn];
    
    
    
    UILabel *priceLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 65, 20)];
    
    priceLab.text =@"合计金额:";
    priceLab.font = [UIFont systemFontOfSize:13];
    [bottomView addSubview:priceLab];
    
    priceLable = [[UILabel alloc] initWithFrame:CGRectMake(75, 15, kScreenWidth-sureBtn.width-80, 20)];
    
    priceLable.text =[NSString stringWithFormat:@"￥%.2f",finishPrice];
    
    priceLable.font = [UIFont systemFontOfSize:15];
    [bottomView addSubview:priceLable];
    
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (IsBingVip) {
        return 5;
    }
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!IsBingVip) {
        return 1;
    }else{
        if (section ==2)
        {
            return self.datas.count+1;
        }
        return 1;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] init];
    header.backgroundColor = kCustomColor(245, 246, 247);
    return header;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section ==0) {
        return 20;
    }
    return 0.5;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section ==0) {
        UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        UILabel *lable =[[UILabel alloc]initWithFrame:CGRectMake(10, 4, kScreenWidth-20, 20)];
        lable.text =@"注：专柜地址将在您确认订后显示";
        lable.textColor =[UIColor redColor];
        lable.font =[UIFont systemFontOfSize:12];
        lable.textAlignment =NSTextAlignmentRight;
        [bgView addSubview:lable];
        return bgView;
        
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        static NSString *iden = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
        if (cell==nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:iden];
            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 70, 20)];
            lab.textColor = [UIColor grayColor];
            lab.text = @"专柜自提：";
            lab.font = [UIFont systemFontOfSize:14];
            [cell.contentView addSubview:lab];
            
            phoneText = [[UITextField alloc] initWithFrame:CGRectMake(lab.right, 11, kScreenWidth-100, 30)];
            phoneText.borderStyle = UITextBorderStyleNone;
            phoneText.keyboardType = UIKeyboardTypeNumberPad;
            phoneText.placeholder = @"请输入手机号";
            phoneText.font = [UIFont systemFontOfSize:14];
            phoneText.delegate =self;
            [cell.contentView addSubview:phoneText];
            phoneText.tag =1001;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    else if(indexPath.section==1)
    {
        static NSString *iden = @"cell1";
        CusVipOrderProTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
        if (cell==nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CusVipOrderProTableViewCell" owner:self options:nil] lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.buyNum=self.buyNum;
        cell.sizeName = self.sizeName;
        cell.priceDic = self.priceDic;
        if (self.priceDic)
        {
            [cell setData:self.detailData];
        }
        return cell;
        
    }
   
    if (IsBingVip) {
        
        if(indexPath.section==2)
        {
            static NSString *iden = @"cell2";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
            if (cell==nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:iden];
                
            }
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            for (UIView *view in cell.contentView.subviews)
            {
                [view removeFromSuperview];
            }
            
            if (self.datas.count>0) {
                if (indexPath.row==0) {
                    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 130, 20)];
                    lab.text = @"选择金鹰会员卡";
                    lab.font = [UIFont systemFontOfSize:14];
                    [cell.contentView addSubview:lab];
                    
                    UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-120, 15, 80, 20)];
                    lab1.textAlignment = NSTextAlignmentRight;
                    lab1.text =@"请选择";
                    lab1.font = [UIFont systemFontOfSize:14];
                    [cell.contentView addSubview:lab1];
                    
                    UIImageView *img= [[UIImageView alloc]initWithFrame:CGRectMake(lab1.right, 5, 12, 12)];
                    img.backgroundColor =[UIColor redColor];
                    [cell.contentView addSubview:img];

                    
                    
                }else{
                    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 130, 20)];
                    self.cardNum = [[self.datas objectAtIndex:indexPath.row-1] objectForKey:@"cardno"];
                    lab.text = self.cardNum;
                    lab.font = [UIFont systemFontOfSize:14];
                    [cell.contentView addSubview:lab];
                }
                return cell;
                
                
            }else{
                UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 130, 20)];
                lab.text = @"选择金鹰会员卡";
                lab.font = [UIFont systemFontOfSize:14];
                [cell.contentView addSubview:lab];
                
                UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-120, 15, 80, 20)];
                lab1.textAlignment = NSTextAlignmentRight;
                lab1.text =@"请选择";
                lab1.font = [UIFont systemFontOfSize:14];
                [cell.contentView addSubview:lab1];
                UIImageView *img= [[UIImageView alloc]initWithFrame:CGRectMake(lab1.right+5, lab.center.y-5, 12, 12)];
                img.image =[UIImage imageNamed:@"展开"];
                [cell.contentView addSubview:img];
                return cell;
            }
        }
        
        if (indexPath.section ==3) {
            static NSString *iden = @"cell3";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
            if (cell==nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:iden];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            for (UIView *view in cell.contentView.subviews)
            {
                [view removeFromSuperview];
            }
            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 70, 20)];
            lab.text = @"VIP折扣:";
            lab.font = [UIFont systemFontOfSize:14];
            [cell.contentView addSubview:lab];
            UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-215, 15, 200, 20)];
            lab1.textAlignment = NSTextAlignmentRight;
            lab1.font = [UIFont systemFontOfSize:13];
            lab1.textColor = [UIColor lightGrayColor];
            if (vipPrice==0)
            {
                lab1.text = @"请先选择会员卡";
            }
            else
            {
                lab1.text = [NSString stringWithFormat:@"%.2f",vipPrice];
            }
            
            [cell.contentView addSubview:lab1];
            return cell;
            
        }
        else if(indexPath.section==4)
        {
            static NSString *iden = @"cell4";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
            if (cell==nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:iden];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            for (UIView *view in cell.contentView.subviews)
            {
                [view removeFromSuperview];
            }
            
            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 70, 20)];
            lab.text = self.detailData.Promotion.Name;
            lab.font = [UIFont systemFontOfSize:14];
            [cell.contentView addSubview:lab];
            
            UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-215, 15, 200, 20)];
            lab1.textAlignment = NSTextAlignmentRight;
            if (self.priceDic) {
                lab1.text = [NSString stringWithFormat:@"立减 %.2f",dayanggouPrice];
            }
            [cell.contentView addSubview:lab1];
            
            return cell;
        }
//        else if(indexPath.section==5)
//        {
//            static NSString *iden = @"cell5";
//            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
//            if (cell==nil)
//            {
//                cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:iden];
//                
//                UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 70, 20)];
//                lab.text = @"发票抬头：";
//                lab.font = [UIFont systemFontOfSize:14];
//                [cell.contentView addSubview:lab];
//                
//                
//                
//                desText = [[UITextField alloc] initWithFrame:CGRectMake(15, lab.top+25, kScreenWidth-30, 40)];
//
//                desText.borderStyle = UITextBorderStyleNone;
//                desText.placeholder = @"请输入";
//                
//                desText.layer.borderColor = kCustomColor(195, 196, 197).CGColor;
//                desText.layer.borderWidth =1;
//                desText.layer.cornerRadius = 2;
//                desText.font = [UIFont systemFontOfSize:14];
//                desText.delegate =self;
//                [cell.contentView addSubview:desText];
//                desText.userInteractionEnabled =NO;
//              
//                
//                btnBgview = [[UIView alloc] initWithFrame:CGRectMake(85, 15, kScreenWidth-85, 20)];
//                btnBgview.backgroundColor = [UIColor clearColor];
//                [cell.contentView addSubview:btnBgview];
//                
//                
//                
//            }
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            
//            for (UIView *view in btnBgview.subviews) {
//                [view removeFromSuperview];
//            }
//            
//            NSArray *arr = @[@" 无",@" 公司",@" 个人"];
//            for (int i=0; i<3; i++)
//            {
//                UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
//                btn.frame = CGRectMake(5+65*i, 0, 60, 20);
//                if ([self.tempArr[i] isEqualToString:@"0"]) {
//                    [btn setImage:[UIImage imageNamed:@"选择"] forState:(UIControlStateNormal)];
//                }
//                else
//                {
//                    [btn setImage:[UIImage imageNamed:@"选中"] forState:(UIControlStateNormal)];
//                }
//                
//                [btn setTitle:arr[i] forState:(UIControlStateNormal)];
//                if (i==0) {
//                    [btn setImage:[UIImage imageNamed:@"选中"] forState:(UIControlStateNormal)];
//                }
//                btn.titleLabel.font = [UIFont systemFontOfSize:13];
//                [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
//                [btn addTarget:self action:@selector(selectFaPiao:) forControlEvents:(UIControlEventTouchUpInside)];
//                [btnBgview addSubview:btn];
//                btn.tag = 100+i;
//                [self.btnArr addObject:btn];
//            }
//            return cell;
//        }
    }
    else {
        if(indexPath.section==2)
        {
            static NSString *iden = @"cell2";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
            if (cell==nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:iden];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            for (UIView *view in cell.contentView.subviews)
            {
                [view removeFromSuperview];
            }
            
            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 70, 20)];
            lab.text = self.detailData.Promotion.Name;
            lab.font = [UIFont systemFontOfSize:14];
            [cell.contentView addSubview:lab];
            
            UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-215, 15, 200, 20)];
            lab1.textAlignment = NSTextAlignmentRight;
            if (self.priceDic) {
                lab1.text = [NSString stringWithFormat:@"立减 %.2f",[[self.priceDic objectForKey:@"discountamount"] floatValue]];
            }
            [cell.contentView addSubview:lab1];
            
            return cell;
        }
//        else if(indexPath.section==3)
//        {
//            static NSString *iden = @"cell5";
//            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
//            if (cell==nil)
//            {
//                cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:iden];
//                
//                UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 70, 20)];
//                lab.text = @"发票抬头：";
//                lab.font = [UIFont systemFontOfSize:14];
//                [cell.contentView addSubview:lab];
//                
//                
//                desText = [[UITextField alloc] initWithFrame:CGRectMake(15, lab.top+25, kScreenWidth-30, 40)];
//                desText.borderStyle = UITextBorderStyleNone;
//                desText.placeholder = @"请输入";
//                
//                desText.layer.borderColor = kCustomColor(195, 196, 197).CGColor;
//                desText.layer.borderWidth =1;
//                desText.layer.cornerRadius = 2;
//                desText.font = [UIFont systemFontOfSize:14];
//                desText.delegate =self;
//                [cell.contentView addSubview:desText];
//                desText.userInteractionEnabled=NO;
//                btnBgview = [[UIView alloc] initWithFrame:CGRectMake(85, 15, kScreenWidth-85, 20)];
//                btnBgview.backgroundColor = [UIColor clearColor];
//                [cell.contentView addSubview:btnBgview];
//                
//                
//                
//            }
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            
//            for (UIView *view in btnBgview.subviews) {
//                [view removeFromSuperview];
//            }
//            
//            NSArray *arr = @[@" 无",@" 公司",@" 个人"];
//            for (int i=0; i<3; i++)
//            {
//                UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
//                btn.frame = CGRectMake(5+65*i, 0, 60, 20);
//                if ([self.tempArr[i] isEqualToString:@"0"]) {
//                    [btn setImage:[UIImage imageNamed:@"选择"] forState:(UIControlStateNormal)];
//                }
//                else
//                {
//                    [btn setImage:[UIImage imageNamed:@"选中"] forState:(UIControlStateNormal)];
//                }
//                [btn setTitle:arr[i] forState:(UIControlStateNormal)];
//                if (i==0) {
//                    [btn setImage:[UIImage imageNamed:@"选中"] forState:(UIControlStateNormal)];
//                }
//                btn.titleLabel.font = [UIFont systemFontOfSize:13];
//                [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
//                [btn addTarget:self action:@selector(selectFaPiao:) forControlEvents:(UIControlEventTouchUpInside)];
//                [btnBgview addSubview:btn];
//                btn.tag = 100+i;
//                [self.btnArr addObject:btn];
//            }
//            return cell;
//        }
    }
    
    return nil;
}

-(void)getVIPCard
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.buyerId forKey:@"buyerId"];
    [dic setObject:self.detailData.ProductId forKey:@"productId"];
    [dic setObject:self.buyNum forKey:@"count"];
    
    [HttpTool postWithURL:@"V3/GetProductCanUserVipCards" params:dic success:^(id json) {
        if ([[json objectForKey:@"isSuccessful"] boolValue])
        {
            [self.datas addObjectsFromArray:[json objectForKey:@"data"]];
            if (self.datas.count==0) {
                [self showHud:@"没有可用的会员卡" andImg:@""];
                IsShowVip = NO;

            }else{
                IsShowVip = YES;
            }
        }
        else
        {
            [self showHudFailed:[json objectForKey:@"message"]];
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (IsBingVip) {
        if (indexPath.section==2) {
            if (indexPath.row==0)
            {
                if (IsShowVip)
                {
                    IsShowVip =NO;
                    [self.datas removeAllObjects];
                    [self.tableView reloadData];
                }
                else
                {
                    [self getVIPCard];
                }
            }
            else
            {
                NSString *discrate1 = [[self.datas objectAtIndex:indexPath.row-1] objectForKey:@"discrate1"];
                NSString *discrate2 = [[self.datas objectAtIndex:indexPath.row-1] objectForKey:@"discrate2"];
                
                
                //vip优惠价格
                if ([self.detailData.Price doubleValue]<[self.detailData.UnitPrice doubleValue])
                {
                    double vip;
                    //二次折扣率
                    double vipDiscount = [self.detailData.VipDiscount doubleValue];
                    double dis2 = (1-[discrate2 doubleValue])*100;
                    
                    if (vipDiscount>dis2)
                    {
                        vip = vipDiscount;
                    }
                    else
                    {
                        vip = dis2;
                    }
                    
                    //vip优惠价格
                    vipPrice = [self.detailData.Price doubleValue]*[self.buyNum floatValue]*((100-vip)/100);
                }
                else
                {
                    double vip;
                    //一次折扣率
                    double vipDiscount = [self.detailData.VipDiscount doubleValue];
                    double dis1 = (1-[discrate1 doubleValue])*100;
                    
                    if (vipDiscount>dis1)
                    {
                        vip = vipDiscount;
                    }
                    else
                    {
                        vip = dis1;
                    }
                    
                    //vip优惠价格
                    vipPrice = [self.detailData.Price doubleValue]*[self.buyNum floatValue]*((100-vip)/100);
                }
                
                //打烊购优惠价格
                double dayanggou = ([self.detailData.Price doubleValue]*[self.buyNum doubleValue]-vipPrice)*[self.detailData.DaYangGouDis.discount doubleValue];
                
                //打烊购最大折扣金额
                double maxamount = [self.detailData.DaYangGouDis.maxamount doubleValue];
                if (maxamount>dayanggou)
                {
                    dayanggouPrice = dayanggou;
                }
                else
                {
                    dayanggouPrice = maxamount;
                }
                
                //应付金额
                finishPrice = [self.detailData.Price doubleValue]*[self.buyNum doubleValue]-vipPrice-dayanggouPrice;
                
                priceLable.text =[NSString stringWithFormat:@"￥%.2f",finishPrice];
                
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:3],[NSIndexPath indexPathForRow:0 inSection:4], nil] withRowAnimation:(UITableViewRowAnimationNone)];
            }
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==1)
    {
        return 180;
    }
    
    if (IsBingVip) {
        if(indexPath.section==5){
            return 100;
        }
    }else{
        if(indexPath.section==3){
            return 100;
        }
    }
    
    return 50;
}


//确认
-(void)didCLickMakeSureBtn:(UIButton *)btn
{
    CusVipOrderProTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    
//    if ([self.needInvoice isEqualToString:@"1"])
//    {
//        if (desText.text.length==0)
//        {
//            [self showHudFailed:@"请填写发票抬头"];
//            return;
//        }
//    }
    if ([phoneText.text isEqualToString:@""])
    {
        [self showHudFailed:@"请填写手机号"];
        return;
    }else if(phoneText.text.length !=11)
    {
        [self showHudFailed:@"请填写正确的手机号"];
        return;
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.needInvoice forKey:@"NeedInvoice"];
    [dic setValue:desText.text forKey:@"InvoiceTitle"];
    [dic setValue:cell.desLab.text forKey:@"Memo"];
    [dic setObject:phoneText.text forKey:@"Mobile"];
    [dic setObject:self.detailData.ProductId forKey:@"ProductId"];
    [dic setObject:self.buyNum forKey:@"Quantity"];
    [dic setValue:self.cardNum forKey:@"VipCardNo"];
    [dic setObject:self.colorId forKey:@"ColorId"];
    [dic setObject:self.sizeId forKey:@"SizeId"];
    [self hudShow:@"正在提交订单"];
    
    [HttpTool postWithURL:@"v3/CreateOrderV3" params:dic success:^(id json) {
        if ([[json objectForKey:@"isSuccessful"] boolValue])
        {
            PayOrderViewController *VC = [[PayOrderViewController alloc] init];
            VC.proName = self.detailData.ProductName;
            VC.proPrice =[NSString stringWithFormat:@"%.2f",finishPrice];
            VC.orderNum = [[json objectForKey:@"data"] objectForKey:@"OrderNo"];
            [self showHudSuccess:@"提交成功"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self.navigationController pushViewController:VC animated:YES];
                
            });
        }
        else
        {
            [self showHudFailed:[json objectForKey:@"message"]];
        }
        NSLog(@"%@",[json objectForKey:@"message"]);
        [self textHUDHiddle];
        
    } failure:^(NSError *error) {
        
    }];
    
   
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.tableView)
    {
        [self.tableView endEditing:YES];
        CGFloat sectionHeaderHeight = 10;
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0)
        {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        }
        else if (scrollView.contentOffset.y>=sectionHeaderHeight)
        {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}



-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return YES;
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag ==1001) {
        return YES;
    }
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.30];
    CGRect rect = self.view.frame;
    rect.origin.y = -220;
    self.view.frame = rect;
    [UIView commitAnimations];
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField.tag ==1001) {
        return YES;
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.30];
    CGRect rect = self.view.frame;
    rect.origin.y = 0;
    self.view.frame = rect;
    [UIView commitAnimations];
    
    [textField resignFirstResponder];
    return  YES;
    
}

-(void)selectFaPiao:(UIButton *)btn
{
    if (btn.tag==100)
    {
        self.needInvoice = @"0";
    }
    else
    {
        self.needInvoice = @"1";
    }
    for (int i=0; i<3; i++)
    {
        if (i==btn.tag-100)
        {
            [self.tempArr replaceObjectAtIndex:btn.tag-100 withObject:@"1"];
        }
        else
        {
            [self.tempArr replaceObjectAtIndex:i withObject:@"0"];
        }
    }
    
    for (UIButton *selectBtn in self.btnArr)
    {
        if ([btn isEqual:selectBtn])
        {
            [selectBtn setImage:[UIImage imageNamed:@"选中"] forState:(UIControlStateNormal)];
            if (btn.tag ==100) {
                desText.userInteractionEnabled =NO;
                desText.text =@"";
            }else{
                desText.userInteractionEnabled =YES;
            }
        }
        else
        {
            [selectBtn setImage:[UIImage imageNamed:@"选择"] forState:(UIControlStateNormal)];
        }
    }
}

@end
