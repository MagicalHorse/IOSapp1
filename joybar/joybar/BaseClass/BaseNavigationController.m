//
//  BaseNavigationController.m
//  Massage
//
//  Created by Sundy on 14-3-10.
//  Copyright (c) 2014年 Sundy. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)rightBtnClicked:(UIButton *)button
{
    [self popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavigationBarHidden:YES animated:NO];
    self.interactivePopGestureRecognizer.delegate = nil;

//    if (kCurrentFloatDevice <= 6)
//    {
//        self.navigationBar.tintColor = [UIColor colorWithRed:190/255.0 green:58.0/255.0 blue:48.0/255.0 alpha:1];
//    }
//    else
//    {
//        self.navigationBar.barTintColor = [UIColor colorWithRed:190/255.0 green:58.0/255.0 blue:48.0/255.0 alpha:1];
//    }
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
