//
//  BuyerOpenViewController.m
//  joybar
//
//  Created by joybar on 15/6/4.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "BuyerOpenViewController.h"

@interface BuyerOpenViewController ()

@end

@implementation BuyerOpenViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.hidesBottomBarWhenPushed = YES;
        
    }
    return self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavBarViewAndTitle:@"开小票"];
    self.retBtn.hidden =NO;
    self.view.backgroundColor = kCustomColor(241, 241, 241);
}


@end
