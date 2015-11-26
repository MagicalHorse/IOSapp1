//
//  LocationViewController.h
//  joybar
//
//  Created by 123 on 15/11/20.
//  Copyright © 2015年 卢兴. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^cityBlock)(NSString *cityName);

@interface LocationViewController : BaseViewController

@property (nonatomic ,strong) cityBlock handleCityName;

@property (nonatomic ,strong) NSString *locationCityName;

@end
