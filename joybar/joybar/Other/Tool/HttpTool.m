//
//  RDHttpTool.m
//  Created by apple on 14-9-10.
//  Copyright (c) 2014年 xinhuaruide. All rights reserved.
//

#define HomeURL  @"http://123.57.52.187:8080/app/"
//#define HomeURL  @"http://123.57.52.187:8070/app"


#import "HttpTool.h"
#import "AFNetworking.h"
#import "Common.h"
#import "NSString+MD5.h"
#import "MBProgressHUD.h"
#import "BaseNavigationController.h"
#import "LoginAndRegisterViewController.h"
@interface HttpTool()
@end

@implementation HttpTool
+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
//    // 0.验证网络
//    [Common IsReachability:^{
//        [MBProgressHUD showError:@"没有网络连接"];
//        if (failure)failure(nil);
//    }];
    NSString  *tempUrl = [HomeURL stringByAppendingFormat:@"%@",url];
    
    NSString *md5Str = [HttpTool signatureStr:params];
    
    NSMutableDictionary *signDic = [NSMutableDictionary dictionaryWithDictionary:params];
    [signDic setObject:md5Str forKey:@"sign"];
    [signDic setObject:[HttpTool getDeviceUUIDString] forKey:@"uid"];
    [signDic setObject:@"2.3" forKey:@"client_version"];
    [signDic setObject:@"IOS" forKey:@"channel"];
    if (TOKEN) {
        [signDic setObject:TOKEN forKey:@"token"];
    }
    // 1.创建请求管理对象
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.发送请求
    [mgr POST:tempUrl parameters:signDic
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          
          if ([[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"statusCode"]] isEqualToString:@"401"])
          {
              LoginAndRegisterViewController *VC = [[LoginAndRegisterViewController alloc] init];
              BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:VC];
              UIViewController* rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
              [rootViewController presentViewController:nav animated:YES completion:nil];
          }

          if (success) {
              success(responseObject);
          }
          
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          if (failure) {
              failure(error);
          }
      }];
}

+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params formDataArray:(NSArray *)formDataArray success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    // 0.验证网络
//    [Common IsReachability:^{
//        [MBProgressHUD showError:@"没有网络连接"];
//        if (failure)failure(nil);
//    }];
    
    // 1.创建请求管理对象
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];

    
    // 2.发送请求
    [mgr POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> totalFormData) {
        for (IWFormData *formData in formDataArray) {
            [totalFormData appendPartWithFileData:formData.data name:formData.name fileName:formData.filename mimeType:formData.mimeType];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)getWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    // 0.验证网络
//    [Common IsReachability:^{
//        [MBProgressHUD showError:@"没有网络连接"];
//        if (failure)failure(nil);
//    }];
    
    // 1.创建请求管理对象
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.发送请求
    [mgr GET:url parameters:params
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         if (success) {
             success(responseObject);
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         if (failure) {
             failure(error);
         }
     }];
}

+(NSString *)signatureStr:(NSDictionary *)params
{
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:params];
    [tempDic setObject:@"IOS" forKey:@"channel"];
    [tempDic setObject:@"2.3" forKey:@"client_version"];
    if (TOKEN) {
        [tempDic setObject:TOKEN forKey:@"token"];

    }
    [tempDic setObject:[HttpTool getDeviceUUIDString] forKey:@"uid"];
    
    NSArray* ary = [tempDic allKeys];
    NSSortDescriptor *sd1 = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES];//yes升序排列，no,降序排列
    NSArray *myary = [ary sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sd1, nil]];//注意这里的ary进行排序后会生产一个新的数组指针，myary，不能在用ary,ary还是保持不变的。
    NSMutableString *tempStr =[[NSMutableString alloc]init];
    
    for (int i=0; i<myary.count; i++)
    {
        NSString *key = [myary objectAtIndex:i];
        NSString *value = [tempDic objectForKey:key];
        NSString *str = [NSString stringWithFormat:@"%@=%@",key,value];
        [tempStr appendString:str];
        if (i!=myary.count-1)
        {
            [tempStr appendString:@"&"];
        }
    }
    NSString *signStr = [NSString stringWithFormat:@"%@%@%@",@"51C703C8-C331-4C03-B417-ECF807BE29D4",tempStr,@"51C703C8-C331-4C03-B417-ECF807BE29D4"];
    NSString *md5Str = [signStr md5Encrypt];
    return md5Str;
}

#pragma mark --UUID
+(NSString *)getDeviceUUIDString
{
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

@end
