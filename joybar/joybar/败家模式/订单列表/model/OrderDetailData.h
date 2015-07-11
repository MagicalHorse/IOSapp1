//
//  OrderDetailData.h
//  joybar
//
//  Created by 123 on 15/6/5.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderDetailData : NSObject

@property (nonatomic ,copy) NSString *BuyerId;
@property (nonatomic ,copy) NSString *BuyerMobile;
@property (nonatomic ,copy) NSString *BuyerName;
@property (nonatomic ,copy) NSString *CreateDate;
@property (nonatomic ,copy) NSString *OrderAmount;
@property (nonatomic ,copy) NSString *OrderNo;
@property (nonatomic ,copy) NSString *OrderStatus;
@property (nonatomic ,copy) NSString *OrderStatusName;
@property (nonatomic ,copy) NSString *PickAddress;
@property (nonatomic ,copy) NSString *Price;
@property (nonatomic ,copy) NSString *ProductCount;
@property (nonatomic ,copy) NSString *ProductId;
@property (nonatomic ,copy) NSString *ProductName;
@property (nonatomic ,copy) NSString *ProductPic;
@property (nonatomic ,copy) NSString *SizeName;
@property (nonatomic ,copy) NSString *SizeValue;
@property (nonatomic ,copy) NSString *BuyerLogo;
@property (nonatomic ,strong) NSArray *Promotions;

@property (nonatomic ,copy) NSString *ShareLink;
@property (nonatomic ,copy) NSString *IsShareable;

@end
