//
//  CusBueryTableViewCell.m
//  joybar
//
//  Created by joybar on 15/11/20.
//  Copyright © 2015年 卢兴. All rights reserved.
//

#import "CusBueryTableViewCell.h"

@implementation CusBueryTableViewCell

- (void)awakeFromNib {
    //商品
    CGFloat w= (kScreenWidth -30)/3;
    CGFloat h =w;

    self.shopBtn =[[UIImageView alloc]initWithFrame:CGRectMake(5, self.lineView.bottom+10 , w, h)];
    self.shopBtn.userInteractionEnabled =YES;
    self.shopBtn1 =[[UIImageView alloc]initWithFrame:CGRectMake(w +10, self.lineView.bottom+10 , w, h)];
    self.shopBtn1.userInteractionEnabled =YES;
    self.shopBtn2 =[[UIImageView alloc]initWithFrame:CGRectMake(2*w+15, self.lineView.bottom+10 , w, h)];
    self.shopBtn2.userInteractionEnabled=YES;
 
    
    [self.bgView addSubview:self.shopBtn];
    [self.bgView addSubview:self.shopBtn1];
    [self.bgView addSubview:self.shopBtn2];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
