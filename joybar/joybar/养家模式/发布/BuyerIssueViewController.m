//
//  BuyerIssueViewController.m
//  joybar
//
//  Created by joybar on 15/5/22.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "BuyerIssueViewController.h"

@interface BuyerIssueViewController (){
    int count;
    UIImage *cImage;
}
@property (nonatomic,strong)UIScrollView *customScrollView;
@property (nonatomic,strong)UIView *customInfoView;
@property (nonatomic,strong)UIView *dscView;
@property (nonatomic,strong)UIView *photoView;
@property (nonatomic,strong)UIButton *addInfoBtn;
@property (nonatomic,strong)UIButton *footerBtn;
@property (nonatomic,strong)NSMutableArray *viewItems;
@property (nonatomic,strong)UITextView *dscText;

@end

@implementation BuyerIssueViewController
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
-(NSMutableArray *)viewItems{
    if (_viewItems ==nil) {
        _viewItems =[[NSMutableArray alloc]init];
    }
    return _viewItems;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    count=0;
    [self addNavBarViewAndTitle:@"发布"];
    [self setInitView];
}

-(void) setInitView{
    
    CGFloat customScrollViewX=0;
    CGFloat customScrollViewY=64;
    CGFloat customScrollViewW=kScreenWidth;
    CGFloat customScrollViewH=kScreenHeight-50-64;
    self.customScrollView = [[UIScrollView alloc]init];
    self.customScrollView.frame =CGRectMake(customScrollViewX, customScrollViewY, customScrollViewW, customScrollViewH);
    self.customScrollView.backgroundColor =kCustomColor(241, 241, 241);
    [self.view addSubview:self.customScrollView];
    
    UIView *titieView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    titieView.backgroundColor =[UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:0.3];
    
    
    UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 300)];
    img.image =[UIImage imageNamed:@"test.jpg"];
    [self.customScrollView addSubview:img];
    
    
    UIView * tzhiView=[[UIView alloc]initWithFrame:CGRectMake(0, img.bottom, kScreenWidth, 100)];
    tzhiView.backgroundColor =[UIColor whiteColor];
    [self.customScrollView addSubview:tzhiView];
    
    UILabel* titieLable= [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    titieLable.font =[UIFont fontWithName:@"youyuan" size:17];
    titieLable.text =@"点击图片任意位置添加标签";
    titieLable.textColor =[UIColor whiteColor];
    titieLable.textAlignment = NSTextAlignmentCenter;
    [titieView addSubview:titieLable];
    [self.customScrollView addSubview:titieView];
    
    

    
    
    //价格（元）
    CGFloat priceViewX=0;
    CGFloat priceViewY=tzhiView.bottom+15;
    CGFloat priceViewW=customScrollViewW;
    CGFloat priceViewH=170;
    UIView * priceView =[[UIView alloc]init];
    priceView.frame = CGRectMake(priceViewX, priceViewY, priceViewW, priceViewH);
    priceView.backgroundColor =[UIColor whiteColor];
    [self.customScrollView addSubview:priceView];

    
    UIImageView *priceImg=[[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 19, 19)];
    priceImg.image =[UIImage imageNamed:@"重点"];
    [priceView addSubview:priceImg];
    UITextField *priceText=[[UITextField alloc]initWithFrame:CGRectMake(priceImg.right, 0, kScreenWidth-priceImg.right, 40)];
    priceText.font =[UIFont fontWithName:@"youyuan" size:16];
    priceText.placeholder =@"价格（元）";
    [priceView addSubview:priceText];
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(15, priceText.bottom, kScreenWidth-15, 1)];
    lineView.backgroundColor =[UIColor lightGrayColor];
    [priceView addSubview:lineView];

    
    UIView *dscView =[[UIView alloc]initWithFrame:CGRectMake(15, lineView.bottom+10, kScreenWidth-30, 100)];
    dscView.layer.borderWidth= 1.5;
    dscView.layer.borderColor = kCustomColor(196, 194, 190).CGColor;
    [priceView addSubview:dscView];

    UIImageView * zdImg = [[UIImageView alloc]init] ;
    zdImg.frame =CGRectMake(5, 5, 19, 19);
    zdImg.image =[UIImage imageNamed:@"重点"];
    [dscView addSubview:zdImg];
    
    _dscText=[[UITextView alloc]init];
    _dscText.textColor =kCustomColor(194, 194, 200);
    _dscText.font =[UIFont fontWithName:@"youyuan" size:15];
    _dscText.frame =CGRectMake(zdImg.right, 0, kScreenWidth-30-zdImg.width-8, 60);
    
    _dscText.text =@"给力商品描述点";
    [dscView addSubview:_dscText];



    
    
    
    CGRect  infoRect =CGRectMake(priceViewX, priceView.bottom+15, priceViewW, 65);
    self.customInfoView = [self setInfoView:infoRect];
    self.customInfoView.backgroundColor =[UIColor whiteColor];
    [self.customScrollView addSubview:self.customInfoView];
    
    self.addInfoBtn= [[UIButton alloc]init];
    self.addInfoBtn.frame = CGRectMake(priceViewX,self.customInfoView.bottom , priceViewW, 40);
    [self.addInfoBtn setTitle:@"添加规格库存" forState:UIControlStateNormal];
    [self.addInfoBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.addInfoBtn setBackgroundColor:[UIColor whiteColor]];
    [self.addInfoBtn addTarget:self action:@selector(addInfoView:) forControlEvents:UIControlEventTouchUpInside];
    [self.customScrollView addSubview:self.addInfoBtn];
    
    self.dscView=  [[UIView alloc]initWithFrame:CGRectMake(0, self.addInfoBtn.bottom, priceViewW, 100)];
    self.dscView.backgroundColor =[UIColor greenColor];
    [self.customScrollView addSubview:self.dscView];
    
    self.photoView=  [[UIView alloc]initWithFrame:CGRectMake(0, self.dscView.bottom+15, priceViewW, 100)];
    self.photoView.backgroundColor =[UIColor grayColor];
    [self.customScrollView addSubview:self.photoView];
    self.customScrollView.contentSize = CGSizeMake(0, kScreenHeight+500);
    
    //发布按钮
    _footerBtn =[[UIButton alloc]initWithFrame:CGRectMake(0,self.customScrollView.bottom, kScreenWidth, 50)];
    [_footerBtn setTitle:@"发布" forState:UIControlStateNormal];
    [_footerBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.view addSubview:_footerBtn];
    
}

-(UIView *)setInfoView:(CGRect)rect{

    UIView * view =[[UIView alloc]initWithFrame:rect];
    
    UITextField *textField1 =[[UITextField alloc]initWithFrame:CGRectMake(15, 15, (kScreenWidth-80)/2, 50)];
    textField1.placeholder =@"规格";
    textField1.layer.borderWidth= 1.5;
    textField1.layer.borderColor = kCustomColor(196, 194, 190).CGColor;
    [view addSubview:textField1];
    
    UITextField *textField2 =[[UITextField alloc]initWithFrame:CGRectMake(textField1.right+15, 15, (kScreenWidth-80)/2, 50)];
    textField2.placeholder =@"库存";
    textField2.layer.borderWidth= 1.5;
    textField2.layer.borderColor = kCustomColor(196, 194, 190).CGColor;

    [view addSubview:textField2];
    
    if (count==0) {
        UIImageView * textImg =[[UIImageView alloc]initWithFrame:CGRectMake(textField2.right+15, 30, 19, 19)];
        textImg.image =[UIImage imageNamed:@"重点"];
        [view addSubview:textImg];
    }else{
        UIButton *addBtn=[[UIButton alloc]initWithFrame:CGRectMake(textField2.right+15, 30, 19, 19)];
        [addBtn setImage:[UIImage imageNamed:@"重点"] forState:UIControlStateNormal];
        [addBtn addTarget:self action:@selector(delInfoView:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:addBtn];
    }
    
    return view;
    
}

-(void)delInfoView:(UIButton *)btn{
    count--;
    UIView * view =btn.superview;
    [self.viewItems removeObject:[NSString stringWithFormat:@"%ld",view.tag]];
    
    for (NSString *str in self.viewItems) {
        if ([str intValue]>view.tag) {
            UIView *view =[self.view viewWithTag:[str intValue]];
            view.frame =CGRectMake(0, view.origin.y-50, view.width, view.height);
        }
    }
    
    self.addInfoBtn.frame =CGRectMake(0, self.addInfoBtn.frame.origin.y-50, kScreenWidth, self.addInfoBtn.frame.size.height);
   
    self.dscView.frame = CGRectMake(0, self.addInfoBtn.bottom, kScreenWidth, 100);
    self.photoView.frame = CGRectMake(0,  self.dscView.bottom, kScreenWidth, 100);
    if (kScreenHeight+50<self.photoView.bottom+count*50) {
        self.customScrollView.contentSize = CGSizeMake(0, self.photoView.bottom+count*5);
    }else{
        self.customScrollView.contentSize = CGSizeMake(0, kScreenHeight+500);
    }
    [view removeFromSuperview];

}
-(void)addInfoView:(UIButton *)btn{
    count++;
    CGRect  infoRect;
    
    if (count==1) {
         infoRect =CGRectMake(0,self.customInfoView.bottom, kScreenWidth, 65);
    }else{
         infoRect =CGRectMake(0,self.customInfoView.bottom+(count-1)*65, kScreenWidth, 65);
    }
    UIView *view=   [self setInfoView:infoRect];
    

    view.tag =count*100;
    view.backgroundColor =[UIColor whiteColor];
    [self.customScrollView addSubview:view];

    btn.frame =CGRectMake(0, view.bottom, kScreenWidth, 40);
    self.dscView.frame = CGRectMake(0, btn.bottom, kScreenWidth, 100);
    self.photoView.frame = CGRectMake(0,  self.dscView.bottom, kScreenWidth, 100);
    if (kScreenHeight+50<self.photoView.bottom+count*50) {
        self.customScrollView.contentSize = CGSizeMake(0, self.photoView.bottom+count*5);

    }else{
        self.customScrollView.contentSize = CGSizeMake(0, kScreenHeight+500);
    }
    
    [self.viewItems addObject:[NSString stringWithFormat:@"%d",count*100]];

}
@end
