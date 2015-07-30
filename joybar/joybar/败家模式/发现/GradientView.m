//
//  GradientView.m
//  joybar
//
//  Created by 123 on 15/7/30.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "GradientView.h"
#import <QuartzCore/QuartzCore.h>
@implementation GradientView


- (void)drawRect:(CGRect)rect {
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = rect;
    UIColor *upColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1];
    UIColor *downColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1];
    gradient.colors = [NSArray arrayWithObjects:(id)upColor.CGColor,
                       (id)downColor.CGColor,nil];
    [self.layer insertSublayer:gradient atIndex:0];
}


@end
