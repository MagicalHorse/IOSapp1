//
//  BaseTabBarController.m
//  SwanVip
//
//  Created by Sundy on 13-12-10.
//  Copyright (c) 2013年 Sundy. All rights reserved.
//

#import "BaseTabBarController.h"

@interface BaseTabBarController ()

@end

@implementation BaseTabBarController

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
    
    //删除背景
    [self deleteBgImage];
}

////删除背景
- (void)deleteBgImage
{
    self.tabBar.backgroundImage = [UIImage imageNamed:@"tabBackImage.png"];
//    self.tabBar.selectedImageTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:tabSelectedImage]];
//    [[self tabBar]setSelectionIndicatorImage:[UIImage imageNamed:tabSelectedImage]];
    for (UIView *view in self.view.subviews)
    {
        if ([view isKindOfClass:NSClassFromString(@"UITabBarBackgroundView")])
        {
            [view removeFromSuperview];
            
            break;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
