//
//  BuyerStoreTableViewCell.m
//  joybar
//
//  Created by liyu on 15/5/8.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "BuyerStoreTableViewCell.h"

@implementation BuyerStoreTableViewCell

- (void)awakeFromNib {
    UIView * view= [[UIView alloc]initWithFrame:CGRectMake(15, 100, kScreenWidth-30, 1)];
    view.backgroundColor = kCustomColor(240, 240, 240);
    [self addSubview:view];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
