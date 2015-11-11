//
//  CusTabBarViewController.m
//  joybar
//
//  Created by 卢兴 on 15/4/16.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "CusTabBarViewController.h"
@interface CusTabBarViewController ()

@end

@implementation CusTabBarViewController

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
    
    //初始化子视图
    [self _initWithControllers];
    //创建自定义TabBar
    [self _initTabBarViewController];
    self.tabBar.backgroundColor = [UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1.0f];
    [self connectionSoctet];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

//socket
-(void)connectionSoctet{
    
    NSString *tempName =[[Public getUserInfo]objectForKey:@"id"];
    NSString *urlStr;
    if (tempName)
    {
        urlStr = [NSString stringWithFormat:@"%@?userid=%@",SocketUrl,[[Public getUserInfo] objectForKey:@"id"]];
    }
    else
    {
        urlStr = [NSString stringWithFormat:@"%@?userid=%@",SocketUrl,@"0"];
    }
    if (tempName)
    {
        [SIOSocket socketWithHost:urlStr response:^(SIOSocket *socket) {
            [SocketManager socketManager].socket = socket;
            [socket on: @"connect" callback: ^(SIOParameterArray *args) {
                NSLog(@"connnection is success:%@",[args description]);
            }];
            
            [[SocketManager socketManager].socket emit:@"online" args:@[tempName]];
            [[SocketManager socketManager].socket on:@"room message" callback:^(NSArray *args) {
                
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:args.firstObject];
                NSString *toUserId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"toUserId"]];
                
                if (self.selectedIndex==1||self.selectedIndex ==2)
                {
                    self.circleMarkLab.hidden = YES;
                    self.msgMarkLab.hidden = YES;
                    
                    if ([toUserId isEqualToString:@"0"])
                    {
                        [self.fastView receiveMessage];
                    }
                    else
                    {
                        [self.messageView receiveMessage];
                    }
                }
                else
                {
                    if ([toUserId isEqualToString:@"0"])
                    {
                        self.circleMarkLab.hidden = NO;
                    }
                    else
                    {
                        self.msgMarkLab.hidden = NO;
                    }
                }
            }];
        }];
        
        [[SocketManager socketManager].socket on:@"disconnect" callback:^(NSArray *args) {
            NSLog(@"disconnect");
        }];
    }
}

-(void)_initWithControllers
{
    _homeView = [[CusHomeViewController alloc]init];
    _fastView = [[CusCircleViewController alloc]init];
    _messageView = [[CusMessageViewController alloc]init];
    _fineView = [[CusFindViewController alloc]init];
    _myAccountView = [[CusMineViewController alloc] init];
    self.homeNav = [[BaseNavigationController alloc]initWithRootViewController:_homeView];
    self.fastNav = [[BaseNavigationController alloc]initWithRootViewController:_fastView];
    self.cartNav = [[BaseNavigationController alloc]initWithRootViewController:_messageView];
    self.findNav = [[BaseNavigationController alloc]initWithRootViewController:_fineView];
    self.myAccountNav = [[BaseNavigationController alloc]initWithRootViewController:_myAccountView];
    
    NSArray *navs = [NSArray arrayWithObjects:self.homeNav,self.fastNav,self.cartNav,self.findNav,self.myAccountNav, nil];
    
    self.viewControllers = navs;
}

-(void)_initTabBarViewController
{
    //TabBarItem的title
    NSArray *title = @[@"",@"",@"",@"",@""];
    //TabBar上Button在Normal状态下的图片
    NSArray *tabBarImage = @[@"shouye1",@"quanzi1",@"xiaoxi1",@"faxian1",@"geren1"];
    //TabBar上Button在Selected状态下的图片
    NSArray *tabBarPress = @[@"shouye2",@"quanzi2",@"xiaoxi2",@"faxian2",@"geren2"];
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
        
        tabBtn.center = CGPointMake(32+(rect.size.width)*i, self.tabBar.frame.size.height/2);
        tabBtn.tag = i+100;
        
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
        
        if (i==1) {
            _circleMarkLab = [[UILabel alloc] initWithFrame:CGRectMake(tabBtn.width/2+10, 5, 8, 8)];
            _circleMarkLab.backgroundColor = [UIColor redColor];
            _circleMarkLab.layer.cornerRadius = _circleMarkLab.width/2;
            _circleMarkLab.clipsToBounds  = YES;
            _circleMarkLab.hidden = YES;
            [tabBtn addSubview:_circleMarkLab];
        }
        if (i==2) {
            _msgMarkLab = [[UILabel alloc] initWithFrame:CGRectMake(tabBtn.width/2+10, 5, 8, 8)];
            _msgMarkLab.backgroundColor = [UIColor redColor];
            _msgMarkLab.layer.cornerRadius = _msgMarkLab.width/2;
            _msgMarkLab.clipsToBounds  = YES;
            _msgMarkLab.hidden = YES;
            [tabBtn addSubview:_msgMarkLab];
        }
    }
    UIButton *homeBtn = (self.btnArray)[0];
    
    homeBtn.selected = YES;
    homeBtn.userInteractionEnabled = NO;
}

//按钮选中事件
- (void)SelectedTabBarIndex:(UIButton*)button
{
    if (button.tag-100==2||button.tag-100==4||button.tag-100==1)
    {
        NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
        if (!dic)
        {
            LoginAndRegisterViewController *VC = [[LoginAndRegisterViewController alloc] init];
            BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:VC];
            [self presentViewController:nav animated:YES completion:nil];
            return;
        }
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
    
    if (button.tag-100==1)
    {
        self.circleMarkLab.hidden = YES;
    }
    else if (button.tag-100==2)
    {
        self.msgMarkLab.hidden = YES;
    }
}

-(void)SelectedIndex:(NSUInteger)selectedIndex
{
    if ([self isKindOfClass:[UITabBarController class]])
    {
        [super setSelectedIndex:selectedIndex];
    }
    [self SelectedTabBarIndex:[self.btnArray objectAtIndex:selectedIndex]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)dealloc
{
    NSLog(@"aa");
}

@end
