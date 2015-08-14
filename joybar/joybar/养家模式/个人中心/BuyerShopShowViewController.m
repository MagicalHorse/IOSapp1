//
//  BuyerShopShowViewController.m
//  joybar
//
//  Created by joybar on 15/6/3.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "BuyerShopShowViewController.h"

@interface BuyerShopShowViewController ()<UITextViewDelegate>
@property (nonatomic ,strong)UITextView *textView;
@property (nonatomic, strong)UILabel *countLable;
@end

@implementation BuyerShopShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavBarViewAndTitle:@"店铺说明"];
    UIButton *searchBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    searchBtn.frame = CGRectMake(kScreenWidth-64, 10, 64, 64);
    [searchBtn setTitle:@"完成" forState:UIControlStateNormal];
    [searchBtn setTitleColor :[UIColor blackColor] forState:UIControlStateNormal];
    searchBtn.titleLabel.font =[UIFont systemFontOfSize:15];
    [searchBtn addTarget:self action:@selector(setData) forControlEvents:(UIControlEventTouchUpInside)];
    [self.navView addSubview:searchBtn];
    [self setInitView];
    
}

- (void)setInitView {
    
    UIView *view= [[UIView alloc]initWithFrame:CGRectMake(10, 74, kScreenWidth-20, 200)];
    view.layer.borderWidth= 1.5;
    view.layer.borderColor = kCustomColor(196, 194, 190).CGColor;
    [self.view addSubview:view];
    
    _textView =[[UITextView alloc]init];
    _textView.frame =CGRectMake(0, 0, kScreenWidth-20, 180);
    _textView.delegate =self;
    _textView.font =[UIFont systemFontOfSize:15];
    NSDictionary * temp =[Public getUserInfo];
    _textView.text =[temp objectForKey:@"description"];
    
    NSDictionary *dict=[Public getUserInfo];
    self.textView.text =[dict objectForKey:@"Description"];
    [_textView becomeFirstResponder];
    [view addSubview:_textView];
    
   _countLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 175, view.width-10, 20)];
    _countLable.textAlignment =NSTextAlignmentRight;
    _countLable.textColor =[UIColor lightGrayColor];
    _countLable.font =[UIFont systemFontOfSize:14];
    NSUInteger count =self.textView.text.length;
    _countLable.text =[NSString stringWithFormat:@"%ld字",200-count];
    [view addSubview:_countLable];
    
}
-(void)setData{
    
    [self.textView resignFirstResponder];
    if (self.textView.text.length>200) {
        [self showHudFailed:@"店铺描述不能大于200字"];
        return;
    }
    
    NSMutableDictionary *dict =[[NSMutableDictionary alloc]init];
    [dict setObject:self.textView.text forKey:@"description"];
    [HttpTool postWithURL:@"Buyer/SetStoreDescription" params:dict success:^(id json) {
        BOOL  isSuccessful =[[json objectForKey:@"isSuccessful"] boolValue];
        if (isSuccessful) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[Public getUserInfo]];
            [dic setObject:self.textView.text forKey:@"Description"];
            [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"userInfo"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self showHudFailed:[json objectForKey:@"message"]];
        }
        
    } failure:^(NSError *error) {
        
    }];
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
-(void)textViewDidChange:(UITextView *)textView{
    NSInteger number = [textView.text length];
    if (number > 200) {
               textView.text = [textView.text substringToIndex:200];
        number = 200;
    }
    _countLable.text =[NSString stringWithFormat:@"%ld字",200-number];
}

@end
