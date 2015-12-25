//
//  CusCollectionViewCell.m
//  joybar
//
//  Created by 123 on 15/5/12.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "CusCollectionViewCell.h"

@implementation CusCollectionViewCell
{
    NSDictionary *dataDic;
}

-(void)setCollectionData:(NSDictionary *)dic andHeight:(NSInteger)height
{
    dataDic = dic;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, IMAGEHEiGHT, height)];
//    imageView.backgroundColor = [self randomColor];
    NSString *imgUrl = [NSString stringWithFormat:@"%@",[[dic objectForKey:@"pic"] objectForKey:@"pic"]];
    imageView.clipsToBounds = YES;
    [imageView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    [self.contentView addSubview:imageView];
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:bgView];
    
    UILabel *nameLab = [[UILabel alloc] init];
    nameLab.text = [dic objectForKey:@"Name"];
    nameLab.numberOfLines = 2;
    nameLab.font = [UIFont systemFontOfSize:13];
//    CGSize size = [Public getContentSizeWith:nameLab.text andFontSize:13 andWidth:IMAGEHEiGHT-10];
    nameLab.frame = CGRectMake(5, 5, IMAGEHEiGHT-10, 35);
    [bgView addSubview:nameLab];
    
    //白色背景高度
    bgView.frame =CGRectMake(0, height, IMAGEHEiGHT, 35+35);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, nameLab.bottom+12, 12, 10)];
    label.text = @"￥";
    label.textColor = [UIColor redColor];
    label.font = [UIFont systemFontOfSize:12];
    [bgView addSubview:label];
    
    UILabel *priceLab = [[UILabel alloc] initWithFrame:CGRectMake(label.right+1, nameLab.bottom+5, 70, 20)];
    priceLab.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"Price"]];
    priceLab.textColor = [UIColor redColor];
    priceLab.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:priceLab];
  
    UIButton *clickZan = [UIButton buttonWithType:(UIButtonTypeCustom)];
    clickZan.frame = CGRectMake(IMAGEHEiGHT-60, nameLab.bottom+5, 60, 20);
    clickZan.backgroundColor = [UIColor clearColor];
    
    [clickZan setImage:[UIImage imageNamed:@"yishoucang"] forState:(UIControlStateNormal)];
    [clickZan addTarget:self action:@selector(didClickCancelCollect:) forControlEvents:(UIControlEventTouchUpInside)];
    [bgView addSubview:clickZan];
}

-(void)didClickCancelCollect:(UIButton *)btn
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[dataDic objectForKey:@"Id"] forKey:@"Id"];
    [dic setValue:@"0" forKey:@"Status"];
    [self hudShow:@"正在取消收藏"];
    [HttpTool postWithURL:@"Product/Favorite" params:dic isWrite:YES  success:^(id json) {
        
        [self textHUDHiddle];
        if ([json objectForKey:@"isSuccessful"])
        {
            [btn setImage:[UIImage imageNamed:@"yishoucang"] forState:(UIControlStateNormal)];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelCollectNot" object:self userInfo:nil];
        }
        else
        {
            [self showHudFailed:[json objectForKey:@"message"]];
        }
        
    } failure:^(NSError *error) {
    }];
    

}

@end
