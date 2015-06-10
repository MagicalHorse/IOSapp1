//
//  FindItems.h
//  joybar
//
//  Created by 123 on 15/6/1.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FindProduct.h"
@interface FindItems : NSObject

@property (nonatomic ,copy) NSString *BrandId;
@property (nonatomic ,copy) NSString *BrandName;
@property (nonatomic ,copy) NSString *BrandLogo;
@property (nonatomic ,copy) NSMutableArray *Product;
@end
