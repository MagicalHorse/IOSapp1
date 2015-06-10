//
//  Header.h
//  山东邮政
//
//  Created by wangyibo on 14-9-5.
//  Copyright (c) 2014年 wyb. All rights reserved.
//

#ifndef _____Header_h
#define _____Header_h

//屏幕的物理宽度
#define     kScreenWidth            [UIScreen mainScreen].bounds.size.width
//屏幕的物理高度
#define     kScreenHeight           [UIScreen mainScreen].bounds.size.height
//当前设备的版本
#define     kCurrentFloatDevice     [[[UIDevice currentDevice]systemVersion]floatValue]

#define     BGCOLOR                 [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1]

#define     kCOLOR(a)               [UIColor colorWithRed:a/255.0f green:a/255.0f blue:a/255.0f alpha:1.0f]

#define     kCustomColor(a,b,c)     [UIColor colorWithRed:a/255.0f green:b/255.0f blue:c/255.0f alpha:1.0f]

#define PageCount @"6"
#define TOKEN [[[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"]objectForKey:@"token"]
#endif
//#define @"youyuan" @"HelveticaNeueLTPro-Lt"
#define AlyAccessKey  @"9mtpdwiywiF5yYwV"
#define AlySecretKey  @"IfGB5txNXBv0vv7Z5qERPH1Bp4DLtn"
#define AlyBucket @"apprss"
#define AlyBucketHostId @"oss-cn-beijing.aliyuncs.com"
#define SocketUrl @"http://182.92.7.70:8000/chat"





