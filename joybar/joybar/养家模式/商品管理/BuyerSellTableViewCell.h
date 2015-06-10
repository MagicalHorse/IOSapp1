//
//  BuyerSellTableViewCell.h
//  joybar
//
//  Created by liyu on 15/5/8.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BuyerSellTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *threeConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *StoreImgView;
@property (weak, nonatomic) IBOutlet UILabel *StoreName;

@property (weak, nonatomic) IBOutlet UILabel *StoreDetails;
@property (weak, nonatomic) IBOutlet UILabel *StoreNo;

@property (weak, nonatomic) IBOutlet UILabel *StoreTime;
@property (weak, nonatomic) IBOutlet UILabel *StorePirce;

@property (weak, nonatomic) IBOutlet UIButton *downBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *sbBtn;
@property (weak, nonatomic) IBOutlet UIButton *cyBtn;

@end
