//
//  CusCollectionViewCell.m
//  joybar
//
//  Created by 123 on 15/5/12.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "CusCollectionViewCell.h"

@implementation CusCollectionViewCell


-(void)setCollectionData:(NSDictionary *)dic andHeight:(NSInteger)height
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (kScreenWidth-15)/2, height)];
//    imageView.backgroundColor = [self randomColor];
    NSString *imgUrl = [NSString stringWithFormat:@"%@_320x0.jpg",[[dic objectForKey:@"pic"] objectForKey:@"pic"]];
    imageView.clipsToBounds = YES;
    [imageView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:nil];
    [self.contentView addSubview:imageView];
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:bgView];
    
    UILabel *nameLab = [[UILabel alloc] init];
    nameLab.text = [dic objectForKey:@"Name"];
    nameLab.numberOfLines = 0;
    nameLab.font = [UIFont fontWithName:@"youyuan" size:13];
    CGSize size = [Public getContentSizeWith:nameLab.text andFontSize:13 andWidth:(kScreenWidth-15)/2-10];
    nameLab.frame = CGRectMake(5, 5, (kScreenWidth-15)/2-10, size.height);
    [bgView addSubview:nameLab];
    
    
    //白色背景高度
    bgView.frame =CGRectMake(0, height, (kScreenWidth-15)/2, size.height+35);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, nameLab.bottom+12, 10, 10)];
    label.text = @"￥";
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:12];
    [bgView addSubview:label];
    
    UILabel *priceLab = [[UILabel alloc] initWithFrame:CGRectMake(label.right+1, nameLab.bottom+5, 70, 20)];
    priceLab.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"Price"]];
    priceLab.textColor = [UIColor redColor];
    priceLab.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:priceLab];

    UIButton *clickZan = [UIButton buttonWithType:(UIButtonTypeCustom)];
    clickZan.frame = CGRectMake((kScreenWidth-15)/2-60, nameLab.bottom+5, 60, 20);
    clickZan.backgroundColor = [UIColor clearColor];
    [clickZan setImage:[UIImage imageNamed:@"xingxing"] forState:(UIControlStateNormal)];
    [clickZan setTitle:@"123" forState:(UIControlStateNormal)];
    clickZan.titleLabel.font = [UIFont systemFontOfSize:11];
    [clickZan setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
    clickZan.userInteractionEnabled = YES;
    [clickZan addTarget:self action:@selector(didClickCancelCollect:) forControlEvents:(UIControlEventTouchUpInside)];
    [bgView addSubview:clickZan];
}

-(void)didClickCancelCollect:(UIButton *)btn
{
    
}

@end
