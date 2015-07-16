//
//  Tag.h
//  joybar
//
//  Created by joybar on 15/7/8.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tag : NSObject
@property (nonatomic,copy)NSString* Name;
@property (nonatomic,assign)float PosX;
@property (nonatomic,assign)float PosY;
@property (nonatomic,strong)NSNumber* ResourceId;
@property (nonatomic,strong)NSNumber* SourceId;
@property (nonatomic,strong)NSNumber* SourceType;

@end
