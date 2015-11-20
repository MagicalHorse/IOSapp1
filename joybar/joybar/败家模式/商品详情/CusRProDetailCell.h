//
//  CusRProDetailCell.h
//  joybar
//
//  Created by 123 on 15/11/20.
//  Copyright © 2015年 卢兴. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProDetailData.h"
@interface CusRProDetailCell : UITableViewCell<UIScrollViewDelegate>

-(void)setDetailData:(ProDetailData *)proData andIndex:(NSIndexPath *)indexPath;

@end
