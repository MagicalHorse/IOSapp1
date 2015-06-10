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

@property (nonatomic, strong, readonly) UIWindow *overlayWindow;
@property (nonatomic, strong, readonly) UIActivityIndicatorView *spinnerView;


- (void)showWithStatus:(NSString*)string networkIndicator:(BOOL)show;

- (void)dismiss;

@end


@implementation SVProgressHUD

@synthesize overlayWindow, spinnerView;

+ (SVProgressHUD*)sharedView {
    static dispatch_once_t once;
    static SVProgressHUD *sharedView;
    dispatch_once(&once, ^ {
        sharedView = [[SVProgressHUD alloc] init];
    });
    return sharedView;
}

#pragma mark - Show Methods
+ (void)show
{
    [[SVProgressHUD sharedView] showWithStatus:@"0" networkIndicator:NO];
}

+(void)show1
{
    [[SVProgressHUD sharedView] showWithStatus:@"1" networkIndicator:NO];

}

#pragma mark - Dismiss Methods

+ (void)dismiss {
	[[SVProgressHUD sharedView] dismiss];
}

#pragma mark - Master show/dismiss methods

- (void)showWithStatus:(NSString*)string  networkIndicator:(BOOL)show
{
    if ([string isEqualToString:@"0"]) {
        self.overlayWindow.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight-64-49);
    }
    else
    {
        self.overlayWindow.frame =CGRectMake(0, 64, kScreenWidth, kScreenHeight-64);
    }
    [self.overlayWindow addSubview:self];
    
    [self.spinnerView startAnimating];
    
    [self.overlayWindow makeKeyAndVisible];
    self.alpha = 1;
}


- (void)dismiss {
    
    self.alpha = 0;
    
    NSMutableArray *windows = [[NSMutableArray alloc] initWithArray:[UIApplication sharedApplication].windows];
    [windows removeObject:overlayWindow];
    overlayWindow = nil;
    
    [windows enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIWindow *window, NSUInteger idx, BOOL *stop) {
        if([window isKindOfClass:[UIWindow class]] && window.windowLevel == UIWindowLevelNormal) {
            [window makeKeyWindow];
            *stop = YES;
        }
    }];
}

#pragma mark - Utilities

#pragma mark - Getters
- (UIWindow *)overlayWindow
{
    if(!overlayWindow)
    {
        overlayWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64-49)];
        overlayWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        overlayWindow.backgroundColor = [UIColor whiteColor];
        overlayWindow.userInteractionEnabled = YES;
    }
    return overlayWindow;
}

- (UIActivityIndicatorView *)spinnerView
{
    if (spinnerView == nil)
    {
        spinnerView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		spinnerView.hidesWhenStopped = YES;
		spinnerView.bounds = CGRectMake(0, 0, 37, 37);
        spinnerView.center = CGPointMake(kScreenWidth/2, self.overlayWindow.height/2);
    }
    if(!spinnerView.superview)
        [self.overlayWindow addSubview:spinnerView];
    
    return spinnerView;
}


@end
