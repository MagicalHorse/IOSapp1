//
//  BuyerIssueViewController.h
//  joybar
//
//  Created by joybar on 15/5/22.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@class Detail;

@interface BuyerIssueViewController : BaseViewController
@property (nonatomic,strong)UIImage *image;
@property (nonatomic,strong)NSMutableDictionary *images;
@property (nonatomic,strong)Detail *detail;
@property (nonatomic ,strong)NSString *productId;
@property (nonatomic ,assign)int btnType;
@end
