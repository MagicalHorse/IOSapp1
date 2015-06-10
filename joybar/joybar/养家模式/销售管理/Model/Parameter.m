//
//  Parameter.m
//  joybar
//
//  Created by joybar on 15/5/27.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "Parameter.h"

@implementation Parameter
-(instancetype)initWith:(NSString *)page andPageSize:(NSString *)pageSize;
{
    if (self =[super init]) {
        self.page =page;
        self.pageSzie=pageSize;
    }
    return self;
}
@end
