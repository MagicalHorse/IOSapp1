//
//  NSString+MD5.h
//  SwanVip
//
//  Created by Sundy on 13-12-31.
//  Copyright (c) 2013年 Sundy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface NSString (MD5)

- (NSString *)md5Encrypt;

@end
