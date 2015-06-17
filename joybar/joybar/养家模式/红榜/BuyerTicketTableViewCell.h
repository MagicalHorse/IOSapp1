//
//  BuyerTicketTableViewCell.h
//  joybar
//
//  Created by liyu on 15/5/6.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BuyerTicketTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ticketIcon;
@property (weak, nonatomic) IBOutlet UILabel *ticketTitle;
@property (weak, nonatomic) IBOutlet UILabel *ticketCount;

@end
