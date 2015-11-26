//
//  CusShopTableViewCell.h
//  joybar
//
//  Created by joybar on 15/11/20.
//  Copyright © 2015年 卢兴. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CusShopTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UILabel *juliView;

@end
