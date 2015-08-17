//
//  BuyerTabBarViewController.m
//  joybar
//
//  Created by 卢兴 on 15/4/16.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "BuyerTabBarViewController.h"
#import "BuyerHomeViewController.h"
#import "BuyerTicketViewController.h"
#import "BuyerCircleViewController.h"
#import "BuyerOpenMessageViewController.h"
#import "BuyerStoreViewController.h"
#import "CusTabBarViewController.h"
#import "CusHomeViewController.h"
#import "CusCircleViewController.h"
#import "CusCartViewController.h"
#import "CusFindViewController.h"
#import "BuyerMineViewController.h"
#import "LoginAndRegisterViewController.h"
#import "CusMessageViewController.h"
#import "BuyerMessageViewController.h"
#import "BuyerMineViewController.h"
#import "BuyerCameraViewController.h"
#import "BuyerOpenViewController.h"
#import "CusMessageViewController.h"
@interface BuyerTabBarViewController ()<UIActionSheetDelegate>

@end

@implementation BuyerTabBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        self.hidesBottomBarWhenPushed =YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    // Do any additional setup after loading the view.
    //初始化子视图
    [self _initWithControllers];
    //创建自定义TabBar
    [self _initTabBarViewController];
    self.tabBar.backgroundColor = [UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1.0f];
    [[SocketManager socketManager].socket on:@"room message" callback:^(NSArray *args) {
        
//        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:args.firstObject];
//        NSString *toUserId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"toUserId"]];
        if (self.selectedIndex==3)
        {
            self.buyerMsgMark.hidden = YES;
        }
        else
        {
            self.buyerMsgMark.hidden = NO;
        }
        
    }];

}

-(void)_initWithControllers
{
    BuyerHomeViewController *homeView = [[BuyerHomeViewController alloc]init];
    BuyerTicketViewController *fastView = [[BuyerTicketViewController alloc]init];
    UIViewController *messageView = [[UIViewController alloc]init];
    CusMessageViewController *fineView = [[CusMessageViewController alloc]init];
    BuyerMineViewController *myAccountView = [[BuyerMineViewController alloc] init];
    self.buyerHomeNav = [[BaseNavigationController alloc]initWithRootViewController:homeView];
    self.buyerTicketNav = [[BaseNavigationController alloc]initWithRootViewController:fastView];
    self.buyerCircleNav = [[BaseNavigationController alloc]initWithRootViewController:messageView];
    self.buyerMesNav = [[BaseNavigationController alloc]initWithRootViewController:fineView];
    self.buyerStoreNav = [[BaseNavigationController alloc]initWithRootViewController:myAccountView];
    NSArray *navs = [NSArray arrayWithObjects:self.buyerHomeNav,self.buyerTicketNav,self.buyerCircleNav,self.buyerMesNav,self.buyerStoreNav, nil];
    
    self.viewControllers = navs;
}

-(void)_initTabBarViewController
{
    //TabBarItem的title
    NSArray *title = @[@"",@"",@"",@"",@""];
    //TabBar上Button在Normal状态下的图片
    NSArray *tabBarPress = @[@"shouye2",@"jiangli2",@"fabu点击",@"xiaoxi2",@"geren2"];
    //TabBar上Button在Selected状态下的图片
    NSArray * tabBarImage = @[@"shouye1",@"jiangli1",@"fabu常态",@"xiaoxi1",@"geren1"];
    self.btnArray = [NSMutableArray array];
    //创建TabBar上的Button和Label
    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.tabBar.frame.size.height)];
    bgImgView.userInteractionEnabled = YES;
    bgImgView.backgroundColor = [UIColor clearColor];
    [self.tabBar addSubview:bgImgView];
    for (int i = 0; i<[title count]; i++)
    {
        UIButton *tabBtn;
        tabBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        tabBtn.backgroundColor = [UIColor clearColor];
        //默认选中状态为NO
        tabBtn.selected = NO;
        //设置Button的frame
        CGRect rect;
        rect.origin.x = (kScreenWidth/[title count])*i;
        rect.origin.y = 0;
        rect.size.width = kScreenWidth/[title count];
        rect.size.height = self.tabBar.frame.size.height;
        tabBtn.frame = rect;
        
        tabBtn.center = CGPointMake(32+(rect.size.width)*i, self.tabBar.frame.size.height/2);        tabBtn.tag = i+100;
        
        tabBtn.frame = rect;
        tabBtn.titleLabel.font = [UIFont systemFontOfSize:10.0f];
        tabBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        //        tabBtn.userInteractionEnabled = YES;
        
        //设置图片
        [tabBtn setImage:[UIImage imageNamed:tabBarImage[i]]
                forState:UIControlStateNormal];
        [tabBtn setImage:[UIImage imageNamed:tabBarPress[i]] forState:UIControlStateHighlighted];
        [tabBtn setImage:[UIImage imageNamed:tabBarPress[i]]
                forState:UIControlStateSelected];
        //设置标题
        [tabBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        
        NSString *titleStr = title[i];
        [tabBtn setTitle:titleStr
                forState:UIControlStateNormal];
        [tabBtn setTitle:titleStr
                forState:UIControlStateSelected];
        [tabBtn setAdjustsImageWhenDisabled:NO];
        [tabBtn setAdjustsImageWhenHighlighted:NO];
        //设置触发事件
        [tabBtn addTarget:self
                   action:@selector(SelectedTabBarIndex:)
         forControlEvents:UIControlEventTouchUpInside];
        //将btn添加到数组
        [self.btnArray addObject:tabBtn];
        [bgImgView addSubview:tabBtn];
        if (i==3)
        {
            _buyerMsgMark = [[UILabel alloc] initWithFrame:CGRectMake(tabBtn.width/2+10, 5, 8, 8)];
            _buyerMsgMark.backgroundColor = [UIColor redColor];
            _buyerMsgMark.layer.cornerRadius = _buyerMsgMark.width/2;
            _buyerMsgMark.clipsToBounds  = YES;
            _buyerMsgMark.hidden = YES;
            [tabBtn addSubview:_buyerMsgMark];

        }
    }
    UIButton *homeBtn = (self.btnArray)[0];
    
    homeBtn.selected = YES;
    homeBtn.userInteractionEnabled = NO;
}

//按钮选中事件
- (void)SelectedTabBarIndex:(UIButton*)button
{
        if (button.tag-100==2)
        {
            
            
            UIActionSheet *action= [[UIActionSheet alloc] initWithTitle:nil
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                 destructiveButtonTitle:nil
                                                      otherButtonTitles:@"开小票", @"发布商品", nil];
            // Show the sheet
            [action showInView:self.view];
            return;
            
        }
    else if (button.tag-100==3)
    {
         self.buyerMsgMark.hidden = YES;
    }
    
    self.selectedIndex = button.tag-100;
    [self.btnArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         UIButton *btn = (UIButton *)obj;
         
         if (idx == self.selectedIndex)
         {
             btn.selected = YES;
             btn.userInteractionEnabled = NO;
         }
         else
         {
             btn.selected = NO;
             btn.userInteractionEnabled = YES;
         }
     }];
}

-(void)SelectedIndex:(NSUInteger)selectedIndex
{
    if ([self isKindOfClass:[UITabBarController class]])
    {
        [super setSelectedIndex:selectedIndex];
    }
    [self SelectedTabBarIndex:[self.btnArray objectAtIndex:selectedIndex]];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex ==0) {
        BuyerOpenViewController * open =[[BuyerOpenViewController alloc]init];
         BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:open];
        [self presentViewController:nav animated:YES completion:nil];
        
    }else if(buttonIndex ==1){
        [Common saveUserDefault:@"1" keyName:@"backPhone"];
        BuyerCameraViewController *VC = [[BuyerCameraViewController alloc] init];
        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:VC];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

-(void)dealloc
{
    NSLog(@"aaa");
}
@end
