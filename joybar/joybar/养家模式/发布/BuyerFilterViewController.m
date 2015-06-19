//
//  BuyerFilterViewController.m
//  joybar
//
//  Created by joybar on 15/6/17.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "BuyerFilterViewController.h"
#import "BuyerIssueViewController.h"
#import "FeSlideFilterView.h"
#import "CIFilter+LUT.h"
#import "BuyerTagViewController.h"

@interface BuyerFilterViewController ()<BuyerTagDelegate>
{
    UIImage *cImage;
}
@property (nonatomic,strong)UIView *customInfoView;
@property (nonatomic,strong)UIView *dscView;
@property (nonatomic,strong)UIView *photoView;
@property (nonatomic,strong)UIButton *footerBtn;
@property (nonatomic,strong)UIImageView *bgImage;

@end

@implementation BuyerFilterViewController
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
-(instancetype)initWithImg:(UIImage *)image{
    if (self =[super init]) {
        cImage=image;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavBarViewAndTitle:@"编辑图片"];
    [self setInitView];
}

-(void) setInitView{
    
    self.view.backgroundColor =kCustomColor(241, 241, 241);
    
    UIView *titieView=[[UIView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, 40)];
    titieView.backgroundColor =[UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:0.3];
   
    
    _bgImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, 300)];
    _bgImage.image =[UIImage imageNamed:@"test.jpg"];
    [self.view addSubview:_bgImage];
    _bgImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickImage:)];
    [_bgImage addGestureRecognizer:tap];
    
    UILabel* titieLable= [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    titieLable.font =[UIFont fontWithName:@"youyuan" size:17];
    titieLable.text =@"点击图片任意位置添加标签";
    titieLable.textColor =[UIColor whiteColor];
    titieLable.textAlignment = NSTextAlignmentCenter;
    [titieView addSubview:titieLable];
    [self.view addSubview:titieView];
    
    UIView * tzhiView=[[UIView alloc]initWithFrame:CGRectMake(0, _bgImage.bottom, kScreenWidth, 110)];
    tzhiView.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:tzhiView];
    

    for (int i=0; i<4; i++) {
        UIButton *btn =[[UIButton alloc]initWithFrame:CGRectMake((kScreenWidth/4-20)*i+15*(i+1), 15, kScreenWidth/4-20, 60)];
        btn.tag =i+1;
        btn.backgroundColor =[UIColor greenColor];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [tzhiView addSubview:btn];
        UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth/4-20)*i+15*(i+1), btn.bottom+10, kScreenWidth/4-20, 13)];
        label.text=@"我是滤镜";
        label.font =[UIFont fontWithName:@"youyuan" size:13];
        [tzhiView addSubview:label];
        

    }
    
    //下一步按钮
    _footerBtn =[[UIButton alloc]initWithFrame:CGRectMake(0,self.view.bottom-50, kScreenWidth, 50)];
    [_footerBtn setTitle:@"下一步" forState:UIControlStateNormal];
    _footerBtn.backgroundColor =[UIColor whiteColor];
    [_footerBtn addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
    [_footerBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [self.view addSubview:_footerBtn];
    
}
-(void)btnClick:(UIButton *)btn{
    NSInteger i =btn.tag;
    UIImage *image =[UIImage imageNamed:@"test.jpg"];
    switch (i) {
        case 1:
            self.bgImage.image =[self getNewImg:image AndType:1];
            break;
        case 2:
            self.bgImage.image =[self getNewImg:image AndType:2];
            break;
        case 3:
            self.bgImage.image =[self getNewImg:image AndType:3];
            break;
        case 4:
            self.bgImage.image =[self getNewImg:image AndType:4];
            break;
            
        default:
            break;
    }
}
-(void)nextClick{
    BuyerIssueViewController *issue=[[BuyerIssueViewController alloc]init];
    [self.navigationController pushViewController:issue animated:YES];
}
-(void)didClickImage:(UITapGestureRecognizer *)tap
{
    
    CGPoint point = [tap locationInView:tap.view];
    
    BuyerTagViewController *tagView= [[BuyerTagViewController alloc]init];
    tagView.delegate =self;
    tagView.cpoint =point;
    [self.navigationController pushViewController:tagView animated:YES];
    

}

-(void)panTagImageView:(UIPanGestureRecognizer *)pan
{
    if ([(UIPanGestureRecognizer *)pan state] == UIGestureRecognizerStateBegan)
    {
        
    }
    
    if ([(UIPanGestureRecognizer *)pan state] == UIGestureRecognizerStateChanged)
    {
        NSLog(@"%f---%f",pan.view.frame.origin.x,pan.view.frame.origin.y);
        CGPoint translatedPoint = [pan translationInView:pan.view.superview];
        
        CGFloat x = pan.view.center.x + translatedPoint.x;
        CGFloat y = pan.view.center.y + translatedPoint.y;
        
        CGPoint newcenter = CGPointMake(x, y);
        [pan setTranslation:CGPointMake(0, 0) inView:pan.view];
        
        float halfx = CGRectGetMidX(pan.view.bounds);
        //x坐标左边界
        newcenter.x = MAX(halfx, newcenter.x);
        //x坐标右边界
        newcenter.x = MIN(pan.view.superview.bounds.size.width - halfx, newcenter.x);
        
        //y坐标同理
        float halfy = CGRectGetMidY(pan.view.bounds);
        newcenter.y = MAX(halfy, newcenter.y);
        newcenter.y = MIN(pan.view.superview.bounds.size.height - halfy, newcenter.y);
        //移动view
        pan.view.center = newcenter;
    }
    if ([(UIPanGestureRecognizer *)pan state] == UIGestureRecognizerStateEnded)
    {
//        CGPoint point = [pan locationInView:pan.view];
        NSLog(@"%f---%f",pan.view.frame.origin.x,pan.view.frame.origin.y);
    }
}
//BuyerTagDelegate

-(void)didSelectedTag:(NSString *)tagText AndPoint:(CGPoint)point{
    NSString *tag = tagText;
    CGSize size = [Public getContentSizeWith:tag andFontSize:13 andHigth:20];
    CGFloat x = point.x ;
    CGFloat y = point.y;
    UIView *tagView = [[UIView alloc] initWithFrame:CGRectMake(x, y, size.width+30, 25)];
    tagView.backgroundColor = [UIColor clearColor];
    [_bgImage addSubview:tagView];
    
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
    tagLab.text = tag;
    [tagImage addSubview:tagLab];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panTagImageView:)];
    [tagView addGestureRecognizer:panGestureRecognizer];
}



-(UIImage *)getNewImg:(UIImage *)img AndType :(int)type{
    
    NSString *nameLUT = [NSString stringWithFormat:@"filter_lut_%d",type];
    CIFilter *lutFilter = [CIFilter filterWithLUT:nameLUT dimension:64];
    
    CIImage *ciImage = [[CIImage alloc] initWithImage:img];
    [lutFilter setValue:ciImage forKey:@"inputImage"];
    CIImage *outputImage = [lutFilter outputImage];
    
    CIContext *context = [CIContext contextWithOptions:[NSDictionary dictionaryWithObject:(__bridge id)(CGColorSpaceCreateDeviceRGB()) forKey:kCIContextWorkingColorSpace]];
    
    UIImage *newImage = [UIImage imageWithCGImage:[context createCGImage:outputImage fromRect:outputImage.extent]];
    return newImage;
}

@end
