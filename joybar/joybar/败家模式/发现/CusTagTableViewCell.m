//
//  CusTagTableViewCell.m
//  joybar
//
//  Created by 123 on 15/4/28.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "CusTagTableViewCell.h"
#import "CusBuyerDetailViewController.h"
@implementation CusTagTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
    }
    
    return self;
}

-(void) setData:(NSArray *)dataArr andIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array1 = [self.contentView subviews];
    for (UIView *view in array1)
    {
        [view removeFromSuperview];
    }
    //构建单元格的视图区域
    for(int index = 0;index < dataArr.count; index ++ )
    {
        UIImageView *tagImage = [[UIImageView alloc] init];
        
        CGRect frame = CGRectMake(5+5*index+(kScreenWidth-20)/3*index, 5, (kScreenWidth-20)/3, (kScreenWidth-20)/3);

        tagImage.frame = frame;
        
        tagImage.tag = index + 10;
        tagImage.userInteractionEnabled = YES;
        
        NSString *imageURL = [NSString stringWithFormat:@"%@",[[dataArr objectAtIndex:index] objectForKey:@"Pic"]];
        [tagImage sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        tagImage.contentMode = UIViewContentModeScaleAspectFill;
        tagImage.clipsToBounds = YES;
        [self.contentView addSubview:tagImage];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickTagImage:)];
        [tagImage addGestureRecognizer:tap];
    }
}

-(void)didClickTagImage:(UITapGestureRecognizer *)tap
{
    NSString *proId = [[self.dataArray objectAtIndex:tap.view.tag-10] objectForKey:@"ProductId"];
    CusBuyerDetailViewController *VC = [[CusBuyerDetailViewController alloc] init];
    VC.productId = proId;
    [self.viewController.navigationController pushViewController:VC animated:YES];
}

@end
