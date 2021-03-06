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
    self.scrollView.contentSize = CGSizeMake(0, 568);
    [self.view addSubview:self.scrollView];
    
    UIButton *returnBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    returnBtn.frame = CGRectMake(10, 35, 64, 64);
    returnBtn.backgroundColor = [UIColor clearColor];
    [returnBtn addTarget:self action:@selector(didClickReturnBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:returnBtn];
    
    UIImageView *retImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 59/7, 110/7)];
    retImage.image = [UIImage imageNamed:@"back.png"];
    [returnBtn addSubview:retImage];
    
//    UIButton *cartBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    cartBtn.frame = CGRectMake(kScreenWidth-54, 10, 64, 64);
//    cartBtn.backgroundColor = [UIColor clearColor];
//    [cartBtn setImage:[UIImage imageNamed:@"购物车"] forState:(UIControlStateNormal)];
//    [cartBtn addTarget:self action:@selector(didClickcartBtn) forControlEvents:(UIControlEventTouchUpInside)];
//    [self.view addSubview:cartBtn];
    
    [self initWithFooterView];
    
    [self getDetailData];
    
}



-(void)initView:(ProDetailData *)proData
{
    UIImageView *headerImage = [[UIImageView alloc] init];
    headerImage.center = CGPointMake(kScreenWidth/2, 50);
    headerImage.bounds = CGRectMake(0, 0, 50, 50);
    [headerImage sd_setImageWithURL:[NSURL URLWithString:proData.BuyerLogo] placeholderImage:nil];
    headerImage.layer.cornerRadius = headerImage.width/2;
    headerImage.clipsToBounds = YES;
    [self.scrollView addSubview:headerImage];
    
    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(0, headerImage.bottom+5, kScreenWidth, 20)];
    nameLab.text = proData.BuyerName;
    nameLab.font = [UIFont fontWithName:@"youyuan" size:16];
    nameLab.textAlignment = NSTextAlignmentCenter;
    [self.scrollView addSubview:nameLab];
    
    self.imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, nameLab.bottom+5, kScreenWidth-10, 290)];
    self.imageScrollView.contentSize =CGSizeMake(prodata.ProductPic.count*(kScreenWidth-10), 0);
    self.imageScrollView.alwaysBounceVertical = NO;
    self.imageScrollView.alwaysBounceHorizontal = YES;
    self.imageScrollView.pagingEnabled = YES;
    self.imageScrollView.showsHorizontalScrollIndicator = NO;
    self.imageScrollView.delegate = self;
    [self.scrollView addSubview:self.imageScrollView];
    
    for (int i=0; i<prodata.ProductPic.count; i++)
    {
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(self.imageScrollView.width*i, 0, self.imageScrollView.width, 300)];
        image.contentMode = UIViewContentModeScaleAspectFill;
        image.clipsToBounds = YES;
        [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@_320x0.jpg",[prodata.ProductPic objectAtIndex:i]]] placeholderImage:nil];
        [self.imageScrollView addSubview:image];
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
    lab.font =[UIFont fontWithName:@"youyuan" size:13];
    lab.textColor = [UIColor grayColor];
    [self.scrollView addSubview:lab];
    
    UILabel *sellNum = [[UILabel alloc] initWithFrame:CGRectMake(lab.right-5, lab.top, 60, 20)];
    sellNum.text = proData.TurnCount;
    sellNum.font = [UIFont fontWithName:@"youyuan" size:13];
    [self.scrollView addSubview:sellNum];
    
    UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-80, lab.bottom-5, 40, 20)];
    lab1.text = @"好评:";
    lab1.font =[UIFont fontWithName:@"youyuan" size:13];
    lab1.textColor = [UIColor grayColor];
    [self.scrollView addSubview:lab1];
    
    UILabel *goodNum = [[UILabel alloc] initWithFrame:CGRectMake(lab1.right-5, lab1.top, 60, 20)];
    goodNum.text = @"12345";
    goodNum.font = [UIFont fontWithName:@"youyuan" size:13];
    [self.scrollView addSubview:goodNum];
    
    UILabel *priceLab = [[UILabel alloc] init];
    priceLab.frame = CGRectMake(10, self.imageScrollView.bottom+5, 150, 20);
    priceLab.text = [NSString stringWithFormat:@"￥%@",proData.Price];
    priceLab.textColor = [UIColor redColor];
    priceLab.font = [UIFont systemFontOfSize:20];
    [self.scrollView addSubview:priceLab];
    
    UILabel *markLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-140, self.imageScrollView.bottom+5, 130, 20)];
    markLab.text = @"*商品只支持商城自提";
    markLab.font = [UIFont fontWithName:@"youyuan" size:12];
    markLab.textColor = [UIColor redColor];
    [self.scrollView addSubview:markLab];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, priceLab.bottom+5, kScreenWidth-90, 20)];
    titleLab.text = proData.ProductName;
    titleLab.font = [UIFont fontWithName:@"youyuan" size:14];
    [self.scrollView addSubview:titleLab];
    
    UILabel *locationLab = [[UILabel alloc] initWithFrame:CGRectMake(10, titleLab.bottom+5, kScreenWidth-20, 20)];
    locationLab.text = [NSString stringWithFormat:@"自提地点: %@",proData.PickAddress];
    locationLab.font = [UIFont fontWithName:@"youyuan" size:13];
    locationLab.textColor = [UIColor grayColor];
    [self.scrollView addSubview:locationLab];
    
    UIButton *collectBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    collectBtn.backgroundColor = [UIColor clearColor];
    collectBtn.frame = CGRectMake(0, locationLab.bottom+10, 60, 30);
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
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth-260, locationLab.bottom+10, 240, 30)];
    bgView.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:bgView];
    
    for (int i=0; i<7; i++)
    {
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(35*i, 0, 30, 30)];
        img.layer.cornerRadius = img.width/2;
        img.backgroundColor = [UIColor grayColor];
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
    
    [HttpTool postWithURL:@"Product/GetProductDetail" params:dic success:^(id json) {
        
        if ([[json objectForKey:@"isSuccessful"] boolValue])
        {
            NSDictionary *dic = [json objectForKey:@"data"];
            prodata = [ProDetailData objectWithKeyValues:dic];
            [self initView:prodata];
        }
        else
        {
            
        }
        NSLog(@"%@",json);
        
    } failure:^(NSError *error) {
        
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
            lab.font = [UIFont fontWithName:@"youyuan" size:12];
            [btn addSubview:lab];
        }
        else
        {
            btn.frame = CGRectMake(kScreenWidth/2, 0, kScreenWidth/2, 44);
            [btn setTitle:[arr objectAtIndex:i-2] forState:(UIControlStateNormal)];
            btn.titleLabel.font = [UIFont fontWithName:@"youyuan" size:14];
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
        [dic setValue:@"0" forKey:@"Status"];
    }
    else
    {
        [dic setValue:@"1" forKey:@"Status"];
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
