//
//  NearItems.h
//  joybar
//
//  Created by 123 on 15/6/1.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NearItems : NSObject

@property (nonatomic ,copy) NSString *UserId;
@property (nonatomic ,copy) NSString *UserName;
@property (nonatomic ,copy) NSString *AssociateId;
@property (nonatomic ,copy) NSString *Address;
@property (nonatomic ,copy) NSString *ProductId;
@property (nonatomic ,copy) NSString *ProductName;
@property (nonatomic ,copy) NSString *CreateTime;
@property (nonatomic ,copy) NSString *IsFavorite;
@property (nonatomic ,copy) NSString *BuyerLogo;
@property (nonatomic ,strong) NSMutableArray *Pic;
@end
