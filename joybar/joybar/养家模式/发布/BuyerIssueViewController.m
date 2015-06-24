//
//  BuyerIssueViewController.m
//  joybar
//
//  Created by joybar on 15/5/22.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "BuyerIssueViewController.h"
#import "FeSlideFilterView.h"
#import "CIFilter+LUT.h"
@interface BuyerIssueViewController (){
    int count;
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
    
    //customScrollView
    CGFloat customScrollViewX=0;
    CGFloat customScrollViewY=64;
    CGFloat customScrollViewW=kScreenWidth;
    CGFloat customScrollViewH=kScreenHeight-50-64;
    self.customScrollView = [[UIScrollView alloc]init];
    self.customScrollView.frame =CGRectMake(customScrollViewX, customScrollViewY, customScrollViewW, customScrollViewH);
    self.customScrollView.backgroundColor =kCustomColor(241, 241, 241);
    [self.view addSubview:self.customScrollView];
    
    //photoView
    self.photoView=  [[UIView alloc]initWithFrame:CGRectMake(0,12, customScrollViewW, 115)];
    self.photoView.backgroundColor =[UIColor whiteColor];
    [self.customScrollView addSubview:self.photoView];
    
    for (int i=0; i<3; i++) {
        UIButton *btn =[[UIButton alloc]initWithFrame:CGRectMake((kScreenWidth/3-20)*i+15*(i+1), 15, kScreenWidth/3-20, 85)];
        btn.tag =i+1;
        btn.layer.borderWidth= 1.5;
        btn.layer.borderColor = kCustomColor(169, 200, 234).CGColor;
        [btn setTitle:@"+图片" forState:UIControlStateNormal];
        [btn setTitleColor:kCustomColor(194, 194, 200)  forState:UIControlStateNormal];

        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.photoView addSubview:btn];
    }
    
    
    //priceView
    CGFloat priceViewX=0;
    CGFloat priceViewY=self.photoView.bottom+12;
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
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(15, priceText.bottom, kScreenWidth-15, 0.5)];
    lineView.backgroundColor =[UIColor lightGrayColor];
    [priceView addSubview:lineView];

    
    UIView *dscView =[[UIView alloc]initWithFrame:CGRectMake(15, lineView.bottom+10, kScreenWidth-30, 100)];
    dscView.layer.borderWidth= 1.5;
    dscView.layer.borderColor = kCustomColor(196, 194, 190).CGColor;
    [priceView addSubview:dscView];
    
    UILabel *lable =[[UILabel alloc]initWithFrame:CGRectMake(dscView.width-35, dscView.height-20, 30, 15)];
    lable.text =@"30字";
    lable.textColor =kCustomColor(194, 194, 200);
    lable.font =[UIFont fontWithName:@"youyuan" size:13];

    [dscView addSubview:lable];

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
    
    CGRect  infoRect =CGRectMake(priceViewX, priceView.bottom+12, priceViewW, 70);
    self.customInfoView = [self setInfoView:infoRect];
    self.customInfoView.backgroundColor =[UIColor whiteColor];
    
    [self.customScrollView addSubview:self.customInfoView];
    
    self.addInfoBtn= [[UIButton alloc]init];
    self.addInfoBtn.frame = CGRectMake(priceViewX,self.customInfoView.bottom+0.5 , priceViewW, 50);
    [self.addInfoBtn setTitle:@"添加规格库存" forState:UIControlStateNormal];
    self.addInfoBtn.titleLabel.font =[UIFont fontWithName:@"youyuan" size:17];
    [self.addInfoBtn setTitleColor: kCustomColor(38, 118, 210) forState:UIControlStateNormal];
    
    [self.addInfoBtn setBackgroundColor:[UIColor whiteColor]];
    [self.addInfoBtn addTarget:self action:@selector(addInfoView:) forControlEvents:UIControlEventTouchUpInside];
    [self.customScrollView addSubview:self.addInfoBtn];
    
   
    
    
    //发布按钮
    _footerBtn =[[UIButton alloc]initWithFrame:CGRectMake(0,self.customScrollView.bottom, kScreenWidth, 50)];
    [_footerBtn setTitle:@"发布" forState:UIControlStateNormal];
    [_footerBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [self.view addSubview:_footerBtn];
    self.customScrollView.contentSize = CGSizeMake(0, self.addInfoBtn.bottom+50);

    
}

-(void)btnClick:(UIButton *)btn{
    NSInteger i =btn.tag;
    switch (i) {
        case 1:
            
            break;
            
        default:
            break;
    }
}


-(UIView *)setInfoView:(CGRect)rect{

    UIView * view =[[UIView alloc]initWithFrame:rect];
    
    UITextField *textField1 =[[UITextField alloc]initWithFrame:CGRectMake(15, 15, (kScreenWidth-80)/2, 40)];
    textField1.placeholder =@"规格";
    textField1.layer.borderWidth= 1.5;

    textField1.layer.borderColor = kCustomColor(196, 194, 190).CGColor;
    [view addSubview:textField1];
    
    UITextField *textField2 =[[UITextField alloc]initWithFrame:CGRectMake(textField1.right+15, 15, (kScreenWidth-80)/2, 40)];
    textField2.placeholder =@"库存";
    textField2.layer.borderWidth= 1.5;
    textField2.layer.borderColor = kCustomColor(196, 194, 190).CGColor;

    [view addSubview:textField2];
    
    if (count==0) {
        UIImageView * textImg =[[UIImageView alloc]initWithFrame:CGRectMake(textField2.right+15, 25, 19, 19)];
        textImg.image =[UIImage imageNamed:@"重点"];
        [view addSubview:textImg];
    }else{
        UIButton *addBtn=[[UIButton alloc]initWithFrame:CGRectMake(textField2.right+15, 25, 21, 21)];
        [addBtn setImage:[UIImage imageNamed:@"ggshanchu"] forState:UIControlStateNormal];
        [addBtn addTarget:self action:@selector(delInfoView:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:addBtn];
    }
    return view;
    
}

-(void)delInfoView:(UIButton *)btn{
    count--;
    UIView * view =btn.superview;
    [self.viewItems removeObject:[NSString stringWithFormat:@"%ld",view.tag]];
    
    for (int i =0; i<self.viewItems.count; i++) {
    
        NSString *str=self.viewItems[i];
        if ([str intValue]>view.tag) {
            UIView *view =[self.view viewWithTag:[str intValue]];
            view.frame =CGRectMake(0, view.origin.y-55, view.width, view.height);
            self.viewItems[i]=[NSString stringWithFormat:@"%@",@(view.tag-100)];
            view.tag =view.tag-100;
        }
    }

    self.addInfoBtn.frame =CGRectMake(0, self.addInfoBtn.frame.origin.y-55, kScreenWidth, self.addInfoBtn.frame.size.height);
   
    if (kScreenHeight+50<self.addInfoBtn.bottom+count*5) {
        self.customScrollView.contentSize = CGSizeMake(0, self.addInfoBtn.bottom+count*5);
        
    }else{
        self.customScrollView.contentSize = CGSizeMake(0,self.addInfoBtn.bottom+50);
    }
    [view removeFromSuperview];

}
-(void)addInfoView:(UIButton *)btn{
    count++;
    CGRect  infoRect;
    
    if (count==1) {
         infoRect =CGRectMake(0,self.customInfoView.bottom-15, kScreenWidth, 70);
    }else{
         infoRect =CGRectMake(0,(self.customInfoView.bottom+(count-1)*70)-count*15, kScreenWidth, 70);
    }
    UIView *view= [self setInfoView:infoRect];
    

    view.tag =count*100;
    view.backgroundColor =[UIColor whiteColor];
    [self.customScrollView addSubview:view];

    btn.frame =CGRectMake(0, view.bottom+1, kScreenWidth, 50);
    
    if(count*100==[[self.viewItems lastObject]intValue]){
        [self.viewItems addObject:[NSString stringWithFormat:@"%d",count*100+100]];
    }else{
        [self.viewItems addObject:[NSString stringWithFormat:@"%d",count*100]];
    }
    
    if (kScreenHeight+50<self.addInfoBtn.bottom+count*5) {
        self.customScrollView.contentSize = CGSizeMake(0, self.addInfoBtn.bottom+count*5);
        
    }else{
        self.customScrollView.contentSize = CGSizeMake(0,self.addInfoBtn.bottom+50);
    }
}
@end
