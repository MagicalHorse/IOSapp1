//
//  HJHeaderViewCell.m
//  joybar
//
//  Created by joybar on 15/11/28.
//  Copyright © 2015年 卢兴. All rights reserved.
//

#import "HJHeaderViewCell.h"

@implementation HJHeaderViewCell

- (void)awakeFromNib {
    
    _iconView.layer.cornerRadius = _iconView.width/2;
    _iconView.clipsToBounds  = YES;
}

@end
