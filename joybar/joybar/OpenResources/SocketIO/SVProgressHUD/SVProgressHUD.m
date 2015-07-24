//
//  SVProgressHUD.m
//
//  Created by Sam Vermette on 27.03.11.
//  Copyright 2011 Sam Vermette. All rights reserved.
//
//  https://github.com/samvermette/SVProgressHUD
//

#import "SVProgressHUD.h"
#import <QuartzCore/QuartzCore.h>

@interface SVProgressHUD ()

//@property (nonatomic, readwrite) SVProgressHUDMaskType maskType;

@property (nonatomic, strong, readonly) UIActivityIndicatorView *spinnerView;
@property (nonatomic ,strong) UIView *hudBgView;

@end


@implementation SVProgressHUD

@synthesize  hudBgView,spinnerView;

+ (SVProgressHUD*)sharedView {
    static dispatch_once_t once;
    static SVProgressHUD *sharedView;
    dispatch_once(&once, ^ {
        sharedView = [[SVProgressHUD alloc] init];
    });
    return sharedView;
}
#pragma mark - Show Methods
+ (void)showInView:(UIView *)view WithPoint:(CGPoint)point andHeight:(CGFloat)height
{
    [[SVProgressHUD sharedView] showWithStatus:view WithPoint:point andHeight:height];
}

#pragma mark - Dismiss Methods

+ (void)dismiss
{
    [[SVProgressHUD sharedView].hudBgView removeFromSuperview];
    [[SVProgressHUD sharedView].spinnerView removeFromSuperview];
}

#pragma mark - Master show/dismiss methods

- (void)showWithStatus:(UIView *)view WithPoint:(CGPoint)point andHeight:(CGFloat)height
{
    hudBgView = [[UIView alloc] init];
    hudBgView.frame = CGRectMake(point.x, point.y, kScreenWidth, height);
    hudBgView.backgroundColor = [UIColor whiteColor];
    [view addSubview:hudBgView];
    
    spinnerView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinnerView.hidesWhenStopped = YES;
    spinnerView.bounds = CGRectMake(0, 0, 37, 37);
    spinnerView.center = CGPointMake(view.width/2, self.hudBgView.height/2);
    [hudBgView addSubview:spinnerView];
    [spinnerView startAnimating];
}

@end
