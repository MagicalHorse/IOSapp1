//
//  HomeTableView.h
//  joybar
//
//  Created by 123 on 15/6/9.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "BaseTableView.h"

@interface HomeTableView : BaseTableView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong) NSMutableArray *dataArr;

@end
