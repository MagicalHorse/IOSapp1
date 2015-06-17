//
//  BaseViewController.m
//  Massage
//
//  Created by Sundy on 14-3-10.
//  Copyright (c) 2014年 Sundy. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseNavigationController.h"
#import "AppDelegate.h"
@interface BaseViewController ()

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self changeThemeNav];

    //设置视图是否延伸到StatusBar的后面
    if (kCurrentFloatDevice >= 7.0)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        //刷新状态栏样式
        [self setNeedsStatusBarAppearanceUpdate];
    }    
    self.view.backgroundColor = [UIColor whiteColor];
//    [self addNavBarViewAndTitle:@"adasd"];
//    [self initNoDataView];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

}

-(void)initNoDataView
{
    self.noDataView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.noDataView.backgroundColor = [UIColor clearColor];
    self.noDataView.hidden = YES;
    [self.view addSubview:self.noDataView];
    
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"暂无数据";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:17.0f];
    label.center = CGPointMake(self.noDataView.center.x, self.noDataView.center.y-50);
    label.bounds = CGRectMake(0, 0, kScreenWidth, 20);
    [self.noDataView addSubview:label];
}

-(void)returnBtnClicked:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)addNavBarViewAndTitle:(NSString *)title
{
    //navigationBar
    
    self.navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    self.navView.backgroundColor = [UIColor whiteColor];
//    self.navView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
//    self.navView.layer.shadowRadius = 5;
//    self.navView.layer.shadowOffset = CGSizeMake(1, 1);
//    self.navView.layer.shadowOpacity = 0.5;
    self.navView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.navView.layer.borderWidth = 0.5;
    [self.view addSubview:self.navView];
//    }
    //title
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.center = CGPointMake(self.navView.center.x, self.navView.center.y+10);
    titleLab.bounds = CGRectMake(0, 0, kScreenWidth/3, 44);
    titleLab.text = title;
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.textColor = [UIColor blackColor];
    titleLab.font =[UIFont fontWithName:@"youyuan" size:17];
    titleLab.shadowOffset = CGSizeMake(0, 1);
    [self.navView addSubview:titleLab];
    
    //返回按钮
    self.retBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.retBtn.frame = CGRectMake(13, 25, 50, 40);
    self.retBtn.backgroundColor = [UIColor clearColor];
    
    [self.retBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    self.retBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.retBtn addTarget:self action:@selector(returnBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:self.retBtn];
    
    UIImageView *retImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 59/7, 110/7)];
    retImage.image = [UIImage imageNamed:@"back.png"];
    [self.retBtn addSubview:retImage];
}

/*

-(void)creatNavigationItemBtnWithTitle:(NSString *)title target:(id)target action:(SEL)action position:(NSInteger)position font:(UIFont *)font width:(NSInteger)inter
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = font;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.bounds = CGRectMake(0, 0, inter, 40);
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    if (position == 1) {
        self.navigationItem.leftBarButtonItem = item;
    }else{
        self.navigationItem.rightBarButtonItem = item;
    }
}

#pragma mark -
#pragma mark - 修改导航主题
- (void)changeThemeNav
{
    //修改导航栏的标题颜色
    [[UINavigationBar appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f]}];

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor greenColor];
    shadow.shadowOffset = CGSizeMake(20, 40);
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor whiteColor], NSForegroundColorAttributeName,
                                                           shadow, NSShadowAttributeName,
                                                           [UIFont boldSystemFontOfSize:18.0f], NSFontAttributeName, nil]];
//    给导航栏的返回按钮着色
//    colorWithHexString:@"006699"
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];

}

#pragma mark -
#pragma mark - IOS7适配   状态栏文字修改为白色
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark -  HUD
- (void)hudShow
{
    if(HUD == nil)
    {
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        HUD.alpha = 0.4;
        [self.view addSubview:HUD];
        HUD.delegate = self;
        HUD.labelText = @"加载中...";
    }
	[HUD show:YES];
}

- (void)hudShow:(NSString *)content
{
    if(textHUD == nil)
    {
        textHUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:textHUD];
        textHUD.delegate = self;
        textHUD.labelText = content;
    }
	[textHUD show:YES];
}

- (void)hiddleHud
{
    [HUD removeFromSuperview];
    HUD = nil;
}

- (void)textHUDHiddle
{
    [textHUD removeFromSuperview];
    
    textHUD = nil;
}

- (void)hudShowWithText:(NSString *)text
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
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
    MBProgressHUD *t_HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:t_HUD];
    t_HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:img]];
    t_HUD.mode = MBProgressHUDModeCustomView;
    t_HUD.labelText = tip;
    t_HUD.removeFromSuperViewOnHide = YES;
    [t_HUD show:YES];
    [t_HUD hide:YES afterDelay:1.0];
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods
- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    HUD = nil;
}

#pragma mark - UserData
- (void)storeUserData:(NSMutableDictionary *)store
{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userInfo"];
    [[NSUserDefaults standardUserDefaults]setObject:store forKey:@"userInfo"];
}

- (void)storeUserNameAndPassword:(NSMutableDictionary *)dic
{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"loginInfo"];
    [[NSUserDefaults standardUserDefaults]setObject:dic forKey:@"loginInfo"];
}

- (NSDictionary *)getLoginInfo
{
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:@"loginInfo"];
    return dic;
}

- (NSMutableDictionary *)getInfoDic
{
    NSMutableDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
    
    return dic;
}

#pragma mark - ASI
- (NSString *)getAsiErrorInfo:(id)error
{
    return @"网络似乎有问题,请检查网络";
}

- (NSString *)getasiCompeleteError:(id)result
{
    NSString *str = [[result valueForKey:@"query"] valueForKey:@"reason"];
    
    return str;
}
@end
