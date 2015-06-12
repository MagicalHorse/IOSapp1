//
//  CusFindTableViewCell.h
//  joybar
//
//  Created by 123 on 15/5/5.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FindItems.h"
@interface CusFindTableViewCell : UITableViewCell

-(void)setData:(NSDictionary *)dic;

@property (nonatomic ,strong) FindItems *findItems;

@end
