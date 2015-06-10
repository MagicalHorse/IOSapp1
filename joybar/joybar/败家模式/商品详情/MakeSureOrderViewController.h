//
//  MakeSureOrderViewController.h
//  joybar
//
//  Created by 123 on 15/5/28.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "BaseViewController.h"
#import "ProDetailData.h"
@interface MakeSureOrderViewController : BaseViewController

@property (nonatomic ,strong) ProDetailData *detailData;

@property (nonatomic ,strong) NSString *buyNum;

@property (nonatomic ,strong) NSString *sizeId;

@property (nonatomic ,strong) NSString *sizeName;

@end
