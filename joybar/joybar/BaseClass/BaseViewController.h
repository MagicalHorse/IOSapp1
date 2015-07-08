//
//  BaseViewController.h
//  Massage
//  控制器基类

//  Created by Sundy on 14-3-10.
//  Copyright (c) 2014年 Sundy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface BaseViewController : UIViewController<MBProgressHUDDelegate>{
    MBProgressHUD *HUD;
    MBProgressHUD *textHUD;
}

@property (strong, nonatomic) UIButton *retBtn;
@property (strong, nonatomic) UIView *noDataView;

//自定义navigationBar
@property (strong, nonatomic) UIView *navView;
@property (strong, nonatomic) UIView *lineView;

- (void)hudShow;
- (void)hudShow:(NSString *)content;
- (void)hiddleHud;
- (void)textHUDHiddle;
- (void)hudShowWithText:(NSString *)text;
- (void)showHudSuccess:(NSString *)tip;
- (void)showHudFailed:(NSString *)tip;
- (void)showHud:(NSString *)tip andImg:(NSString *)img;

- (void)storeUserData:(NSMutableDictionary *)store;
-(void) addNavBarViewAndTitle:(NSString *)title;
-(void)returnBtnClicked:(UIButton *)button;

#pragma mark - ASI
- (NSString *)getAsiErrorInfo:(id)error;
- (NSString *)getasiCompeleteError:(id)result;

- (void)showInView:(UIView *)view WithPoint:(CGPoint)point andHeight:(CGFloat)height;
- (void)activityDismiss;
@end
