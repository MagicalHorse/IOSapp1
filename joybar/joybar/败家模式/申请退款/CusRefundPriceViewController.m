//
//  CusRefundPriceViewController.m
//  joybar
//
//  Created by 123 on 15/6/15.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "CusRefundPriceViewController.h"

@interface CusRefundPriceViewController ()

@property (nonatomic ,assign) NSInteger priceNum;


@end

@implementation CusRefundPriceViewController
{
    UILabel *buyNumLab;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.priceNum = 0;

    [self addNavBarViewAndTitle:@"申请退款"];
    self.view.backgroundColor = kCustomColor(240, 241, 242);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickScroll)];
    [self.scrollView addGestureRecognizer:tap];
    
    self.refundText.layer.borderColor = [UIColor grayColor].CGColor;
    self.refundText.layer.borderWidth = 0.5;
    self.refundText.layer.cornerRadius = 3;
    NSString *tempUrl = [NSString stringWithFormat:@"%@",self.proImageStr];
    [self.proImage sd_setImageWithURL:[NSURL URLWithString:tempUrl] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    self.proName.text = self.proNameStr;
    self.proNumLab.text = [NSString stringWithFormat:@"x%@",self.proNumStr];
    self.proSizeLab.text = self.proSizeStr;
    self.proPriceLab.text = [NSString stringWithFormat:@"￥%@",self.proPriceStr];
    self.refundPriceLab.text = [NSString stringWithFormat:@"￥%.2f",[self.proPriceStr floatValue]*[self.proNumStr floatValue]];
    
//    UIView *numView = [[UIView alloc] initWithFrame:CGRectMake(self.proStatusLab.left, self.refundPriceLab.bottom+25, 120, 30)];
//    numView.backgroundColor = kCustomColor(240, 240, 240);
//    numView.layer.cornerRadius = 4;
//    numView.layer.borderWidth = 0.5f;
//    numView.layer.borderColor = kCustomColor(223, 223, 223).CGColor;
//    [self.bgView addSubview:numView];
    
//    UIButton *addBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    addBtn.frame = CGRectMake(numView.width-44, 0, 44, numView.height);
//    [addBtn setImage:[UIImage imageNamed:@"加号icon"] forState:(UIControlStateNormal)];
//    [addBtn setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
//    addBtn.titleLabel.font = [UIFont systemFontOfSize:18];
//    addBtn.backgroundColor = [UIColor clearColor];
//    [addBtn addTarget:self action:@selector(didCLickAddNum) forControlEvents:(UIControlEventTouchUpInside)];
//    [numView addSubview:addBtn];
//    
//    UIButton *minusBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    minusBtn.frame = CGRectMake(0, 0, 44, numView.height);
//    [minusBtn setImage:[UIImage imageNamed:@"减号可点击icon"] forState:(UIControlStateNormal)];
//    [minusBtn setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
//    minusBtn.titleLabel.font = [UIFont systemFontOfSize:18];
//    minusBtn.backgroundColor = [UIColor clearColor];
//    [minusBtn addTarget:self action:@selector(didClickDecrease) forControlEvents:(UIControlEventTouchUpInside)];
//    [numView addSubview:minusBtn];
    
//    buyNumLab = [[UILabel alloc] initWithFrame:CGRectMake(44, 0, numView.width-88, numView.height)];
//    buyNumLab.backgroundColor = [UIColor whiteColor];
//    buyNumLab.text = [NSString stringWithFormat:@"%ld",(long)self.priceNum];
//    buyNumLab.textAlignment = NSTextAlignmentCenter;
//    [numView addSubview:buyNumLab];
    
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

////增加
//-(void)didCLickAddNum
//{
//    if (self.priceNum>=[self.proNumStr integerValue])
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"超过购买数量" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好", nil];
//        [alert show];
//        return;
//    }
//    
//    self.priceNum+=1;
//    buyNumLab.text = [NSString stringWithFormat:@"%ld",(long)self.priceNum];
//    CGFloat price = self.priceNum*[self.proPriceStr doubleValue];
//    self.refundPriceLab.text = [NSString stringWithFormat:@"￥%.2f",price];
//}
//
////减少
//-(void)didClickDecrease
//{
//    if (self.priceNum<1)
//    {
//        return;
//    }
//    else
//    {
//        self.priceNum-=1;
//        buyNumLab.text = [NSString stringWithFormat:@"%ld",(long)self.priceNum];
//        CGFloat price = self.priceNum*[self.proPriceStr doubleValue];
//        self.refundPriceLab.text = [NSString stringWithFormat:@"￥%.2f",price];
//    }
//}

//提交申请
-(void)didClickRefundBtn
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.orderNum forKey:@"OrderNo"];
    NSString *price = [self.refundPriceLab.text stringByReplacingOccurrencesOfString:@"￥" withString:@""];
    if([price floatValue]==0)
    {
        [self showHudFailed:@"退款金额不能为0"];
        return;
    }
    [dic setObject:self.proNumStr forKey:@"Count"];
    if ([self.refundText.text isEqualToString:@""])
    {
        [self showHudFailed:@"请填写退款理由"];
        
        return;
    }
    [dic setObject:self.refundText.text forKey:@"Reason"];
    
    [self hudShow:@"正在申请退款..."];
    [HttpTool postWithURL:@"Order/Apply_Rma" params:dic success:^(id json) {
       
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

-(void)didClickScroll
{
    [self.scrollView endEditing:YES];
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





@end
