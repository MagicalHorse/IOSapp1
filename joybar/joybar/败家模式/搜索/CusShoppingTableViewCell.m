//
//  CusShoppingTableViewCell.m
//  joybar
//
//  Created by joybar on 15/11/20.
//  Copyright © 2015年 卢兴. All rights reserved.
//

#import "CusShoppingTableViewCell.h"

@implementation CusShoppingTableViewCell

- (void)awakeFromNib {
    self.shopIconView.contentMode=UIViewContentModeScaleAspectFill;
    self.shopIconView.clipsToBounds =YES;
    self.shopIconView.layer.masksToBounds =YES;}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
