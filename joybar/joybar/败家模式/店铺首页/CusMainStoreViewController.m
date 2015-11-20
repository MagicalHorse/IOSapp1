//
//  CusMainStoreViewController.m
//  joybar
//
//  Created by 123 on 15/11/20.
//  Copyright © 2015年 卢兴. All rights reserved.
//

#import "CusMainStoreViewController.h"
#import "CusHomeStoreViewController.h"
@interface CusMainStoreViewController ()<UIScrollViewDelegate>

@property (nonatomic ,strong) UIScrollView *scrollView;

@end

@implementation CusMainStoreViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addNavBarViewAndTitle:@""];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64)];
    self.scrollView.delegate =self;
    self.scrollView.contentSize = CGSizeMake(kScreenWidth*2, 0);
    [self.view addSubview:self.scrollView];
    
    NSArray *title = @[@"店铺",@"圈子"];
    for (int i=0; i<2; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(60+i*(kScreenWidth/2-60), 20, (kScreenWidth/2-60), 40);
        [button setTitle:title[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
//        button.backgroundColor = [UIColor redColor];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        button.tag = i + 100;
        [button addTarget:self action:@selector(didClickHeadButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.navView addSubview:button];

        
    }
    
    CusHomeStoreViewController *homeStoreVC = [[CusHomeStoreViewController alloc] init];
    homeStoreVC.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [self addChildViewController:homeStoreVC];
    
    [self.view addSubview:homeStoreVC.view];
    
    homeStoreVC.userId = @"838";

    
}

@end
