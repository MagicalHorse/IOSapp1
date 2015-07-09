//
//  Detail.h
//  joybar
//
//  Created by joybar on 15/7/8.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Detail : NSObject
@property (nonatomic,copy)NSString* Desc;
@property (nonatomic,strong)NSNumber* Price;
@property (nonatomic,copy)NSString* Sku_Code;
@property (nonatomic,strong)NSNumber *PublishStatus;
//@property (nonatomic,strong)NSMutableArray *ExtendPropertys;
@property (nonatomic,strong)NSMutableArray *Images;
@property (nonatomic,strong)NSMutableArray *Sizes;


@end
