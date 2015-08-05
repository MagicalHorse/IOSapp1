//
//  CusTagViewController.m
//  joybar
//
//  Created by 123 on 15/4/28.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "CusTagViewController.h"
#import "MJRefresh.h"
#import "CusBuyerDetailViewController.h"
@interface CusTagViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>

@property (nonatomic ,strong) NSMutableArray *tagArr;

@property (nonatomic ,assign) NSInteger pageNum;

@property (nonatomic ,strong) UICollectionView *collectionView;

@end


@implementation CusTagViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pageNum = 1;
    self.tagArr = [NSMutableArray array];
    
    self.view.backgroundColor = kCustomColor(234, 239, 239);
    
    UICollectionViewFlowLayout*layout = [[UICollectionViewFlowLayout alloc]init];
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64) collectionViewLayout:layout];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    self.collectionView.contentInset= UIEdgeInsetsMake(5, 5, 5, 5);
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.view addSubview:self.collectionView];

//    self.collectionView.headerHidden = NO;

    [self addNavBarViewAndTitle:self.BrandName];
    
    [self getData:NO];

    //    // 2.集成刷新控件
//        [self addHeader];
        [self addFooter];

}

//- (void)addHeader
//{
//    __weak CusTagViewController* vc = self;
//    // 添加下拉刷新头部控件
//    [self.collectionView addHeaderWithCallback:^{
//        vc.pageNum = 1;
//        [vc.tagArr removeAllObjects];
//        [vc getData:YES];
//
//    }];
//
//    [self.collectionView headerBeginRefreshing];
//}

- (void)addFooter
{
    __weak CusTagViewController *vc = self;
    // 添加上拉刷新尾部控件
    [self.collectionView addFooterWithCallback:^{
        vc.pageNum++;
        [vc getData:YES];
    }];
}

-(void)getData:(BOOL)isRefresh
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:self.BrandId forKey:@"BrandId"];
//    [dic setValue:self.BrandName forKey:@"Name"];
    [dic setValue:[NSString stringWithFormat:@"%ld",(long)self.pageNum] forKey:@"Page"];
    [dic setValue:@"24" forKey:@"PageSize"];
    [self hudShow];
    [HttpTool postWithURL:@"Product/GetProductListByBrandId" params:dic success:^(id json) {

        [self.tagArr removeAllObjects];
        [self hiddleHud];
        if ([[json objectForKey:@"isSuccessful"] boolValue])
        {
            NSArray *arr = [[json objectForKey:@"data"] objectForKey:@"items"];
            
            if (arr.count<24)
            {
                self.collectionView.footerHidden = YES;
            }
            else
            {
                self.collectionView.footerHidden = NO;
            }
            [self.tagArr addObjectsFromArray:arr];
            [self.collectionView reloadData];
        }
        else
        {
            [self showHudFailed:[json objectForKey:@"message"]];
        }
//        [self.collectionView headerEndRefreshing];
        [self.collectionView footerEndRefreshing];

    } failure:^(NSError *error) {

        [self hiddleHud];
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.tagArr.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *proId = [[self.tagArr objectAtIndex:indexPath.row] objectForKey:@"ProductId"];
    CusBuyerDetailViewController *VC = [[CusBuyerDetailViewController alloc] init];
    VC.productId = proId;
    [self.navigationController pushViewController:VC animated:YES];

}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    if (cell==nil)
    {
        cell = [[UICollectionViewCell alloc]init];
    }
    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    UIImageView *tagImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, cell.bounds.size.width, cell.bounds.size.height)];
    NSString *imageURL = [NSString stringWithFormat:@"%@",[[self.tagArr objectAtIndex:indexPath.row] objectForKey:@"Pic"]];
    [tagImage sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    [cell.contentView addSubview:tagImage];
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((kScreenWidth-20)/3,(kScreenWidth-20)/3);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

@end
