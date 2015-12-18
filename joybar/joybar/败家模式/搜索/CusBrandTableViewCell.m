//
//  CusBrandTableViewCell.m
//  joybar
//
//  Created by joybar on 15/11/20.
//  Copyright © 2015年 卢兴. All rights reserved.
//

#import "CusBrandTableViewCell.h"

@implementation CusBrandTableViewCell

- (void)awakeFromNib {
    self.iconView.contentMode=UIViewContentModeScaleAspectFill;
    self.iconView.clipsToBounds =YES;
    self.iconView.layer.masksToBounds =YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
