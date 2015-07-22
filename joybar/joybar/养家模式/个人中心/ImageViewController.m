//
//  ImageViewController.m
//  LLSimpleCameraExample
//
//  Created by Ömer Faruk Gül on 15/11/14.
//  Copyright (c) 2014 Ömer Faruk Gül. All rights reserved.
//

#import "ImageViewController.h"
#import "ViewUtils.h"
#import "UIImage+Crop.h"
#import "BuyerFilterViewController.h"

@interface ImageViewController ()<BuyerFilterDelgeate>
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *infoLabel;
@property (strong, nonatomic) UIButton *cancelButton;

@end

@implementation ImageViewController

- (instancetype)initWithImage:(UIImage *)image {
    self = [super initWithNibName:nil bundle:nil];
    if(self) {
        self.image = image;
    }
    return self;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor blackColor];
    
    self.imageView = [[UIImageView alloc] init];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.image =self.image;
    self.imageView.frame =CGRectMake(0, 64, kScreenWidth, kScreenWidth);
    [self.view addSubview:self.imageView];
    CGFloat btnY =  (kScreenWidth+64 +70);

    UIButton * btn=[[UIButton alloc]initWithFrame:CGRectMake(10, btnY, 70, 70)];
    [btn setTitle:@"重拍" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:btn];
    
     UIButton *btn1= [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-90, btnY, 80, 70)];
    [btn1 setTitle:@"使用照片" forState:UIControlStateNormal];
    btn1.titleLabel.font = [UIFont systemFontOfSize:18];
    [btn1 addTarget:self action:@selector(btn1Click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)btnClick{
    
    [self.delegate dismissCamrea:nil andDataArray:nil];
}

- (void)btn1Click
{
    NSString * ctype =[Common getUserDefaultKeyName:@"backPhone"];
     //如果选择，关闭相机。传代理，不选择，跳到下一个
    if ([ctype isEqualToString:@"1"]||[ctype isEqualToString:@"3"] ) {
        BuyerFilterViewController *issue=[[BuyerFilterViewController alloc]initWithImg:self.image];
        issue.delegate =self;
        [self.navigationController pushViewController:issue animated:YES];
    }else{
        
        [self dismissViewControllerAnimated:NO completion:nil];
        if ([self.delegate respondsToSelector:@selector(dismissCamrea:andDataArray:)]) {
            [self.delegate dismissCamrea:self.image andDataArray:nil];
        }
    }
}

-(void)choose:(UIImage *)image andImgs:(NSMutableDictionary *)array
{
    NSString *back =[Common getUserDefaultKeyName:@"backPhone"];
    if (![back isEqualToString:@"1"]) {
        [self dismissViewControllerAnimated:NO completion:nil];
        if ([self.delegate respondsToSelector:@selector(dismissCamrea:andDataArray:)]) {
            [self.delegate dismissCamrea:image andDataArray:array];
        }
    }
}


@end
