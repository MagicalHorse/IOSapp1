//
//  HJCarouselViewCell.m
//  HJCarouselDemo
//
//  Created by haijiao on 15/8/20.
//  Copyright (c) 2015年 olinone. All rights reserved.
//

#import "HJCarouselViewCell.h"

@implementation HJCarouselViewCell

- (void)awakeFromNib {

    [[self.guanzhuView layer]setCornerRadius:5];    
    self.ShopView.clipsToBounds =YES;
    self.ShopView.layer.cornerRadius =self.ShopView.width/2;
    
}

@end
