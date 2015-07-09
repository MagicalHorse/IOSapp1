//
//  MessageMoreView.h
//  FaceView
//  更多功能按钮

//  Created by Sundy on 14-4-5.
//  Copyright (c) 2014年 Mobile Financial. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CusProLinkViewController.h"

@protocol MessageMoreViewDelegate <NSObject>

-(void)reCreatNewNotification;

-(void)handleProLinkDelegate:(NSArray *)proArr;

-(void)handleImage:(NSData *)data;

@end

@interface MessageMoreView : UIView<UIImagePickerControllerDelegate,UINavigationControllerDelegate,proDelegate>

//按钮标题
@property (strong, nonatomic) NSMutableArray *btnTitle;
//按钮图片
@property (strong, nonatomic) NSMutableArray *imageArray;
@property (strong, nonatomic) id<MessageMoreViewDelegate> messageMoreDelegate;


@end
