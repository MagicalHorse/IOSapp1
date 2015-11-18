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
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "SDWebImageManager.h"
#import "CusBrandDetailViewController.h"
@implementation CusHomeTableViewCell
{
    CGFloat cellHeight;
    MZTimerLabel *timer3;
    UILabel *showLab;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
    }
    return self;
}

-(void)setData:(NSDictionary *)dic andIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {
        self.backgroundColor = [UIColor whiteColor];
        
        NSArray *arr  = @[@"",@"",@"",@"",@""];
    }
    else
    {
        
        //商场
//        CGFloat tempViewHeight = (kScreenWidth-20)/3-10+140;
        //认证买手
        CGFloat tempViewHeight = (kScreenWidth-20)/3-10+180;

        UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(5, 10, kScreenWidth-10, tempViewHeight)];
        tempView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:tempView];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
        imageView.backgroundColor = [UIColor orangeColor];
        [tempView addSubview:imageView];
        
        //倒计时
        
        showLab = [[UILabel alloc] initWithFrame:CGRectMake(tempView.width-120, 0, 60, 20)];
        showLab.backgroundColor = kCustomColor(251, 163, 41);
        showLab.textColor = [UIColor whiteColor];
        showLab.font = [UIFont systemFontOfSize:11];
        showLab.text = @" 距离开始 :";
        [tempView addSubview:showLab];
        
        UILabel *timeLab = [[UILabel alloc] initWithFrame:CGRectMake(showLab.right, 0, 60, 20)];
        timeLab.backgroundColor = kCustomColor(251, 163, 41);
        timeLab.textColor = [UIColor whiteColor];
        timeLab.font = [UIFont systemFontOfSize:11];
//        timeLab.textAlignment = NSTextAlignmentCenter;
        [tempView addSubview:timeLab];
        
        timer3 = [[MZTimerLabel alloc] initWithLabel:timeLab andTimerType:MZTimerLabelTypeTimer];
        timer3.delegate = self;
        [timer3 setCountDownTime:10];
        [timer3 start];

        
        UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(imageView.right+5, imageView.top+5, tempView.width-90-120, 20)];
        nameLab.text = @"金鹰商场";
        nameLab.font = [UIFont systemFontOfSize:16];
        [tempView addSubview:nameLab];
        
        
        //商场
//        UIImageView *localImage = [[UIImageView alloc] initWithFrame:CGRectMake(imageView.right+5, nameLab.bottom+18, 12, 12)];
//        localImage.image = [UIImage imageNamed:@"location"];
//        [tempView addSubview:localImage];
//        
//        UILabel *localLab = [[UILabel alloc] initWithFrame:CGRectMake(localImage.right+3, nameLab.bottom+15, tempView.width-140, 20)];
//        localLab.text = @"北京,中关村南大街";
//        localLab.font = [UIFont systemFontOfSize:11];
//        [tempView addSubview:localLab];
//        
//        UILabel *distanceLab = [[UILabel alloc] initWithFrame:CGRectMake(tempView.width-45, nameLab.bottom+15, 40, 20)];
//        distanceLab.text = @"100KM";
//        distanceLab.font = [UIFont systemFontOfSize:11];
//        [tempView addSubview:distanceLab];
        
        
        //认证买手
        UILabel *describeLab = [[UILabel alloc] init];
        describeLab.text = @"北京,中关村南北京北京,中关村南北京,北京,中关村南北京,北京,中关村南北京,北京,中关村南北京,北京,中关村南北京,,";
        describeLab.font = [UIFont systemFontOfSize:11];
//        describeLab.backgroundColor = [UIColor orangeColor];
        describeLab.numberOfLines = 2;
        CGSize size = [Public getContentSizeWith:describeLab.text andFontSize:11 andWidth:tempView.width-90];
        describeLab.frame = CGRectMake(imageView.right+5, nameLab.bottom+8, tempView.width-90, size.height-13);
        [tempView addSubview:describeLab];

        
        
        //品牌
        UIButton *brandBtn  =[UIButton buttonWithType:(UIButtonTypeCustom)];
        brandBtn.frame = CGRectMake(tempView.width-52-15, imageView.bottom+15, 56, 20);
        brandBtn.backgroundColor = kCustomColor(220, 221, 221);
        [brandBtn setTitle:@"更多品牌" forState:(UIControlStateNormal)];
        [brandBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        brandBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        brandBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [brandBtn addTarget:self action:@selector(didClickMoreBrand) forControlEvents:(UIControlEventTouchUpInside)];
        [tempView addSubview:brandBtn];
        
        NSMutableArray *arr = [NSMutableArray arrayWithArray:@[@"only",@"asd",@"asdasda",@"阿打算打算",@"asdaasda",@"asdasda",@"asdasdasd"]];
        CGFloat beforeBtnWith=0;
        CGFloat totalWidth=0;
        for (int i=0; i<arr.count; i++)
        {
            CGSize btnSize = [Public getContentSizeWith:arr[i] andFontSize:13 andHigth:20];
            
            totalWidth = btnSize.width+10+totalWidth;
            
            
            if (totalWidth>tempView.width-62)
            {
                [arr removeLastObject];
            }
            else
            {
                UIButton *btn  =[UIButton buttonWithType:(UIButtonTypeCustom)];
                btn.backgroundColor = kCustomColor(220, 221, 221);
                [btn setTitle:arr[i] forState:(UIControlStateNormal)];
                [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
                btn.titleLabel.font = [UIFont systemFontOfSize:13];
                btn.titleLabel.textAlignment = NSTextAlignmentCenter;
                btn.tag = i+100;
                [btn addTarget:self action:@selector(didClickBrand:) forControlEvents:(UIControlEventTouchUpInside)];
                
                btn.frame = CGRectMake(10*(i+1)+beforeBtnWith+2, imageView.bottom+15, btnSize.width+4, 20);
                [tempView addSubview:btn];
                beforeBtnWith = btnSize.width+beforeBtnWith;
                
            }
        }
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, brandBtn.bottom+8, tempView.width-20, 1)];
        lineView.backgroundColor = kCustomColor(220, 221, 221);
        [tempView addSubview:lineView];
        
        CGFloat imageWidth = tempView.width/3-10;
        
        //商品
        for (int i=0; i<3; i++)
        {
            UIImageView *proImage = [[UIImageView alloc] initWithFrame:CGRectMake(imageWidth*i+5*i+10, lineView.bottom+10, imageWidth, imageWidth)];
            proImage.backgroundColor = [UIColor orangeColor];
            [tempView addSubview:proImage];
            
            UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, proImage.height/4*3, proImage.width, proImage.height/4)];
            bgView.backgroundColor = [UIColor blackColor];
            bgView.alpha =0.3;
            [proImage addSubview:bgView];
            
            UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, proImage.width/2, proImage.height/4)];
            price.textColor = [UIColor whiteColor];
            price.text = @"100.00";
            price.font = [UIFont systemFontOfSize:14];
            [bgView addSubview:price];
            
            UILabel *discountPrice = [[UILabel alloc] initWithFrame:CGRectMake(price.right, 2, proImage.width/2, proImage.height/4-2)];
            discountPrice.textColor = [UIColor whiteColor];
            discountPrice.text = @"100.00";
            discountPrice.font = [UIFont systemFontOfSize:11];
            [bgView addSubview:discountPrice];
            
            CGSize size = [Public getContentSizeWith:discountPrice.text andFontSize:11 andHigth:proImage.height/4-2];
            
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, bgView.height/2, size.width, 1)];
            line.backgroundColor = [UIColor whiteColor];
            [discountPrice addSubview:line];
            
            UIImageView *buyerHeaderImage = [[UIImageView alloc] initWithFrame:CGRectMake(proImage.left, proImage.bottom+5, 40, 40)];
            buyerHeaderImage.clipsToBounds = YES;
            buyerHeaderImage.layer.cornerRadius = buyerHeaderImage.width/2;
            buyerHeaderImage.backgroundColor = [UIColor redColor];
            [tempView addSubview:buyerHeaderImage];
            
            UILabel *buyerName = [[UILabel alloc] initWithFrame:CGRectMake(buyerHeaderImage.right+5, proImage.bottom+8, proImage.width-50, 15)];
            buyerName.text = @"大神的阿萨德";
            buyerName.font = [UIFont systemFontOfSize:12];
            [tempView addSubview:buyerName];
            
            UILabel *buyerBrandName = [[UILabel alloc] initWithFrame:CGRectMake(buyerHeaderImage.right+5, buyerName.bottom, proImage.width-50, 20)];
            buyerBrandName.text = @"kkkk";
            buyerBrandName.font = [UIFont systemFontOfSize:11];
            [tempView addSubview:buyerBrandName];

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

//    NSString *msg = [NSString stringWithFormat:@"Countdown of Example 6 finished!\nTime counted: %i seconds",(int)countTime];
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:msg delegate:nil cancelButtonTitle:@"Awesome!" otherButtonTitles:nil];
//    [alertView show];
}

//点击更多品牌
-(void)didClickMoreBrand
{
    
}

//点击品牌
-(void)didClickBrand:(UIButton *)btn
{
    
}

@end
