//
//  CusBueryTableViewCell.h
//  joybar
//
//  Created by joybar on 15/11/20.
//  Copyright © 2015年 卢兴. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CusBueryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *guanzhuBtn;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (strong, nonatomic)  UIImageView *shopBtn;
@property (strong, nonatomic)  UIImageView *shopBtn1;
@property (strong, nonatomic)  UIImageView *shopBtn2;


@end
