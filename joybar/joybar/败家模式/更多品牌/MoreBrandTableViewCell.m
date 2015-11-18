//
//  CusFindTableViewCell.m
//  joybar
//
//  Created by 123 on 15/5/5.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "MoreBrandTableViewCell.h"
#import "CusBrandDetailViewController.h"
@implementation MoreBrandTableViewCell
{
    NSArray *dataArr;
}

-(void)setData:(NSArray *)arr
{
    dataArr = arr;
    //构建单元格的视图区域
    for(int index = 0;index < arr.count; index ++ )
    {
        CGFloat height =(kScreenWidth-9)/2;
        CGRect frame = CGRectMake(3+3*index+height*index, 3, height, height*0.75);
        UIImageView *proImage = [[UIImageView alloc] initWithFrame:frame];
        proImage.tag = index + 10;
//        proImage.image = [UIImage imageNamed:@"123.jpg"];
        [proImage sd_setImageWithURL:[NSURL URLWithString:[[arr objectAtIndex:index] objectForKey:@"Pic"]] placeholderImage:nil];
        proImage.userInteractionEnabled = YES;
        proImage.contentMode = UIViewContentModeScaleAspectFill;
        proImage.clipsToBounds = YES;
        proImage.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:proImage];
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, proImage.width, proImage.height)];
        image.image = [UIImage imageNamed:@"jianbian"];
        [proImage addSubview:image];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickImage:)];
        [proImage addGestureRecognizer:tap];
        
        UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(0, proImage.bottom-30, proImage.width, 15)];
        nameLab.textAlignment = NSTextAlignmentCenter;
        nameLab.text = [[arr objectAtIndex:index] objectForKey:@"BrandName"];
        nameLab.textColor = [UIColor whiteColor];
        nameLab.font = [UIFont systemFontOfSize:15];
        [proImage addSubview:nameLab];
    }
}

-(void)didClickImage:(UITapGestureRecognizer *)tap
{
    NSDictionary *dic = [dataArr objectAtIndex:tap.view.tag-10];
    CusBrandDetailViewController *VC = [[CusBrandDetailViewController alloc] init];
        VC.BrandId = [dic objectForKey:@"BrandId"];
        VC.BrandName = [dic objectForKey:@"BrandName"];
    [self.viewController.navigationController pushViewController:VC animated:YES];
    
}


@end
