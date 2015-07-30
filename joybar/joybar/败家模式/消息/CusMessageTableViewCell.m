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
    headerImg.clipsToBounds = YES;
    [headerImg sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"Logo"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    [self.contentView addSubview:headerImg];
    
    UILabel *msgCountLab = [[UILabel alloc] initWithFrame:CGRectMake(headerImg.right-25, -5, 20, 20)];
    NSString *count = [NSString stringWithFormat:@"%@",[dic objectForKey:@"UnReadCount"]];
    if ([count isEqualToString:@"0"])
    {
        msgCountLab.hidden = YES;
    }
    else
    {
        msgCountLab.hidden = NO;
    }
    msgCountLab.text = count;
    msgCountLab.backgroundColor = [UIColor redColor];
    msgCountLab.textColor = [UIColor whiteColor];
    msgCountLab.font = [UIFont systemFontOfSize:13];
    msgCountLab.layer.cornerRadius = msgCountLab.width/2;
    msgCountLab.layer.masksToBounds = YES;
    msgCountLab.textAlignment = NSTextAlignmentCenter;
    [headerImg addSubview:msgCountLab];
    
    UILabel *levelLab = [[UILabel alloc] initWithFrame:CGRectMake(headerImg.right+10, headerImg.top+3, 0, 15)];
    levelLab.backgroundColor = kCustomColor(228, 229, 230);
    levelLab.textAlignment = NSTextAlignmentCenter;
    levelLab.text = @"达人";
    levelLab.textColor = [UIColor grayColor];
    levelLab.layer.masksToBounds = YES;
    levelLab.layer.cornerRadius =2;
    levelLab.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:levelLab];
    
    UILabel *namelab = [[UILabel alloc] initWithFrame:CGRectMake(levelLab.right+5, headerImg.top+2, kScreenWidth-170, 20)];
    namelab.text = [dic objectForKey:@"Name"];
    namelab.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:namelab];
    
    UILabel *lastMsg = [[UILabel alloc] initWithFrame:CGRectMake(headerImg.right+10, namelab.bottom+12, kScreenWidth-90, 20)];
    lastMsg.textColor = [UIColor grayColor];
    lastMsg.text = [dic objectForKey:@"UnReadMessage"];
    lastMsg.font =[UIFont systemFontOfSize:14];
    [self.contentView addSubview:lastMsg];
    
    UILabel *timeLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-40, namelab.top, 40, 20)];
    timeLab.text = [dic objectForKey:@"UpdateTime"];
    timeLab.font = [UIFont systemFontOfSize:13];
    timeLab.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:timeLab];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
