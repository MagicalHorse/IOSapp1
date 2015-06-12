
//
//  CusTagTableViewCell.h
//  joybar
//
//  Created by 123 on 15/4/28.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CusTagTableViewCell : UITableViewCell


-(void) setData:(NSArray *)dataArr andIndexPath:(NSIndexPath *)indexPath;

@property (nonatomic ,assign) NSInteger currentMaxDisplayedRow;

@end
