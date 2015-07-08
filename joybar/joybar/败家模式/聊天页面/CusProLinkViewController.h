//
//  CusProLinkViewController.h
//  joybar
//
//  Created by 123 on 15/5/19.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "BaseViewController.h"

@protocol proDelegate <NSObject>

-(void)selectPro:(NSArray *)arr;

@end
@interface CusProLinkViewController : BaseViewController

@property (nonatomic, strong) NSString *titleStr;

@property (nonatomic ,assign) id<proDelegate> delegate;

@end
