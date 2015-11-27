//
//  CusShoppingTableViewCell.h
//  joybar
//
//  Created by joybar on 15/11/20.
//  Copyright © 2015年 卢兴. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CusShoppingTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *shopIconView;
@property (weak, nonatomic) IBOutlet UILabel *desLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UIButton *chCBtn;

@end
