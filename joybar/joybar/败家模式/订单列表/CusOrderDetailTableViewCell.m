//
//  CusOrderDetailTableViewCell.m
//  joybar
//
//  Created by 123 on 15/5/28.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "CusOrderDetailTableViewCell.h"

@implementation CusOrderDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setData:(OrderDetailData *)detailData
{
    NSString *imageURL = [NSString stringWithFormat:@"%@_320x0.jpg",detailData.ProductPic];
    [self.proImage sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:nil];
    self.proImage.clipsToBounds = YES;
    
    self.proNameLab.text = detailData.ProductName;
    self.sizeLab.text = [NSString stringWithFormat:@"%@:%@",detailData.SizeName,detailData.SizeValue];
    self.numLab.text = [NSString stringWithFormat:@"x%@",detailData.ProductCount];
    self.priceLab.text = [NSString stringWithFormat:@"￥%@",detailData.Price];
}

@end
