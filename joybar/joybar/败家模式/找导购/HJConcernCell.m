//
//  HJConcernCell.m
//  joybar
//
//  Created by joybar on 15/11/28.
//  Copyright © 2015年 卢兴. All rights reserved.
//

#import "HJConcernCell.h"

@implementation HJConcernCell

- (void)awakeFromNib {


    [[self.bgView layer]setCornerRadius:8];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.iconView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.iconView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.iconView.layer.mask = maskLayer;
    
}

@end
