//
//  BuyerOpenViewController.m
//  joybar
//
//  Created by joybar on 15/6/4.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "BuyerOpenViewController.h"

@interface BuyerOpenViewController ()<UITextFieldDelegate>{
    BOOL isPrice;
}
- (IBAction)btnClick;
@property (nonatomic,strong)UIView *tempView;
@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,strong)UIButton *cancleBtn;
@property (weak, nonatomic) IBOutlet UITextField *priceText;

@property (weak, nonatomic) IBOutlet UITextField *noText;
@property (weak, nonatomic) IBOutlet UIButton *btn;
- (IBAction)textChange:(id)sender;

@end

@implementation BuyerOpenViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        isPrice=NO;
        self.hidesBottomBarWhenPushed = YES;
        
    }
    return self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavBarViewAndTitle:@"开小票"];
    self.retBtn.hidden =YES;
    self.view.backgroundColor = kCustomColor(241, 241, 241);
    UIButton *searchBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    searchBtn.frame = CGRectMake(kScreenWidth-64, 10, 64, 64);
    [searchBtn setTitle:@"取消" forState:UIControlStateNormal];
    [searchBtn setTitleColor :[UIColor blackColor] forState:UIControlStateNormal];
    searchBtn.titleLabel.font =[UIFont fontWithName:@"youyuan" size:15];
    [searchBtn addTarget:self action:@selector(calClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.navView addSubview:searchBtn];
}

-(void)calClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)btnClick {
    if (self.priceText.text.length==0) {
        [self showHudFailed:@"请输入货号"];
        return;
    }else
    if (self.noText.text.length==0) {
        [self showHudFailed:@"请输入金额"];
        return;
    }else
    if (!isPrice) {
        [self showHudFailed:@"价格只能为两位小数"];
        return;
    }
    [self hudShow:@"正在创建"];
    self.btn.userInteractionEnabled =NO;
    NSMutableDictionary *dic =[NSMutableDictionary dictionary];
    [dic setObject:self.noText.text forKey:@"price"];
    [dic setObject:self.priceText.text forKey:@"saleCode"];

    [HttpTool postWithURL:@"Order/CreateGeneralOrder" params:dic success:^(id json) {
        BOOL  isSuccessful =[[json objectForKey:@"isSuccessful"] boolValue];
        if (isSuccessful) {
            UIImage *decodedImage;
            if ([[json objectForKey:@"data"]objectForKey:@"QrCode"]) {
                NSData *decodedImageData = [[NSData alloc]initWithBase64Encoding:[[json objectForKey:@"data"] objectForKey:@"QrCode"]];
                decodedImage = [UIImage imageWithData:decodedImageData];
            }
            
            NSString *no =[[json objectForKey:@"data"]objectForKey:@"OrderNo"];
            NSString *price =[[[json objectForKey:@"data"] objectForKey:@"Amount"]stringValue];
            [self addBigView:decodedImage AndNo:no AndPrice:price];
        }else{
            [self showHudFailed:[json objectForKey:@"message"]];
        }
        [self textHUDHiddle];
    } failure:^(NSError *error) {
        [self showHudFailed:@"网络繁忙,请稍后再试"];
        [self textHUDHiddle];
    }];
    
    
}

-(void)addBigView:(UIImage*)img AndNo:(NSString *)no AndPrice :(NSString *)price
{
    _tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64-49)];
    _tempView.hidden = NO;
    _tempView.alpha =0.6 ;
    _tempView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_tempView];

    _bgView = [[UIView alloc] init];
    _bgView.center = CGPointMake(kScreenWidth/2, kScreenHeight/2);
    _bgView.bounds = CGRectMake(0, 0, kScreenWidth-50, (kScreenWidth-50)*1.35);
    _bgView.layer.cornerRadius = 4;
    _bgView.backgroundColor = kCustomColor(245, 246, 247);
    _bgView.hidden = NO;
    _bgView.userInteractionEnabled = YES;
    [self.view addSubview:_bgView];

    _cancleBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _cancleBtn.center = CGPointMake(kScreenWidth-25, _bgView.top);
    _cancleBtn.bounds = CGRectMake(0, 0, 50, 50);
    _cancleBtn.hidden = NO;
    [_cancleBtn setImage:[UIImage imageNamed:@"叉icon"] forState:(UIControlStateNormal)];
    [_cancleBtn addTarget:self action:@selector(didClickHiddenView:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_cancleBtn];


    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(80, 25, _bgView.width-100, 20)];
    titleLab.text = no;
    titleLab.font = [UIFont fontWithName:@"youyuan" size:16];
    [_bgView addSubview:titleLab];

    UILabel *numLab = [[UILabel alloc] initWithFrame:CGRectMake(80, titleLab.bottom+2, _bgView.width-100, 20)];
    numLab.text = price;
    numLab.font = [UIFont fontWithName:@"youyuan" size:14];
    numLab.textColor = [UIColor darkGrayColor];
    [_bgView addSubview:numLab];

    UIImageView *codeImage = [[UIImageView alloc] initWithFrame:CGRectMake(35, 75+10, _bgView.width-70, _bgView.width-70)];
    codeImage.image =img;
    [_bgView addSubview:codeImage];

}
//点叉
-(void)didClickHiddenView:(UIButton *)btn
{
    btn.hidden = YES;

    _bgView.transform = CGAffineTransformMakeScale(1, 1);

    [UIView animateWithDuration:0.25
                     animations:^{
                         _bgView.transform = CGAffineTransformMakeScale(0.001, 0.001);
                         _bgView.alpha = 0.6;
                     }completion:^(BOOL finish){
                         _tempView.hidden = YES;
                         _bgView.hidden = YES;
                         self.btn.userInteractionEnabled =YES;

                     }];

}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.noText resignFirstResponder];
    [self.priceText resignFirstResponder];

}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)textChange:(id)sender {
    UITextField *text =(UITextField *)sender;
    if (![self isKindOfNumer:[text text]]) {
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
@end
