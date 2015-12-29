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

-(void)setData:(NSDictionary *)dic
{

    NSString *imageURL = [NSString stringWithFormat:@"%@",[dic objectForKey:@"ProductPic"]];
    [self.proImage sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    self.proImage.clipsToBounds = YES;
    
    self.proNameLab.text = [dic objectForKey:@"ProductName"];
    self.sizeLab.text = [NSString stringWithFormat:@"%@:%@",[dic objectForKey:@"SizeName"],[dic objectForKey:@"SizeValue"]];
    self.numLab.text = [NSString stringWithFormat:@"x%@",[dic objectForKey:@"ProductCount"]];
    self.priceLab.text = [NSString stringWithFormat:@"￥%@",[dic objectForKey:@"Price"]];
}

@end
