//
//  BuyerFansTableViewCell.m
//  joybar
//
//  Created by joybar on 15/6/8.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "BuyerFansTableViewCell.h"

@implementation BuyerFansTableViewCell

- (void)awakeFromNib {
    
    self.fansIcon.layer.cornerRadius = self.fansIcon.width/2;
    self.fansIcon.clipsToBounds =YES;
    self.fansImg.layer.cornerRadius = self.fansImg.width/2;
    self.fansImg.clipsToBounds =YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
