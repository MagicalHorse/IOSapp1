//
//  CusZProDetailViewController.m
//  joybar
//
//  Created by 123 on 15/10/14.
//  Copyright © 2015年 卢兴. All rights reserved.
//

#import "CusZProDetailViewController.h"
#import "CusCartViewController.h"
#import "CusChatViewController.h"
#import "ProDetailData.h"
#import "HomeUsers.h"
#import "ProductPicture.h"
#import "HomePicTag.h"
#import "CusTagViewController.h"
#import "CusHomeStoreViewController.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"

@interface CusZProDetailViewController ()<UIScrollViewDelegate>

@property (nonatomic ,strong) UIScrollView *scrollView;
@property (nonatomic ,strong) UIScrollView *imageScrollView;
@property (nonatomic ,strong) UIPageControl *pageControl;

@end

@implementation CusZProDetailViewController

{
    ProDetailData *prodata;
}
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    self.productId = @"12947";
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.scrollView.alwaysBounceVertical = YES;
    self.scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];
    
    [self addNavBarViewAndTitle:@"商品详情"];
    
    
    UIButton *shareBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    shareBtn.frame = CGRectMake(kScreenWidth-54, 10, 64, 64);
    shareBtn.backgroundColor = [UIColor clearColor];
    [shareBtn setImage:[UIImage imageNamed:@"fenxiang-1"] forState:(UIControlStateNormal)];
    [shareBtn addTarget:self action:@selector(didClickShare:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.navView addSubview:shareBtn];
    
    [self getDetailData];
}


-(void)initView:(ProDetailData *)proData
{
    
    self.imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenWidth)];
    self.imageScrollView.contentSize =CGSizeMake(prodata.ProductPic.count*(kScreenWidth), 0);
    self.imageScrollView.alwaysBounceVertical = NO;
    self.imageScrollView.alwaysBounceHorizontal = YES;
    self.imageScrollView.pagingEnabled = YES;
    self.imageScrollView.showsHorizontalScrollIndicator = NO;
    self.imageScrollView.delegate = self;
    [self.scrollView addSubview:self.imageScrollView];
    
    
    
    for (int i=0; i<prodata.ProductPic.count; i++)
    {
        ProductPicture *pic = [prodata.ProductPic objectAtIndex:i];
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(self.imageScrollView.width*i, 0, self.imageScrollView.width, self.imageScrollView.width)];
        image.contentMode = UIViewContentModeScaleAspectFill;
        image.clipsToBounds = YES;
        image.userInteractionEnabled = YES;
        [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",pic.Logo]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        [self.imageScrollView addSubview:image];
        
        ProductPicture *proPic = [prodata.ProductPic objectAtIndex:i];
        //标签View
        for (int j=0; j<proPic.Tags.count; j++)
        {
            HomePicTag *proTags = [proPic.Tags objectAtIndex:j];
            CGSize size = [Public getContentSizeWith:proTags.Name andFontSize:13 andHigth:20];
            CGFloat x = [proTags.PosX floatValue]*kScreenWidth;
            CGFloat y = [proTags.PosY floatValue]*kScreenWidth;
            UIView *tagView = [[UIView alloc] initWithFrame:CGRectMake(x, y, size.width+30, 25)];
            tagView.backgroundColor = [UIColor clearColor];
            tagView.tag = 100+i+j;
            [image addSubview:tagView];
            
            UIImageView *jiaoImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, tagView.height)];
            jiaoImage.image = [UIImage imageNamed:@"bqqian"];
            [tagView addSubview:jiaoImage];
            
            UIImageView *tagImage = [[UIImageView alloc] initWithFrame:CGRectMake(jiaoImage.right, 0, size.width, tagView.height)];
            tagImage.image = [UIImage imageNamed:@"bqhou"];
            [tagView addSubview:tagImage];
            
            UILabel *tagLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tagImage.width, tagView.height)];
            tagLab.textColor = [UIColor whiteColor];
            tagLab.font = [UIFont systemFontOfSize:13];
            tagLab.text = proTags.Name;
            [tagImage addSubview:tagLab];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickTag:)];
            [tagView addGestureRecognizer:tap];
        }
    }
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.imageScrollView.bottom-30, kScreenWidth, 20)];
    _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    [_pageControl setBackgroundColor:[UIColor clearColor]];
    _pageControl.currentPage = 0;
    if (prodata.ProductPic.count==1)
    {
        _pageControl.hidden = YES;
    }
    else
    {
        _pageControl.hidden = NO;
    }
    _pageControl.numberOfPages = prodata.ProductPic.count;
    [self.scrollView addSubview:_pageControl];
    
    UILabel *priceLab = [[UILabel alloc] init];
    priceLab.font = [UIFont systemFontOfSize:20];
    priceLab.text = [NSString stringWithFormat:@"￥%@",proData.Price];
    CGSize priceSize = [Public getContentSizeWith:priceLab.text andFontSize:20 andHigth:20];
    priceLab.frame = CGRectMake(10, self.imageScrollView.bottom+5, priceSize.width, 20);
    priceLab.textColor = [UIColor redColor];
    [self.scrollView addSubview:priceLab];
    
    UILabel *originalPriceLab = [[UILabel alloc] init];
    CGSize originalPriceSize = [Public getContentSizeWith:priceLab.text andFontSize:14 andHigth:20];
    originalPriceLab.text = [NSString stringWithFormat:@"￥%@",proData.Price];
    originalPriceLab.textColor = [UIColor grayColor];
    originalPriceLab.font = [UIFont systemFontOfSize:14];
    originalPriceLab.frame = CGRectMake(priceLab.right+10, self.imageScrollView.bottom+5, originalPriceSize.width, 20);
    [self.scrollView addSubview:originalPriceLab];
    
    UILabel *grayLine = [[UILabel alloc] initWithFrame:CGRectMake(originalPriceLab.left, self.imageScrollView.bottom+16, originalPriceLab.width, 1)];
    grayLine.backgroundColor = [UIColor grayColor];
    [self.scrollView addSubview:grayLine];
    
    UILabel *discountLab = [[UILabel alloc] init];
    discountLab.backgroundColor = [UIColor redColor];
    discountLab.text  = @"1.1折";
    discountLab.textColor = [UIColor whiteColor];
    discountLab.font = [UIFont systemFontOfSize:11];
    discountLab.textAlignment = NSTextAlignmentCenter;
    CGSize discountSize = [Public getContentSizeWith:discountLab.text andFontSize:11 andHigth:20];
    discountLab.frame = CGRectMake(originalPriceLab.right+10, self.imageScrollView.bottom+7, discountSize.width+6, 16);
    [self.scrollView addSubview:discountLab];
    
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.text = proData.ProductName;
    titleLab.font = [UIFont systemFontOfSize:14];
    titleLab.numberOfLines = 0;
    CGSize titleSize = [Public getContentSizeWith:titleLab.text andFontSize:14 andWidth:kScreenWidth-15];
    titleLab.frame = CGRectMake(10, priceLab.bottom+5, kScreenWidth-15, titleSize.height);
    [self.scrollView addSubview:titleLab];
    
    //打烊购
    //-----------------------------------------------------------------------------------
    UIView *tempView = [[UIView alloc] init];
    tempView.backgroundColor = kCustomColor(241, 241, 241);
    [self.scrollView addSubview:tempView];
    
    UIView *nightView = [[UIView alloc] init];
    nightView.backgroundColor = [UIColor whiteColor];
    //    nightView.layer.shadowOpacity = 0.1;
    //    nightView.layer.shadowOffset = CGSizeMake(0, 1);
    [tempView addSubview:nightView];
    
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 15, 15)];
    imageView1.image = [UIImage imageNamed:@"打烊购时间icon"];
    [nightView addSubview:imageView1];
    
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(10, imageView1.bottom+5, imageView1.width, imageView1.height)];
    imageView2.image = [UIImage imageNamed:@"打烊购icon"];
    [nightView addSubview:imageView2];
    
    UILabel *nightLab = [[UILabel alloc] initWithFrame:CGRectMake(imageView1.right+5, imageView1.top, kScreenWidth-60, imageView1.height)];
    nightLab.text = proData.Promotion.DescriptionText;
    nightLab.font = [UIFont systemFontOfSize:11];
    nightLab.textColor = [UIColor grayColor];
    [nightView addSubview:nightLab];
    
    UILabel *nightLab1 = [[UILabel alloc] init];
    nightLab1.text = proData.Promotion.TipText;
    nightLab1.numberOfLines = 0;
    CGSize size = [Public getContentSizeWith:nightLab1.text andFontSize:11 andWidth:kScreenWidth-60];
    nightLab1.frame = CGRectMake(imageView2.right+5, imageView2.top, kScreenWidth-60, size.height);
    nightLab1.font = [UIFont systemFontOfSize:11];
    nightLab1.textColor = [UIColor grayColor];
    [nightView addSubview:nightLab1];
    
    if (![proData.Promotion.IsShow boolValue])
    {
        imageView1.hidden = NO;
        imageView2.hidden = NO;
        nightView.frame = CGRectMake(0, 13, kScreenWidth, size.height+40);
        tempView.frame = CGRectMake(0, titleLab.bottom+10, kScreenWidth, nightView.height+13);
        nightView.hidden = NO;
        tempView.hidden = NO;
    }
    else
    {
        imageView1.hidden = YES;
        imageView2.hidden = YES;
        nightView.frame = CGRectMake(0, 10, kScreenWidth, 0);
        tempView.frame = CGRectMake(0, titleLab.bottom+10, kScreenWidth, 0);
        nightView.hidden = YES;
        tempView.hidden = YES;
    }
    //-----------------------------------------------------------------------------------
    //个人信息
    UIView *infoView = [[UIView alloc] initWithFrame:CGRectMake(0, tempView.bottom, kScreenWidth, 133)];
    infoView.backgroundColor = kCustomColor(241, 241, 241);
    [self.scrollView addSubview:infoView];
    
    UIView *infoWhiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 13, kScreenWidth, 108)];
    infoWhiteView.backgroundColor = [UIColor whiteColor];
    [infoView addSubview:infoWhiteView];
    
    UILabel *brandLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 60, 40)];
    brandLab.text = @"ONLY";
    brandLab.textColor = [UIColor orangeColor];
    brandLab.font = [UIFont systemFontOfSize:15];
    [infoWhiteView addSubview:brandLab];
    
    UILabel *location = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-100, 0, 80, 40)];
    location.text = @"中国北京";
    location.textAlignment = NSTextAlignmentRight;
    location.textColor = [UIColor darkGrayColor];
    location.font = [UIFont systemFontOfSize:15];
    [infoWhiteView addSubview:location];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, location.bottom, kScreenWidth-10, 1)];
    line.backgroundColor = kCustomColor(241, 241, 241);
    [infoWhiteView addSubview:line];
    
    UIImageView *headerImage = [[UIImageView alloc] init];
    headerImage.frame = CGRectMake(10, line.bottom+10, 50, 50);
    [headerImage sd_setImageWithURL:[NSURL URLWithString:proData.BuyerLogo] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    headerImage.layer.cornerRadius = headerImage.width/2;
    headerImage.clipsToBounds = YES;
    headerImage.userInteractionEnabled = YES;
    [infoWhiteView addSubview:headerImage];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didCLickToStore)];
    [headerImage addGestureRecognizer:tap];
    
    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(headerImage.right+10, headerImage.top+5, kScreenWidth, 20)];
    nameLab.text = proData.BuyerName;
    //    NSString *htmlString = @"div class="">本帖属于CocoaChina</a>会员发表，转帖请写明来源和帖子地址</div>    as肯定不行。。。建议去看一下官方文档的Type Casting章节。。。要不后续会很坑自己    <br>    </div>    </div>    </td>";
    //    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    //    nameLab.attributedText = attributedString;
    nameLab.font = [UIFont systemFontOfSize:15];
    [infoWhiteView addSubview:nameLab];
    
    UIImageView *locationImg = [[UIImageView alloc] initWithFrame:CGRectMake(headerImage.right+8, nameLab.bottom+3, 13, 13)];
    locationImg.image = [UIImage imageNamed:@"location.png"];
    [infoWhiteView addSubview:locationImg];
    
    UILabel *locationNameLab = [[UILabel alloc] initWithFrame:CGRectMake(locationImg.right, nameLab.bottom, kScreenWidth-170, 20)];
    locationNameLab.text = @"啊实打实大师大师的";
    locationNameLab.font = [UIFont systemFontOfSize:13];
    locationNameLab.textColor = [UIColor darkGrayColor];
    [infoWhiteView addSubview:locationNameLab];
    
    UIButton *circleBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    circleBtn.frame = CGRectMake(kScreenWidth-80, line.bottom+20, 60, 25);
    circleBtn.backgroundColor = [UIColor orangeColor];
    circleBtn.layer.masksToBounds = YES;
    circleBtn.layer.cornerRadius = 3;
    circleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [circleBtn setTitle:@"进圈" forState:(UIControlStateNormal)];
    [circleBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    
    [infoWhiteView addSubview:circleBtn];
    
    UIImageView *helpImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2-(kScreenWidth)/1.1/2, infoView.bottom+5, (kScreenWidth)/1.1, (kScreenWidth*2.3)/1.1)];
    helpImageView.image = [UIImage imageNamed:@"jianjie.png"];
    [self.scrollView addSubview:helpImageView];
    
    self.scrollView.contentSize = CGSizeMake(0, tempView.height+kScreenWidth-10+280+titleLab.size.height+titleSize.height+helpImageView.height+infoView.height);
}

-(void)getDetailData
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.productId forKey:@"productId"];
    NSString *userId =[[Public getUserInfo] objectForKey:@"id"];
    if (userId)
    {
        [dic setObject:userId forKey:@"UserId"];
    }
    else
    {
        [dic setObject:@"0" forKey:@"UserId"];
    }
    
    [self showInView:self.view WithPoint:CGPointMake(0, 64+40) andHeight:kScreenHeight-64-40];
    
    [HttpTool postWithURL:@"Product/GetProductDetail" params:dic success:^(id json) {
        
        NSLog(@"%@",json);
        if ([[json objectForKey:@"isSuccessful"] boolValue])
        {
            NSDictionary *dic = [json objectForKey:@"data"];
            prodata = [ProDetailData objectWithKeyValues:dic];
            [self initView:prodata];
            
            [self initWithFooterView];
        }
        else
        {
            [self showHudFailed:[json objectForKey:@"message"]];
        }
        [self activityDismiss];
        
    } failure:^(NSError *error) {
        [self showHudFailed:@"服务器正在维护,请稍后再试"];
        [self activityDismiss];
    }];
}

-(void)initWithFooterView
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-44, kScreenWidth, 44)];
    footerView.backgroundColor = kCustomColor(252, 251, 251);
    [self.view addSubview:footerView];
    
    NSArray *arr = @[@"立即购买"];
    NSArray *titleArr;
    NSArray *imageArr;
    
    if ([prodata.IsFavorite boolValue])
    {
        titleArr = @[@"私聊",@"取消收藏"];
        imageArr= @[@"liaotian",@"xingxing"];
    }
    else
    {
        titleArr = @[@"私聊",@"收藏"];
        imageArr= @[@"liaotian",@"xing"];
    }
    for (int i=0; i<3; i++)
    {
        UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        btn.tag = 1000+i;
        btn.frame = CGRectMake(kScreenWidth/4*i, 0, kScreenWidth/4, 44);
        
        [btn addTarget:self action:@selector(didClickBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        if (i<2)
        {
            btn.backgroundColor = kCustomColor(252, 251, 251);
            UIImageView *img =[[UIImageView alloc] init];
            img.center = CGPointMake(btn.width/2, btn.height/2-10);
            img.bounds = CGRectMake(0, 0, 15, 15);
            img.tag = 100+i;
            img.image = [UIImage imageNamed:[imageArr objectAtIndex:i]];
            [btn addSubview:img];
            
            UILabel *lab = [[UILabel alloc] init];
            lab.center = CGPointMake(btn.width/2, btn.height/2+10);
            lab.bounds = CGRectMake(0, 0, btn.width, 20);
            lab.textAlignment = NSTextAlignmentCenter;
            lab.text = [titleArr objectAtIndex:i];
            lab.tag = 10000+i;
            lab.font = [UIFont systemFontOfSize:12];
            [btn addSubview:lab];
        }
        else
        {
            btn.frame = CGRectMake(kScreenWidth/2, 0, kScreenWidth/2, 44);
            [btn setTitle:[arr objectAtIndex:i-2] forState:(UIControlStateNormal)];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
            btn.backgroundColor = kCustomColor(253, 137, 83);
        }
        [footerView addSubview:btn];
    }
}

-(void)didClickReturnBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)didClickBtn:(UIButton *)btn
{
    if (!TOKEN)
    {
        [Public showLoginVC:self];
        return;
    }

    switch (btn.tag) {
        case 1000:
        {
            //私聊
            CusChatViewController *VC = [[CusChatViewController alloc] initWithUserId:prodata.BuyerId AndTpye:2 andUserName:prodata.BuyerName];
            VC.detailData = prodata;
            VC.isFrom = isFromPrivateChat;
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        case 1001:
        {
            //收藏
            [self collect:btn];
        }
            break;
        case 1002:
        {
            //我要买
            CusChatViewController *VC = [[CusChatViewController alloc] initWithUserId:prodata.BuyerId AndTpye:2 andUserName:prodata.BuyerName];
            VC.detailData = prodata;
            VC.isFrom = isFromBuyPro;
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        default:
            break;
    }
}

//分享
-(void)didClickShare:(UIButton *)button
{
    if (!TOKEN)
    {
        [Public showLoginVC:self];
        return;
    }
    
    [UMSocialWechatHandler setWXAppId:APP_ID appSecret:APP_SECRET url:nil];
    
    
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:@""] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:@"55d43bf367e58eac01002b7f"
                                          shareText:[NSString stringWithFormat:@"快看！这里有一件超值的%@商品",@""]
                                         shareImage:image
                                    shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline]
                                           delegate:nil];
    }];
}

-(void)didClickBuyBtn:(UIButton *)button
{
    if (!TOKEN)
    {
        [Public showLoginVC:self];
        return;
    }
    //立即购买
    CusChatViewController *VC = [[CusChatViewController alloc] initWithUserId:prodata.BuyerId AndTpye:2 andUserName:prodata.BuyerName];
    VC.detailData = prodata;
    VC.isFrom = isFromBuyPro;
    [self.navigationController pushViewController:VC animated:YES];
}
-(void)collect:(UIButton *)btn
{
    UILabel *lab = (UILabel *)[btn viewWithTag:10001];
    UIImageView *img = (UIImageView *)[btn viewWithTag:101];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:prodata.ProductId forKey:@"Id"];
    if ([lab.text isEqualToString:@"收藏"])
    {
        [dic setValue:@"1" forKey:@"Status"];
    }
    else
    {
        [dic setValue:@"0" forKey:@"Status"];
    }
    [HttpTool postWithURL:@"Product/Favorite" params:dic isWrite:YES  success:^(id json) {
        
        if ([json objectForKey:@"isSuccessful"])
        {
            if ([lab.text isEqualToString:@"收藏"])
            {
                lab.text=@"取消收藏";
                img.image = [UIImage imageNamed:@"xingxing"];
            }
            else
            {
                lab.text=@"收藏";
                img.image = [UIImage imageNamed:@"xing"];
            }
        }
        else
        {
            [self showHudFailed:[json objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        
    }];
}
//UIScrollViewDelegate方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.imageScrollView == scrollView)
    {
        NSInteger index = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;
        
        [_pageControl setCurrentPage:index];
    }
}

-(void)didClickCollect:(UIButton *)btn
{
    if (!TOKEN)
    {
        [Public showLoginVC:self];
        return;
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:prodata.ProductId forKey:@"Id"];
    if (btn.selected==NO)
    {
        [dic setObject:@"1" forKey:@"Status"];
    }
    else
    {
        [dic setObject:@"0" forKey:@"Status"];
    }
    [HttpTool postWithURL:@"Product/Like" params:dic isWrite:YES success:^(id json) {
        
        if ([[json objectForKey:@"isSuccessful"] boolValue])
        {
            if (btn.selected==NO)
            {
                prodata.LikeUsers.Count = [NSString stringWithFormat:@"%ld",[prodata.LikeUsers.Count integerValue]+1];
                prodata.LikeUsers.IsLike = @"1";
                [btn setImage:[UIImage imageNamed:@"点赞h"] forState:(UIControlStateNormal)];
                [btn setTitle:prodata.LikeUsers.Count forState:(UIControlStateNormal)];
                btn.selected = YES;
            }
            else
            {
                prodata.LikeUsers.Count = [NSString stringWithFormat:@"%ld",[prodata.LikeUsers.Count integerValue]-1];
                prodata.LikeUsers.IsLike = @"0";
                
                [btn setImage:[UIImage imageNamed:@"点赞"] forState:(UIControlStateNormal)];
                [btn setTitle:prodata.LikeUsers.Count forState:(UIControlStateNormal)];
                btn.selected = NO;
            }
        }
        else
        {
            
        }
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)didClickImage:(UITapGestureRecognizer *)btn
{
    
}

//点击标签
-(void)didClickTag:(UITapGestureRecognizer *)tap
{
    ProductPicture *proPic = [prodata.ProductPic objectAtIndex:self.imageScrollView.contentOffset.x/(kScreenWidth-10)];
    HomePicTag *proTags = [proPic.Tags objectAtIndex:tap.view.tag-100-self.imageScrollView.contentOffset.x/(kScreenWidth-10)];
    CusTagViewController *VC = [[CusTagViewController alloc] init];
    VC.BrandId = proTags.SourceId;
    VC.BrandName = proTags.Name;
    [self.navigationController pushViewController:VC animated:YES];
}

//点击头像
-(void)didCLickToStore
{
    CusHomeStoreViewController *VC = [[CusHomeStoreViewController alloc] init];
    VC.userId = prodata.BuyerId;
    VC.userName = prodata.BuyerName;
    [self.navigationController pushViewController:VC animated:YES];
}

@end
