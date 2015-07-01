//
//  Order.h
//  joybar
//
//  Created by joybar on 15/5/26.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Store : NSObject

@property (nonatomic,strong)NSNumber* BrandId;
@property (nonatomic,copy)NSString* BrandName;
@property (nonatomic,copy)NSString* ExpireTime;
@property (nonatomic,copy)NSString* Pic;
@property (nonatomic,strong)NSNumber *Price;
@property (nonatomic,strong)NSNumber *ProductId;
@property (nonatomic,copy)NSString* ProductName;
@property (nonatomic,strong)NSString* StoreItemNo;

@end
