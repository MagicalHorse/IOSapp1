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
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //        //调用初始化下拉刷新子视图
            [self setupRefresh];
        });
        self.isShowFooterView=YES;
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

    [self addFooterWithTarget:self action:@selector(footerRereshing)];
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
//    if (self.isShowFooterView) {
//        [self addFooterWithTarget:self action:@selector(footerRereshing)];
//    }
    //    [self headerBeginRefreshing];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    if (self.headerRefreshingText1)
    {
        self.headerPullToRefreshText = self.headerPullToRefreshText1;
        self.headerReleaseToRefreshText = self.headerReleaseToRefreshText1;
        self.headerRefreshingText = self.headerRefreshingText1;
    }
    
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
    self.footerHidden = hidden;
}

-(void)hiddenHeader:(BOOL)hidden
{
    self.headerHidden = hidden;
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
