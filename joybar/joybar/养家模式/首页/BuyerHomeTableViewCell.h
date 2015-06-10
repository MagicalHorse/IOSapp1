//
//  CusHomeTableViewCell.h
//  joybar
//
//  Created by liyu on 15/5/6.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BuyerHomeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *tilteView;

@property (weak, nonatomic) IBOutlet UILabel *tilteD1View;
@property (weak, nonatomic) IBOutlet UILabel *tilteD2View;
@property (weak, nonatomic) IBOutlet UILabel *pirceD1View;
@property (weak, nonatomic) IBOutlet UILabel *pirceD2View;
@property (weak, nonatomic) IBOutlet UILabel *pirceDd1View;
@property (weak, nonatomic) IBOutlet UILabel *pirceDd2View;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lableXConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lableLConstraint;

@end
