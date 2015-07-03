//
//  Order.h
//  joybar
//
//  Created by joybar on 15/5/26.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Order : NSObject

@property (nonatomic,strong)NSNumber* Amount;
@property (nonatomic,copy)NSString* CreateTime;
@property (nonatomic,strong)NSNumber* InCome;
@property (nonatomic,copy)NSString* OrderNo;
@property (nonatomic,strong)NSMutableArray *Products;
@property (nonatomic,strong)NSNumber* Status;
@property (nonatomic,copy)NSString* StatusName;
@property (nonatomic,strong)NSNumber *GoodsAmount;
@property (nonatomic,assign)BOOL IsGoodsPick;
@end
