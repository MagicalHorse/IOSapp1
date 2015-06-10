//
//  fansModel.h
//  joybar
//
//  Created by 123 on 15/6/1.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FansModel : NSObject

@property (nonatomic ,copy) NSString *UserLogo;
@property (nonatomic ,copy) NSString *UserName;
@property (nonatomic ,copy) NSString *FavoiteCount;
@property (nonatomic ,copy) NSString *FansCount;
@property (nonatomic ,copy) NSString *UserId;
@property (nonatomic ,copy) NSString *isFavorite;
@property (nonatomic ,copy) NSString *CreateTime;

@end
