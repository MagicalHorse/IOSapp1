//
//  ProDetailData.h
//  joybar
//
//  Created by 123 on 15/5/29.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LikeUsers.h"
#import "ProductPic.h"
#import "ProDetailPromotion.h"
@interface ProDetailData : NSObject

@property (nonatomic ,copy) NSString *BuyerId;
@property (nonatomic ,copy) NSString *BuyerName;
@property (nonatomic ,copy) NSString *BuyerLogo;
@property (nonatomic ,copy) NSString *TurnCount;
@property (nonatomic ,copy) NSString *PickAddress;
@property (nonatomic ,copy) NSString *ProductId;
@property (nonatomic ,copy) NSString *ProductName;
@property (nonatomic ,copy) NSString *Price;
@property (nonatomic ,copy) NSString *IsFavorite;
@property (nonatomic ,copy) NSString *BuyerMobile;
@property (nonatomic ,copy) NSString *StoreName;

@property (nonatomic ,strong)NSMutableArray *ProductPic;
@property (nonatomic ,strong) ProDetailPromotion *Promotion;

@property (nonatomic ,strong) LikeUsers *LikeUsers;

@property (nonatomic ,strong) NSMutableArray *Sizes;

@end
