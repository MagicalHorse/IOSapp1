//
//  RDCommon.m
//  joybar
//
//  Created by 123 on 15/5/11.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "Common.h"
#import "Reachability.h"
@implementation Common
#pragma mark --验证是否有网络连接
+ (void)IsReachability:(void (^)())completion
{
    Reachability *r = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    NSInteger status =[r currentReachabilityStatus];
    if (status == 0) {
        [UIView animateWithDuration:0.25 animations:^{
            
        } completion:^(BOOL finished) {
            
            if (completion) {
                completion();
            }
        }];
        return;
    }
}
+ (void)saveUserDefault:(NSString *)tokenString keyName:(NSString *)keyName
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults)
    {
        [standardUserDefaults setObject:tokenString forKey:keyName];
        [standardUserDefaults synchronize];
    }
}

+ (NSString*)getUserDefaultKeyName:(NSString *)keyName
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString* tokenString = [standardUserDefaults objectForKey:keyName];
    return tokenString;
}
@end
