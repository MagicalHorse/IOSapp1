//
//  BuyerCameraViewController.h
//  joybar
//
//  Created by joybar on 15/6/2.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "BaseViewController.h"
@protocol BuyerCameraDelgeate <NSObject>
@optional
-(void)dismissCamrea:(UIImage *)image WithTag:(int)type;
@end
@interface BuyerCameraViewController : BaseViewController
@property (nonatomic, weak) id <BuyerCameraDelgeate> delegate;
-(instancetype)initWithType:(int)type;
@property (nonatomic,assign)NSInteger imgTag;

@end

