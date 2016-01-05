//
//  RefundTableViewCell2.m
//  joybar
//
//  Created by 123 on 15/12/31.
//  Copyright © 2015年 卢兴. All rights reserved.
//

#import "RefundTableViewCell2.h"

@implementation RefundTableViewCell2

- (void)awakeFromNib {
        self.refundTextView.layer.borderColor = [UIColor grayColor].CGColor;
        self.refundTextView.layer.borderWidth = 0.5;
        self.refundTextView.layer.cornerRadius = 3;
}

@end
