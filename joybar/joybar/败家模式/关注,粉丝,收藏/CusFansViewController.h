//
//  CusFansViewController.h
//  joybar
//
//  Created by 123 on 15/5/12.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "BaseViewController.h"

@interface CusFansViewController : BaseViewController

@property (nonatomic ,strong) NSString *titleStr;
@property (nonatomic ,strong) BaseTableView *tableView;

@property (nonatomic ,assign) NSInteger pageNum;
@property (nonatomic ,strong) NSMutableArray *fanArr;

-(CusFansViewController *)initIsY;
@end
