//
//  BueryDetailsTableViewCell.m
//  joybar
//
//  Created by joybar on 15/5/28.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "BueryDetailsTableViewCell.h"

@implementation BueryDetailsTableViewCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)telUser {
    
    UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"顾客电话" message: self.userPhone.text delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex ==1) {
        NSString *phone =[NSString stringWithFormat:@"tel://%@",self.userPhone.text];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
    }
}



@end
