//
//  BuyerStoreTableViewCell.h
//  joybar
//
//  Created by liyu on 15/5/8.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BuyerStoreTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *picView;
@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet UILabel *detileView;
@property (weak, nonatomic) IBOutlet UILabel *noView;
@property (weak, nonatomic) IBOutlet UILabel *priceView;
@property (weak, nonatomic) IBOutlet UILabel *countView;
@property (weak, nonatomic) IBOutlet UILabel *guigeView;

@end
