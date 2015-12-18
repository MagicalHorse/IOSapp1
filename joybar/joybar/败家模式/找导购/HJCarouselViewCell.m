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

    self.ShopView.clipsToBounds =YES;
    self.ShopView.layer.cornerRadius =self.ShopView.width/2;
    self.guanzhuView.layer.cornerRadius =3;
    self.ShopView.userInteractionEnabled =YES;
    
    self.ShopView.contentMode=UIViewContentModeScaleAspectFill;
    self.ShopView.clipsToBounds =YES;
    self.ShopView.layer.masksToBounds =YES;

    
}

@end
