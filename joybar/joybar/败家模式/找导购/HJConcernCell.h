//
//  HJConcernCell.h
//  joybar
//
//  Created by joybar on 15/11/28.
//  Copyright © 2015年 卢兴. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HJConcernCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *dscLab;
@property (weak, nonatomic) IBOutlet UIButton *shCBtn;

@end
