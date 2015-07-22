//
//  Store.h
//  joybar
//
//  Created by liyu on 15/5/12.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Product;
@interface Product : NSObject

@property (nonatomic,strong)NSNumber* Id;
@property (nonatomic,copy)NSString* BrandName;
@property (nonatomic,strong)NSNumber* BrandId;
@property (nonatomic,copy)NSString* Name;
@property (nonatomic,strong)NSNumber* Count;
@property (nonatomic,strong)NSNumber* Price;
@property (nonatomic,copy)NSString* StoreItemNo;
@property (nonatomic,copy)NSString* SizeName;
@property (nonatomic,copy)NSString* ColorName;
@property (nonatomic,copy)NSString* Picture;

@end
