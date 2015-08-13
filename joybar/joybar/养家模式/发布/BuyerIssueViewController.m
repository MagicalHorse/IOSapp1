//
//  BuyerIssueViewController.m
//  joybar
//
//  Created by joybar on 15/5/22.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "BuyerIssueViewController.h"
#import "FeSlideFilterView.h"
#import "JSONKit.h"
#import "BuyerCameraViewController.h"
#import "BuyerFilterViewController.h"
#import "BaseNavigationController.h"
#import "Detail.h"
#import "DetailSize.h"
#import "Image.h"
#import "MJExtension.h"
#import "Tag.h"


@interface BuyerIssueViewController ()<UITextFieldDelegate,UITextViewDelegate,UIScrollViewDelegate,BuyerCameraDelgeate,BuyerFilterDelgeate>
{
    int count;
    BOOL isPrice;
}
@property (nonatomic,strong)UIScrollView *customScrollView;
@property (nonatomic,strong)UIView *customInfoView;
@property (nonatomic,strong)UIView *dscView;
@property (nonatomic,strong)UIView *photoView;
@property (nonatomic,strong)UIButton *addInfoBtn;
@property (nonatomic,strong)UIButton *footerBtn;
@property (nonatomic,strong)NSMutableArray *viewItems;
@property (nonatomic,strong)UITextView *dscText;
@property (nonatomic,strong)BuyerCameraViewController *customCamera;

@property (nonatomic,strong)UITextField *priceText1;
@property (nonatomic,strong)UITextField *priceText;
@property (nonatomic,strong)UITextField *textField1;
@property (nonatomic,strong)UITextField *textField2;

@property (nonatomic,strong)UIImageView *btn1;
@property (nonatomic,strong)UIImageView *btn2;
@property (nonatomic,strong)UIImageView *btn3;
@property (nonatomic,strong)UILabel *titLable;
@property (nonatomic,strong)UILabel *titLable1;
@property (nonatomic,strong)UILabel *titLable2;


@property (nonatomic,strong)NSMutableArray *sizeArray;
@property (nonatomic,strong)NSMutableDictionary *imagesArray;

@property (nonatomic,strong)UIButton *clBtn1;
@property (nonatomic,strong)UIButton *clBtn2;
@property (nonatomic,strong)UIButton *clBtn3;


@end

@implementation BuyerIssueViewController

-(NSMutableArray *)sizeArray{
    if (_sizeArray ==nil) {
        _sizeArray =[[NSMutableArray alloc]init];
    }
    return _sizeArray;
}
-(NSMutableDictionary *)imagesArray{
    if (_imagesArray ==nil) {
        _imagesArray =[[NSMutableDictionary alloc]init];
    }
    return _imagesArray;
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
        self.hidesBottomBarWhenPushed = YES;
        self.customScrollView = [[UIScrollView alloc]init];
        self.btn1=[[UIImageView alloc]init];
        self.btn1.tag=1;
        self.btn1.userInteractionEnabled =YES;
        self.btn2=[[UIImageView alloc]init];
        self.btn2.tag=2;
        self.btn2.userInteractionEnabled =YES;
        self.btn3=[[UIImageView alloc]init];
        self.btn3.tag=3;
        self.btn3.userInteractionEnabled =YES;

    }
    return self;
}

-(NSMutableArray *)viewItems{
    if (_viewItems ==nil) {
        _viewItems =[[NSMutableArray alloc]init];
    }
    return _viewItems;
}
-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    if (self.btn2.image==nil) {
        _titLable1.hidden=NO;
         _clBtn2.hidden=YES;
    }else{
        _titLable1.hidden=YES;
         _clBtn2.hidden=NO;
    }
    if(self.btn3.image ==nil){
        _titLable2.hidden=NO;
         _clBtn3.hidden=YES;
    }else{
        _titLable2.hidden=YES;
         _clBtn3.hidden=NO;
    }
    
    if(self.btn1.image ==nil){
        _titLable.hidden=NO;
        _clBtn1.hidden=YES;
    }else{
        _titLable.hidden=YES;
        _clBtn1.hidden=NO;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    count=0;
    if (self.detail) {
        [self addNavBarViewAndTitle:@"修改商品"];
    }else{
        [self addNavBarViewAndTitle:@"发布商品"];
        self.retBtn.hidden =YES;
    }
    [self setInitView];
}

-(void) setInitView{
    
    //customScrollView
    CGFloat customScrollViewX=0;
    CGFloat customScrollViewY=64;
    CGFloat customScrollViewW=kScreenWidth;
    CGFloat customScrollViewH=kScreenHeight-50-64;
    self.customScrollView.frame =CGRectMake(customScrollViewX, customScrollViewY, customScrollViewW, customScrollViewH);
    self.customScrollView.backgroundColor =kCustomColor(241, 241, 241);
    self.customScrollView.delegate=self;
    [self.view addSubview:self.customScrollView];
    
    
  
    
    //photoView
    self.photoView=  [[UIView alloc]initWithFrame:CGRectMake(0,12, customScrollViewW, 115)];
    self.photoView.backgroundColor =[UIColor whiteColor];
    [self.customScrollView addSubview:self.photoView];
    
     UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelect)];
    [self.customScrollView addGestureRecognizer:tap];
    
    [self creatBtn:self.btn1];
    [self creatBtn:self.btn2];
    [self creatBtn:self.btn3];
    [self creatBtnTitle:self.btn1];
    [self creatBtnTitle:self.btn2];
    [self creatBtnTitle:self.btn3];
    
    self.clBtn1= [self addCancel:self.btn1];
    [self.clBtn1 addTarget:self action:@selector(clBtn1Click) forControlEvents:UIControlEventTouchUpInside];
    self.clBtn2= [self addCancel:self.btn2];
    [self.clBtn2 addTarget:self action:@selector(clBtn2Click) forControlEvents:UIControlEventTouchUpInside];
    self.clBtn3= [self addCancel:self.btn3];
    [self.clBtn3 addTarget:self action:@selector(clBtn3Click) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.images) {
        if (self.btnType ==2) {
            self.btn2.image =self.image;
           
        }else if(self.btnType ==3){
            self.btn3.image =self.image;
        }else{
            self.btn1.image =self.image;
        }
    }
    if (self.detail) {
        NSMutableArray *images =self.detail.Images;
        for (int i=0; i<images.count;i++) {
            [self.imagesArray setObject:images[i] forKey:@(i)];
        }
    }
    if (self.images) {
        [self.imagesArray setObject:self.images forKey:@(0)];
    }

    //priceView
    CGFloat priceViewX=0;
    CGFloat priceViewY=self.photoView.bottom+12;
    CGFloat priceViewW=customScrollViewW;
    CGFloat priceViewH=210;
    UIView * priceView =[[UIView alloc]init];
    priceView.frame = CGRectMake(priceViewX, priceViewY, priceViewW, priceViewH);
    priceView.backgroundColor =[UIColor whiteColor];
    [self.customScrollView addSubview:priceView];
    
    UIImageView *priceImg1=[[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 19, 19)];
    priceImg1.image =[UIImage imageNamed:@"重点"];
    [priceView addSubview:priceImg1];
    UILabel *huohao =[[UILabel alloc]initWithFrame:CGRectMake(priceImg1.right+2, 0, 42, 40)];
    huohao.text =@"货号:";
    huohao.font =[UIFont fontWithName:@"youyuan" size:16];
    [priceView addSubview:huohao];

    
    _priceText1=[[UITextField alloc]initWithFrame:CGRectMake(huohao.right, 0, kScreenWidth-huohao.right, 40)];
    _priceText1.tag =10001;
    _priceText1.delegate =self;
    _priceText1.font =[UIFont fontWithName:@"youyuan" size:16];
    _priceText1.placeholder =@"请输入";
    [priceView addSubview:_priceText1];
    UIView *lineView1=[[UIView alloc]initWithFrame:CGRectMake(15, _priceText1.bottom, kScreenWidth-15, 0.5)];
    lineView1.backgroundColor =[UIColor lightGrayColor];
    [priceView addSubview:lineView1];
    
    
    UIImageView *priceImg=[[UIImageView alloc]initWithFrame:CGRectMake(15, 55, 19, 19)];
    priceImg.image =[UIImage imageNamed:@"重点"];
    [priceView addSubview:priceImg];
    
    UILabel *jiage =[[UILabel alloc]initWithFrame:CGRectMake(priceImg.right+2, 45, 42, 40)];
    jiage.text =@"价格:";
    jiage.font =[UIFont fontWithName:@"youyuan" size:16];
    [priceView addSubview:jiage];
    
    _priceText=[[UITextField alloc]initWithFrame:CGRectMake(jiage.right, 45, kScreenWidth-jiage.right-45, 40)];
    _priceText.tag =10002;
    _priceText.keyboardType =UIKeyboardTypeDecimalPad;
    _priceText.delegate =self;
    [_priceText addTarget:self action:@selector(priceTextChanged:) forControlEvents:UIControlEventEditingChanged];
    _priceText.font =[UIFont fontWithName:@"youyuan" size:16];
    _priceText.placeholder =@"请输入";
    [priceView addSubview:_priceText];
    UILabel *jiageyuan =[[UILabel alloc]initWithFrame:CGRectMake(_priceText.right-10, 45, 42, 40)];
    jiageyuan.textAlignment =NSTextAlignmentRight;
    jiageyuan.text =@"元";
    jiageyuan.font =[UIFont fontWithName:@"youyuan" size:16];
    [priceView addSubview:jiageyuan];
    
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(15, _priceText.bottom, kScreenWidth-15, 0.5)];
    lineView.backgroundColor =[UIColor lightGrayColor];
    [priceView addSubview:lineView];

    
    UIView *dscView =[[UIView alloc]initWithFrame:CGRectMake(15, lineView.bottom+10, kScreenWidth-30, 100)];
    dscView.layer.borderWidth= 1.5;
    dscView.layer.borderColor = kCustomColor(196, 194, 190).CGColor;
    [priceView addSubview:dscView];
    
    UILabel *lable =[[UILabel alloc]initWithFrame:CGRectMake(dscView.right-55, dscView.height-20, 60, 15)];
    lable.text =@"100字";
    lable.textColor =kCustomColor(194, 194, 200);
    lable.font =[UIFont systemFontOfSize:13];

    [dscView addSubview:lable];

    UIImageView * zdImg = [[UIImageView alloc]init] ;
    zdImg.frame =CGRectMake(5, 5, 19, 19);
    zdImg.image =[UIImage imageNamed:@"重点"];
    [dscView addSubview:zdImg];
    
    _dscText=[[UITextView alloc]init];
    _dscText.delegate =self;
    _dscText.textColor =kCustomColor(194, 194, 200);
    _dscText.font =[UIFont systemFontOfSize:15];
    _dscText.frame =CGRectMake(zdImg.right, 0, kScreenWidth-30-zdImg.width-8, 60);
    
    _dscText.text =@"给力商品描述点";
    [dscView addSubview:_dscText];
    
    CGRect  infoRect =CGRectMake(priceViewX, priceView.bottom+12, priceViewW, 70);
    self.customInfoView = [self setInfoView:infoRect andShow:1];
    self.customInfoView.tag =10;
    self.customInfoView.backgroundColor =[UIColor whiteColor];
    
    [self.customScrollView addSubview:self.customInfoView];
    
    self.addInfoBtn= [[UIButton alloc]init];
    self.addInfoBtn.frame = CGRectMake(priceViewX,self.customInfoView.bottom+0.5 , priceViewW, 50);
    [self.addInfoBtn setTitle:@"添加规格库存" forState:UIControlStateNormal];
    self.addInfoBtn.titleLabel.font =[UIFont systemFontOfSize:17];
    [self.addInfoBtn setTitleColor: kCustomColor(38, 118, 210) forState:UIControlStateNormal];
    
    [self.addInfoBtn setBackgroundColor:[UIColor whiteColor]];
    [self.addInfoBtn addTarget:self action:@selector(addInfoView:andShow:) forControlEvents:UIControlEventTouchUpInside];
    [self.customScrollView addSubview:self.addInfoBtn];
    
    //发布按钮
    _footerBtn =[[UIButton alloc]initWithFrame:CGRectMake(0,kScreenHeight-50, kScreenWidth, 50)];
    if (self.detail) {
        [_footerBtn setTitle:@"修改" forState:UIControlStateNormal];

    }else{
        [_footerBtn setTitle:@"发布" forState:UIControlStateNormal];
        //取消发布
        UIButton *finishBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        finishBtn.frame = CGRectMake(kScreenWidth-80, 35, 64, 15);
        finishBtn.backgroundColor = [UIColor clearColor];
        [finishBtn setTitle:@"取消发布" forState:(UIControlStateNormal)];
        [finishBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        finishBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [finishBtn addTarget:self action:@selector(didClickFinishBtn) forControlEvents:(UIControlEventTouchUpInside)];
        [self.navView addSubview:finishBtn];
    }
    [_footerBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [_footerBtn setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_footerBtn];
    [_footerBtn addTarget:self action:@selector(publicsh) forControlEvents:UIControlEventTouchUpInside];
    
    self.customScrollView.contentSize = CGSizeMake(0, self.addInfoBtn.bottom+50);
    if (self.detail) {
        [self updateInfoView:self.detail];
        isPrice=YES;

    }
    else{
        isPrice=NO;
    }
    
}

//第一张图片点击取消
-(void)clBtn1Click{
    self.btn1.image=nil;
    self.titLable.hidden=NO;
    self.clBtn1.hidden=YES;

    [self.imagesArray removeObjectForKey:@(0)];
}
-(void)clBtn2Click{
    self.btn2.image=nil;
    self.titLable1.hidden=NO;
    self.clBtn2.hidden=YES;
    [self.imagesArray removeObjectForKey:@(1)];

}
-(void)clBtn3Click{
    self.btn3.image=nil;
    self.titLable2.hidden=NO;
    self.clBtn3.hidden=YES;
    [self.imagesArray removeObjectForKey:@(2)];

}

-(void)didClickFinishBtn{
   
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)priceTextChanged:(UITextField *)textField{
    if (![self isKindOfNumer:textField.text]) {
        isPrice=NO;
        [self showHudFailed:@"价格只能为两位小数点"];
    }else{
        isPrice=YES;
    }
}
-(BOOL)isKindOfNumer:(NSString *)text{
    
    NSArray *array= [text componentsSeparatedByString:@"."];
    if (array.count ==2) {
        NSString *temp= array[1];
        if (temp.length>2) {
            return NO;
        }else{
            return YES;
        }
        return YES;
    }else if(array.count>2){
        return NO;
    }
    return YES;
}
//修改才会进
-(void)updateInfoView:(Detail *)detail
{

    self.priceText.text =[detail.Price stringValue];
    self.dscText.text =detail.Desc;
    self.priceText1.text =detail.Sku_Code;
    for (int i=0; i<detail.Images.count; i++) {
        Image *img =detail.Images[i];
        NSString *url =[NSString stringWithFormat:@"%@",img.ImageUrl];
         UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
        if (i==0) {
            self.btn1.image =image;
        }else if(i==1){
            self.btn2.image =image;

        }else if(i==2){
            self.btn3.image =image;
        }
    }
    for (int i=1; i<detail.Sizes.count; i++) {
       
        [self addInfoView:self.addInfoBtn andShow:1];
    }
  
    if(self.viewItems.count>0){
       
        for (int y =0; y<self.viewItems.count; y++) {
            UIView *view =[self.view viewWithTag:[self.viewItems[y] intValue]];
            for (int i=0; i<view.subviews.count; i++) {
                UIView *v =view.subviews[i];
                if ([v isKindOfClass: [UITextField class]] ) {
                    UITextField *ctext =(UITextField *)v;
                    DetailSize *size=detail.Sizes[y+1];
                    if (i==1) {
                        ctext.text=size.Name;
                    }else if(i==3){
                        ctext.text =[size.Inventory stringValue];
                    }
                }
                
            }
        }
    }
}

-(void)returnBtnClicked:(UIButton *)button
{
    [Common saveUserDefault:@"1" keyName:@"backPhone"];
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)creatBtn:(UIImageView *)btn
{
    NSInteger i=btn.tag-1;
    btn.frame= CGRectMake((kScreenWidth/3-20)*i+15*(i+1), 15, 85, 85);
    btn.layer.borderWidth= 1.5;
    btn.layer.borderColor = kCustomColor(169, 200, 234).CGColor;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnClick:)];
    [btn addGestureRecognizer:tap];
    [self.photoView addSubview:btn];

    
    
}
-(UIButton *)addCancel :(UIImageView *)btn{
    UIButton *clbtn = [[UIButton alloc]init];
    clbtn.frame =CGRectMake(btn.right-25, btn.top-15, 40, 40);
    [clbtn setImage:[UIImage imageNamed:@"ggshanchu"] forState:UIControlStateNormal];
    [self.photoView addSubview:clbtn];
    return clbtn;
}
-(void)creatBtnTitle :(UIImageView *)btn{
    if (btn.tag==2) {
        _titLable1 =[[UILabel alloc]initWithFrame:CGRectMake(btn.frame.origin.x, btn.frame.origin.y, btn.frame.size.width, btn.frame.size.height)];
        _titLable1.text =@"+图片";
        _titLable1.textColor =[UIColor grayColor];
        _titLable1.textAlignment =NSTextAlignmentCenter;
        _titLable1.font =[UIFont fontWithName:@"youyuan" size:16];
        [self.photoView addSubview:_titLable1];
    }else if(btn.tag ==3){
        _titLable2 =[[UILabel alloc]initWithFrame:CGRectMake(btn.frame.origin.x, btn.frame.origin.y, btn.frame.size.width, btn.frame.size.height)];
        _titLable2.text =@"+图片";
        _titLable2.textColor =[UIColor grayColor];
        _titLable2.textAlignment =NSTextAlignmentCenter;
        _titLable2.font =[UIFont fontWithName:@"youyuan" size:16];
        [self.photoView addSubview:_titLable2];
    }else{
        _titLable =[[UILabel alloc]initWithFrame:CGRectMake(btn.frame.origin.x, btn.frame.origin.y, btn.frame.size.width, btn.frame.size.height)];
        _titLable.text =@"+图片";
        _titLable.textColor =[UIColor grayColor];
        _titLable.textAlignment =NSTextAlignmentCenter;
        _titLable.font =[UIFont fontWithName:@"youyuan" size:16];
        [self.photoView addSubview:_titLable];
    }
   
}
//发布
-(void)publicsh{
       if (self.imagesArray.count==0) {
        [self showHudFailed:@"请至少上传一张图片"];
        return;
    }else if(self.priceText1.text.length==0){
        [self showHudFailed:@"请填写货号"];
        return;
    }else if(self.priceText.text.length==0){
        [self showHudFailed:@"请填写价格"];
        return;
    }else if(!isPrice){
        [self showHudFailed:@"价格只能为两位小数点"];
        return;
    }else if(self.dscText.text.length==0||[self.dscText.text isEqualToString:@"给力商品描述点"]){
        [self showHudFailed:@"请填写商品描述"];
        return;
    }else if(self.dscText.text.length>100){
        [self showHudFailed:@"商品描述不能大于100字符"];
        return;
    }
    self.sizeArray=nil;
    NSMutableDictionary *tempSizes =[NSMutableDictionary dictionary];
    UIView *view =[self.view viewWithTag:10];
    for (int i=0; i<view.subviews.count; i++) {
        UIView *v =view.subviews[i];
        if ([v isKindOfClass: [UITextField class]] ) {
            UITextField *ctext =(UITextField *)v;
            if (i==1) {
                if (ctext.text.length ==0) {
                    [self showHudFailed:@"规格不能为空"];
                    return;
                }
                [tempSizes setValue:ctext.text forKey:@"name"];
            }else if(i==3)
            {
                if (ctext.text.length ==0) {
                    [self showHudFailed:@"库存不能为空"];
                    return;
                }else if([ctext.text isEqualToString:@"0"]){
                    [self showHudFailed:@"库存不能小于0"];
                    return;
                }
                [tempSizes setValue:ctext.text forKey:@"Inventory"];
            }
        }
    }
    if (tempSizes) {
        [self.sizeArray addObject:tempSizes];
    }
    if(self.viewItems.count>0){
        for (NSString *str in self.viewItems) {
            UIView *view =[self.view viewWithTag:[str intValue]];
            NSMutableDictionary *tempSizes1 =[NSMutableDictionary dictionary];
            for (int i=0; i<view.subviews.count; i++) {
                UIView *v =view.subviews[i];
                if ([v isKindOfClass: [UITextField class]] ) {
                    UITextField *ctext =(UITextField *)v;
                    if (i==1) {
                        if (ctext.text.length ==0) {
                            [self showHudFailed:@"规格不能为空"];
                            return;
                        }
                        [tempSizes1 setValue:ctext.text forKey:@"name"];
                    }else if(i==3){
                        if (ctext.text.length ==0) {
                            [self showHudFailed:@"库存不能为空"];
                            return;
                        }else if([ctext.text isEqualToString:@"0"]){
                            [self showHudFailed:@"库存不能小于0"];
                            return;
                        }
                        [tempSizes1 setValue:ctext.text forKey:@"Inventory"];
                    }
                }
                
            }
            [self.sizeArray addObject:tempSizes1];
        }
    }
    

    if (self.detail) {
        [self hudShow:@"正在修改"];
    }else{
        [self hudShow:@"正在发布"];
    }
   
    NSMutableDictionary *dict =[[NSMutableDictionary alloc]init];
    [dict setObject:self.priceText.text forKey:@"Price"];
    [dict setObject:self.sizeArray forKey:@"Sizes"];
    
    //修改Image为字典对象
   
    NSMutableArray *tempImagesArray =[NSMutableArray array];
    for (NSNumber *i in [self.imagesArray allKeys]) {
        
        if ([[self.imagesArray objectForKey:i] isKindOfClass :NSClassFromString(@"Image")]) {
            Image *image =[self.imagesArray objectForKey:i];
            [self.imagesArray setObject:[image keyValues] forKey:i];
        }
        
        NSDictionary *dict =[self.imagesArray objectForKey:i];
        [tempImagesArray addObject:dict];
    }
    
    
    [dict setObject:tempImagesArray forKey:@"Images"];
    [dict setObject:self.dscText.text forKey:@"Desc"];
    [dict setObject:self.priceText1.text forKey:@"Sku_Code"];
    

    NSString *tempUrl;
    if (self.detail) {
        tempUrl =@"Product/Update";
        [dict setObject:self.productId forKey:@"Id"];
    }else{
        tempUrl =@"Product/Create";
    }
     NSDictionary * parameters = [ NSDictionary dictionaryWithObjectsAndKeys:[ dict JSONString], @"json" , nil ];
    
    [HttpTool postWithURL:tempUrl params:parameters success:^(id json) {
        BOOL  isSuccessful =[[json objectForKey:@"isSuccessful"] boolValue];
        if (isSuccessful) {
            if (self.detail) {
                [self showHudSuccess:@"修改成功"];

                dispatch_time_t time=dispatch_time(DISPATCH_TIME_NOW, 1*NSEC_PER_SEC);
                dispatch_after(time, dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });

            }else{
                [self showHudSuccess:@"发布成功"];
                dispatch_time_t time=dispatch_time(DISPATCH_TIME_NOW, 1*NSEC_PER_SEC);
                dispatch_after(time, dispatch_get_main_queue(), ^{
                    [self dismissViewControllerAnimated:YES completion:nil];
                });
            }
        }else{
            [self showHudFailed:[json objectForKey:@"message"]];
        }
        [self textHUDHiddle];
    } failure:^(NSError *error) {
        NSLog(@"%@",[error description]);
    }];
}
//选择图片
-(void)btnClick:(UITapGestureRecognizer *)btn{
    NSInteger i =btn.view.tag;
    switch (i) {
        case 1:
            if (self.detail &&[self.imagesArray objectForKey:@(0)]){
                Image *image;
                if (![[self.imagesArray objectForKey:@(0)] isKindOfClass:[Image class]]){
                    NSDictionary *dict=[self.imagesArray objectForKey:@(0)];
                    image= [Image objectWithKeyValues:dict];
                }else{
                    image =[self.imagesArray objectForKey:@(0)];
                }

                BuyerFilterViewController *filter =[[BuyerFilterViewController alloc]initWithImg:self.btn1.image andImage:image];
                filter.btnType =(int)self.btn1.tag;
                filter.delegate=self;
                [self.navigationController pushViewController:filter animated:YES];
                
            }
            else if(self.btn1.image) {
                if ([self.imagesArray objectForKey:@(0)]) {
                    NSDictionary *imageurl =[self.imagesArray objectForKey:@(0)];
                    BuyerFilterViewController *filter =[[BuyerFilterViewController alloc]initWithImg:self.btn1.image];
                    filter.delegate=self;
                    filter.btnType =(int)self.btn1.tag;
                    filter.imageDic =imageurl;
                    [self.navigationController pushViewController:filter animated:YES];
                }
            }else {
                self.btnType =1;
                [Common saveUserDefault:@"3" keyName:@"backPhone"];
                self.customCamera =[[BuyerCameraViewController alloc]initWithType:(int)i];
                self.customCamera.delegate =self;
                BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:self.customCamera];
                [self presentViewController:nav animated:YES completion:nil];
            }
                break;
        case 2:
            if (self.detail&&[self.imagesArray objectForKey:@(1)]) {
                
                Image *image =[[Image alloc]init];
                if (![[self.imagesArray objectForKey:@(1)] isKindOfClass:[Image class]]){
                    image.ImageUrl =[[self.imagesArray objectForKey:@(1)]objectForKey:@"ImageUrl"];
                    image.Tags =[[self.imagesArray objectForKey:@(1)]objectForKey:@"Tags"];
                }else{
                    image =[self.imagesArray objectForKey:@(1)];
                }
                BuyerFilterViewController *filter =[[BuyerFilterViewController alloc]initWithImg:self.btn2.image andImage:image];
                filter.delegate=self;
                filter.btnType =(int)self.btn2.tag;
                [self.navigationController pushViewController:filter animated:YES];
                
            }else if (self.btn2.image) {
                
                if ([self.imagesArray objectForKey:@(1)]) {
                    NSDictionary *imageurl =[self.imagesArray objectForKey:@(1)];
                    BuyerFilterViewController *filter =[[BuyerFilterViewController alloc]initWithImg:self.btn2.image];
                    filter.imageDic =imageurl;
                    filter.delegate =self;
                    filter.btnType =(int)self.btn2.tag;

                    [self.navigationController pushViewController:filter animated:YES];
                }
                
            }else {
                self.btnType =2;
                [Common saveUserDefault:@"3" keyName:@"backPhone"];
                self.customCamera =[[BuyerCameraViewController alloc]initWithType:(int)i];
                self.customCamera.delegate =self;
                BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:self.customCamera];
                [self presentViewController:nav animated:YES completion:nil];
            }
            
          
            break;
        case 3:
            if (self.detail &&[self.imagesArray objectForKey:@(2)]) {
                Image *image =[[Image alloc]init];
                if (![[self.imagesArray objectForKey:@(2)] isKindOfClass:[Image class]]){
                    image.ImageUrl =[[self.imagesArray objectForKey:@(2)]objectForKey:@"ImageUrl"];
                    image.Tags =[[self.imagesArray objectForKey:@(2)]objectForKey:@"Tags"];
                }else{
                    image =[self.imagesArray objectForKey:@(2)];
                }
                BuyerFilterViewController *filter =[[BuyerFilterViewController alloc]initWithImg:self.btn3.image andImage:image];
                filter.delegate=self;
                filter.btnType =(int)i;
                [self.navigationController pushViewController:filter animated:YES];
                
            }else if (self.btn3.image) {
                
                if ([self.imagesArray objectForKey:@(2)]) {
                    NSDictionary *imageurl =[self.imagesArray objectForKey:@(2)];
                    BuyerFilterViewController *filter =[[BuyerFilterViewController alloc]initWithImg:self.btn3.image];
                    filter.imageDic =imageurl;
                    filter.delegate =self;
                    filter.btnType =(int)i;

                    [self.navigationController pushViewController:filter animated:YES];
                }
                
            }else {
                self.btnType =3;
                [Common saveUserDefault:@"3" keyName:@"backPhone"];
                self.customCamera =[[BuyerCameraViewController alloc]initWithType:(int)i];
                self.customCamera.delegate =self;
                BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:self.customCamera];
                [self presentViewController:nav animated:YES completion:nil];
            }
            break;
            
        default:
            break;
    }

    
}


-(UIView *)setInfoView:(CGRect)rect andShow:(int)isShow
{

    UIView * view =[[UIView alloc]initWithFrame:rect];
    
    UILabel *lable1 =[[UILabel alloc]initWithFrame:CGRectMake(15, 15, 40, 40)];
    lable1.text =@"规格:";
    lable1.font =[UIFont fontWithName:@"youyuan" size:16];
    [view addSubview:lable1];

    _textField1 =[[UITextField alloc]initWithFrame:CGRectMake(lable1.right+2, 15, (kScreenWidth-160)/2, 40)];
    _textField1.delegate =self;
    _textField1.layer.borderWidth= 1.5;
    _textField1.tag =10003;

    _textField1.layer.borderColor = kCustomColor(196, 194, 190).CGColor;
    [view addSubview:_textField1];
    
    
    UILabel *lable2 =[[UILabel alloc]initWithFrame:CGRectMake(_textField1.right+15, 15, 40, 40)];
    lable2.text =@"库存:";
    lable2.font =[UIFont fontWithName:@"youyuan" size:16];
    [view addSubview:lable2];

    
    _textField2 =[[UITextField alloc]initWithFrame:CGRectMake(lable2.right+2, 15, (kScreenWidth-160)/2, 40)];
    _textField2.tag =10004;

    _textField2.delegate =self;
    _textField2.keyboardType=UIKeyboardTypeNumberPad;
    _textField2.layer.borderWidth= 1.5;
    _textField2.layer.borderColor = kCustomColor(196, 194, 190).CGColor;

    [view addSubview:_textField2];
    
    if (count==0) {
        UIImageView * textImg =[[UIImageView alloc]initWithFrame:CGRectMake(_textField2.right+10, 25, 19, 19)];
        textImg.image =[UIImage imageNamed:@"重点"];
        [view addSubview:textImg];
    }else{
        UIButton *addBtn=[[UIButton alloc]initWithFrame:CGRectMake(_textField2.right, 17, 40, 40)];
        [addBtn setImage:[UIImage imageNamed:@"ggshanchu"] forState:UIControlStateNormal];
        [addBtn addTarget:self action:@selector(delInfoView:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:addBtn];
    }
    if (self.detail &&isShow==1) {
        if (self.detail.Sizes.count>0) {
            DetailSize *size=self.detail.Sizes[0];
            _textField1.text =size.Name;
            _textField2.text =[size.Inventory stringValue];
        }

    }
    return view;
    
}

-(void)delInfoView:(UIButton *)btn{
    count--;
    UIView * view =btn.superview;
    [self.viewItems removeObject:[NSString stringWithFormat:@"%d",(int)view.tag]];
    
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
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.30];
    CGRect rect = self.view.frame;
    rect.origin.y = 0;
    self.view.frame = rect;
    [UIView commitAnimations];

}
-(void)addInfoView:(UIButton *)btn andShow:(int)isShow
{
    count++;
    CGRect  infoRect;
    
    if (count==1) {
         infoRect =CGRectMake(0,self.customInfoView.bottom-15, kScreenWidth, 70);
    }else{
         infoRect =CGRectMake(0,(self.customInfoView.bottom+(count-1)*70)-count*15, kScreenWidth, 70);
    }
    UIView *view= [self setInfoView:infoRect andShow:isShow];
    

    view.tag =count*100;
    view.backgroundColor =[UIColor whiteColor];
    [self.customScrollView addSubview:view];

    btn.frame =CGRectMake(0, view.bottom+1, kScreenWidth, 50);
    
    if(count*100==[[self.viewItems lastObject]intValue]){
        [self.viewItems addObject:[NSString stringWithFormat:@"%d",count*100+100]];
    }else{
        [self.viewItems addObject:[NSString stringWithFormat:@"%d",count*100]];
    }
    self.customScrollView.contentSize = CGSizeMake(0,self.customScrollView.contentSize.height+50);
//    if (kScreenHeight+50<self.customScrollView.contentSize.height) {
//        self.customScrollView.contentSize = CGSizeMake(0, self.customScrollView.contentSize.height+250);
//        
//    }else{
//        
//    }
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.customScrollView.contentSize =CGSizeMake(0, self.addInfoBtn.bottom+250);
    return YES;
}

-(void)didSelect{
    if (self.dscText.text.length ==0) {
        self.dscText.text =@"给力商品描述点";
    }
    [self.dscText resignFirstResponder];
    [self.priceText1 resignFirstResponder];
    [self.priceText resignFirstResponder];
    [self.textField1 resignFirstResponder];
    [self.textField2 resignFirstResponder];

}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.priceText1 resignFirstResponder];
    [self.priceText resignFirstResponder];
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@"给力商品描述点"]) {
         self.dscText.text=@"";
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    if(textView.text.length==0){
        self.dscText.text=@"给力商品描述点";
    }
}

-(void)dismissCamrea:(UIImage *)image WithTag:(int)type AndDataArray:(NSMutableDictionary *)array{
    
    switch (type) {
        case 1:
            self.titLable.hidden=YES;
            if (array) {
               
                [self.imagesArray setObject:array forKey:@(0)];
            }
            self.btn1.image =image;
            self.clBtn1.hidden=NO;

            break;
        case 2:
            self.titLable1.hidden=YES;
            if (array) {
                [self.imagesArray setObject:array forKey:@(1)];
            }
            self.btn2.image =image;
            self.clBtn2.hidden=NO;
            
            break;
        case 3:
            self.titLable2.hidden=YES;

            if (array) {
                [self.imagesArray setObject:array forKey:@(2)];
            }
            self.btn3.image =image;
            self.clBtn3.hidden=NO;
            break;
        default:
            break;
    }
}

//filterDelegate
-(void)pop:(UIImage *)image AndDic:(NSMutableDictionary *)dic AndType:(int)type
{
    switch (type) {
        case 1:
            if (dic) {
                [self.imagesArray setObject:dic forKey:@(0)];
            }
            self.btn1.image =image;
            break;
        case 2:
            if (dic) {
                [self.imagesArray setObject:dic forKey:@(1)];
            }
            self.btn2.image =image;
            break;
        case 3:
           
            if (dic) {
                [self.imagesArray setObject:dic forKey:@(2)];

            }
            self.btn3.image =image;
            break;
        default:
            break;
    }

}

@end
