//
//  CusDynTableViewCell.m
//  joybar
//
//  Created by 123 on 15/4/27.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "CusDynTableViewCell.h"
#import "CusHomeStoreViewController.h"
#import "CusCircleDetailViewController.h"
#import "CusBuyerDetailViewController.h"
@implementation CusDynTableViewCell
{
    NSArray *dataArr;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setData:(NSArray *)arr andIndexPath:(NSIndexPath *)indexPath;
{
    dataArr = arr;
    NSDictionary *dic = [arr objectAtIndex:indexPath.row];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 79, kScreenWidth, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:line];
    
    UIImageView *headerImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 55, 55)];
    headerImg.layer.cornerRadius = headerImg.width/2;
    headerImg.clipsToBounds = YES;
    [headerImg sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"Logo"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    [self.contentView addSubview:headerImg];
    
    UILabel *namelab = [[UILabel alloc] initWithFrame:CGRectMake(headerImg.right+10, headerImg.top+5, kScreenWidth-250, 20)];
    namelab.text = [dic objectForKey:@"UserName"];
    namelab.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:namelab];
    
    UILabel *typeLab =[[UILabel alloc] initWithFrame:CGRectMake(namelab.right+5, namelab.top, 100, 20)];
    typeLab.text = [dic objectForKey:@"Context"];
    typeLab.textColor = [UIColor lightGrayColor];
    typeLab.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:typeLab];
    
    UILabel *timeLab = [[UILabel alloc] initWithFrame:CGRectMake(headerImg.right+10, namelab.bottom+10, kScreenWidth-90, 20)];
    timeLab.textColor = [UIColor grayColor];
    timeLab.text = [dic objectForKey:@"CreateTime"];
    timeLab.font =[UIFont systemFontOfSize:14];
    [self.contentView addSubview:timeLab];
    
    UIImageView *typeImage =[[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-70 ,headerImg.top , 55, 55)];
    [typeImage sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"DataLogo"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    typeImage.userInteractionEnabled = YES;
    typeImage.tag = 1000+indexPath.row;
    [self.contentView addSubview:typeImage];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickImage:)];
    [typeImage addGestureRecognizer:tap];
}

-(void)didClickImage:(UITapGestureRecognizer *)tap
{
    NSDictionary *dic = [dataArr objectAtIndex:tap.view.tag-1000];
    NSString *type = [NSString stringWithFormat:@"%@",[dic objectForKey:@"Type"]];
    NSString *tempId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"DataId"]];
    if ([type isEqualToString:@"0"])
    {
        CusHomeStoreViewController *VC = [[CusHomeStoreViewController alloc] init];
        VC.userId = tempId;
        VC.userName = [dic objectForKey:@"UserName"];
        [self.viewController.navigationController pushViewController:VC animated:YES];
    }
    else if ([type isEqualToString:@"1"])
    {
        CusCircleDetailViewController *VC= [[CusCircleDetailViewController alloc] init];
        VC.circleId = tempId;
        [self.viewController.navigationController pushViewController:VC animated:YES];
    }
    else
    {
        CusBuyerDetailViewController *VC = [[CusBuyerDetailViewController alloc] init];
        VC.productId = tempId;
        [self.viewController.navigationController pushViewController:VC animated:YES];
    }
}

@end
