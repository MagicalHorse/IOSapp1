//
//  SelectCityViewController.h
//  joybar
//
//  Created by 123 on 15/5/11.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^SelectCityBlock)(NSString *cityID,NSString *cityName);

@interface SelectCityViewController : BaseViewController

@property (nonatomic ,strong) SelectCityBlock cityBlock;

@end
