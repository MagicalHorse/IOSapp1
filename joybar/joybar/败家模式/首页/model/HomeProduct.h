//
//  Products.h
//  joybar
//
//  Created by 123 on 15/5/27.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductPic.h"
#import "LikeUsers.h"
#import "ProDetailPromotion.h"
@interface HomeProduct : NSObject

@property (nonatomic ,copy) NSString *Buyerid;
@property (nonatomic ,copy) NSString *BuyerName;
@property (nonatomic ,copy) NSString *CreateTime;
@property (nonatomic ,copy) NSString *BuyerAddress;
@property (nonatomic ,copy) NSString *BuyerLogo;
@property (nonatomic ,copy) NSString *Price;
@property (nonatomic ,copy) NSString *ProductName;
@property (nonatomic ,copy) NSString *ProductId;
//@property (nonatomic ,copy) NSString *IsShow;
@property (nonatomic ,copy) NSString *ShareLink;
@property (nonatomic ,strong) ProductPic *ProductPic;
@property (nonatomic ,strong) LikeUsers *LikeUsers;
@property (nonatomic ,strong) ProDetailPromotion *Promotion;
@property (nonatomic ,copy) NSString *TipText;
@end
