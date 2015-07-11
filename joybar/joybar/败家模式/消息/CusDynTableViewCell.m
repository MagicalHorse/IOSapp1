//
//  CusDynTableViewCell.m
//  joybar
//
//  Created by 123 on 15/4/27.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "CusDynTableViewCell.h"

@implementation CusDynTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setData:(NSDictionary *)dic
{
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 79, kScreenWidth, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:line];
    
    UIImageView *headerImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 55, 55)];
    headerImg.layer.cornerRadius = headerImg.width/2;
    [headerImg sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"Logo"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    [self.contentView addSubview:headerImg];
    
    UILabel *namelab = [[UILabel alloc] initWithFrame:CGRectMake(headerImg.right+10, headerImg.top+5, kScreenWidth-250, 20)];
    namelab.text = [dic objectForKey:@"UserName"];
    namelab.font = [UIFont fontWithName:@"youyuan" size:16];
    [self.contentView addSubview:namelab];
    
    UILabel *typeLab =[[UILabel alloc] initWithFrame:CGRectMake(namelab.right+5, namelab.top, 100, 20)];
    typeLab.text = [dic objectForKey:@"Context"];
    typeLab.textColor = [UIColor lightGrayColor];
    typeLab.font = [UIFont fontWithName:@"youyuan" size:15];
    [self.contentView addSubview:typeLab];
    
    UILabel *timeLab = [[UILabel alloc] initWithFrame:CGRectMake(headerImg.right+10, namelab.bottom+10, kScreenWidth-90, 20)];
    timeLab.textColor = [UIColor grayColor];
    timeLab.text = [dic objectForKey:@"CreateTime"];
    timeLab.font =[UIFont fontWithName:@"youyuan" size:14];
    [self.contentView addSubview:timeLab];
    
    UIImageView *typeImage =[[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-70 ,headerImg.top , 55, 55)];
    [typeImage sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"DataLogo"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    [self.contentView addSubview:typeImage];
}

@end
