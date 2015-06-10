//
//  BuyerSellTableViewCell.m
//  joybar
//
//  Created by liyu on 15/5/8.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "BuyerSellTableViewCell.h"

@implementation BuyerSellTableViewCell

- (void)awakeFromNib {
    if (kScreenWidth ==375)
    {
        self.firstConstraint.constant =100;
        self.threeConstraint.constant =-98;
        
    }else if(kScreenWidth ==414){
        self.firstConstraint.constant =105;
        self.threeConstraint.constant =-102;
    }
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
