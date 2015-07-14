//
//  BannerViewController.m
//  joybar
//
//  Created by 123 on 15/7/13.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "BannerViewController.h"

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
    [self addNavBarViewAndTitle:@"推荐"];
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
