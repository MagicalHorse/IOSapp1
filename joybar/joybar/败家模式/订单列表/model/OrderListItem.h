//
//  OrderListItem.h
//  joybar
//
//  Created by 123 on 15/6/2.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderListPro.h"
@interface OrderListItem : NSObject

@property (nonatomic ,copy) NSString *OrderNo;
@property (nonatomic ,copy) NSString *OrderProductType;
@property (nonatomic ,copy) NSString *OrderStatus;
@property (nonatomic ,copy) NSString *OrderProductCount;
@property (nonatomic ,copy) NSString *Amount;
@property (nonatomic ,copy) NSString *CreateDate;
@property (nonatomic ,copy) NSString *Address;
@property (nonatomic ,strong) OrderListPro *Product;
@property (nonatomic ,copy) NSString *BuyerName;
@property (nonatomic ,copy) NSString *OrderStatusStr;
@property (nonatomic ,copy) NSString *ActualAmount;

@end
