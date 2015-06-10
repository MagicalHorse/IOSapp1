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

-(void) setData:(NSDictionary *)dic
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth/4)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:bgView];
    bgView.layer.shadowOpacity = 0.5;
    
    NSArray *imgArr = @[@"全部",@"待付款",@"专柜自提",@"售后"];
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
