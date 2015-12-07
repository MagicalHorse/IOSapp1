//
//  MakeSureVipOrderViewController.h
//  joybar
//
//  Created by joybar on 15/11/19.
//  Copyright © 2015年 卢兴. All rights reserved.
//

#import "BaseViewController.h"
#import "ProDetailData.h"
@interface MakeSureVipOrderViewController : BaseViewController
@property (nonatomic ,strong) ProDetailData *detailData;
@property (nonatomic ,strong) NSString *buyNum;
@property (nonatomic ,strong) NSString *sizeId;
@property (nonatomic ,strong) NSString *sizeName;
@property (nonatomic ,strong) NSString *buyerId;
@end
