//
//  UIView+Additions.h
//  WXWeibo
//  获取UIView的下一个响应链

//  Created by Sundy on 13-12-7.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface UIView (Additions)



//下一个响应链
- (UIViewController *)viewController;


- (void)hudShow;
- (void)hudShow:(NSString *)content;
- (void)hiddleHud;
- (void)textHUDHiddle;
- (void)hudShowWithText:(NSString *)text;

- (void)showHudSuccess:(NSString *)tip;
- (void)showHudFailed:(NSString *)tip;
- (void)showHud:(NSString *)tip andImg:(NSString *)img;

@end
