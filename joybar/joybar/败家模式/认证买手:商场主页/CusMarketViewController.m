//
//  CusMarketViewController.m
//  joybar
//
//  Created by 123 on 15/11/16.
//  Copyright © 2015年 卢兴. All rights reserved.
//

#import "CusMarketViewController.h"
#import "MJRefresh.h"
#import "CusRProDetailViewController.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "CusHomeStoreCollectionViewCell.h"
#import "CusHomeStoreHeader.h"
#import "CusMoreBrandViewController.h"
#import "HistorySearchViewController.h"

#define HEADER_IDENTIFIER @"WaterfallHeader"
#define HEADER_HEIGHT [UIScreen mainScreen].bounds.size.width*0.5+35
@interface CusMarketViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,CHTCollectionViewDelegateWaterfallLayout>

@property (nonatomic ,strong) UICollectionView *collectionView;
@property (nonatomic ,strong) NSMutableArray *proArr;
@property (nonatomic ,strong) NSDictionary *infoDic;
@property (nonatomic ,strong) NSMutableArray *brandArr;
@property (nonatomic ,assign) int pageNum;

@end

@implementation CusMarketViewController
{
    CHTCollectionViewWaterfallLayout *layout;
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
    self.brandArr = [NSMutableArray array];
    [self addNavBarViewAndTitle:self.titleName];
    self.pageNum = 1;
    self.proArr = [NSMutableArray array];
    layout = [[CHTCollectionViewWaterfallLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    layout.minimumColumnSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) collectionViewLayout:layout];
    _collectionView.backgroundColor = kCustomColor(238, 233, 240);
    self.collectionView.alwaysBounceVertical = YES; //垂直方向遇到边框是否总是反弹
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[CusHomeStoreCollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    [_collectionView registerClass:[CusHomeStoreHeader class]
        forSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader
               withReuseIdentifier:HEADER_IDENTIFIER];
    [self.view addSubview:_collectionView];
    
    // 搜索按钮
    UIButton *searchBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    searchBtn.frame = CGRectMake(kScreenWidth-54, 10, 64, 64);
    searchBtn.backgroundColor = [UIColor clearColor];
    [searchBtn setImage:[UIImage imageNamed:@"search"] forState:(UIControlStateNormal)];
    [searchBtn addTarget:self action:@selector(didClickSearchBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.navView addSubview:searchBtn];

    
    [self addHeader];
    [self addFooter];
    [self getData];
}
- (void)addHeader
{
    __weak CusMarketViewController* vc = self;
    // 添加下拉刷新头部控件
    [self.collectionView addHeaderWithCallback:^{
        [vc.proArr removeAllObjects];
        vc.pageNum = 1;
        [vc getData];
    }];
    
    //    [self.collectionView headerBeginRefreshing];
}

- (void)addFooter
{
    __weak CusMarketViewController *vc = self;
    // 添加上拉刷新尾部控件
    [self.collectionView addFooterWithCallback:^{
        vc.pageNum++;
        [vc getData];
    }];
}

-(void)getData
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.storeId forKey:@"StoreId"];
    [dic setObject:[[Public getUserInfo] objectForKey:@"id"] forKey:@"userid"];
    [dic setObject:[NSString stringWithFormat:@"%d",self.pageNum] forKey:@"Page"];
    [dic setObject:@"10" forKey:@"PageSize"];
    [dic setObject:@"7" forKey:@"SortType"];
    [HttpTool postWithURL:@"v3/storeindex" params:dic success:^(id json) {
        if ([[json objectForKey:@"isSuccessful"] boolValue])
        {
            NSArray *arr =[[json objectForKey:@"data"] objectForKey:@"items"];
            self.infoDic = [json objectForKey:@"data"];
            
            [self.brandArr removeAllObjects];
            [self.brandArr addObjectsFromArray: [[json objectForKey:@"data"] objectForKey:@"Brands"]];
            if (self.brandArr.count>0)
            {
                layout.headerHeight = HEADER_HEIGHT;
            }
            else
            {
                layout.headerHeight = HEADER_HEIGHT-35;
            }
            [self.proArr addObjectsFromArray:arr];
            [self.collectionView reloadData];
        }
        else
        {
            [self showHudFailed:[json objectForKey:@"message"]];
        }
        [self.collectionView headerEndRefreshing];
        [self.collectionView footerEndRefreshing];
    } failure:^(NSError *error) {
        
    }];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.proArr.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *proId = [self.proArr [indexPath.row] objectForKey:@"Id"];
    CusRProDetailViewController *VC = [[CusRProDetailViewController alloc] init];
    VC.productId = proId;
    [self.navigationController pushViewController:VC animated:YES];
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CusHomeStoreCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    
    if (cell==nil)
    {
        cell = [[CusHomeStoreCollectionViewCell alloc]init];
    }
    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    if (self.proArr.count>0)
    {
        float height = [[[self.proArr objectAtIndex:indexPath.row] objectForKey:@"Ratio"] floatValue];
        [cell setCollectionData:[self.proArr objectAtIndex:indexPath.row] andHeight:(kScreenWidth-10)/2*height];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.proArr.count>0)
    {
        NSDictionary *dic = [self.proArr objectAtIndex:indexPath.row];
        NSString *text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"ProductName"]];
        CGSize size = [Public getContentSizeWith:text andFontSize:13 andWidth:(kScreenWidth-15)/2-10];
        CGFloat itemH = (kScreenWidth-10)/2*[[dic objectForKey:@"Ratio"] floatValue]+size.height+35;
        CGSize size1 = CGSizeMake((kScreenWidth-10)/2, itemH);
        return size1;
    }
    return CGSizeMake(0, 0);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
    
    if ([kind isEqualToString:CHTCollectionElementKindSectionHeader])
    {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:HEADER_IDENTIFIER forIndexPath:indexPath];
        for (UIView *view in reusableView.subviews)
        {
            [view removeFromSuperview];
        }
        [self addHeaderView:reusableView];
    }
    return reusableView;
}
-(void)addHeaderView:(UIView *)contentView
{
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, HEADER_HEIGHT)];
    bgView.backgroundColor  =[UIColor whiteColor];
    bgView.layer.shadowColor = [UIColor lightGrayColor].CGColor;//shadowColor阴影颜色
    bgView.layer.shadowOffset = CGSizeMake(0,1);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    bgView.layer.shadowOpacity = 0.5;//阴影透明度，默认0
    bgView.layer.shadowRadius = 2;//阴影半径，默认3
    [contentView addSubview:bgView];
    
    UIImageView *tempView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth*0.5)];
//    tempView.backgroundColor  =[UIColor orangeColor];
    [tempView sd_setImageWithURL:[NSURL URLWithString:[self.infoDic objectForKey:@"Logo"]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [contentView addSubview:tempView];
    
    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(15, HEADER_HEIGHT-90, kScreenWidth, 20)];
    nameLab.text = [self.infoDic objectForKey:@"StoreName"];
    nameLab.textColor = [UIColor whiteColor];
    nameLab.font = [UIFont systemFontOfSize:16];
    [tempView addSubview:nameLab];
    

    NSString *level = [NSString stringWithFormat:@"%@",[self.infoDic objectForKey:@"StoreLeave"]];
    if ([level isEqualToString:@"8"])
    {
        UIImageView *localImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, tempView.height-20, 13, 13)];
        localImage.image = [UIImage imageNamed:@"location"];
        [tempView addSubview:localImage];
        
        UILabel *localLab = [[UILabel alloc] initWithFrame:CGRectMake(localImage.right+3, localImage.top-5, tempView.width-140, 20)];
        localLab.text = [self.infoDic objectForKey:@"StoreLocal"];
        localLab.textColor = [UIColor whiteColor];
        localLab.font = [UIFont systemFontOfSize:13];
        [tempView addSubview:localLab];
    }
    else
    {
        UILabel *describe = [[UILabel alloc] init];
        describe.textColor = [UIColor whiteColor];
        describe.font = [UIFont systemFontOfSize:13];
        describe.numberOfLines = 2;
        describe.text = [self.infoDic objectForKey:@"Description"];
        describe.frame =CGRectMake(15, nameLab.bottom, kScreenWidth-30, 26);
        [tempView addSubview:describe];
    }
    
    if (self.brandArr.count>0)
    {
        
        CGFloat beforeBtnWith=0;
        CGFloat totalWidth=0;
        for (int i=0; i<self.brandArr.count; i++)
        {
            NSString *brandName = [self.brandArr[i]objectForKey:@"BrandName"];

            CGSize btnSize = [Public getContentSizeWith:brandName andFontSize:13 andHigth:20];
            
            totalWidth = btnSize.width+10+totalWidth;
            
            if (totalWidth>kScreenWidth-62)
            {
                [self.brandArr removeLastObject];
                
                UIButton *brandBtn  =[UIButton buttonWithType:(UIButtonTypeCustom)];
                brandBtn.frame = CGRectMake(kScreenWidth-52-10, HEADER_HEIGHT-28, 56, 20);
                brandBtn.backgroundColor = kCustomColor(220, 221, 221);
                [brandBtn setTitle:@"更多品牌" forState:(UIControlStateNormal)];
                [brandBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
                brandBtn.titleLabel.font = [UIFont systemFontOfSize:13];
                brandBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
                [brandBtn addTarget:self action:@selector(didClickMoreBrand) forControlEvents:(UIControlEventTouchUpInside)];
                [bgView addSubview:brandBtn];

            }
            else
            {
                UIButton *btn  =[UIButton buttonWithType:(UIButtonTypeCustom)];
                btn.backgroundColor = kCustomColor(220, 221, 221);
                [btn setTitle:brandName forState:(UIControlStateNormal)];
                [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
                btn.titleLabel.font = [UIFont systemFontOfSize:13];
                btn.titleLabel.textAlignment = NSTextAlignmentCenter;
                btn.tag = i+100;
                [btn addTarget:self action:@selector(didClickBrand:) forControlEvents:(UIControlEventTouchUpInside)];
                
                btn.frame = CGRectMake(10*(i+1)+beforeBtnWith+2, HEADER_HEIGHT-28, btnSize.width+4, 20);
                [bgView addSubview:btn];
                beforeBtnWith = btnSize.width+beforeBtnWith;
            }
        }
    }
    
}

//更多品牌
-(void)didClickMoreBrand
{
    CusMoreBrandViewController *VC = [[CusMoreBrandViewController alloc] init];
    VC.storeId = [self.infoDic objectForKey:@"StoreId"];
    [self.navigationController pushViewController: VC animated:YES];
}

-(void)didClickBrand:(UIButton *)btn
{
    
}

//搜索
-(void)didClickSearchBtn
{
    HistorySearchViewController *search =[[HistorySearchViewController alloc]init];
    search.cityId =[[NSUserDefaults standardUserDefaults] objectForKey:@"cityId"]; //城市id
    //经纬度
    search.latitude=  [[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"];
    search.longitude= [[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"];
    search.storeId =self.storeId;
    [self.navigationController pushViewController:search animated:YES];
}


@end
