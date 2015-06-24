//
//  BuyerTagViewController.h
//  joybar
//
//  Created by joybar on 15/6/19.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "BaseViewController.h"
@protocol BuyerTagDelegate<NSObject>
@optional
-(void)didSelectedTag:(NSString *)tagText AndPoint :(CGPoint)point;
@end
@interface BuyerTagViewController : BaseViewController
@property (nonatomic, weak) id <BuyerTagDelegate> delegate;
@property (nonatomic,assign)CGPoint cpoint;
@end
