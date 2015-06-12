//
//  CusNearTableViewCell.h
//  joybar
//
//  Created by 123 on 15/5/5.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NearItems.h"
@interface CusNearTableViewCell : UITableViewCell

-(void)setData:(NSDictionary *)dic;

@property (nonatomic ,strong) NearItems *nearItems;

@end
