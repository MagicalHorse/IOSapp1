//
//  BuyerFilterViewController.h
//  joybar
//
//  Created by joybar on 15/6/17.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "BaseViewController.h"

@protocol BuyerFilterDelgeate <NSObject>
@optional
-(void)choose:(UIImage *)image;
@end
@interface BuyerFilterViewController : BaseViewController
@property (nonatomic, weak) id <BuyerFilterDelgeate> delegate;
-(instancetype)initWithImg:(UIImage *)image;
@property (nonatomic,assign)NSInteger imgTag;
@end
