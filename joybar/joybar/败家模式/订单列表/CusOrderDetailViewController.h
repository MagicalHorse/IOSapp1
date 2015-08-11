//
//  CusOrderDetailViewController.h
//  joybar
//
//  Created by 123 on 15/5/28.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "BaseViewController.h"

@protocol orderDelegate <NSObject>

-(void)refreshOrderList;

@end

@interface CusOrderDetailViewController : BaseViewController

@property (nonatomic ,strong) NSString *orderId;
@property (nonatomic ,strong) NSString *fromType;

@property (nonatomic ,assign) id<orderDelegate> delegate;
@end
