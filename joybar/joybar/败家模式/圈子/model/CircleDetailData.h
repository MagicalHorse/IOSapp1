//
//  CiecleDetailData.h
//  joybar
//
//  Created by 123 on 15/6/3.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CircleDetailData : NSObject

@property (nonatomic ,copy) NSString *BuyerId;
@property (nonatomic ,copy) NSString *BuyerName;
@property (nonatomic ,copy) NSString *BuyerLogo;
@property (nonatomic ,copy) NSString *GroupId;
@property (nonatomic ,copy) NSString *GroupName;
@property (nonatomic ,copy) NSString *MemberCount;
@property (nonatomic ,copy) NSString *GroupPic;

@property (nonatomic ,copy) NSMutableArray *Users;

@end
