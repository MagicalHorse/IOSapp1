//
//  CusHomeViewController.h
//  joybar
//
//  Created by 卢兴 on 15/4/16.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "BaseViewController.h"
#import "CycleScrollView.h"
#import "HomeData.h"

@interface CusHomeViewController : BaseViewController<UIScrollViewDelegate,CycleScrollViewDatasource,CycleScrollViewDelegate>
@property (nonatomic ,strong) HomeData *data;

@end
