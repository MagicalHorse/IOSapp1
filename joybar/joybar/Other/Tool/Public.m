//
//  Public.m
//  joybar
//
//  Created by 123 on 15/5/11.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "Public.h"
#import "LoginAndRegisterViewController.h"
#import "BaseNavigationController.h"
@implementation Public


+(void)showLoginVC:(UIViewController *)VC
{
    LoginAndRegisterViewController *loginVC = [[LoginAndRegisterViewController alloc] init];
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:loginVC];
    [VC presentViewController:nav animated:YES completion:nil];
    
}
+(CGSize)getContentSizeWith:(NSString *)content andFontSize:(NSInteger)fontSize andHigth:(NSInteger)higth
{
    CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake( CGFLOAT_MAX,higth) lineBreakMode:NSLineBreakByWordWrapping];
    
    return size;
}

+(CGSize)getContentSizeWith:(NSString *)content andFontSize:(NSInteger)fontSize andWidth:(NSInteger)width
{
    CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    
    return size;
}

+(NSDictionary *)getUserInfo
{
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    return dic;
}
#pragma mark --UUID
+(NSString *)getDeviceUUIDString
{
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

#pragma mark --验证Email地址
+ (BOOL)validateEmailWithString:(NSString*)emailAddress
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailAddress];
}

#pragma mark --验证电话号码
+ (BOOL)validatePhoneNumberWithString:(NSString*)mobileNum
{
    
    /**
     *手机号码
     *移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     *联通：130,131,132,152,155,156,185,186
     *电信：133,1349,153,180,189
     *京东:170
     */
    NSString *MOBILE = @"^1(3[0-9]|5[0-35-9]|8[0-9])\\d{8}$";
    /**
     10* 中国移动：China Mobile
     11* 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     */
    NSString *CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[0-9])\\d)\\d{7}$";
    
    /**
     15* 中国联通：China Unicom
     16* 130,131,132,152,155,156,185,186
     */
    NSString *CU = @"^1(3[0-2]|76|5[256]|8[0-9])\\d{8}$";
    
    /**
     20
     * 中国电信：China Telecom
     21* 133,1349,153,180,189
     */
    
    NSString *CT = @"^1((33|53|8[0-9])[0-9]|349)\\d{7}$";
    
    /**
     23* 京东:170
     */
    NSString *JD = @"^170\\d{8}$";
    
    /**
     25* 大陆地区固话及小灵通
     26* 区号：010,020,021,022,023,024,025,027,028,029
     27* 号码：七位或八位
     28*/
    /*
     //小灵通 固话暂且不需要
     NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
     */
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CT];
    NSPredicate *regextestjd = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",JD];
    if(
       ([regextestmobile evaluateWithObject:mobileNum] == YES)
       ||
       ([regextestcm     evaluateWithObject:mobileNum] == YES)
       ||
       ([regextestct     evaluateWithObject:mobileNum] == YES)
       ||
       ([regextestcu     evaluateWithObject:mobileNum] == YES)
       ||
       ([regextestjd     evaluateWithObject:mobileNum] == YES))
    {
        return YES;
        
    }
    else
    {
        return NO;
        
    }
}

+(NSString *) getDistanceWithLocation:(double)oldLat and:(double)oldLon and:(double)newLat and:(double)newLon
{
    CLLocation *location1 = [[CLLocation alloc] initWithLatitude:oldLat longitude:oldLon];
    CLLocation *location2 = [[CLLocation alloc] initWithLatitude:newLat longitude:newLon];

    CLLocationDistance distance = [location1 getDistanceFrom:location2];
    NSString *str = [NSString stringWithFormat:@"%f",distance];
    return str;
}

@end
