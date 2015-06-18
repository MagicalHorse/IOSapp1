//
//  CusOrderListTableViewCell.h
//  joybar
//
//  Created by 123 on 15/5/15.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderListItem.h"

@protocol orderListDelegate <NSObject>

-(void)orderListDelegate;

@end

@interface CusOrderListTableViewCell : UITableViewCell<UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UIButton *refundBtn;
@property (strong, nonatomic) IBOutlet UIButton *payBtn;
@property (strong, nonatomic) IBOutlet UILabel *nameLab;
@property (strong, nonatomic) IBOutlet UILabel *orderStatusLab;
@property (strong, nonatomic) IBOutlet UIImageView *proImageView;
@property (strong, nonatomic) IBOutlet UILabel *proNameLab;
@property (strong, nonatomic) IBOutlet UILabel *colorLab;
@property (strong, nonatomic) IBOutlet UILabel *sizeLab;
//x1
@property (strong, nonatomic) IBOutlet UILabel *numLab;
//共xx件商品
@property (strong, nonatomic) IBOutlet UILabel *proNumLab;
@property (strong, nonatomic) IBOutlet UILabel *priceLab;
@property (strong, nonatomic) IBOutlet UILabel *payPriceLab;
@property (strong, nonatomic) IBOutlet UILabel *locationLab;
@property (nonatomic ,assign) id<orderListDelegate> delegate;
@property (nonatomic ,strong) OrderListItem *orderListItem;

-(void)setData;

- (IBAction)didClickRefundBtn:(id)sender;
- (IBAction)didClickPayBtn:(id)sender;

@end
