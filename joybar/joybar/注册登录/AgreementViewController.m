//
//  AgreementViewController.m
//  joybar
//
//  Created by 123 on 15/8/20.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "AgreementViewController.h"

@interface AgreementViewController ()

@end

@implementation AgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavBarViewAndTitle:@"用户协议"];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight)];
    NSURL *url =[NSURL URLWithString:@"http://r.joybar.com.cn/agreement.html"];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    [self.view addSubview:webView];
}
@end
