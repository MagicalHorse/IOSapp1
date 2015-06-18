//
//  PayOrderViewController.h
//  joybar
//
//  Created by 123 on 15/6/11.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "BaseViewController.h"
#import "WXApi.h"
@interface PayOrderViewController : BaseViewController<WXApiDelegate>
- (IBAction)didClickWXPay:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *payCount;
@property (nonatomic ,strong) NSString *orderNum;
@property (nonatomic ,strong) NSString *proName;
@property (nonatomic ,strong) NSString *proPrice;

@end
