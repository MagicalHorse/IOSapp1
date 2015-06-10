//
//  CusHomeTableViewCell.h
//  joybar
//
//  Created by 123 on 15/4/24.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeProduct.h"


@interface CusHomeTableViewCell : UITableViewCell

-(void)setData:(NSDictionary *)dic;

@property (nonatomic ,strong) HomeProduct *homePro;

@end
