//
//  BaseTableView.m
//  joybar
//
//  Created by 123 on 15/5/25.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "BaseTableView.h"
#import "MJRefresh.h"

@implementation BaseTableView


//代码创建时触发此方法xib创建不会触发
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
//        //调用初始化下拉刷新子视图
        [self setupRefresh];
        
        self.dataSource = self;
        self.delegate = self;
        self.dataArr = [NSMutableArray array];

    }
    return self;
}

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self addHeaderWithTarget:self action:@selector(headerRereshing)];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self addFooterWithTarget:self action:@selector(footerRereshing)];
    
//    [self headerBeginRefreshing];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    //    self.tableView.headerPullToRefreshText = @"下拉可以刷新了";
    //    self.tableView.headerReleaseToRefreshText = @"松开马上刷新了";
    //    self.tableView.headerRefreshingText = @"正在帮你刷新中,不客气";
    //
    //    self.tableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    //    self.tableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    //    self.tableView.footerRefreshingText = @"正在帮你加载中,不客气";
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    if (self.headerRereshingBlock)
    {
        self.headerRereshingBlock();
    }
}

- (void)footerRereshing
{
    if (self.footerRereshingBlock)
    {
        self.footerRereshingBlock();
    }
}

-(void)hiddenFooter:(BOOL)hidden
{
    if (hidden)
    {
        self.footerHidden = YES;
    }
    else
    {
        self.footerHidden = NO;
    }
}

// (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
-(void)endRefresh
{
    [self headerEndRefreshing];
    [self footerEndRefreshing];
}

// (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
-(void)footerEndRefresh
{
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

-(NSInteger)numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    return cell;
}

@end
