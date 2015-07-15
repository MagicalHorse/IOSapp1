//
//  BueryDetailsTableViewCell.h
//  joybar
//
//  Created by joybar on 15/5/28.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface BueryDetailsTableViewCell : UITableViewCell <UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *orderNO;
@property (weak, nonatomic) IBOutlet UILabel *orderState;
@property (weak, nonatomic) IBOutlet UILabel *orderPrice;
@property (weak, nonatomic) IBOutlet UILabel *ordertoPrice;
@property (weak, nonatomic) IBOutlet UILabel *orderTime;
@property (weak, nonatomic) IBOutlet UILabel *userNO;
@property (weak, nonatomic) IBOutlet UIImageView *userPic;
@property (weak, nonatomic) IBOutlet UILabel *userPhone;
@property (weak, nonatomic) IBOutlet UILabel *userAddress;
- (IBAction)telUser;

@end
