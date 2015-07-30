//
//  CusFindTableViewCell.m
//  joybar
//
//  Created by 123 on 15/5/5.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "CusFindTableViewCell.h"
#import "CusTagViewController.h"
@implementation CusFindTableViewCell
{
    NSArray *dataArr;
}
- (void)awakeFromNib {
    // Initialization code
}

-(void)setData:(NSArray *)arr
{
    dataArr = arr;
    //构建单元格的视图区域
    for(int index = 0;index < arr.count; index ++ )
    {
        CGRect frame = CGRectMake(5+5*index+(kScreenWidth-15)/2*index, 5, (kScreenWidth-15)/2, (kScreenWidth-15)/2*0.618);
        UIImageView *proImage = [[UIImageView alloc] initWithFrame:frame];
        proImage.tag = index + 10;
        proImage.userInteractionEnabled = YES;
        proImage.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:proImage];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickImage:)];
        [proImage addGestureRecognizer:tap];
        
        UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(0, proImage.bottom-30, proImage.width, 15)];
        nameLab.textAlignment = NSTextAlignmentCenter;
        nameLab.text = @"阿里圣诞节阿萨德爱的阿萨德";
        nameLab.textColor = [UIColor whiteColor];
        nameLab.font = [UIFont systemFontOfSize:13];
        [proImage addSubview:nameLab];
    }

}

-(void)didClickImage:(UITapGestureRecognizer *)tap
{
    CusTagViewController *VC = [[CusTagViewController alloc] init];
    //    VC.BrandId = item.BrandId;
    //    VC.BrandName = item.BrandName;
    [self.viewController.navigationController pushViewController:VC animated:YES];

}


@end
