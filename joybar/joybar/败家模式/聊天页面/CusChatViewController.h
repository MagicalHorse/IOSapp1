//
//  ChatViewController.h
//  joybar
//
//  Created by 123 on 15/5/19.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "BaseViewController.h"
#import "ProDetailData.h"
#import "ListView.h"

enum {
    isFromPrivateChat = 1,
    isFromGroupChat,
    isFromBuyPro,
    };

typedef NSUInteger isFromType;

@interface CusChatViewController : BaseViewController

@property (nonatomic ,strong) ProDetailData *detailData;
@property (nonatomic ,strong) NSString *circleId;
@property (nonatomic ,assign) isFromType isFrom;
//@property (assign, nonatomic) id<MessageTableViewScrollViewDelegate>messageScrollDelegate;

-(instancetype)initWithUserId:(NSString *)userId AndTpye:(int)type andUserName:(NSString *)Username andRoomId:(NSString *)roomId;


@end
