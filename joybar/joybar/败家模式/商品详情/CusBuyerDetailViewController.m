//
//  CusBuyerDetailViewController.m
//  joybar
//
//  Created by 123 on 15/5/13.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "CusBuyerDetailViewController.h"
#import "CusCartViewController.h"
#import "CusChatViewController.h"
#import "ProDetailData.h"
#import "HomeUsers.h"
#import "ProductPicture.h"
#import "HomePicTag.h"
@interface CusBuyerDetailViewController ()<UIScrollViewDelegate>

@property (nonatomic ,strong) UIScrollView *scrollView;
@property (nonatomic ,strong) UIScrollView *imageScrollView;
@property (nonatomic ,strong) UIPageControl *pageControl;
@end

@implementation CusBuyerDetailViewController
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
    
    UIButton *returnBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    returnBtn.frame = CGRectMake(10, 35, 64, 64);
    returnBtn.backgroundColor = [UIColor clearColor];
    [returnBtn addTarget:self action:@selector(didClickReturnBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:returnBtn];
    
    UIImageView *retImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 59/7, 110/7)];
    retImage.image = [UIImage imageNamed:@"back.png"];
    [returnBtn addSubview:retImage];
    
    [self getDetailData];
    
}



-(void)initView:(ProDetailData *)proData
{
    UIImageView *headerImage = [[UIImageView alloc] init];
    headerImage.center = CGPointMake(kScreenWidth/2, 50);
    headerImage.bounds = CGRectMake(0, 0, 50, 50);
    [headerImage sd_setImageWithURL:[NSURL URLWithString:proData.BuyerLogo] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    headerImage.layer.cornerRadius = headerImage.width/2;
    headerImage.clipsToBounds = YES;
    [self.scrollView addSubview:headerImage];
    
    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(0, headerImage.bottom+5, kScreenWidth, 20)];
    nameLab.text = proData.BuyerName;
    nameLab.font = [UIFont systemFontOfSize:16];
    nameLab.textAlignment = NSTextAlignmentCenter;
    [self.scrollView addSubview:nameLab];
    
    self.imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, nameLab.bottom+5, kScreenWidth-10, kScreenWidth-10)];
    self.imageScrollView.contentSize =CGSizeMake(prodata.ProductPic.count*(kScreenWidth-10), 0);
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
        [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",pic.Logo ]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
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
            [image addSubview:tagView];
            
//            UIImageView *pointImage = [[UIImageView alloc] init];
//            pointImage.center = CGPointMake(10, tagView.height/2);
//            pointImage.bounds = CGRectMake(0, 0, 12, 12);
//            pointImage.image = [UIImage imageNamed:@"yuan"];
//            [tagView addSubview:pointImage];
            
            UIImageView *jiaoImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, tagView.height)];
            jiaoImage.image = [UIImage imageNamed:@"bqqian"];
            [tagView addSubview:jiaoImage];
            
            UIImageView *tagImage = [[UIImageView alloc] initWithFrame:CGRectMake(jiaoImage.right, 0, size.width+10, tagView.height)];
            tagImage.image = [UIImage imageNamed:@"bqhou"];
            [tagView addSubview:tagImage];
            
            UILabel *tagLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tagImage.width, tagView.height)];
            tagLab.textColor = [UIColor whiteColor];
            tagLab.font = [UIFont systemFontOfSize:13];
            tagLab.text = proTags.Name;
            [tagImage addSubview:tagLab];
        }
    }
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.imageScrollView.bottom-30, kScreenWidth, 20)];
    _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    [_pageControl setBackgroundColor:[UIColor clearColor]];
    _pageControl.currentPage = 0;
    _pageControl.numberOfPages = prodata.ProductPic.count;
    [self.scrollView addSubview:_pageControl];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-80, 65, 40, 20)];
    lab.text = @"成交:";
    lab.font =[UIFont systemFontOfSize:13];
    lab.textColor = [UIColor grayColor];
    [self.scrollView addSubview:lab];
    
    UILabel *sellNum = [[UILabel alloc] initWithFrame:CGRectMake(lab.right-5, lab.top, 60, 20)];
    sellNum.text = proData.TurnCount;
    sellNum.font = [UIFont systemFontOfSize:13];
    [self.scrollView addSubview:sellNum];
    
    UILabel *priceLab = [[UILabel alloc] init];
    priceLab.frame = CGRectMake(10, self.imageScrollView.bottom+5, 150, 20);
    priceLab.text = [NSString stringWithFormat:@"￥%@",proData.Price];
    priceLab.textColor = [UIColor redColor];
    priceLab.font = [UIFont systemFontOfSize:20];
    [self.scrollView addSubview:priceLab];
    
    UILabel *markLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-140, self.imageScrollView.bottom+5, 130, 20)];
    markLab.text = @"*商品只支持商城自提";
    markLab.font = [UIFont systemFontOfSize:12];
    markLab.textColor = [UIColor redColor];
    [self.scrollView addSubview:markLab];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.text = proData.ProductName;
    titleLab.font = [UIFont systemFontOfSize:14];
    titleLab.numberOfLines = 0;
    CGSize titleSize = [Public getContentSizeWith:titleLab.text andFontSize:14 andWidth:kScreenWidth-15];
    titleLab.frame = CGRectMake(10, priceLab.bottom+5, kScreenWidth-15, titleSize.height);
    [self.scrollView addSubview:titleLab];
    
    UILabel *locationLab = [[UILabel alloc] initWithFrame:CGRectMake(10, titleLab.bottom+5, kScreenWidth-20, 20)];
    locationLab.text = [NSString stringWithFormat:@"自提地点: %@",proData.PickAddress];
    locationLab.font = [UIFont systemFontOfSize:13];
    locationLab.textColor = [UIColor grayColor];
    [self.scrollView addSubview:locationLab];
    
//打烊购
//-----------------------------------------------------------------------------------
    UIView *tempView = [[UIView alloc] init];
    tempView.backgroundColor = kCustomColor(239, 243, 244);
    [self.scrollView addSubview:tempView];
    
    UIView *nightView = [[UIView alloc] init];
    nightView.backgroundColor = [UIColor whiteColor];
    nightView.layer.shadowOpacity = 0.1;
    nightView.layer.shadowOffset = CGSizeMake(0, 1);
    [tempView addSubview:nightView];
    
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 15, 15)];
    imageView1.image = [UIImage imageNamed:@"打烊购时间icon"];
    [tempView addSubview:imageView1];
    
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(10, imageView1.bottom+5, imageView1.width, imageView1.height)];
    imageView2.image = [UIImage imageNamed:@"打烊购icon"];
    [tempView addSubview:imageView2];

    UILabel *nightLab = [[UILabel alloc] initWithFrame:CGRectMake(imageView1.right+5, imageView1.top, kScreenWidth-60, imageView1.height)];
    nightLab.text = proData.Promotion.DescriptionText;
    nightLab.font = [UIFont systemFontOfSize:11];
    nightLab.textColor = [UIColor grayColor];
    [tempView addSubview:nightLab];

    UILabel *nightLab1 = [[UILabel alloc] init];
    nightLab1.text = proData.Promotion.TipText;
    nightLab1.numberOfLines = 0;
    CGSize size = [Public getContentSizeWith:nightLab1.text andFontSize:11 andWidth:kScreenWidth-60];
    nightLab1.frame = CGRectMake(imageView2.right+5, imageView2.top, kScreenWidth-60, size.height);
    nightLab1.font = [UIFont systemFontOfSize:11];
    nightLab1.textColor = [UIColor grayColor];
    [tempView addSubview:nightLab1];

    if ([proData.Promotion.IsShow boolValue])
    {
        imageView1.hidden = NO;
        imageView2.hidden = NO;
        nightView.frame = CGRectMake(0, 0, kScreenWidth, size.height+50);
        tempView.frame = CGRectMake(0, locationLab.bottom+10, kScreenWidth, nightView.height+10);
        nightView.hidden = NO;
        tempView.hidden = NO;

    }
    else
    {
        imageView1.hidden = YES;
        imageView2.hidden = YES;
        nightView.frame = CGRectMake(0, 0, kScreenWidth, 0);
        tempView.frame = CGRectMake(0, locationLab.bottom+10, kScreenWidth, 0);
        nightView.hidden = YES;
        tempView.hidden = YES;
    }
//-----------------------------------------------------------------------------------
    
    self.scrollView.contentSize = CGSizeMake(0, tempView.height+kScreenWidth-10+300+titleLab.size.height);

    UIButton *collectBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    collectBtn.backgroundColor = [UIColor clearColor];
    collectBtn.frame = CGRectMake(0, tempView.bottom+10, 60, 30);
    if ([proData.LikeUsers.IsLike boolValue])
    {
        [collectBtn setImage:[UIImage imageNamed:@"点赞h"] forState:(UIControlStateNormal)];
        collectBtn.selected = YES;
    }
    else
    {
        [collectBtn setImage:[UIImage imageNamed:@"点赞"] forState:(UIControlStateNormal)];
        collectBtn.selected = NO;
    }
    if (!proData.LikeUsers.Count)
    {
        [collectBtn setTitle:@"0" forState:(UIControlStateNormal)];
    }
    else
    {
        [collectBtn setTitle:proData.LikeUsers.Count forState:(UIControlStateNormal)];
    }
    [collectBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    collectBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [collectBtn addTarget:self action:@selector(didClickCollect:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.scrollView addSubview:collectBtn];
    

    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth-260, tempView.bottom+10, 240, 30)];
    bgView.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:bgView];
    
    for (int i=0; i<proData.LikeUsers.Users.count; i++)
    {
        HomeUsers *user = [proData.LikeUsers.Users objectAtIndex:i];
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(35*i, 0, 30, 30)];
        img.layer.cornerRadius = img.width/2;
        [img sd_setImageWithURL:[NSURL URLWithString:user.Logo] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        img.clipsToBounds = YES;
        img.tag = 1000+i;
        img.userInteractionEnabled = YES;
        [bgView addSubview:img];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickImage:)];
        [img addGestureRecognizer:tap];
    }
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
        [self showHudFailed:@"服务器异常,请稍后再试"];
        [self activityDismiss];
    }];
}

-(void)initWithFooterView
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-44, kScreenWidth, 44)];
    footerView.backgroundColor = kCustomColor(252, 251, 251);
    [self.view addSubview:footerView];
    
    NSArray *arr = @[@"我要买"];
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
//            if (i==2)
//            {
//                btn.backgroundColor = kCustomColor(25, 158, 162);
//            }
//            else
//            {
                btn.backgroundColor = kCustomColor(253, 137, 83);
//            }
        }
        [footerView addSubview:btn];
    }
}

-(void)didClickReturnBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}

//-(void)didClickcartBtn
//{
//    CusCartViewController *VC = [[CusCartViewController alloc] init];
//    [self.navigationController pushViewController:VC animated:YES];
//}

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
//UIScrollViewDelegate方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.imageScrollView == scrollView)
    {
        NSInteger index = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;
        //NSLog(@"%d",index);
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
    [HttpTool postWithURL:@"Product/Like" params:dic success:^(id json) {
        
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
    
    [HttpTool postWithURL:@"Product/Favorite" params:dic success:^(id json) {
        
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
            
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}


@end
