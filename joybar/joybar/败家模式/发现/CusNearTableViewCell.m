//
//  CusNearTableViewCell.m
//  joybar
//
//  Created by 123 on 15/5/5.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "CusNearTableViewCell.h"
#import "CusHomeStoreViewController.h"
@implementation CusNearTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setData:(NSDictionary *)dic
{
    UIImageView *headImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 55, 55)];
    headImg.layer.cornerRadius = headImg.width/2;
    headImg.clipsToBounds = YES;
    [headImg sd_setImageWithURL:[NSURL URLWithString:self.nearItems.BuyerLogo] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    headImg.userInteractionEnabled = YES;
    [self.contentView addSubview:headImg];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickHeaderImage:)];
    [headImg addGestureRecognizer:tap];
    
    
    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(headImg.right+10, headImg.top+5, 170, 20)];
    nameLab.text = self.nearItems.UserName;
    nameLab.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:nameLab];
    
    UILabel *locationLab = [[UILabel alloc] initWithFrame:CGRectMake(headImg.right+10,nameLab.bottom+10 , 170, 20)];
    locationLab.text = self.nearItems.Address;
    locationLab.font = [UIFont systemFontOfSize:15];
    locationLab.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:locationLab];
    
    UIButton *attentionBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    attentionBtn.frame = CGRectMake(kScreenWidth-70, 20, 60, 30);
    attentionBtn.backgroundColor = [UIColor whiteColor];
    attentionBtn.layer.borderWidth = 1;
    attentionBtn.layer.borderColor = [UIColor orangeColor].CGColor;
    attentionBtn.layer.cornerRadius = 4;
    if ([self.nearItems.IsFavorite boolValue])
    {
        [attentionBtn setTitle:@"取消关注" forState:(UIControlStateNormal)];
    }
    else
    {
        [attentionBtn setTitle:@"关注" forState:(UIControlStateNormal)];
    }
    attentionBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [attentionBtn setTitleColor:[UIColor orangeColor] forState:(UIControlStateNormal)];
    [attentionBtn addTarget:self action:@selector(didClickAttentionBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:attentionBtn];
    
    for (int i=0; i<self.nearItems.Pic.count; i++)
    {   
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.center = CGPointMake(kScreenWidth/6+kScreenWidth/3*i, kScreenWidth/6-5+headImg.bottom+10);
        imageView.bounds = CGRectMake(0, 0, kScreenWidth/3-10, kScreenWidth/3-10);
        NSString *tempUrl = [NSString stringWithFormat:@"%@",[self.nearItems.Pic objectAtIndex:i]];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [imageView sd_setImageWithURL:[NSURL URLWithString:tempUrl] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        [self.contentView addSubview:imageView];
    }
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenWidth/3+55+24, kScreenWidth, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:line];
}

-(void)didClickAttentionBtn:(UIButton *)btn
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.nearItems.UserId forKey:@"FavoriteId"];
    if ([btn.titleLabel.text isEqualToString:@"关注"])
    {
        [dic setObject:@"1" forKey:@"Status"];
    }
    else
    {
        [dic setObject:@"0" forKey:@"Status"];
    }
    [HttpTool postWithURL:@"User/Favoite" params:dic isWrite:YES success:^(id json) {
        
        if ([[json objectForKey:@"isSuccessful"]boolValue])
        {
            if ([btn.titleLabel.text isEqualToString:@"关注"])
            {
                [btn setTitle:@"取消关注" forState:(UIControlStateNormal)];

                self.nearItems.IsFavorite =@"1";
            }
            else
            {
                [btn setTitle:@"关注" forState:(UIControlStateNormal)];
                
                self.nearItems.IsFavorite =@"0";
            }
        }
        else
        {
            NSLog(@"%@",[json objectForKey:@"message"]);
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}

-(void)didClickHeaderImage:(UITapGestureRecognizer *)tap
{
        CusHomeStoreViewController *VC = [[CusHomeStoreViewController alloc] init];
        VC.userName = self.nearItems.UserName;
        VC.userId = self.nearItems.UserId;
        [self.viewController.navigationController pushViewController:VC animated:YES];
}

@end
