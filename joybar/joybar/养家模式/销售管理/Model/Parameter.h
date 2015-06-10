//
//  Parameter.h
//  joybar
//
//  Created by joybar on 15/5/27.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Parameter : NSObject
@property (nonatomic,copy)NSString *page;
@property (nonatomic,copy)NSString *pageSzie;
-(instancetype)initWith:(NSString *)page andPageSize:(NSString *)pageSize;
@end
