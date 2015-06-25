//
//  BaseTableView.h
//  joybar
//
//  Created by 123 on 15/5/25.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^headerRereshing)(void);
typedef void(^footerRereshing)(void);


@interface BaseTableView : UITableView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong) headerRereshing headerRereshingBlock;
@property (nonatomic ,strong) footerRereshing footerRereshingBlock;

-(void)endRefresh;
-(void)footerEndRefresh;

@property (nonatomic ,strong) NSMutableArray *dataArr;

@property (nonatomic ,strong) NSString *headerPullToRefreshText1;
@property (nonatomic ,strong) NSString *headerReleaseToRefreshText1;
@property (nonatomic ,strong) NSString *headerRefreshingText1;

//隐藏加载更多
-(void)hiddenFooter:(BOOL)hidden;
@end
