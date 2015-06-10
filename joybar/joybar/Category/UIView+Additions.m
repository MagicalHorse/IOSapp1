//
//  UIView+Additions.m
//  WXWeibo
//
//  Created by Sundy on 13-12-7.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "UIView+Additions.h"

@implementation UIView (Additions)

- (UIViewController *)viewController
{
    UIResponder *responser = [self nextResponder];
    do {
        if ([responser isKindOfClass:[UIViewController class]])
        {
            return (UIViewController *)responser;
        }
        responser = [responser nextResponder];
    }
    while (responser != nil);
    return nil;
}

#pragma mark -
#pragma mark -  HUD
- (void)hudShow {
    MBProgressHUD *HUD;
    if(HUD == nil){
        HUD = [[MBProgressHUD alloc] initWithView:self];
        HUD.tag = 20;
        [self addSubview:HUD];
        HUD.delegate = self;
        HUD.labelText = @"加载中..";
    }
    [HUD show:YES];
}

- (void)hudShow:(NSString *)content {
    MBProgressHUD *textHUD;
    if(textHUD == nil){
        textHUD = [[MBProgressHUD alloc] initWithView:self];
        textHUD.tag = 10;
        [self addSubview:textHUD];
        textHUD.delegate = self;
        textHUD.labelText = content;
    }
    [textHUD show:YES];
}


- (void)hiddleHud
{
    MBProgressHUD *hud = (MBProgressHUD *)[self viewWithTag:20];
    [hud removeFromSuperview];
    hud = nil;
}

- (void)textHUDHiddle
{
    MBProgressHUD *textHUD = (MBProgressHUD *)[self viewWithTag:10];
    [textHUD removeFromSuperview];
    textHUD = nil;
}

- (void)hudShowWithText:(NSString *)text
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    hud.margin = 10.f;
    hud.yOffset = kScreenHeight/2-100;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:0.8];
}

- (void)showHudSuccess:(NSString *)tip
{
    [self showHud:tip andImg:@"TipViewIcon.png"];
}

- (void)showHudFailed:(NSString *)tip {
    [self showHud:tip andImg:@"TipViewErrorIcon.png"];
}

- (void)showHud:(NSString *)tip andImg:(NSString *)img
{
    MBProgressHUD *t_HUD = [[MBProgressHUD alloc] initWithView:self];
    [self addSubview:t_HUD];
    t_HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:img]];
    t_HUD.mode = MBProgressHUDModeCustomView;
    t_HUD.labelText = tip;
    t_HUD.removeFromSuperViewOnHide = YES;
    [t_HUD show:YES];
    [t_HUD hide:YES afterDelay:1.0];
}


@end
