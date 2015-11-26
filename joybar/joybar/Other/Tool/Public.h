//
//  Public.h
//  joybar
//
//  Created by 123 on 15/5/11.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@interface Public : NSObject

+(NSString *)getDeviceUUIDString;
+ (BOOL)validateEmailWithString:(NSString*)emailAddress;
+ (BOOL)validatePhoneNumberWithString:(NSString*)mobileNum;
+(NSDictionary *)getUserInfo;
+(CGSize)getContentSizeWith:(NSString *)content andFontSize:(NSInteger)fontSize andWidth:(NSInteger)width;
+(CGSize)getContentSizeWith:(NSString *)content andFontSize:(NSInteger)fontSize andHigth:(NSInteger)higth;
+(void)showLoginVC:(UIViewController *)VC;

+(NSString *) getDistanceWithLocation:(double)oldLat and:(double)oldLon and:(double)newLat and:(double)newLon;
@end
