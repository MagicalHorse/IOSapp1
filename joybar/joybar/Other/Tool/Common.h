//
//  RDCommon.h
//  joybar
//
//  Created by 123 on 15/5/11.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Common : NSObject
+ (void)IsReachability:(void (^)())completion;
+ (void)saveUserDefault:(NSString *)tokenString keyName:(NSString *)keyName;
+ (NSString*)getUserDefaultKeyName:(NSString *)keyName;

@end
