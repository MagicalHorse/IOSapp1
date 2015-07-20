//
//  CusFansTableViewCell.m
//  joybar
//
//  Created by 123 on 15/5/12.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "CusFansTableViewCell.h"

@implementation CusFansTableViewCell
{
    FansModel *fanDataModel;
}
- (void)awakeFromNib {
    // Initialization code
}
-(void)setData:(FansModel *)fanModel
{
    fanDataModel = fanModel;
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 69, kScreenWidth, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:line];
    
    UIImageView *headerImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
    headerImg.layer.cornerRadius = headerImg.width/2;
    [headerImg sd_setImageWithURL:[NSURL URLWithString:fanModel.UserLogo] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    [self.contentView addSubview:headerImg];
    
    UILabel *levelLab = [[UILabel alloc] initWithFrame:CGRectMake(headerImg.right+10, headerImg.top+5, 0, 15)];
    levelLab.backgroundColor = kCustomColor(228, 229, 230);
    levelLab.textAlignment = NSTextAlignmentCenter;
    levelLab.text = @"达人";
    levelLab.textColor = [UIColor grayColor];
    levelLab.layer.masksToBounds = YES;
    levelLab.layer.cornerRadius =2;
    levelLab.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:levelLab];
    
    UILabel *namelab = [[UILabel alloc] initWithFrame:CGRectMake(levelLab.right+5, headerImg.top+4, kScreenWidth-190, 20)];
    namelab.text =fanModel.UserName;
    namelab.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:namelab];
    
//    UIImageView *locationImg = [[UIImageView alloc] initWithFrame:CGRectMake(headerImg.right+10, namelab.bottom+5, 13, 13)];
//    locationImg.image = [UIImage imageNamed:@"location"];
//    [self.contentView addSubview:locationImg];
//    
//    UILabel *locaLab = [[UILabel alloc] initWithFrame:CGRectMake(locationImg.right, namelab.bottom+2, kScreenWidth-130, 20)];
//    locaLab.textColor = [UIColor grayColor];
//    locaLab.text = @"中关村南大街华宇购物中心";
//    locaLab.font =[UIFont fontWithName:@"youyuan" size:12];
//    [self.contentView addSubview:locaLab];
    
    UILabel *attentionLab = [[UILabel alloc] initWithFrame:CGRectMake(headerImg.right+10, namelab.bottom+5, 70, 20)];
    attentionLab.text = [NSString stringWithFormat:@"关注 %@",fanModel.FavoiteCount];
    attentionLab.textColor = [UIColor lightGrayColor];
    attentionLab.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:attentionLab];
    
    UILabel *fansLab = [[UILabel alloc] initWithFrame:CGRectMake(attentionLab.right+5, namelab.bottom+5, 70, 20)];
    fansLab.text = [NSString stringWithFormat:@"粉丝 %@",fanModel.FansCount];
    fansLab.textColor = [UIColor lightGrayColor];
    fansLab.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:fansLab];

    
    UIButton *attentionBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    attentionBtn.frame = CGRectMake(kScreenWidth-70, 20, 60, 27);
    attentionBtn.layer.borderWidth= 0.5;
    attentionBtn.layer.borderColor = [UIColor darkGrayColor].CGColor;
    attentionBtn.layer.cornerRadius = 3;
    if ([fanModel.isFavorite boolValue])
    {
        [attentionBtn setTitle:@"取消关注" forState:(UIControlStateNormal)];
    }
    else
    {
        [attentionBtn setTitle:@"关注" forState:(UIControlStateNormal)];
    }
    [attentionBtn setTitleColor:[UIColor darkGrayColor] forState:(UIControlStateNormal)];
    attentionBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [attentionBtn addTarget:self action:@selector(didClickAttention:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:attentionBtn];
    
}

-(void)didClickAttention:(UIButton *)btn
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:fanDataModel.UserId forKey:@"FavoriteId"];
    if ([btn.titleLabel.text isEqualToString:@"关注"])
    {
        [dic setObject:@"1" forKey:@"Status"];
    }
    else
    {
        [dic setObject:@"0" forKey:@"Status"];
    }
    [HttpTool postWithURL:@"User/Favoite" params:dic success:^(id json) {
        
        if ([[json objectForKey:@"isSuccessful"]boolValue])
        {
            if ([btn.titleLabel.text isEqualToString:@"关注"])
            {
                [btn setTitle:@"取消关注" forState:(UIControlStateNormal)];
                
                fanDataModel.isFavorite =@"1";
            }
            else
            {
                [btn setTitle:@"关注" forState:(UIControlStateNormal)];
                
                fanDataModel.isFavorite =@"0";
            }
        }
        else
        {
            NSLog(@"%@",[json objectForKey:@"message"]);
        }
        
    } failure:^(NSError *error) {
        
    }];

}

@end
