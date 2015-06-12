//
//  HomeLikeUsers.h
//  joybar
//
//  Created by 123 on 15/5/27.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LikeUsers : NSObject

@property (nonatomic ,strong) NSMutableArray *Users;

@property (nonatomic ,copy) NSString *Count;

@property (nonatomic ,copy) NSString *IsLike;
@end
