//
//  CusHomeTableViewCell.m
//  joybar
//
//  Created by liyu on 15/5/6.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "BuyerHomeTableViewCell.h"

@implementation BuyerHomeTableViewCell

- (void)awakeFromNib {

    if (kScreenWidth == 320) {
        _lableXConstraint.constant -=35;
        _lableLConstraint.constant -=35;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
