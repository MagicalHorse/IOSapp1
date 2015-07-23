//
//  CusProDetailViewController.m
//  joybar
//
//  Created by 123 on 15/5/8.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "CusProDetailViewController.h"
#import "DWTagList.h"
@interface CusProDetailViewController ()<UIScrollViewDelegate>

@property (nonatomic ,strong) UIScrollView *scrollView;

@property (nonatomic ,strong) UIScrollView *imageScrollView;

@property (nonatomic ,strong) NSMutableArray *colorImageArr;

@property (nonatomic ,assign) NSInteger priceNum;

@end

@implementation CusProDetailViewController
{
    UIPageControl *pageControl;
    UILabel *buyNumLab;
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.priceNum = 0;
    self.colorImageArr = [[NSMutableArray alloc] init];

    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.scrollView.alwaysBounceVertical = YES;
    self.scrollView.contentSize = CGSizeMake(0, 900);
    [self.view addSubview:self.scrollView];
    
    [self initWithHeaderView];
    [self initWithFooterView];
    [self addNavBarViewAndTitle:@""];
    self.navView.alpha = 0;
    self.lineView.alpha = 0;
    self.retBtn.hidden = YES;
    
    UIButton *returnBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    returnBtn.frame = CGRectMake(-10, 10, 64, 64);
    returnBtn.backgroundColor = [UIColor clearColor];
    [returnBtn addTarget:self action:@selector(didClickReturnBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [returnBtn setImage:[UIImage imageNamed:@"fanhui.png"] forState:(UIControlStateNormal)];
    [self.view addSubview:returnBtn];
    

    UIButton *cartBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    cartBtn.frame = CGRectMake(kScreenWidth-54, 10, 64, 64);
    cartBtn.backgroundColor = [UIColor clearColor];
    [cartBtn setImage:[UIImage imageNamed:@"gouwu"] forState:(UIControlStateNormal)];
    [cartBtn addTarget:self action:@selector(didClickcartBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:cartBtn];

}

-(void)initWithHeaderView
{
    NSArray *imageArr= @[@"1.jpg",@"2.jpg",@"3.jpg"];
    self.imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 300)];
    self.imageScrollView.contentSize =CGSizeMake(imageArr.count*kScreenWidth, 0);
    self.imageScrollView.alwaysBounceVertical = NO;
    self.imageScrollView.alwaysBounceHorizontal = YES;
    self.imageScrollView.pagingEnabled = YES;
    self.imageScrollView.showsHorizontalScrollIndicator = NO;
    self.imageScrollView.delegate = self;
    [self.scrollView addSubview:self.imageScrollView];
    
    for (int i=0; i<imageArr.count; i++)
    {
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth*i, 0, kScreenWidth, 300)];
        image.image = [UIImage imageNamed:[imageArr objectAtIndex:i]];
        [self.imageScrollView addSubview:image];
    }
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.imageScrollView.height-30, kScreenWidth, 20)];
    pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    [pageControl setBackgroundColor:[UIColor clearColor]];
    pageControl.currentPage = 0;
    pageControl.numberOfPages = imageArr.count;
    [self.scrollView addSubview:pageControl];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, self.imageScrollView.bottom+10, kScreenWidth-90, 20)];
    titleLab.text = @"[卷儿] 印花风格连衣裙";
    titleLab.font = [UIFont systemFontOfSize:15];
    [self.scrollView addSubview:titleLab];
    
    UIButton *shareBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    shareBtn.frame = CGRectMake(kScreenWidth-60, self.imageScrollView.bottom+8, 44, 44);
    shareBtn.backgroundColor = [UIColor clearColor];
    [shareBtn addTarget:self action:@selector(didCLickShareBrn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.scrollView addSubview:shareBtn];
    
    UIImageView *shareImg = [[UIImageView alloc] init];
    shareImg.center = CGPointMake(shareBtn.width/2, 10);
    shareImg.bounds = CGRectMake(0, 0, 20, 20);
    shareImg.image = [UIImage imageNamed:@"分享"];
    [shareBtn addSubview:shareImg];
    
    UILabel *shareLab = [[UILabel alloc] initWithFrame:CGRectMake(0, shareImg.bottom-4, shareBtn.width, 20)];
    shareLab.text = @"分享";
    shareLab.font = [UIFont systemFontOfSize:11];
    shareLab.textColor = [UIColor lightGrayColor];
    shareLab.textAlignment = NSTextAlignmentCenter;
    [shareBtn addSubview:shareLab];
    
    UILabel *priceLab = [[UILabel alloc] init];
    priceLab.text = @"￥2130";
    priceLab.textColor = [UIColor redColor];
    priceLab.font = [UIFont systemFontOfSize:20];
    CGSize size =[priceLab.text sizeWithFont:[UIFont systemFontOfSize:20] constrainedToSize:CGSizeMake(CGFLOAT_MAX, 20) lineBreakMode:NSLineBreakByWordWrapping];
    priceLab.frame = CGRectMake(8, titleLab.bottom+5, size.width, 20);
    [self.scrollView addSubview:priceLab];
    
    UILabel *dazheLab = [[UILabel alloc] init];
    dazheLab.text = @"2.3折";
    dazheLab.font = [UIFont systemFontOfSize:11];
    CGSize dazheSize =[dazheLab.text sizeWithFont:[UIFont systemFontOfSize:11] constrainedToSize:CGSizeMake(CGFLOAT_MAX, 13) lineBreakMode:NSLineBreakByWordWrapping];
    dazheLab.backgroundColor = [UIColor redColor];
    dazheLab.textColor = [UIColor whiteColor];
    dazheLab.frame = CGRectMake(priceLab.right+5, titleLab.bottom+10, dazheSize.width, 13);
    [self.scrollView addSubview:dazheLab];

    UILabel *originalPriceLab = [[UILabel alloc] init];
    originalPriceLab.text = @"￥400.00";
    originalPriceLab.textColor = [UIColor lightGrayColor];
    originalPriceLab.font = [UIFont systemFontOfSize:13];
    CGSize originalPriceSize = [originalPriceLab.text sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(CGFLOAT_MAX, 13) lineBreakMode:NSLineBreakByWordWrapping];
    originalPriceLab.frame = CGRectMake(10, dazheLab.bottom+5, originalPriceSize.width, 13);
    [self.scrollView addSubview:originalPriceLab];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 7, originalPriceLab.width, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [originalPriceLab addSubview:line];
    
    UILabel *pinpai = [[UILabel alloc] initWithFrame:CGRectMake(10, originalPriceLab.bottom+5, 40, 20)];
    pinpai.text = @"品牌:";
    pinpai.font = [UIFont systemFontOfSize:15];
    [self.scrollView addSubview:pinpai];
    
    UILabel *pinpaiName = [[UILabel alloc] initWithFrame:CGRectMake(pinpai.right+5, originalPriceLab.bottom+5, kScreenWidth-100, 20)];
    pinpaiName.text = @"Jock Jone";
    pinpaiName.font = [UIFont systemFontOfSize:15];
    [self.scrollView addSubview:pinpaiName];
    
    UILabel *colorLab = [[UILabel alloc] initWithFrame:CGRectMake(10, pinpai.bottom+28, 40, 20)];
    colorLab.text = @"颜色:";
    colorLab.font = [UIFont systemFontOfSize:15];
    [self.scrollView addSubview:colorLab];

    
//选择颜色
    UIView *colorTempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 60)];
    colorTempView.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:colorTempView];
    
    NSArray *colorArr = @[@"1",@"2",@"3",@"4",@"1"];
    
    for (int i=0; i<colorArr.count; i++)
    {
        UIImageView *colorImageView = [[UIImageView alloc] init];
        colorImageView.backgroundColor = [UIColor magentaColor];
        colorImageView.userInteractionEnabled = YES;
        colorImageView.tag = 1000+i;
        int a = i/4;// 行
        int b = i%4;// 列
        CGRect frame = CGRectMake((colorTempView.width/4)*b-3, 65*a, (colorTempView.width/4), 55);
        colorImageView.center = CGPointMake(frame.origin.x + frame.size.width/2, frame.origin.y + frame.size.height/2);
        colorImageView.bounds = CGRectMake(0, 0, 55, 55);
        [colorTempView addSubview:colorImageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectColor:)];
        [colorImageView addGestureRecognizer:tap];
        
        [self.colorImageArr addObject:colorImageView];
    }
    
    colorTempView.frame = CGRectMake(colorLab.right+5, pinpaiName.bottom+10, 250, 60+colorArr.count%4*60);
    
//选择尺码
    UILabel *sizeLab = [[UILabel alloc] initWithFrame:CGRectMake(10, colorTempView.bottom+15, 40, 20)];
    sizeLab.text = @"尺码:";
    sizeLab.font = [UIFont systemFontOfSize:15];
    [self.scrollView addSubview:sizeLab];

    DWTagList*sizeBtn = [[DWTagList alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-100, 300.0f)];
    sizeBtn.backgroundColor = [UIColor clearColor];
    NSArray *array = [[NSArray alloc] initWithObjects:@"X", @"XXL", @"L", @"S",@"X", @"XXL", @"L", @"S", nil];
    [sizeBtn setTags:array];
    [self.scrollView addSubview:sizeBtn];
    CGFloat height = [sizeBtn fittedSize].height;
    sizeBtn.frame = CGRectMake(sizeLab.right+5, colorTempView.bottom+12, kScreenWidth-100, height);
    
//数量
    UILabel *numLab = [[UILabel alloc] initWithFrame:CGRectMake(10, sizeBtn.bottom+22, 40, 20)];
    numLab.text = @"数量:";
    numLab.font = [UIFont systemFontOfSize:15];
    [self.scrollView addSubview:numLab];

    UIView *numView = [[UIView alloc] initWithFrame:CGRectMake(numLab.right+6, sizeBtn.bottom+15, 120, 35)];
    numView.backgroundColor = kCustomColor(240, 240, 240);
    numView.layer.cornerRadius = 4;
    numView.layer.borderWidth = 0.5f;
    numView.layer.borderColor = kCustomColor(223, 223, 223).CGColor;
    [self.scrollView addSubview:numView];
    
    UIButton *addBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    addBtn.frame = CGRectMake(numView.width-44, 0, 44, 35);
    addBtn.backgroundColor = [UIColor clearColor];
    [addBtn addTarget:self action:@selector(didCLickAddNum) forControlEvents:(UIControlEventTouchUpInside)];
    [numView addSubview:addBtn];
    
    UIButton *minusBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    minusBtn.frame = CGRectMake(0, 0, 44, 35);
    minusBtn.backgroundColor = [UIColor clearColor  ];
    [minusBtn addTarget:self action:@selector(didClickDecrease) forControlEvents:(UIControlEventTouchUpInside)];
    [numView addSubview:minusBtn];
    
    buyNumLab = [[UILabel alloc] initWithFrame:CGRectMake(44, 0, numView.width-88, 35)];
    buyNumLab.backgroundColor = [UIColor whiteColor];
    buyNumLab.text = [NSString stringWithFormat:@"%ld",(long)self.priceNum];
    buyNumLab.textAlignment = NSTextAlignmentCenter;
    [numView addSubview:buyNumLab];
    
}

-(void)initWithFooterView
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-44, kScreenWidth, 44)];
    footerView.backgroundColor = kCustomColor(252, 251, 251);
    [self.view addSubview:footerView];
    
    NSArray *arr = @[@"加入购物车",@"立即购买"];
    
    NSArray *titleArr = @[@"私聊",@"收藏"];
    NSArray *imageArr = @[@"liaotian",@"xing"];
    for (int i=0; i<4; i++)
    {
        UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        btn.frame = CGRectMake(kScreenWidth/4*i, 0, kScreenWidth/4, 44);
        if (i<2)
        {
            btn.backgroundColor = kCustomColor(252, 251, 251);
            
            UIImageView *img =[[UIImageView alloc] init];
            img.center = CGPointMake(btn.width/2, btn.height/2-10);
            img.bounds = CGRectMake(0, 0, 15, 15);
            img.image = [UIImage imageNamed:[imageArr objectAtIndex:i]];
            [btn addSubview:img];
            
            UILabel *lab = [[UILabel alloc] init];
            lab.center = CGPointMake(btn.width/2, btn.height/2+10);
            lab.bounds = CGRectMake(0, 0, 30, 20);
            lab.textAlignment = NSTextAlignmentCenter;
            lab.text = [titleArr objectAtIndex:i];
            lab.font = [UIFont systemFontOfSize:12];
            [btn addSubview:lab];
        }
        else
        {
            [btn setTitle:[arr objectAtIndex:i-2] forState:(UIControlStateNormal)];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
            if (i==2)
            {
                btn.backgroundColor = kCustomColor(25, 158, 162);
            }
            else
            {
                btn.backgroundColor = kCustomColor(253, 137, 83);
            }
        }
        [footerView addSubview:btn];
    }
}

//返回
-(void)didClickReturnBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}
//点击购物车
-(void)didClickcartBtn
{
    
}

//点击分享
-(void)didCLickShareBrn
{
    
}

//UIScrollViewDelegate方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.imageScrollView == scrollView)
    {
        NSInteger index = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;
        //NSLog(@"%d",index);
        [pageControl setCurrentPage:index];
        
    }
}

//选择颜色
-(void)didSelectColor:(UITapGestureRecognizer *)tap
{
    UIImageView *seletImageView = (UIImageView *)tap.view;
    
    for (UIImageView *imageView in self.colorImageArr)
    {
        if (imageView==seletImageView)
        {
            imageView.layer.borderColor = [UIColor blueColor].CGColor;
            imageView.layer.borderWidth = 1;
        }
        else
        {
            imageView.layer.borderWidth = 0;
        }
 
    }
}

//增加
-(void)didCLickAddNum
{
    self.priceNum+=1;
    buyNumLab.text = [NSString stringWithFormat:@"%ld",(long)self.priceNum];
}

//减少
-(void)didClickDecrease
{
    if (self.priceNum<1)
    {
        return;
    }
    else
    {
        self.priceNum-=1;
        buyNumLab.text = [NSString stringWithFormat:@"%ld",(long)self.priceNum];
    }
}

@end
