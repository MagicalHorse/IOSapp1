//
//  CusZProDetailCell.h
//  joybar
//
//  Created by 123 on 15/11/19.
//  Copyright © 2015年 卢兴. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProDetailData.h"
@interface CusZProDetailCell : UITableViewCell<UIScrollViewDelegate>


-(void)setDetailData:(ProDetailData *)proData andIndex:(NSIndexPath *)indexPath;

@end
