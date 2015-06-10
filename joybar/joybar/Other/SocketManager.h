//
//  SocketManager.h
//  joybar
//
//  Created by joybar on 15/6/8.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SIOSocket.h"

@interface SocketManager : NSObject
@property(nonatomic,strong)SIOSocket *socket;
+(instancetype)socketManager;
@end
