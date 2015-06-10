//
//  CusFindTableViewCell.m
//  joybar
//
//  Created by 123 on 15/5/5.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "CusFindTableViewCell.h"
#import "FindItems.h"
#import "FindProduct.h"
@implementation CusFindTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setData:(NSDictionary *)dic
{
    //品牌
    UIImageView *brandImage= [[UIImageView alloc] init];
    brandImage.center = CGPointMake(kScreenWidth/2, 30);
    brandImage.bounds = CGRectMake(0, 0, 50, 50);
    [brandImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@_100x100.jpg",self.findItems]] placeholderImage:nil];
    [self.contentView addSubview:brandImage];
    
    for (int i=0; i<4; i++)
    {
        FindProduct *findPro = [self.findItems.Product objectAtIndex:i];
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.center = CGPointMake(kScreenWidth/8+kScreenWidth/4*i, (kScreenWidth/4-5)/2+brandImage.bottom+10);
        imageView.bounds = CGRectMake(0, 0, kScreenWidth/4-5, kScreenWidth/4-5);
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@_100x100.jpg",findPro.Pic]] placeholderImage:nil];
        [self.contentView addSubview:imageView];
    }
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenWidth/4+70, kScreenWidth, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:line];
}

@end
