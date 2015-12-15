//
//  CusBrandDetailViewController.h
//  joybar
//
//  Created by 123 on 15/4/28.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "BaseViewController.h"

@interface CusBrandDetailViewController : BaseViewController

@property (nonatomic ,strong) NSString *BrandId;
@property (nonatomic ,strong) NSString *BrandName;
@property (nonatomic ,copy)NSString *cityId;
@property (nonatomic ,copy)NSString *storeId;
@end
