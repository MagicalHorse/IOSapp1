//
//  CusCollectionViewController.m
//  joybar
//
//  Created by 123 on 15/5/12.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "CusCollectionViewController.h"
#import "CustomCollectionViewLayout.h"
#import "CusAttentionViewController.h"
#import "CusCollectionViewCell.h"
#import "MJRefresh.h"
#import "LNWaterfallFlowLayout.h"
@interface CusCollectionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (nonatomic ,assign) NSInteger pageNum;
@end

@implementation CusCollectionViewController
{
    LNWaterfallFlowLayout *layout;
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageNum = 1;
    self.view.backgroundColor = kCustomColor(245, 246, 247);
    self.dataSource = [NSMutableArray array];
    [self initializeUserInterface];
    [self addNavBarViewAndTitle:@"收藏"];

    self.collectionView.headerHidden = NO;
    [self getData];
//    // 2.集成刷新控件
//    [self addHeader];
//    [self addFooter];

}

//- (void)addHeader
//{
//    __weak CusCollectionViewController* vc = self;
//    // 添加下拉刷新头部控件
//    [self.collectionView addHeaderWithCallback:^{
//        [vc.dataSource removeAllObjects];
//        [vc getData];
//        
//    }];
//    
//    [self.collectionView headerBeginRefreshing];
//}
//
//- (void)addFooter
//{
//    __weak CusCollectionViewController *vc = self;
//    // 添加上拉刷新尾部控件
//    [self.collectionView addFooterWithCallback:^{
//        vc.pageNum++;
//        [vc getData];
//    }];
//}

-(void)getData
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[NSString stringWithFormat:@"%ld",(long)self.pageNum] forKey:@"page"];
    [dic setValue:@"10000" forKey:@"pagesize"];
    
    [HttpTool postWithURL:@"Product/GetMyFavoriteProductList" params:dic success:^(id json) {
        
        if ([[json objectForKey:@"isSuccessful"] boolValue])
        {
            NSArray *arr = [[json objectForKey:@"data"] objectForKey:@"items"];
//            if (arr.count<6)
//            {
//                self.collectionView.footerHidden = YES;
//            }
//            else
//            {
//                self.collectionView.footerHidden = NO;
//
//            }
            [self.dataSource addObjectsFromArray:arr];

            layout.goodsList = self.dataSource;
            [self.collectionView reloadData];
        }
//        [self.collectionView headerEndRefreshing];
//        [self.collectionView footerEndRefreshing];
    } failure:^(NSError *error) {
        
    }];
}

- (void)initializeUserInterface {
    
    layout = [[LNWaterfallFlowLayout alloc] init];
    layout.columnCount = 2;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.bounces = NO;
    _collectionView.contentInset = UIEdgeInsetsMake(5, 5, 5, 5);
    [_collectionView registerClass:[CusCollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    [self.view addSubview:_collectionView];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CusCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    if (cell==nil)
    {
        cell = [[CusCollectionViewCell alloc]init];
    }
    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    float height = [[[[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"pic"] objectForKey:@"Ratio"] floatValue];
    
    [cell setCollectionData:[self.dataSource objectAtIndex:indexPath.row] andHeight:320*height];
    
    return cell;
}

@end
