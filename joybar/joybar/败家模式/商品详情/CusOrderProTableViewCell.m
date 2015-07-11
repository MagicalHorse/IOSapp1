//
//  CusOrderProTableViewCell.m
//  joybar
//
//  Created by 123 on 15/5/28.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "CusOrderProTableViewCell.h"

@implementation CusOrderProTableViewCell

-(void)setData:(ProDetailData *)proDetailData
{
    self.sizeLab.text = [NSString stringWithFormat:@"颜色:默认  规格:%@",self.sizeName];
    self.buyNameLab.text = proDetailData.BuyerName;
    self.addressLab.text = proDetailData.StoreName;
    NSString *imageURL = [NSString stringWithFormat:@"%@_320x0.jpg",proDetailData.ProductPic.firstObject];
    self.proImage.clipsToBounds = YES;
    [self.proImage sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    self.proName.text = proDetailData.ProductName;
    self.numLab.text = [NSString stringWithFormat:@"x%@",self.buyNum];
    self.proNumLab.text = [NSString stringWithFormat:@"共%@件商品",self.buyNum];
    self.allPriceLab.text = [NSString stringWithFormat:@"￥%@",[self.priceDic objectForKey:@"extendprice"]];
    self.priceLab.text = [NSString stringWithFormat:@"￥%@",[self.priceDic objectForKey:@"price"]];
}

@end
