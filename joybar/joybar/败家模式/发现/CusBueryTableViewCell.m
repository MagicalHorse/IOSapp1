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
    for (int i=0; i<3; i++)
    {
        CGFloat w= (kScreenWidth -30)/3;
        CGFloat y =w;
        UIImageView *proImage = [[UIImageView alloc] initWithFrame:CGRectMake( w*i+(i+1)*5, self.lineView.bottom+10, w, y)];
        proImage.backgroundColor = [UIColor orangeColor];
        [self.bgView addSubview:proImage];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
