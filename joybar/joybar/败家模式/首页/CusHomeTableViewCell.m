//
//  CusHomeTableViewCell.m
//  joybar
//
//  Created by 123 on 15/4/24.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "CusHomeTableViewCell.h"
#import "CusHomeStoreViewController.h"
#import "SDWebImageManager.h"
#import "CusBrandDetailViewController.h"
#import "CusMoreBrandViewController.h"
#import "CusRProDetailViewController.h"
#import "CusZProDetailViewController.h"
@implementation CusHomeTableViewCell
{
    CGFloat cellHeight;
    MZTimerLabel *timer3;
    UILabel *showLab;
    
    UIView *tempView;
    UIImageView *imageView;
    UILabel *timeLab;
    UILabel *nameLab;
    UILabel *describeLab;
    UILabel *localLab;
    UIImageView *localImage;
    UILabel *distanceLab;
    
    UIView *brandView;
    UIView *lineView;
    UIView *proView;
    NSDictionary *infoDic;
    NSMutableArray *brandArr;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        brandArr = [NSMutableArray array];
        
        tempView = [[UIView alloc] initWithFrame:CGRectMake(5, 10, kScreenWidth-10, 100)];
        tempView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:tempView];
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
        imageView.backgroundColor = [UIColor orangeColor];
        [tempView addSubview:imageView];
        
        //倒计时
        showLab = [[UILabel alloc] initWithFrame:CGRectMake(tempView.width-120, 0, 60, 20)];
        showLab.backgroundColor = kCustomColor(251, 163, 41);
        showLab.textColor = [UIColor whiteColor];
        showLab.font = [UIFont systemFontOfSize:11];
        [tempView addSubview:showLab];
        
        timeLab = [[UILabel alloc] initWithFrame:CGRectMake(showLab.right, 0, 60, 20)];
        timeLab.backgroundColor = kCustomColor(251, 163, 41);
        timeLab.textColor = [UIColor whiteColor];
        timeLab.font = [UIFont systemFontOfSize:11];
        [tempView addSubview:timeLab];
        
        timer3 = [[MZTimerLabel alloc] initWithLabel:timeLab andTimerType:MZTimerLabelTypeTimer];
        timer3.delegate = self;
        [timer3 start];
        
        nameLab = [[UILabel alloc] initWithFrame:CGRectMake(imageView.right+5, imageView.top+5, tempView.width-90-120, 20)];
        nameLab.font = [UIFont systemFontOfSize:16];
        [tempView addSubview:nameLab];
        
        //认证买手
        describeLab = [[UILabel alloc] init];
        describeLab.font = [UIFont systemFontOfSize:11];
        describeLab.numberOfLines = 2;
        CGSize size = [Public getContentSizeWith:describeLab.text andFontSize:11 andWidth:tempView.width-90];
        describeLab.frame = CGRectMake(imageView.right+5, nameLab.bottom+8, tempView.width-90, size.height-13);
        [tempView addSubview:describeLab];
        
        //商场
        localImage = [[UIImageView alloc] initWithFrame:CGRectMake(imageView.right+5, nameLab.bottom+18, 12, 12)];
        localImage.image = [UIImage imageNamed:@"location"];
        [tempView addSubview:localImage];
        
        localLab = [[UILabel alloc] initWithFrame:CGRectMake(localImage.right+3, nameLab.bottom+15, tempView.width-140, 20)];
        localLab.font = [UIFont systemFontOfSize:11];
        [tempView addSubview:localLab];
        
        distanceLab = [[UILabel alloc] initWithFrame:CGRectMake(tempView.width-45, nameLab.bottom+15, 40, 20)];
        distanceLab.font = [UIFont systemFontOfSize:11];
        [tempView addSubview:distanceLab];
        
        brandView = [[UIView alloc] initWithFrame:CGRectMake(0, imageView.bottom+15, tempView.width, 0)];
        brandView.backgroundColor = [UIColor clearColor];
        [tempView addSubview:brandView];
        
        lineView = [[UIView alloc] initWithFrame:CGRectMake(10, brandView.bottom, tempView.width-20, 1)];
        lineView.backgroundColor = kCustomColor(220, 221, 221);
        [tempView addSubview:lineView];
        
        proView = [[UIView alloc] initWithFrame:CGRectMake(0, brandView.bottom+15, tempView.width, tempView.width/3-10)];
        proView.backgroundColor = [UIColor clearColor];
        [tempView addSubview:proView];
        
    }
    return self;
}

-(void)setData:(NSDictionary *)dic andIndexPath:(NSIndexPath *)indexPath
{
    infoDic = dic;
    [brandArr addObjectsFromArray: [dic objectForKey:@"Brands"]];
    NSString *StoreLeave = [NSString stringWithFormat:@"%@",[dic objectForKey:@"StoreLeave"]];
    CGFloat tempViewHeight;
    if ([StoreLeave isEqualToString:@"8"])
    {
        //认证买手
        tempViewHeight = (kScreenWidth-20)/3-10+160;
        
    }
    else
    {
        //商场
        if (brandArr.count>0)
        {
            tempViewHeight = (kScreenWidth-20)/3-10+140;
        }
        else
        {
            tempViewHeight = (kScreenWidth-20)/3-10+120;
        }
    }
    
    tempView.frame = CGRectMake(5, 10, kScreenWidth-10, tempViewHeight);
    [imageView sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"Logo"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    //如果IsStart=true  则是剩余结束时间，否则是剩余开始时间
    BOOL IsStart = [[dic objectForKey:@"IsStart"] boolValue];
    //营业时长（秒）
    NSInteger BusinessTime = [[dic objectForKey:@"BusinessTime"] intValue];
    //剩余时长（秒）
    NSInteger RemainTime = [[dic objectForKey:@"RemainTime"] intValue];
    
    if (IsStart)
    {
        [timer3 setCountDownTime:RemainTime];
        showLab.text = @" 距离结束 :";
    }
    else
    {
        [timer3 setCountDownTime:BusinessTime];
        showLab.text = @" 距离开始 :";
    }
    nameLab.text = [dic objectForKey:@"Name"];
    
    if ([StoreLeave isEqualToString:@"8"])
    {
        localImage.hidden = YES;
        localLab.hidden = YES;
        distanceLab.hidden = YES;
        describeLab.hidden = NO;
        //认证买手
        describeLab.text = [dic objectForKey:@"Description"];
        CGSize size = [Public getContentSizeWith:describeLab.text andFontSize:11 andWidth:tempView.width-90];
        describeLab.frame = CGRectMake(imageView.right+5, nameLab.bottom+8, tempView.width-90, 40-13);
    }
    else
    {
        //商场
        localImage.hidden = NO;
        localLab.hidden = NO;
        distanceLab.hidden = NO;
        describeLab.hidden = YES;
        
        NSString *lat = [[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"];
        NSString *lon = [[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"];
        NSString *distance = [Public getDistanceWithLocation:[lat doubleValue] and:[lon doubleValue] and:[[dic objectForKey:@"Lat"] doubleValue] and:[[dic objectForKey:@"Lon"] doubleValue]];
        distanceLab.text = [NSString stringWithFormat:@"%.1fKM",[distance floatValue]/1000];
        localLab.text = [dic objectForKey:@"Location"];
    }
    if (brandArr.count>0)
    {
        brandView.frame = CGRectMake(0, imageView.bottom+15, tempView.width, 20);
        lineView.frame = CGRectMake(10, brandView.bottom+5, tempView.width-20, 1);
        proView.frame = CGRectMake(0, brandView.bottom+15, tempView.width, tempView.width/3-10);
        for (UIView *view in brandView.subviews)
        {
            [view removeFromSuperview];
        }

        //品牌
        
        CGFloat beforeBtnWith=0;
        CGFloat totalWidth=0;
        for (int i=0; i<brandArr.count; i++)
        {
            NSString *brandName = [brandArr[i] objectForKey:@"BrandName"] ;
            CGSize btnSize = [Public getContentSizeWith:brandName andFontSize:13 andHigth:20];
            
            totalWidth = btnSize.width+10+totalWidth;
            if (totalWidth>tempView.width-62)
            {
                [brandArr removeLastObject];
                
                UIButton *brandBtn  =[UIButton buttonWithType:(UIButtonTypeCustom)];
                brandBtn.frame = CGRectMake(tempView.width-52-15, 0, 56, 20);
                brandBtn.backgroundColor = kCustomColor(220, 221, 221);
                [brandBtn setTitle:@"更多品牌" forState:(UIControlStateNormal)];
                [brandBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
                brandBtn.titleLabel.font = [UIFont systemFontOfSize:13];
                brandBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
                [brandBtn addTarget:self action:@selector(didClickMoreBrand) forControlEvents:(UIControlEventTouchUpInside)];
                [brandView addSubview:brandBtn];
            }
            else
            {
                UIButton *btn  =[UIButton buttonWithType:(UIButtonTypeCustom)];
                btn.backgroundColor = kCustomColor(220, 221, 221);
                [btn setTitle:brandName forState:(UIControlStateNormal)];
                [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
                btn.titleLabel.font = [UIFont systemFontOfSize:13];
                btn.titleLabel.textAlignment = NSTextAlignmentCenter;
                btn.tag = i+100;
                [btn addTarget:self action:@selector(didClickBrand:) forControlEvents:(UIControlEventTouchUpInside)];
                
                btn.frame = CGRectMake(10*(i+1)+beforeBtnWith+2, 0, btnSize.width+4, 20);
                [brandView addSubview:btn];
                beforeBtnWith = btnSize.width+beforeBtnWith;
            }
        }
    }

    for (UIView *view in proView.subviews)
    {
        [view removeFromSuperview];
    }
    CGFloat imageWidth = tempView.width/3-10;
    NSArray *products = [dic objectForKey:@"Products"];
    //商品
    for (int i=0; i<products.count; i++)
    {
        NSDictionary *proDic = [products objectAtIndex:i];
        UIImageView *proImage = [[UIImageView alloc] initWithFrame:CGRectMake(imageWidth*i+5*i+10, 0, imageWidth, imageWidth)];
        //            proImage.backgroundColor = [UIColor orangeColor];
        [proImage sd_setImageWithURL:[NSURL URLWithString:[proDic objectForKey:@"Pic"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        proImage.userInteractionEnabled = YES;
        proImage.tag = 10+i;
        [proView addSubview:proImage];
        
        UITapGestureRecognizer *proTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickProView:)];
        [proImage addGestureRecognizer:proTap];
        
        if ([StoreLeave isEqualToString:@"8"])
        {
            UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, proImage.height/4*3, proImage.width, proImage.height/4)];
            bgView.backgroundColor = [UIColor blackColor];
            bgView.alpha =0.3;
            [proImage addSubview:bgView];
            
            UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, proImage.width/2, proImage.height/4)];
            price.textColor = [UIColor whiteColor];
            price.text = [NSString stringWithFormat:@"￥%@",[proDic objectForKey:@"Price"]];
            price.font = [UIFont systemFontOfSize:14];
            [bgView addSubview:price];
            
            UILabel *discountPrice = [[UILabel alloc] initWithFrame:CGRectMake(price.right, 2, proImage.width/2, proImage.height/4-2)];
            discountPrice.textColor = [UIColor whiteColor];
            discountPrice.text = [NSString stringWithFormat:@"￥%@",[proDic objectForKey:@"UnitPrice"]];
            discountPrice.font = [UIFont systemFontOfSize:11];
            [bgView addSubview:discountPrice];
            
            CGSize size = [Public getContentSizeWith:discountPrice.text andFontSize:11 andHigth:proImage.height/4-2];
            
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, bgView.height/2, size.width, 1)];
            line.backgroundColor = [UIColor whiteColor];
            [discountPrice addSubview:line];
            
            UIImageView *buyerHeaderImage = [[UIImageView alloc] initWithFrame:CGRectMake(proImage.left, proImage.bottom+5, 40, 40)];
            buyerHeaderImage.clipsToBounds = YES;
            buyerHeaderImage.layer.cornerRadius = buyerHeaderImage.width/2;
            [buyerHeaderImage sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"UserLogo"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            buyerHeaderImage.userInteractionEnabled = YES;
            buyerHeaderImage.tag = 100+i;
            [proView addSubview:buyerHeaderImage];
            
            UITapGestureRecognizer *headerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickHeaderImage:)];
            [buyerHeaderImage addGestureRecognizer:headerTap];
            
            UILabel *buyerName = [[UILabel alloc] initWithFrame:CGRectMake(buyerHeaderImage.right+5, proImage.bottom+8, proImage.width-50, 15)];
            buyerName.text = [proDic objectForKey:@"NickName"];
            buyerName.font = [UIFont systemFontOfSize:12];
            [proView addSubview:buyerName];
            
            UILabel *buyerBrandName = [[UILabel alloc] initWithFrame:CGRectMake(buyerHeaderImage.right+5, buyerName.bottom, proImage.width-50, 20)];
            buyerBrandName.text = [NSString stringWithFormat:@"BrandName"];
            buyerBrandName.font = [UIFont systemFontOfSize:11];
            [proView addSubview:buyerBrandName];
        }
    }
}

-(void)addBrandView
{
    
}


-(void)timerLabel:(MZTimerLabel*)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime
{
    [timer3 setCountDownTime:3];
    [timer3 start];
}

//点击更多品牌
-(void)didClickMoreBrand
{
    CusMoreBrandViewController *VC = [[CusMoreBrandViewController alloc] init];
    VC.storeId = [infoDic objectForKey:@"StoreId"];
    [self.viewController.navigationController pushViewController:VC animated:YES];
}

//点击品牌
-(void)didClickBrand:(UIButton *)btn
{
    CusBrandDetailViewController *VC = [[CusBrandDetailViewController alloc] init];
    VC.BrandId = [brandArr[btn.tag-100] objectForKey:@"BrandId"];
    VC.BrandId = [brandArr[btn.tag-100] objectForKey:@"BrandName"];
    [self.viewController.navigationController pushViewController:VC animated:YES];
}

//点击头像
-(void)didClickHeaderImage:(UITapGestureRecognizer *)tap
{
    NSInteger i = tap.view.tag-100;
    NSLog(@"%d",i);
}

//点商品
-(void)didClickProView:(UITapGestureRecognizer *)tap
{
    NSInteger i = tap.view.tag-10;
    NSArray *products = [infoDic objectForKey:@"Products"];
    NSString *proId = [products[i] objectForKey:@"ProductId"];
    NSString *Userleave = [NSString stringWithFormat:@"%@",[products[i]objectForKey:@"Userleave"]];

    if ([Userleave isEqualToString:@"8"])
    {
        
        //认证买手
        CusRProDetailViewController *VC = [[CusRProDetailViewController alloc] init];
        VC.productId = proId;
        [self.viewController.navigationController pushViewController:VC animated:YES];

    }
    else
    {
        CusZProDetailViewController *VC = [[CusZProDetailViewController alloc] init];
        VC.productId = proId;
        [self.viewController.navigationController pushViewController:VC animated:YES];
    }
    
}

@end
