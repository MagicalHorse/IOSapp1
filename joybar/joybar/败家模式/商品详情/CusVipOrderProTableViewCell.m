//
//  CusVipOrderProTableViewCell.m
//  joybar
//
//  Created by joybar on 15/11/19.
//  Copyright © 2015年 卢兴. All rights reserved.
//

#import "CusVipOrderProTableViewCell.h"
#import "ProductPicture.h"
@implementation CusVipOrderProTableViewCell
-(void)awakeFromNib{
    
    self.bgTextFieldView.layer.borderColor = kCustomColor(195, 196, 197).CGColor;
    self.bgTextFieldView.layer.borderWidth =1;
    self.bgTextFieldView.layer.cornerRadius = 2;
}

-(void)setData:(ProDetailData *)proDetailData
{
    self.sizeLab.text = [NSString stringWithFormat:@"规格:%@",self.sizeName];
    self.buyNameLab.text = proDetailData.BuyerName;
    self.colorLab.text = proDetailData.StoreName;
    ProductPicture *pic = proDetailData.ProductPic.firstObject;
    NSString *imageURL = [NSString stringWithFormat:@"%@",pic.Logo];
    self.proImage.clipsToBounds = YES;
    [self.proImage sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    self.allPriceLab.text = [NSString stringWithFormat:@"￥%@",[self.priceDic objectForKey:@"extendprice"]];
    self.priceLab.text = [NSString stringWithFormat:@"￥%@",[self.priceDic objectForKey:@"price"]];
}

@end
