//
//  CusRefundPriceVipController.m
//  joybar
//
//  Created by joybar on 15/12/29.
//  Copyright © 2015年 卢兴. All rights reserved.
//

#import "CusRefundPriceVipController.h"

@interface CusRefundPriceVipController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *nameAddress;
@property (weak, nonatomic) IBOutlet UILabel *namePhone;
@property (weak, nonatomic) IBOutlet UILabel *nameMe;
@property (weak, nonatomic) IBOutlet UILabel *nameNo;
@property (weak, nonatomic) IBOutlet UITextView *detailsText;

@end

@implementation CusRefundPriceVipController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavBarViewAndTitle:@"申请退款"];
    self.view.backgroundColor = kCOLOR(246);
    [self getData];
}

-(void)getData
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.orderNo forKey:@"orderNo"];
    [HttpTool postWithURL:@"V3/GetOrderStoreRmaInfo" params:dic success:^(id json) {
        
        if ([[json objectForKey:@"isSuccessful"] boolValue])
        {
            NSDictionary *dict = [json objectForKey:@"data"];
            self.nameLab.text = [dict objectForKey:@"StoreName"];
            self.nameAddress.text = [dict objectForKey:@"RmaAddress"];
            self.namePhone.text = [dict objectForKey:@"StoreMobile"];
            self.nameMe.text = [dict objectForKey:@"RmaPerson"];
            self.nameNo.text = self.orderNo;
            self.detailsText.text = [[dict objectForKey:@"RmaTips"] firstObject];
        }
        
    } failure:^(NSError *error) {
        
    }];
}


@end
