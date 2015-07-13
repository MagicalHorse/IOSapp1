//
//  CusMineFirstTableViewCell.m
//  joybar
//
//  Created by 123 on 15/5/5.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "CusMineFirstTableViewCell.h"
#import "CusFansViewController.h"
#import "CusBuyerCircleViewController.h"
#import "CusAttentionViewController.h"
@implementation CusMineFirstTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setData:(MineData *)mineData
{
    UIView*bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 300-15)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.shadowOpacity = 0.5;
    [self.contentView addSubview:bgView];
    
    self.bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    self.bgImageView.image = [UIImage imageNamed:@"bgImage.png"];
    [bgView addSubview:self.bgImageView];
    
    UIImageView *circleImage = [[UIImageView alloc] init];
    circleImage.center = CGPointMake(kScreenWidth/2, 110);
    circleImage.bounds = CGRectMake(0, 0, 75, 75);
    circleImage.layer.borderWidth = 0.5;
    circleImage.layer.cornerRadius = circleImage.width/2;
    circleImage.layer.borderColor = [UIColor whiteColor].CGColor;
    circleImage.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:circleImage];
    
    UIImageView *headImage = [[UIImageView alloc] init];
    headImage.center = CGPointMake(circleImage.center.x, circleImage.center.y);
    headImage.bounds = CGRectMake(0, 0, 65, 65);
    headImage.layer.cornerRadius = headImage.width/2;
    headImage.clipsToBounds = YES;
    NSString *url = [[Public getUserInfo] objectForKey:@"logo"];
    [headImage sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    [self.contentView addSubview:headImage];

    UILabel *namelab =[[UILabel alloc] init];
    namelab.center = CGPointMake(headImage.center.x, circleImage.bottom+15);
    namelab.bounds = CGRectMake(0, 0, 150, 150);
    namelab.text = [[Public getUserInfo] objectForKey:@"nickname"];
    namelab.textColor = [UIColor whiteColor];
    namelab.textAlignment = NSTextAlignmentCenter;
    namelab.font = [UIFont fontWithName:@"youyuan" size:18];
    [self.contentView addSubview:namelab];
        
    UIView *tempView = [[UIView alloc] init];
    tempView.center = CGPointMake(kScreenWidth/2, self.bgImageView.bottom+43);
    tempView.bounds = CGRectMake(0, 0, kScreenWidth-60, 70);
    tempView.backgroundColor = [UIColor clearColor];
    [bgView addSubview:tempView];
    
    NSArray *nameArr = @[@"关注",@"粉丝",@"圈子"];
    NSArray *numArr ;
    if(mineData)
    {
        numArr = @[mineData.FollowingCount,mineData.FollowerCount,mineData.CommunityCount];
    }
    else
    {
        numArr = @[@"0",@"0",@"0"];
    }
    for (int i=0; i<3; i++)
    {
        UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        btn.center = CGPointMake(tempView.width/3*i+tempView.width/6, 35);
        btn.bounds = CGRectMake(0, 0, 70, 70);
        btn.adjustsImageWhenHighlighted = NO;
        [btn setImage:[UIImage imageNamed:@"圆.png"] forState:(UIControlStateNormal)];
        btn.tag = 1000+i;
        [btn addTarget:self action:@selector(didClickBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        [tempView addSubview:btn];
        
        UILabel *numLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 30, 13)];
        numLab.font = [UIFont fontWithName:@"youyuan" size:12];
        numLab.textColor = [UIColor darkGrayColor];
        numLab.textAlignment = NSTextAlignmentCenter;
        numLab.text = [numArr objectAtIndex:i];
        [btn addSubview:numLab];
        
        UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(20, numLab.bottom, 30, 20)];
        nameLab.font = [UIFont fontWithName:@"youyuan" size:14];
        nameLab.textColor = [UIColor grayColor];
        nameLab.text = [nameArr objectAtIndex:i];
        nameLab.textAlignment = NSTextAlignmentCenter;
        [btn addSubview:nameLab];
    }
}

-(void)didClickBtn:(UIButton *)btn
{
    switch (btn.tag)
    {
        case 1000:
        {
            CusAttentionViewController *VC = [[CusAttentionViewController alloc] init];
            [self.viewController.navigationController pushViewController:VC animated:YES];
        }
            
            break;
            
        case 1001:
        {
            CusFansViewController *VC = [[CusFansViewController alloc] init];
            VC.titleStr = @"粉丝";
            [self.viewController.navigationController pushViewController:VC animated:YES];

        }
            break;

        case 1002:
        {
            CusBuyerCircleViewController *VC = [[CusBuyerCircleViewController alloc] init];
            [self.viewController.navigationController pushViewController:VC animated:YES];
        }
            break;

        default:
            break;
    }
}



@end
