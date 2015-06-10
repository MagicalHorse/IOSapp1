//
//  BaseModel.h
//  山东邮政
//
//  Created by wangyibo on 14/10/17.
//  Copyright (c) 2014年 wyb. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PropertyString(p) @property (nonatomic, strong) NSString *p;
#define PropertyInteger(p) @property (nonatomic, assign) NSInteger p;
#define PropertyBool(p) @property (nonatomic, assign) BOOL p;
#define PropertyNumber(p) @property (nonatomic, strong) NSNumber *p;
#define PropertyNSArray(p) @property (nonatomic, strong) NSArray *p;

@interface BaseModel : NSObject

@end
