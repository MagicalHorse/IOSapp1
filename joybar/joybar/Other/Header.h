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
#define AlyAccessKey  @"9mtpdwiywiF5yYwV"
#define AlySecretKey  @"IfGB5txNXBv0vv7Z5qERPH1Bp4DLtn"
#define AlyBucket @"apprss"
#define AlyBucketHostId @"oss-cn-beijing.aliyuncs.com"
//#define SocketUrl @"http://182.92.7.70:8000/chat"
#define SocketUrl @"http://182.92.7.70:8001/chat"

#define APP_ID          @"wx281aa8c2686c0e7c"               //APPID
#define APP_SECRET      @"1a8fd52d8cb2b6099b1c4c669e5e2717" //appsecret
//商户号，填写商户对应参数
#define MCH_ID          @"1247257401"
//商户API密钥，填写相应参数
#define PARTNER_ID      @"9b1c4c669e5e27171a8fd52d8cb2b609"
//支付结果回调页面
//#define NOTIFY_URL      @"http://wxpay.weixin.qq.com/pub_v2/pay/notify.v2.php"

//#define NOTIFY_URL      @"http://123.57.52.187:8080/app/Payment/WeiXinPayResult"

//获取服务器端支付数据地址（商户自定义）
#define SP_URL          @"http://wxpay.weixin.qq.com/pub_v2/app/app_pay.php"

//#define HomeURL  @"http://123.57.52.187:8080/app/"
//#define HomeURL  @"http://123.57.52.187:8070/app/"
#define HomeURL  @"http://123.57.77.86:8080/app/"

