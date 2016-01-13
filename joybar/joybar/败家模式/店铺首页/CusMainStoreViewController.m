//
//  CusMainStoreViewController.m
//  joybar
//
//  Created by 123 on 15/11/20.
//  Copyright © 2015年 卢兴. All rights reserved.
//

#import "CusMainStoreViewController.h"
#import "CusHomeStoreViewController.h"
#import "CircleViewController.h"
@interface CusMainStoreViewController ()<UIScrollViewDelegate>

@property (nonatomic ,strong) UIScrollView *scrollView;
@property (nonatomic ,strong) UIViewController *currentVC;
@property (nonatomic ,strong) CusHomeStoreViewController *homeStoreVC;
@property (nonatomic ,strong) CircleViewController *buyerCircleVC;
@property (nonatomic ,strong) NSMutableArray *btnArr;
@property (nonatomic ,strong) UIView *line;
@end

@implementation CusMainStoreViewController


-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self =[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

-(void)loadView
{
    [super loadView];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64)];
//    self.scrollView.alwaysBounceVertical = NO;
//    self.scrollView.alwaysBounceHorizontal = YES;
//    self.scrollView.pagingEnabled = YES;
//    self.scrollView.showsHorizontalScrollIndicator = NO;
//    self.scrollView.bounces = NO;
    self.scrollView.scrollEnabled = NO;
    self.scrollView.contentSize = CGSizeMake(kScreenWidth*2, 0);
    [self.view addSubview:self.scrollView];
    
    _homeStoreVC = [[CusHomeStoreViewController alloc] init];
    _homeStoreVC.userId = self.userId;
    _homeStoreVC.userName = self.userName;
    _homeStoreVC.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [self addChildViewController:_homeStoreVC];
    
    _buyerCircleVC = [[CircleViewController alloc] initWithUserId:self.userId AndTpye:1 andUserName:self.userName];
    _buyerCircleVC.userId = self.userId;
    _buyerCircleVC.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64);
    
    [self.scrollView addSubview:_homeStoreVC.view];
    self.currentVC = _homeStoreVC;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addNavBarViewAndTitle:@""];

    self.btnArr = [[NSMutableArray alloc] init];
    _line = [[UIView alloc] init];
    _line.backgroundColor = [UIColor orangeColor];
    [self.navView addSubview:_line];

    NSArray *title = @[@"店铺",@"圈子"];
    for (int i=0; i<2; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(60+i*(kScreenWidth/2-60), 20, (kScreenWidth/2-60), 40);
        [button setTitle:title[i] forState:UIControlStateNormal];
        if (i==0)
        {
            [button setTitleColor:[UIColor orangeColor] forState:(UIControlStateNormal)];
        }
        else
        {
            [button setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        }
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        button.tag = i + 100;
        [button addTarget:self action:@selector(didClickHeadButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.navView addSubview:button];
        [self.btnArr addObject:button];
        if (!self.isCircle)
        {
            if (i==0)
            {
                [self didClickHeadButtonAction:button];
            }
            _line.center = CGPointMake((kScreenWidth/2-60)/2+60, 63);
            _line.bounds = CGRectMake(0, 0, 60, 2);
        }
        else
        {
            if (i==1)
            {
                [self didClickHeadButtonAction:button];
            }
            _line.center = CGPointMake(60+(kScreenWidth/2-60)*3/2, 63);
            _line.bounds = CGRectMake(0, 0, 60, 2);
        }
    }
}

- (void)didClickHeadButtonAction:(UIButton *)button
{
    for (UIButton *selectBtn in self.btnArr)
    {
        if ([selectBtn isEqual:button])
        {
            [selectBtn setTitleColor:[UIColor orangeColor] forState:(UIControlStateNormal)];
        }
        else
        {
            [selectBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        }
    }
    
    //  点击处于当前页面的按钮,直接跳出
    if ((self.currentVC == self.homeStoreVC && button.tag == 100)||(self.currentVC == self.buyerCircleVC && button.tag == 101.)) {
        return;
    }else{
        
        //  展示2个,其余一样,自行补全噢
        switch (button.tag) {
            case 100:
                [self replaceController:self.currentVC newController:_homeStoreVC];
                _line.center = CGPointMake(button.center.x, 63);
                break;
            case 101:
                
                if (!TOKEN)
                {
                    [Public showLoginVC:self];
                    return;
                }
                else
                {
                    [self replaceController:self.currentVC newController:_buyerCircleVC];
                    _line.center = CGPointMake(button.center.x, 63);
                }
                break;
        }
    }
}

//  切换各个标签内容
- (void)replaceController:(UIViewController *)oldController newController:(UIViewController *)newController
{
    /**
     *            着重介绍一下它
     *  transitionFromViewController:toViewController:duration:options:animations:completion:
     *  fromViewController      当前显示在父视图控制器中的子视图控制器
     *  toViewController        将要显示的姿势图控制器
     *  duration                动画时间(这个属性,old friend 了 O(∩_∩)O)
     *  options                 动画效果(渐变,从下往上等等,具体查看API)
     *  animations              转换过程中得动画
     *  completion              转换完成
     */
    
    [self addChildViewController:newController];
    [self transitionFromViewController:oldController toViewController:newController duration:0 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
        
        if (finished) {
            
            [newController didMoveToParentViewController:self];
            [oldController willMoveToParentViewController:nil];
            [oldController removeFromParentViewController];
            self.currentVC = newController;
            
        }else{
            self.currentVC = oldController;
        }
    }];
}


@end
