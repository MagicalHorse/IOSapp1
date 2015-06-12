//
//  CusMineSecTableViewCell.m
//  joybar
//
//  Created by 123 on 15/5/5.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "CusMineSecTableViewCell.h"
#import "CusOrderListViewController.h"
@implementation CusMineSecTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void) setData:(MineData *)mineData
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth/4)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:bgView];
    bgView.layer.shadowOpacity = 0.5;
    
    NSArray *imgArr = @[@"全部",@"待付款",@"专柜自提",@"售后"];
    NSArray *numArr = @[mineData.AllOrderCount,mineData.WaitPaymentOrderCount,mineData.PickedSelfOrderCount,mineData.AfterSaleOrderCount];
    for (int i=0; i<imgArr.count; i++)
    {
        
        UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        btn.frame = CGRectMake(kScreenWidth/imgArr.count*i, 0, kScreenWidth/imgArr.count, kScreenWidth/imgArr.count);
        btn.tag = 1000+i;
        btn.backgroundColor = [UIColor clearColor];
        [btn addTarget:self action:@selector(didClickBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        [bgView addSubview:btn];

        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.center = CGPointMake(btn.width/2, btn.height/2-10);
        imgView.bounds = CGRectMake(0, 0, 20, 20);
        imgView.backgroundColor = [UIColor clearColor];
        imgView.image = [UIImage imageNamed:[imgArr objectAtIndex:i]];
        [btn addSubview:imgView];
        
        UILabel *lab = [[UILabel alloc] init];
        lab.center = CGPointMake(btn.width/2, btn.height/2+15);
        lab.bounds = CGRectMake(0, 0, btn.width, btn.height);
        lab.font = [UIFont fontWithName:@"youyuan" size:13];
        lab.text = [imgArr objectAtIndex:i];
        lab.textColor = [UIColor darkGrayColor];
        lab.textAlignment = NSTextAlignmentCenter;
        [btn addSubview:lab];
        
        UILabel *numLab = [[UILabel alloc] init];
        numLab.center = CGPointMake(imgView.right, imgView.top);
        numLab.bounds = CGRectMake(0, 0, 18, 18);
        numLab.backgroundColor = [UIColor whiteColor];
        numLab.clipsToBounds = YES;
        numLab.layer.borderColor = [UIColor orangeColor].CGColor;
        numLab.layer.borderWidth = 1;
        numLab.text = [numArr objectAtIndex:i];
        if ([numLab.text isEqualToString:@"0"])
        {
            numLab.hidden = YES;
        }
        else
        {
            numLab.hidden = NO;
        }
        numLab.textColor = [UIColor orangeColor];
        numLab.textAlignment = NSTextAlignmentCenter;
        numLab.font = [UIFont systemFontOfSize:12];
        numLab.layer.cornerRadius = numLab.width/2;
        [btn addSubview:numLab];
    }
}
-(void)didClickBtn:(UIButton *)btn
{
    NSInteger index = btn.tag-1000;
    CusOrderListViewController *VC = [[CusOrderListViewController alloc] init];
    VC.btnIndex = index;
    [self.viewController.navigationController pushViewController:VC animated:YES];
}
@end
