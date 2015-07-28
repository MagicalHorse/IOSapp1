//
//  BueryAuthInfoViewController.h
//  joybar
//
//  Created by joybar on 15/5/25.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "BaseViewController.h"

@interface BueryAuthInfoViewController : BaseViewController
-(instancetype)initWithImgNames:(NSMutableDictionary *)arrayNames;
@property (nonatomic,strong) NSString *textName;
@end
