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
    self.msgCountLab.layer.cornerRadius = self.msgCountLab.width/2;
    self.msgCountLab.layer.masksToBounds = YES;
}

-(void)setData:(NSDictionary *)dic
{
    NSString *imgURL = [NSString stringWithFormat:@"%@_100x100.jpg",[dic objectForKey:@"Logo"]];
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:imgURL] placeholderImage:nil];
    self.nameLab.text = [dic objectForKey:@"Name"];
    self.timeLab.text = [dic objectForKey:@"UnReadLastTime"];
    
    NSString *count = [NSString stringWithFormat:@"%@",[dic objectForKey:@"UnReadCount"]];
    if ([count isEqualToString:@"0"])
    {
        self.msgCountLab.hidden = YES;
    }
    else
    {
        self.msgCountLab.text = count;
    }
    
}

@end
