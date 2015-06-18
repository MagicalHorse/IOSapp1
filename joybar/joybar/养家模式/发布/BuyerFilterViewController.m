//
//  BuyerFilterViewController.m
//  joybar
//
//  Created by joybar on 15/6/17.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "BuyerFilterViewController.h"

@interface BuyerFilterViewController (){
    UIImage *cImage;
}
@property (nonatomic,strong)UIView *customInfoView;
@property (nonatomic,strong)UIView *dscView;
@property (nonatomic,strong)UIView *photoView;
@property (nonatomic,strong)UIButton *footerBtn;

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
   
    
    UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, 300)];
    img.image =[UIImage imageNamed:@"test.jpg"];
    [self.view addSubview:img];
    
    UILabel* titieLable= [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    titieLable.font =[UIFont fontWithName:@"youyuan" size:17];
    titieLable.text =@"点击图片任意位置添加标签";
    titieLable.textColor =[UIColor whiteColor];
    titieLable.textAlignment = NSTextAlignmentCenter;
    [titieView addSubview:titieLable];
    [self.view addSubview:titieView];
    
    UIView * tzhiView=[[UIView alloc]initWithFrame:CGRectMake(0, img.bottom, kScreenWidth, 110)];
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
    [_footerBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [self.view addSubview:_footerBtn];
    
}
-(void)btnClick:(UIButton *)btn{

}

@end
