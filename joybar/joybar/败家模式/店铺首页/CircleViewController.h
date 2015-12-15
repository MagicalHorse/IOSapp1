//
//  CircleViewController.h
//  joybar
//
//  Created by 123 on 15/11/23.
//  Copyright © 2015年 卢兴. All rights reserved.
//

#import "BaseViewController.h"
#import "ProDetailData.h"
#import "ListView.h"


typedef NSUInteger isFromType;

@interface CircleViewController : BaseViewController

@property (nonatomic ,strong) NSString *circleId;
@property (nonatomic ,strong) NSString *userId;
//@property (nonatomic ,strong) NSString *chatRoomId;
//@property (assign, nonatomic) id<MessageTableViewScrollViewDelegate>messageScrollDelegate;
//@property (nonatomic ,strong) NSString *userName;

-(instancetype)initWithUserId:(NSString *)userId AndTpye:(int)type andUserName:(NSString *)Username;


@end
