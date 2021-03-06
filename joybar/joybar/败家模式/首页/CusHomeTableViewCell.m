//
//  CusHomeTableViewCell.m
//  joybar
//
//  Created by 123 on 15/4/24.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "CusHomeTableViewCell.h"
#import "CusHomeStoreViewController.h"
#import "HomeUsers.h"
#import "HomePicTag.h"
#import "CusChatViewController.h"
@implementation CusHomeTableViewCell
{
    CGFloat cellHeight;
}
-(void)setData:(NSDictionary *)dic
{
    UIImageView *headImg = [[UIImageView alloc] initWithFrame:CGRectMake(7, 7, 55, 55)];
    [headImg sd_setImageWithURL:[NSURL URLWithString:self.homePro.BuyerLogo] placeholderImage:[UIImage imageNamed:@"1.jpg"]];
    headImg.layer.cornerRadius = headImg.width/2;
    headImg.clipsToBounds = YES;
    headImg.userInteractionEnabled = YES;
    [self.contentView addSubview:headImg];
    
    UITapGestureRecognizer *headImageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didCLickHeaderImage)];
    [headImg addGestureRecognizer:headImageTap];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(headImg.width+20, 7, kScreenWidth-100, 30)];
    titleLab.text = self.homePro.BuyerName;
    titleLab.font = [UIFont fontWithName:@"youyuan" size:18];
    [self.contentView addSubview:titleLab];
    
    UIImageView *locationImg = [[UIImageView alloc] initWithFrame:CGRectMake(headImg.width+20, titleLab.bottom+3, 13, 13)];
    locationImg.image = [UIImage imageNamed:@"location.png"];
    [self.contentView addSubview:locationImg];
    
    UILabel *locationLab = [[UILabel alloc] initWithFrame:CGRectMake(locationImg.right, titleLab.bottom, kScreenWidth-170, 20)];
    locationLab.text = self.homePro.BuyerAddress;
    locationLab.font = [UIFont fontWithName:@"youyuan" size:13];
    locationLab.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:locationLab];
    
    UILabel *timeLab =[[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-90, titleLab.bottom, 80, 20)];
    timeLab.text = self.homePro.CreateTime;
    timeLab.textAlignment = NSTextAlignmentRight;
    timeLab.textColor = [UIColor lightGrayColor];
    timeLab.font = [UIFont fontWithName:@"youyuan" size:13];
    [self.contentView addSubview:timeLab];
    
    //展示图片
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, locationLab.bottom+17, kScreenWidth, kScreenHeight-350)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@_320x0.jpg",self.homePro.ProductPic.Name]] placeholderImage:[UIImage imageNamed:@"test.jpg"]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.userInteractionEnabled = YES;
    [self.contentView addSubview:imageView];
    
    //标签View
    for (int i=0; i<self.homePro.ProductPic.Tags.count; i++)
    {
        HomePicTag *tag = [self.homePro.ProductPic.Tags objectAtIndex:i];
        CGSize size = [Public getContentSizeWith:tag.TagName andFontSize:13 andHigth:20];
        CGFloat x = [tag.PosX floatValue];
        CGFloat y = [tag.PosY floatValue];
        UIView *tagView = [[UIView alloc] initWithFrame:CGRectMake(x, y, size.width+30, 25)];
        tagView.backgroundColor = [UIColor clearColor];
        [imageView addSubview:tagView];
        
        UIImageView *pointImage = [[UIImageView alloc] init];
        pointImage.center = CGPointMake(10, tagView.height/2);
        pointImage.bounds = CGRectMake(0, 0, 12, 12);
        pointImage.image = [UIImage imageNamed:@"yuan"];
        [tagView addSubview:pointImage];
        
        UIImageView *jiaoImage = [[UIImageView alloc] initWithFrame:CGRectMake(pointImage.right+5, 0, 15, tagView.height)];
        jiaoImage.image = [UIImage imageNamed:@"bqqian"];
        [tagView addSubview:jiaoImage];
        
        UIImageView *tagImage = [[UIImageView alloc] initWithFrame:CGRectMake(jiaoImage.right, 0, size.width+10, tagView.height)];
        tagImage.image = [UIImage imageNamed:@"bqhou"];
        [tagView addSubview:tagImage];
        
        UILabel *tagLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tagImage.width, tagView.height)];
        tagLab.textColor = [UIColor whiteColor];
        tagLab.font = [UIFont fontWithName:@"youyuan" size:13];
        tagLab.text = tag.TagName;
        [tagImage addSubview:tagLab];
    }
    
    UILabel *descriptionLab = [[UILabel alloc] initWithFrame:CGRectMake(10, imageView.bottom+10, kScreenWidth-20, 20)];
    descriptionLab.text = self.homePro.ProductName;
    descriptionLab.font = [UIFont fontWithName:@"youyuan" size:16];
    [self.contentView addSubview:descriptionLab];
    
    UILabel *priceLab = [[UILabel alloc] initWithFrame:CGRectMake(10, descriptionLab.bottom+14, 100, 20)];
    priceLab.text = [NSString stringWithFormat:@"￥%@",self.homePro.Price];
    priceLab.font = [UIFont fontWithName:@"youyuan" size:18];
    priceLab.textColor = [UIColor redColor];
    [self.contentView addSubview:priceLab];
    
    UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-100, descriptionLab.bottom+10, 80, 33)];
    shareBtn.backgroundColor = kCustomColor(248, 248, 248);
    shareBtn.layer.borderColor = kCustomColor(236, 236, 236).CGColor;
    [shareBtn setTitle:@" 分享" forState:(UIControlStateNormal)];
    [shareBtn setImage:[UIImage imageNamed:@"fenxiang"] forState:(UIControlStateNormal)];
    [shareBtn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
    shareBtn.titleLabel.font =[UIFont fontWithName:@"youyuan" size:14];
    shareBtn.layer.borderWidth = 0.5;
    shareBtn.layer.cornerRadius = 3;
    [shareBtn addTarget:self action:@selector(didClickShare:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:shareBtn];

    UIButton *chatBtn = [[UIButton alloc] initWithFrame:CGRectMake(shareBtn.left-100, descriptionLab.bottom+10, 80, 33)];
    chatBtn.backgroundColor = kCustomColor(248, 248, 248);
    chatBtn.layer.borderColor = kCustomColor(236, 236, 236).CGColor;
    [chatBtn setTitle:@" 私聊" forState:(UIControlStateNormal)];
    [chatBtn setImage:[UIImage imageNamed:@"评论"] forState:(UIControlStateNormal)];
    [chatBtn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
    chatBtn.titleLabel.font =[UIFont fontWithName:@"youyuan" size:14];
    chatBtn.layer.borderWidth = 0.5;
    chatBtn.layer.cornerRadius = 3;
    [chatBtn addTarget:self action:@selector(didClickChat) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:chatBtn];
    
    UIButton *collectBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    collectBtn.backgroundColor = [UIColor clearColor];
    collectBtn.frame = CGRectMake(0, chatBtn.bottom+10, 60, 30);
    if ([self.homePro.LikeUsers.IsLike boolValue])
    {
        [collectBtn setImage:[UIImage imageNamed:@"点赞h"] forState:(UIControlStateNormal)];
        collectBtn.selected = YES;
    }
    else
    {
        [collectBtn setImage:[UIImage imageNamed:@"点赞"] forState:(UIControlStateNormal)];
        collectBtn.selected = NO;
    }
    
    if (!self.homePro.LikeUsers.Count)
    {
        [collectBtn setTitle:@"0" forState:(UIControlStateNormal)];
    }
    else
    {
        [collectBtn setTitle:self.homePro.LikeUsers.Count forState:(UIControlStateNormal)];
    }
    [collectBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    collectBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [collectBtn addTarget:self action:@selector(didClickCollect:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:collectBtn];

    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth-260, chatBtn.bottom+10, 240, 30)];
    bgView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:bgView];
    
    for (int i=0; i<self.homePro.LikeUsers.Users.count; i++)
    {
        HomeUsers *user = [self.homePro.LikeUsers.Users objectAtIndex:i];
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(35*i, 0, 30, 30)];
        img.layer.cornerRadius = img.width/2;
        img.clipsToBounds = YES;
        [img sd_setImageWithURL:[NSURL URLWithString:user.Logo] placeholderImage:[UIImage imageNamed:@"test.jpg"]];
        img.backgroundColor = kCustomColor(245, 246, 247);

        img.tag = 1000+i;
        img.userInteractionEnabled = YES;
        [bgView addSubview:img];
//        if (i==6)
//        {
//            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, img.width, img.height-10)];
//            lab.text = @"...";
//            lab.textAlignment =NSTextAlignmentCenter;
//            lab.textColor = [UIColor blackColor];
//            [img addSubview:lab];
//        }
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickImage:)];
        [img addGestureRecognizer:tap];
    }
}

//分享
-(void)didClickShare:(UIButton *)btn
{
    if (!TOKEN)
    {
        [Public showLoginVC:self.viewController];
        return;
    }
    

}

//私聊
-(void)didClickChat
{
    if (!TOKEN)
    {
        [Public showLoginVC:self.viewController];
        return;
    }
    
    CusChatViewController *VC = [[CusChatViewController alloc] initWithUserId:self.homePro.Buyerid AndTpye:2 andUserName:self.homePro.BuyerName];
    [self.viewController.navigationController pushViewController:VC animated:YES];

}


//点击头像
-(void)didCLickHeaderImage
{
    CusHomeStoreViewController *VC = [[CusHomeStoreViewController alloc] init];
    VC.userId = self.homePro.Buyerid;
    VC.userName = self.homePro.BuyerName;
    [self.viewController.navigationController pushViewController:VC animated:YES];
}

-(void)didClickImage:(UITapGestureRecognizer *)tap
{
    
}

//收藏
-(void)didClickCollect:(UIButton *)btn
{
    if (!TOKEN)
    {
        [Public showLoginVC:self.viewController];
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.homePro.ProductId forKey:@"Id"];
    if (btn.selected==NO)
    {
        [dic setObject:@"1" forKey:@"Status"];
    }
    else
    {
        [dic setObject:@"0" forKey:@"Status"];
    }
    [HttpTool postWithURL:@"Product/Like" params:dic success:^(id json) {
        
        if ([[json objectForKey:@"isSuccessful"] boolValue])
        {
            if (btn.selected==NO)
            {
                self.homePro.LikeUsers.Count = [NSString stringWithFormat:@"%ld",[self.homePro.LikeUsers.Count integerValue]+1];
                self.homePro.LikeUsers.IsLike = @"1";
                [btn setImage:[UIImage imageNamed:@"点赞h"] forState:(UIControlStateNormal)];
                [btn setTitle:self.homePro.LikeUsers.Count forState:(UIControlStateNormal)];
                btn.selected = YES;
            }
            else
            {
                
                self.homePro.LikeUsers.Count = [NSString stringWithFormat:@"%ld",[self.homePro.LikeUsers.Count integerValue]-1];
                self.homePro.LikeUsers.IsLike = @"0";

                [btn setImage:[UIImage imageNamed:@"点赞"] forState:(UIControlStateNormal)];
                [btn setTitle:self.homePro.LikeUsers.Count forState:(UIControlStateNormal)];
                btn.selected = NO;
            }

        }
        else
        {
            
        }
        
    } failure:^(NSError *error) {
        
    }];
}

@end
