//
//  BaseModel.m
//  山东邮政
//
//  Created by wangyibo on 14/10/17.
//  Copyright (c) 2014年 wyb. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"未定义的键:%@",key);
}

@end
