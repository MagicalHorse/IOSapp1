//
//  SearchDetailsViewController.h
//  joybar
//
//  Created by joybar on 15/11/20.
//  Copyright © 2015年 卢兴. All rights reserved.
//

#import "BaseViewController.h"

@interface SearchDetailsViewController : BaseViewController
@property (nonatomic ,copy)NSString *serachText;
@property (nonatomic ,copy)NSString *latitude;
@property (nonatomic ,copy)NSString *longitude;
@property (nonatomic ,copy)NSString *cityId;
@property (nonatomic ,assign)int cusSearchType;
@property (nonatomic ,copy)NSString *storeId;
@end
