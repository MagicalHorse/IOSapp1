//
//  CusHomeStoreViewController.m
//  joybar
//
//  Created by 123 on 15/5/7.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "CusHomeStoreViewController.h"
#import "CusHomeStoreCollectionViewCell.h"
#import "HomeStoreData.h"
#import "MJRefresh.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "CusHomeStoreHeader.h"
#import "CusChatViewController.h"
#import "CusRProDetailViewController.h"
#define CELL_COUNT 30
#define HEADER_IDENTIFIER @"WaterfallHeader"

@interface CusHomeStoreViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, CHTCollectionViewDelegateWaterfallLayout,UIScrollViewDelegate,handleCollectDelegate>


@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) NSMutableArray *itemHeights;


@property (nonatomic ,strong)UITableView *circleTableView;

@property (nonatomic ,strong) HomeStoreData *storeData;

@property (nonatomic ,assign) NSInteger pageNum;

@end

@implementation CusHomeStoreViewController
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"%@",self.userId);
    
    [self getData];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dataSource = [NSMutableArray array];
    self.pageNum = 1;
    self.view.backgroundColor = kCustomColor(245, 246, 247);
//    [self addNavBarViewAndTitle:self.userName];
    [self initializeUserInterface];
    // 2.集成刷新控件
    [self addHeader];
    [self addFooter];
    
    UIButton *chatBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    chatBtn.frame = CGRectMake(0, kScreenHeight-40, kScreenWidth, 40);
    chatBtn.backgroundColor =[UIColor orangeColor];
    [chatBtn setTitle:@"私聊" forState:(UIControlStateNormal)];
    [chatBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    chatBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [chatBtn addTarget:self action:@selector(didClickChat:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:chatBtn];
}

- (void)addHeader
{
    __weak CusHomeStoreViewController* vc = self;
    // 添加下拉刷新头部控件
    [self.collectionView addHeaderWithCallback:^{
        [vc.dataSource removeAllObjects];
        vc.pageNum = 1;
        [vc getProListData];
    }];

//    [self.collectionView headerBeginRefreshing];
}

- (void)addFooter
{
    __weak CusHomeStoreViewController *vc = self;
    // 添加上拉刷新尾部控件
    [self.collectionView addFooterWithCallback:^{
        vc.pageNum++;
        [vc getProListData];
    }];
}

-(void) getProListData
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *ID = [[Public getUserInfo] objectForKey:@"id"];
    if (ID)
    {
        [dic setObject:ID forKey:@"userid"];
    }
    else
    {
        [dic setObject:@"0" forKey:@"userid"];
    }
    [dic setValue:self.userId forKey:@"buyerId"];
    [dic setObject:[NSString stringWithFormat:@"%ld",(long)self.pageNum] forKey:@"page"];
    [dic setObject:@"20" forKey:@"pagesize"];
    [self hudShow];
    [HttpTool postWithURL:@"V3/GetBuyerProduct" params:dic success:^(id json) {
        
        if ([[json objectForKey:@"isSuccessful"] boolValue])
        {
            NSArray *arr = [[json objectForKey:@"data"] objectForKey:@"items"];
            if (arr.count<20)
            {
                self.collectionView.footerHidden = YES;
            }
            else
            {
                self.collectionView.footerHidden = NO;
            }
            [self.dataSource addObjectsFromArray:arr];
            
            [self.collectionView reloadData];
            [self.collectionView headerEndRefreshing];
            [self.collectionView footerEndRefreshing];
        }
        else
        {
            [self showHudFailed:[json objectForKey:@"message"]];
        }
        [self hiddleHud];
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)getData
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.userId forKey:@"userid"];

    [HttpTool postWithURL:@"User/GetUserInfo" params:dic success:^(id json) {
        
        if ([[json objectForKey:@"isSuccessful"] boolValue])
        {
            self.storeData = [HomeStoreData objectWithKeyValues:[json objectForKey:@"data"]];
            CGSize size = [Public getContentSizeWith:self.storeData.Description andFontSize:14 andWidth:kScreenWidth-20];
            CGFloat height = size.height+125;
            layout.headerHeight = height;
            [self getProListData];

            [self.collectionView reloadData];
        }
        else
        {
            [self showHudFailed:[json objectForKey:@"message"]];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)addHeaderView:(UIView *)contentView
{
    UIImageView *headerImage = [[UIImageView alloc] init];
//    headerImage.center = CGPointMake(kScreenWidth/2, 45);
//    headerImage.bounds = CGRectMake(0, 0, 60, 60);
    headerImage.frame = CGRectMake(10, 10, 60, 60);
    headerImage.layer.cornerRadius = headerImage.width/2;
    headerImage.clipsToBounds = YES;
    [headerImage sd_setImageWithURL:[NSURL URLWithString:self.storeData.Logo] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    [contentView addSubview:headerImage];
    
    UILabel *namelab = [[UILabel alloc] initWithFrame:CGRectMake(headerImage.right+5, headerImage.top, kScreenWidth, 20)];
    namelab.text = self.storeData.UserName;
    namelab.font = [UIFont systemFontOfSize:15];
    [contentView addSubview:namelab];
    
    UILabel *brandLab = [[UILabel alloc] initWithFrame:CGRectMake(headerImage.right+5, namelab.bottom, kScreenWidth, 20)];
    brandLab.text = self.storeData.SectionName;
    brandLab.font = [UIFont systemFontOfSize:14];
    [contentView addSubview:brandLab];
    
    UILabel *fanCount = [[UILabel alloc] initWithFrame:CGRectMake(headerImage.right+5, brandLab.bottom, kScreenWidth-90, 20)];
    fanCount.font = [UIFont systemFontOfSize:13];
    fanCount.textColor = [UIColor grayColor];
    fanCount.text = [NSString stringWithFormat:@"粉丝 %@   商品 %@",self.storeData.FollowerCount,self.storeData.ProductCount];
    [contentView addSubview:fanCount];
    
    UIButton *attentionBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    attentionBtn.frame = CGRectMake(kScreenWidth-90, brandLab.top, 65, 30);
    attentionBtn.layer.cornerRadius = 3;
    if ([self.storeData.IsFollowing boolValue])
    {
        [attentionBtn setTitle:@"已关注" forState:(UIControlStateNormal)];
        attentionBtn.backgroundColor = [UIColor grayColor];
    }
    else
    {
        [attentionBtn setTitle:@"关注" forState:(UIControlStateNormal)];
        attentionBtn.backgroundColor = [UIColor orangeColor];
    }
    [attentionBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    attentionBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [attentionBtn addTarget:self action:@selector(didClickAttention:) forControlEvents:(UIControlEventTouchUpInside)];
    [contentView addSubview:attentionBtn];
    
    UIImageView *localImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, fanCount.bottom+13, 12, 12)];
    localImage.image = [UIImage imageNamed:@"location"];
    [contentView addSubview:localImage];

    UILabel *localLab = [[UILabel alloc] initWithFrame:CGRectMake(localImage.right+3, fanCount.bottom+10, kScreenWidth-35, 20)];
    localLab.text = self.storeData.Address;
    localLab.textColor = [UIColor grayColor];
    localLab.font = [UIFont systemFontOfSize:13];
    [contentView addSubview:localLab];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(10, localLab.bottom+5, kScreenWidth-20, 1)];
    line1.backgroundColor = kCustomColor(220, 220, 220);
    [contentView addSubview:line1];
    
    UILabel *descLab = [[UILabel alloc] init];
    descLab.text = self.storeData.Description;
    if ([self.storeData.Description isEqualToString:@""])
    {
        descLab.text = @"这家伙很懒,什么也没写";
    }
    //    descLab.text = @"啊实打实的哪算了健康的那是健康的纳税会计的那是离开你打算看见的哪凉快的纳税款到哪里看的那是单身的";
    CGSize size = [Public getContentSizeWith:descLab.text andFontSize:14 andWidth:kScreenWidth-20];
    descLab.numberOfLines = 0;
    descLab.font = [UIFont systemFontOfSize:14];
    descLab.textColor = [UIColor darkGrayColor];
    descLab.frame = CGRectMake(10, line1.bottom+10, kScreenWidth-20, size.height);
    [contentView addSubview:descLab];
}

- (void)initializeUserInterface
{
    layout = [[CHTCollectionViewWaterfallLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    layout.minimumColumnSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-40) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.alwaysBounceVertical = YES; //垂直方向遇到边框是否总是反弹
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[CusHomeStoreCollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    [_collectionView registerClass:[CusHomeStoreHeader class]
        forSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader
               withReuseIdentifier:HEADER_IDENTIFIER];
    [self.view addSubview:_collectionView];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{    
    CusHomeStoreCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    if (cell==nil)
    {
        cell = [[CusHomeStoreCollectionViewCell alloc]init];
    }
    cell.delegate = self;

    cell.backgroundColor = [UIColor yellowColor];
    
    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    if (self.dataSource.count>0)
    {
        float height = [[[[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"pic"] objectForKey:@"Ratio"] floatValue];
        
        [cell setCollectionData:[self.dataSource objectAtIndex:indexPath.row] andHeight:(kScreenWidth-10)/2*height];
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CusRProDetailViewController *VC = [[CusRProDetailViewController alloc] init];
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

//点击私聊
-(void)didClickChat:(UIButton *)btn
{
    CusChatViewController * chat= [[CusChatViewController alloc]initWithUserId:self.userId AndTpye:1 andUserName:self.userName];
    chat.isFrom =isFromPrivateChat;
    [self.navigationController pushViewController:chat animated:YES];
}

//点击关注
-(void)didClickAttention:(UIButton *)btn
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.userId forKey:@"FavoriteId"];
    if ([btn.titleLabel.text isEqualToString:@"关注"])
    {
        [dic setObject:@"1" forKey:@"Status"];
    }
    else
    {
        [dic setObject:@"0" forKey:@"Status"];
    }
    [HttpTool postWithURL:@"User/Favoite" params:dic isWrite:YES success:^(id json) {
        
        if ([[json objectForKey:@"isSuccessful"]boolValue])
        {
            if ([btn.titleLabel.text isEqualToString:@"关注"])
            {
                [btn setImage:nil forState:(UIControlStateNormal)];
                [btn setTitle:@"取消关注" forState:(UIControlStateNormal)];
                btn.backgroundColor = [UIColor grayColor];
            }
            else
            {
                [btn setImage:[UIImage imageNamed:@"关注white.png"] forState:(UIControlStateNormal)];
                [btn setTitle:@"关注" forState:(UIControlStateNormal)];
                btn.backgroundColor = kCustomColor(253, 162, 41);
            }
        }
        else
        {
            NSLog(@"%@",[json objectForKey:@"message"]);
        }
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)collectHandle
{
    self.pageNum = 1;
    [self.dataSource removeAllObjects];
    [self getProListData];
}

@end
