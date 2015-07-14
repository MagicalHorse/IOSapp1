//
//  CusCollectionViewController.m
//  joybar
//
//  Created by 123 on 15/5/12.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "CusCollectionViewController.h"
#import "CusAttentionViewController.h"
#import "CusCollectionViewCell.h"
#import "MJRefresh.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "CusBuyerDetailViewController.h"
@interface CusCollectionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,CHTCollectionViewDelegateWaterfallLayout>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (nonatomic ,assign) NSInteger pageNum;
@end

@implementation CusCollectionViewController

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
    CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
    
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    layout.minimumColumnSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[CusCollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    [self.view addSubview:self.collectionView];
    [self addNavBarViewAndTitle:@"收藏"];
    
    //    self.collectionView.headerHidden = NO;
    [self getData];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cancelCollect) name:@"cancelCollectNot" object:nil];
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
    
    [self hudShow];
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
            
            [self.collectionView reloadData];
        }
        [self hiddleHud];
        //        [self.collectionView headerEndRefreshing];
        //        [self.collectionView footerEndRefreshing];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
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
    
    [cell setCollectionData:[self.dataSource objectAtIndex:indexPath.row] andHeight:(kScreenWidth-10)/2*height];
    
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CusBuyerDetailViewController *VC = [[CusBuyerDetailViewController alloc] init];
    VC.productId = [[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"Id"];
    [self.navigationController pushViewController: VC animated:YES];
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [self.dataSource objectAtIndex:indexPath.row];
    NSString *text = [dic objectForKey:@"Name"];
    CGSize size = [Public getContentSizeWith:text andFontSize:13 andWidth:(kScreenWidth-15)/2-10];
    CGFloat itemH = (kScreenWidth-10)/2*[[[dic objectForKey:@"pic"] objectForKey:@"Ratio"] floatValue]+size.height+35;
    
    CGSize size1 = CGSizeMake((kScreenWidth-10)/2, itemH);
    
    NSLog(@"++++++++++++++%f",size1.height);
    return size1;
}


-(void)cancelCollect
{
    [self getData];
}

@end
