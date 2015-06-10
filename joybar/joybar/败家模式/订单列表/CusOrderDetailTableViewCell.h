//
//  CusOrderDetailTableViewCell.h
//  joybar
//
//  Created by 123 on 15/5/28.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDetailData.h"
@interface CusOrderDetailTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *proImage;
@property (strong, nonatomic) IBOutlet UILabel *proNameLab;
@property (strong, nonatomic) IBOutlet UILabel *sizeLab;
@property (strong, nonatomic) IBOutlet UILabel *numLab;
@property (strong, nonatomic) IBOutlet UILabel *priceLab;
-(void)setData:(OrderDetailData *)detailData;

@end
