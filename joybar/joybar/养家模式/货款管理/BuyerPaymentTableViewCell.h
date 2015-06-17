//
//  BuyerPaymentTableViewCell.h
//  joybar
//
//  Created by joybar on 15/6/10.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BuyerPaymentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *stateBtn;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *paymentPrice;
@property (weak, nonatomic) IBOutlet UILabel *paymentNo;
@property (weak, nonatomic) IBOutlet UILabel *paymentTime;

@end
