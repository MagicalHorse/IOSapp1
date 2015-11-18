//
//  CusMarketViewController.m
//  joybar
//
//  Created by 123 on 15/11/16.
//  Copyright © 2015年 卢兴. All rights reserved.
//

#import "CusMarketViewController.h"
#import "MJRefresh.h"
#import "CusBuyerDetailViewController.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "CusHomeStoreCollectionViewCell.h"
#import "CusHomeStoreHeader.h"
#import "CusMoreBrandViewController.h"
#define HEADER_IDENTIFIER @"WaterfallHeader"
#define HEADER_HEIGHT [UIScreen mainScreen].bounds.size.width*0.618+35
@interface CusMarketViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,CHTCollectionViewDelegateWaterfallLayout>

@property (nonatomic ,strong) UICollectionView *collectionView;


@end

@implementation CusMarketViewController

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
    [self addNavBarViewAndTitle:@"品牌名"];
    CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    layout.minimumColumnSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    layout.headerHeight = HEADER_HEIGHT;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) collectionViewLayout:layout];
    _collectionView.backgroundColor = kCustomColor(238, 233, 240);
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[CusHomeStoreCollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    [_collectionView registerClass:[CusHomeStoreHeader class]
        forSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader
               withReuseIdentifier:HEADER_IDENTIFIER];
    [self.view addSubview:_collectionView];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 20;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *proId = @"";
    CusBuyerDetailViewController *VC = [[CusBuyerDetailViewController alloc] init];
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
    
    //    float height = [[[[self.tagArr objectAtIndex:indexPath.row] objectForKey:@"pic"] objectForKey:@"Ratio"] floatValue];
    //
    //    [cell setCollectionData:[self.tagArr objectAtIndex:indexPath.row] andHeight:(kScreenWidth-10)/2*height];
    
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSDictionary *dic = [self.tagArr objectAtIndex:indexPath.row];
    //    NSString *text = [dic objectForKey:@"Name"];
    //    CGSize size = [Public getContentSizeWith:text andFontSize:13 andWidth:(kScreenWidth-15)/2-10];
    //    CGFloat itemH = (kScreenWidth-10)/2*[[[dic objectForKey:@"pic"] objectForKey:@"Ratio"] floatValue]+size.height+35;
    //
    CGSize size1 = CGSizeMake((kScreenWidth-10)/2, 200);
    
    return size1;
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
    
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth*0.618)];
    tempView.backgroundColor  =[UIColor orangeColor];
    [contentView addSubview:tempView];
    
    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(15, HEADER_HEIGHT-100, kScreenWidth, 20)];
    nameLab.text = @"商场名称";
    nameLab.textColor = [UIColor whiteColor];
    nameLab.font = [UIFont systemFontOfSize:16];
    [tempView addSubview:nameLab];
    
    UILabel *describe = [[UILabel alloc] init];
    describe.textColor = [UIColor whiteColor];
    describe.font = [UIFont systemFontOfSize:13];
    describe.numberOfLines = 2;
    describe.text = @"啊实打实大师大实打实大大叔大大声地阿萨德asdasdasdasdadasdasda叔大大声地阿萨德asdasdasdasdadasdasdasdasd";
    CGSize size = [Public getContentSizeWith:describe.text andFontSize:13 andWidth:kScreenWidth-30];
    describe.frame =CGRectMake(15, nameLab.bottom, kScreenWidth-30, size.height);
    [tempView addSubview:describe];
    
    UIButton *brandBtn  =[UIButton buttonWithType:(UIButtonTypeCustom)];
    brandBtn.frame = CGRectMake(kScreenWidth-52-10, HEADER_HEIGHT-28, 56, 20);
    brandBtn.backgroundColor = kCustomColor(220, 221, 221);
    [brandBtn setTitle:@"更多品牌" forState:(UIControlStateNormal)];
    [brandBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    brandBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    brandBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [brandBtn addTarget:self action:@selector(didClickMoreBrand) forControlEvents:(UIControlEventTouchUpInside)];
    
    [bgView addSubview:brandBtn];
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:@[@"only",@"asd",@"asdasda",@"阿打算打算",@"asdaasda",@"asdasda",@"asdasdasd"]];
    CGFloat beforeBtnWith=0;
    CGFloat totalWidth=0;
    for (int i=0; i<arr.count; i++)
    {
        CGSize btnSize = [Public getContentSizeWith:arr[i] andFontSize:13 andHigth:20];

        totalWidth = btnSize.width+10+totalWidth;
        
        
        if (totalWidth>kScreenWidth-62)
        {
            [arr removeLastObject];
        }
        else
        {
            UIButton *btn  =[UIButton buttonWithType:(UIButtonTypeCustom)];
            btn.backgroundColor = kCustomColor(220, 221, 221);
            [btn setTitle:arr[i] forState:(UIControlStateNormal)];
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

//更多品牌
-(void)didClickMoreBrand
{
    CusMoreBrandViewController *VC = [[CusMoreBrandViewController alloc] init];
    [self.navigationController pushViewController: VC animated:YES];
}

-(void)didClickBrand:(UIButton *)btn
{
    
}


@end
