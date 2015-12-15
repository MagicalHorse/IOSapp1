//
//  BannerViewController.m
//  joybar
//
//  Created by 123 on 15/7/13.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "BannerViewController.h"
#import "CusZProDetailViewController.h"
#import "CusRProDetailViewController.h"
#import "CusMainStoreViewController.h"
#import "CusBrandDetailViewController.h"
#import "CusMarketViewController.h"
@interface BannerViewController ()

@end

@implementation BannerViewController

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
    // Do any additional setup after loading the view.
    [self addNavBarViewAndTitle:@"专题"];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64)];
    webView.scalesPageToFit = YES;
    NSURL *url =[NSURL URLWithString:self.link];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    webView.delegate =self;
    
    [self.view addSubview:webView];
    
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [self hudShow];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hiddleHud];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"%@",request.URL);
    
    NSString *url = [NSString stringWithFormat:@"%@",request.URL];
    NSArray *arr = [url componentsSeparatedByString:@"&"];
    
    if (arr.count<3)
    {
        
    }
    else
    {
        NSString *type = arr.firstObject;
        NSString *typeId = [[arr[1] componentsSeparatedByString:@"="] lastObject];
        NSString *key = [[arr[2] componentsSeparatedByString:@"="] lastObject];
        if ([type isEqualToString:@"app://type=product"])
        {
            NSString *userLevel = arr[3];

            //专柜买手商品
            if ([userLevel isEqualToString:@"userleave=4"])
            {
                CusZProDetailViewController *VC = [[CusZProDetailViewController alloc] init];
                VC.productId = typeId;
                [self.navigationController pushViewController:VC animated:YES];
            }
            //认证买手商品
            else if ([userLevel isEqualToString:@"userleave=8"])
            {
                CusRProDetailViewController *VC = [[CusRProDetailViewController alloc] init];
                VC.productId = typeId;
                [self.navigationController pushViewController:VC animated:YES];
            }
        }
        
        else if ([type isEqualToString:@"app://type=brand"])
        {
            CusBrandDetailViewController *VC = [[CusBrandDetailViewController alloc] init];
            VC.BrandId = typeId;
            VC.BrandName = key;
            [self.navigationController pushViewController:VC animated:YES];
        }
        else if ([type isEqualToString:@"app://type=buyer"])
        {
            CusMainStoreViewController *VC = [[CusMainStoreViewController alloc] init];
            VC.userId = typeId;
            VC.isCircle = NO;
            [self.navigationController pushViewController:VC animated:YES];
        }
        else if ([type isEqualToString:@"app://type=store"])
        {
            CusMarketViewController *VC = [[CusMarketViewController alloc] init];
            VC.storeId = typeId;
            [self.navigationController pushViewController:VC animated:YES];

        }
    }
    
    
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
