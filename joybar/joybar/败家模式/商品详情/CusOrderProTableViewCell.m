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
    self.addressLab.text = proDetailData.PickAddress;
    NSString *imageURL = [NSString stringWithFormat:@"%@_320x0.jpg",proDetailData.ProductPic.firstObject];
    [self.proImage sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:nil];
    self.proName.text = proDetailData.ProductName;
    self.numLab.text = [NSString stringWithFormat:@"x%@",self.buyNum];
    self.proNumLab.text = [NSString stringWithFormat:@"共%@件商品",self.buyNum];
    CGFloat price = [proDetailData.Price floatValue]*[self.buyNum floatValue];
    self.allPriceLab.text = [NSString stringWithFormat:@"￥%.2f",price];
    self.priceLab.text = [NSString stringWithFormat:@"￥%@",proDetailData.Price];
}

@end
