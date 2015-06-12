//
//  PayOrderViewController.h
//  joybar
//
//  Created by 123 on 15/6/11.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "BaseViewController.h"

@interface PayOrderViewController : BaseViewController
- (IBAction)didClickWXPay:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *payCount;

@end
