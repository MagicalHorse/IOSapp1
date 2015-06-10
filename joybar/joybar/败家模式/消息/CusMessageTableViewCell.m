//
//  CusMessageTableViewCell.m
//  joybar
//
//  Created by 123 on 15/4/27.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "CusMessageTableViewCell.h"

@implementation CusMessageTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    
}
-(void)setData:(NSDictionary *)dic
{
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 79, kScreenWidth, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:line];
    
    UIImageView *headerImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 55, 55)];
    headerImg.layer.cornerRadius = headerImg.width/2;
    headerImg.backgroundColor = [UIColor orangeColor];
    [self.contentView addSubview:headerImg];
    
    UILabel *levelLab = [[UILabel alloc] initWithFrame:CGRectMake(headerImg.right+10, headerImg.top+3, 35, 15)];
    levelLab.backgroundColor = kCustomColor(228, 229, 230);
    levelLab.textAlignment = NSTextAlignmentCenter;
    levelLab.text = @"达人";
    levelLab.textColor = [UIColor grayColor];
    levelLab.layer.masksToBounds = YES;
    levelLab.layer.cornerRadius =2;
    levelLab.font = [UIFont fontWithName:@"youyuan" size:14];
    [self.contentView addSubview:levelLab];
    
    UILabel *namelab = [[UILabel alloc] initWithFrame:CGRectMake(levelLab.right+5, headerImg.top+2, kScreenWidth-170, 20)];
    namelab.text = @"啊实打实大师的阿萨德";
    namelab.font = [UIFont fontWithName:@"youyuan" size:16];
    [self.contentView addSubview:namelab];
    
    UILabel *lastMsg = [[UILabel alloc] initWithFrame:CGRectMake(headerImg.right+10, namelab.bottom+12, kScreenWidth-90, 20)];
    lastMsg.textColor = [UIColor grayColor];
    lastMsg.text = @"啊实打实大师大师的阿什顿";
    lastMsg.font =[UIFont fontWithName:@"youyuan" size:14];
    [self.contentView addSubview:lastMsg];
    
    UILabel *timeLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-40, namelab.top, 40, 20)];
    timeLab.text = @"13:00";
    timeLab.font = [UIFont fontWithName:@"youyuan" size:13];
    timeLab.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:timeLab];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
