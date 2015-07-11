//
//  CircleTableViewCell.m
//  joybar
//
//  Created by 123 on 15/4/20.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "CircleTableViewCell.h"
#import "UIView+Shadow.h"
#import "CusChatViewController.h"
@implementation CircleTableViewCell
{
    NSArray *arr;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void) setData:(NSArray *)dataArr
{
    arr = dataArr;
    NSArray *array1 = [self.contentView subviews];
    for (UIView *view in array1)
    {
        [view removeFromSuperview];
    }
    //构建单元格的视图区域
    for(int index = 0;index < dataArr.count; index ++ )
    {
        CGRect frame = CGRectMake(20+20*index+(kScreenWidth-60)/2*index, 20, (kScreenWidth-60)/2, (kScreenWidth-60)/2);
        UIImageView *image = [[UIImageView alloc] initWithFrame:frame];
        image.tag = index + 10;
        image.userInteractionEnabled = YES;
        image.image = [UIImage imageNamed:@"quanzi01.png"];
        [self.contentView addSubview:image];
        
        UIImageView *headImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 8, image.width-20, image.height-20)];
        headImage.layer.masksToBounds = YES;
        headImage.layer.cornerRadius = headImage.width/2;
        headImage.backgroundColor = [UIColor whiteColor];
        headImage.contentMode = UIViewContentModeScaleAspectFill;
        [headImage sd_setImageWithURL:[NSURL URLWithString:[[dataArr objectAtIndex:index] objectForKey:@"Logo"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        headImage.userInteractionEnabled = YES;
        headImage.tag = 1000+index;
        [image addSubview:headImage];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickImage:)];
        [headImage addGestureRecognizer:tap];
        
        UIImageView *shadowImg = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, headImage.width, headImage.height)];
//        headImage.contentMode = UIViewContentModeScaleAspectFill;
        shadowImg.image = [UIImage imageNamed:@"shadow.png"];
        [headImage addSubview:shadowImg];

        //圈子名称
        UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(20+20*index+(kScreenWidth-60)/2*index, image.bottom+10, image.width, 15)];
        nameLab.text = [[dataArr objectAtIndex:index] objectForKey:@"Name"];
        nameLab.textAlignment = NSTextAlignmentCenter;
        nameLab.font = [UIFont fontWithName:@"youyuan" size:15];
        [self.contentView addSubview:nameLab];
        
        
        UILabel *numLab = [[UILabel alloc] initWithFrame:CGRectMake(20+20*index+(kScreenWidth-60)/2*index, nameLab.bottom+3, image.width, 13)];
        numLab.text = [NSString stringWithFormat:@"人数: %@",[[dataArr objectAtIndex:index] objectForKey:@"MemberCount"]];
        numLab.textAlignment = NSTextAlignmentCenter;
        numLab.font = [UIFont fontWithName:@"youyuan" size:11];
        [self.contentView addSubview:numLab];
        
        UIImageView *locationImg = [[UIImageView alloc] initWithFrame:CGRectMake(35+20*index+(kScreenWidth-60)/2*index, numLab.bottom+3, 13, 13)];
        locationImg.image = [UIImage imageNamed:@"location.png"];
        [self.contentView addSubview:locationImg];
        
        
        UILabel *addressLab = [[UILabel alloc] initWithFrame:CGRectMake(locationImg.right, numLab.bottom+3, 100, 13)];
        addressLab.text = [[dataArr objectAtIndex:index] objectForKey:@"Address"];
        addressLab.textAlignment = NSTextAlignmentLeft;
        addressLab.textColor = [UIColor lightGrayColor];
        addressLab.backgroundColor = [UIColor clearColor];
        addressLab.font = [UIFont fontWithName:@"youyuan" size:11];
        [self.contentView addSubview:addressLab];
    }
}

-(void)didClickImage:(UITapGestureRecognizer *)tap
{
    NSString *circleId = [[arr objectAtIndex:tap.view.tag-1000] objectForKey:@"Id"];
    NSString *circleName = [[arr objectAtIndex:tap.view.tag-1000] objectForKey:@"Name"];
    CusChatViewController *VC = [[CusChatViewController alloc] initWithUserId:circleId AndTpye:2 andUserName:circleName];
    VC.circleId = circleId;
    VC.isFrom = isFromGroupChat;
    [self.viewController.navigationController pushViewController:VC animated:YES];
}

@end
