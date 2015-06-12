//
//  CusMyCircleTableViewCell.m
//  joybar
//
//  Created by 123 on 15/5/4.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "CusMyCircleTableViewCell.h"

@implementation CusMyCircleTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = [UIColor whiteColor];
    self.headImage.layer.cornerRadius = self.headImage.width/2;
    self.headImage.clipsToBounds = YES;
    self.nameLab.font = [UIFont fontWithName:@"youyuan" size:17];
    self.timeLab.font = [UIFont fontWithName:@"youyuan" size:12];
    self.lastMessageLab.font = [UIFont fontWithName:@"youyuan" size:14];
    
    
}

-(void)setData:(NSDictionary *)dic
{
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"Logo"]] placeholderImage:nil];
    self.nameLab.text = [dic objectForKey:@"Name"];
//    self.timeLab.text = [dic objectForKey:@""];

}

@end
