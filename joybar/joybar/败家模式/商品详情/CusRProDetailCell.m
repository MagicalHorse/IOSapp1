//
//  CusRProDetailCell.m
//  joybar
//
//  Created by 123 on 15/11/20.
//  Copyright © 2015年 卢兴. All rights reserved.
//

#import "CusRProDetailCell.h"
#import "ProductPicture.h"
#import "CusMainStoreViewController.h"
@implementation CusRProDetailCell
{
    UIPageControl *pageControl;
    ProDetailData *detailData;
}
- (void)awakeFromNib {
    // Initialization code
}
-(void)setDetailData:(ProDetailData *)proData andIndex:(NSIndexPath *)indexPath
{
    detailData = proData;
    if (indexPath.section==0)
    {
        UIScrollView *imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth)];
        imageScrollView.contentSize =CGSizeMake(proData.ProductPic.count*(kScreenWidth), 0);
        imageScrollView.alwaysBounceVertical = NO;
        imageScrollView.alwaysBounceHorizontal = YES;
        imageScrollView.pagingEnabled = YES;
        imageScrollView.showsHorizontalScrollIndicator = NO;
        imageScrollView.delegate = self;
        [self.contentView addSubview:imageScrollView];
        
        for (int i=0; i<proData.ProductPic.count; i++)
        {
            ProductPicture *pic = [proData.ProductPic objectAtIndex:i];
            
            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(imageScrollView.width*i, 0, imageScrollView.width, imageScrollView.width)];
            image.contentMode = UIViewContentModeScaleAspectFill;
            image.clipsToBounds = YES;
            image.userInteractionEnabled = YES;
            [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",pic.Logo]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            [imageScrollView addSubview:image];
        }
        pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, imageScrollView.bottom-30, kScreenWidth, 20)];
        pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        [pageControl setBackgroundColor:[UIColor clearColor]];
        pageControl.currentPage = 0;
        if (proData.ProductPic.count==1)
        {
            pageControl.hidden = YES;
        }
        else
        {
            pageControl.hidden = NO;
        }
        pageControl.numberOfPages = proData.ProductPic.count;
        [self.contentView addSubview:pageControl];
        
        UILabel *priceLab = [[UILabel alloc] init];
        priceLab.font = [UIFont systemFontOfSize:20];
        priceLab.text = [NSString stringWithFormat:@"￥%@",proData.Price];
        CGSize priceSize = [Public getContentSizeWith:priceLab.text andFontSize:20 andHigth:20];
        priceLab.frame = CGRectMake(10, imageScrollView.bottom+5, priceSize.width, 20);
        priceLab.textColor = [UIColor redColor];
        [self.contentView addSubview:priceLab];
        
        UILabel *originalPriceLab = [[UILabel alloc] init];
        CGSize originalPriceSize = [Public getContentSizeWith:priceLab.text andFontSize:14 andHigth:20];
        originalPriceLab.text = [NSString stringWithFormat:@"￥%@",proData.UnitPrice];
        originalPriceLab.textColor = [UIColor grayColor];
        originalPriceLab.font = [UIFont systemFontOfSize:14];
        originalPriceLab.frame = CGRectMake(priceLab.right+10, imageScrollView.bottom+5, originalPriceSize.width+10, 20);
        [self.contentView addSubview:originalPriceLab];
        
        UILabel *grayLine = [[UILabel alloc] initWithFrame:CGRectMake(originalPriceLab.left, imageScrollView.bottom+16, originalPriceLab.width, 1)];
        grayLine.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:grayLine];
        
//        UILabel *discountLab = [[UILabel alloc] init];
//        discountLab.backgroundColor = [UIColor redColor];
//        discountLab.text  = @"1.1折";
//        discountLab.textColor = [UIColor whiteColor];
//        discountLab.font = [UIFont systemFontOfSize:11];
//        discountLab.textAlignment = NSTextAlignmentCenter;
//        CGSize discountSize = [Public getContentSizeWith:discountLab.text andFontSize:11 andHigth:20];
//        discountLab.frame = CGRectMake(originalPriceLab.right+10, imageScrollView.bottom+7, discountSize.width+6, 16);
//        [self.contentView addSubview:discountLab];
        
        
        UILabel *titleLab = [[UILabel alloc] init];
        titleLab.text = proData.ProductName;
        titleLab.font = [UIFont systemFontOfSize:14];
        titleLab.numberOfLines = 0;
        CGSize titleSize = [Public getContentSizeWith:titleLab.text andFontSize:14 andWidth:kScreenWidth-15];
        titleLab.frame = CGRectMake(10, priceLab.bottom+5, kScreenWidth-15, titleSize.height);
        [self.contentView addSubview:titleLab];
        
        UILabel *markLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-140, imageScrollView.bottom+5, 130, 20)];
        markLab.text = @"*商品只支持商城自提";
        markLab.font = [UIFont systemFontOfSize:12];
        markLab.textColor = [UIColor redColor];
        [self.contentView addSubview:markLab];
    }
    
    else if (indexPath.section==1)
    {
        UILabel *location = [[UILabel alloc]init];
        location.text = [NSString stringWithFormat:@"自提地址:%@",proData.PickAddress];
        location.numberOfLines = 2;
        CGSize locationSize = [Public getContentSizeWith:location.text andFontSize:13 andWidth:kScreenWidth-20];
        location.font = [UIFont systemFontOfSize:13];
        location.frame =CGRectMake(10, 10, kScreenWidth-20, locationSize.height);
        [self.contentView addSubview:location];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, location.bottom+5, kScreenWidth-15, 1)];
        line.backgroundColor = kCustomColor(212, 212, 212);
        [self.contentView addSubview:line];

        
        UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, location.bottom+15, 15, 15)];
        imageView1.image = [UIImage imageNamed:@"打烊购时间icon"];
        [self.contentView addSubview:imageView1];
        
        UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(10, imageView1.bottom+15, imageView1.width, imageView1.height)];
        imageView2.image = [UIImage imageNamed:@"打烊购icon"];
        [self.contentView addSubview:imageView2];
        
        UILabel *nightLab = [[UILabel alloc] initWithFrame:CGRectMake(imageView1.right+5, imageView1.top, kScreenWidth-60, imageView1.height)];
        nightLab.text = proData.Promotion.DescriptionText;
        nightLab.font = [UIFont systemFontOfSize:11];
        nightLab.textColor = [UIColor grayColor];
        [self.contentView addSubview:nightLab];
        
        UILabel *nightLab1 = [[UILabel alloc] init];
        nightLab1.text = proData.Promotion.TipText;
        nightLab1.numberOfLines = 0;
        CGSize size = [Public getContentSizeWith:nightLab1.text andFontSize:11 andWidth:kScreenWidth-60];
        nightLab1.frame = CGRectMake(imageView2.right+5, imageView2.top, kScreenWidth-60, size.height);
        nightLab1.font = [UIFont systemFontOfSize:11];
        nightLab1.textColor = [UIColor grayColor];
        [self.contentView addSubview:nightLab1];
    }
    
    else if (indexPath.section==2)
    {
        UILabel *brandLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 60, 40)];
        brandLab.text = proData.BrandName;
        brandLab.textColor = [UIColor orangeColor];
        brandLab.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:brandLab];
        
        UILabel *location = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-100, 0, 80, 40)];
        location.text = proData.CityName;
        location.textAlignment = NSTextAlignmentRight;
        location.textColor = [UIColor darkGrayColor];
        location.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:location];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, location.bottom, kScreenWidth-10, 1)];
        line.backgroundColor = kCustomColor(241, 241, 241);
        [self.contentView addSubview:line];
        
        UIImageView *headerImage = [[UIImageView alloc] init];
        headerImage.frame = CGRectMake(10, line.bottom+10, 50, 50);
        [headerImage sd_setImageWithURL:[NSURL URLWithString:proData.BuyerLogo] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        headerImage.layer.cornerRadius = headerImage.width/2;
        headerImage.clipsToBounds = YES;
        headerImage.userInteractionEnabled = YES;
        [self.contentView addSubview:headerImage];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickToStore)];
        [headerImage addGestureRecognizer:tap];
        
        UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(headerImage.right+10, headerImage.top+5, kScreenWidth, 20)];
        nameLab.text = proData.BuyerName;
        //    NSString *htmlString = @"div class="">本帖属于CocoaChina</a>会员发表，转帖请写明来源和帖子地址</div>    as肯定不行。。。建议去看一下官方文档的Type Casting章节。。。要不后续会很坑自己    <br>    </div>    </div>    </td>";
        //    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        //    nameLab.attributedText = attributedString;
        nameLab.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:nameLab];
        
        UIImageView *locationImg = [[UIImageView alloc] initWithFrame:CGRectMake(headerImage.right+8, nameLab.bottom+3, 13, 13)];
        locationImg.image = [UIImage imageNamed:@"location.png"];
        [self.contentView addSubview:locationImg];
        
        UILabel *locationNameLab = [[UILabel alloc] initWithFrame:CGRectMake(locationImg.right, nameLab.bottom, kScreenWidth-150, 20)];
        locationNameLab.text = proData.CityName;
        locationNameLab.font = [UIFont systemFontOfSize:13];
        locationNameLab.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:locationNameLab];
        
        UIButton *circleBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        circleBtn.frame = CGRectMake(kScreenWidth-80, line.bottom+20, 60, 25);
        circleBtn.backgroundColor = [UIColor orangeColor];
        circleBtn.layer.masksToBounds = YES;
        circleBtn.layer.cornerRadius = 3;
        circleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [circleBtn setTitle:@"进圈" forState:(UIControlStateNormal)];
        [circleBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [circleBtn addTarget:self action:@selector(didClickToCircle) forControlEvents:(UIControlEventTouchUpInside)];
        [self.contentView addSubview:circleBtn];
    }
    else
    {
        UIImageView *helpImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2-(kScreenWidth)/1.1/2, 0, (kScreenWidth)/1.1, (kScreenWidth*2.3)/1.1)];
        helpImageView.image = [UIImage imageNamed:@"jianjie.png"];
        [self.contentView addSubview:helpImageView];
    }
}

//UIScrollViewDelegate方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;
    
    [pageControl setCurrentPage:index];
}

-(void)didClickToStore
{
    if (!TOKEN)
    {
        [Public showLoginVC:self.viewController];
        return;
    }

    CusMainStoreViewController *VC = [[CusMainStoreViewController alloc] init];
    VC.userId = detailData.BuyerId;
    VC.isCircle = NO;
    VC.userName =detailData.BuyerName;
    [self.viewController.navigationController pushViewController:VC animated:YES];

}

-(void)didClickToCircle
{
    if (!TOKEN)
    {
        [Public showLoginVC:self.viewController];
        return;
    }

    CusMainStoreViewController *VC = [[CusMainStoreViewController alloc] init];
    VC.userId = detailData.BuyerId;
    VC.isCircle = YES;
    VC.userName =detailData.BuyerName;
    [self.viewController.navigationController pushViewController:VC animated:YES];
}

@end
