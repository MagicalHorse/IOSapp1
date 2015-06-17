//
//  BuyerOpenViewController.m
//  joybar
//
//  Created by joybar on 15/6/4.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "BuyerOpenViewController.h"

@interface BuyerOpenViewController ()
- (IBAction)btnClick;
@property (nonatomic,strong)UIView *tempView;
@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,strong)UIButton *cancleBtn;


@end

@implementation BuyerOpenViewController

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
    
    [self addBigView];
}

-(void)addBigView
{
    _tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _tempView.hidden = NO;
    _tempView.alpha = 0;
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

    UIImageView *headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 60, 60)];
    headerImage.backgroundColor = [UIColor orangeColor];
    headerImage.layer.cornerRadius = headerImage.width/2;
    [_bgView addSubview:headerImage];

    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(headerImage.right+5, headerImage.top+10, _bgView.width-100, 20)];
    titleLab.text = @"啊实打实女包";
    titleLab.font = [UIFont fontWithName:@"youyuan" size:16];
    [_bgView addSubview:titleLab];

    UILabel *numLab = [[UILabel alloc] initWithFrame:CGRectMake(headerImage.right+5, titleLab.bottom+2, _bgView.width-100, 20)];
    numLab.text = @"成员: 123123人";
    numLab.font = [UIFont fontWithName:@"youyuan" size:14];
    numLab.textColor = [UIColor darkGrayColor];
    [_bgView addSubview:numLab];

    UIImageView *codeImage = [[UIImageView alloc] initWithFrame:CGRectMake(35, headerImage.bottom+10, _bgView.width-70, _bgView.width-70)];
    codeImage.backgroundColor = [UIColor orangeColor];
    [_bgView addSubview:codeImage];

    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, codeImage.bottom+10, _bgView.width, 20)];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text = @"点击分享给你的朋友吧";
    lab.textColor = [UIColor grayColor];
    lab.font = [UIFont fontWithName:@"youyuan" size:13];
    [_bgView addSubview:lab];

    UIButton *shareBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    shareBtn.center = CGPointMake(_bgView.width/2, lab.bottom+20);
    shareBtn.bounds = CGRectMake(0, 0, 80, 30);
    [shareBtn setTitle:@"分享" forState:(UIControlStateNormal)];
    [shareBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    shareBtn.titleLabel.font = [UIFont fontWithName:@"youyuan" size:14];
    shareBtn.layer.cornerRadius = 3;
    shareBtn.layer.borderColor = [UIColor darkGrayColor].CGColor;
    shareBtn.layer.borderWidth = 0.5;
    
//    [shareBtn addTarget:self action:@selector(didClickShareBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [_bgView addSubview:shareBtn];
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
                     }];

}
@end
