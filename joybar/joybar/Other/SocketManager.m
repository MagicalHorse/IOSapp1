//
//  SocketManager.m
//  joybar
//
//  Created by joybar on 15/6/8.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "SocketManager.h"

@implementation SocketManager
+(instancetype)socketManager{
    static SocketManager *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}
@end
