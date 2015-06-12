//
//  CusHomeStoreViewController.m
//  joybar
//
//  Created by 123 on 15/5/7.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "CusHomeStoreViewController.h"
#import "CustomCollectionViewLayout.h"
#import "CusFansViewController.h"
#import "CusCollectionViewController.h"
#import "CusCollectionViewCell.h"
#import "CusMyCircleTableViewCell.h"
#import "CusBuyerCircleViewController.h"
#import "HomeStoreData.h"
static NSInteger headerHeight = 300;

@interface CusHomeStoreViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, CustomCollectionViewLayoutDelegate,UIScrollViewDelegate>


@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) NSMutableArray *itemHeights;

@property (nonatomic ,strong) UIView *headerView;

@property (nonatomic ,strong) UIView *orangeLine;

@property (nonatomic ,strong)UITableView *circleTableView;

@property (nonatomic ,strong) HomeStoreData *storeData;

@end

@implementation CusHomeStoreViewController
{
    CustomCollectionViewLayout *layout;
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
    
    self.view.backgroundColor = kCustomColor(245, 246, 247);
    [self initializeDataSource];

    [self getData];
}

-(void)getData
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.userId forKey:@"userid"];
    [SVProgressHUD showInView:self.view WithY:64 andHeight:kScreenHeight];
    [HttpTool postWithURL:@"User/GetUserInfo" params:dic success:^(id json) {
        
        if ([[json objectForKey:@"isSuccessful"] boolValue])
        {
            self.storeData = [HomeStoreData objectWithKeyValues:[json objectForKey:@"data"]];
            [self initializeUserInterface];
            [self addHeaderView:self.collectionView];
            [self addNavBarViewAndTitle:self.userName];

            [self.collectionView reloadData];
        }
        else
        {
            
        }
        [SVProgressHUD dismiss];
        NSLog(@"message->%@",[json objectForKey:@"message"]);
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)addHeaderView:(UIScrollView *)contentView
{
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    self.headerView.backgroundColor = [UIColor whiteColor];
    [self.collectionView addSubview:self.headerView];
    
    UIImageView *headerImage = [[UIImageView alloc] init];
    headerImage.center = CGPointMake(kScreenWidth/2, 45);
    headerImage.bounds = CGRectMake(0, 0, 60, 60);
    headerImage.layer.cornerRadius = headerImage.width/2;
    [headerImage sd_setImageWithURL:[NSURL URLWithString:self.storeData.Logo] placeholderImage:nil];
    [self.headerView addSubview:headerImage];
    
    UILabel *namelab = [[UILabel alloc] initWithFrame:CGRectMake(0, headerImage.bottom+5, kScreenWidth, 20)];
    namelab.text = self.storeData.UserName;
    namelab.textAlignment = NSTextAlignmentCenter;
    namelab.font = [UIFont fontWithName:@"youyuan" size:17];
    [self.headerView addSubview:namelab];
    
    UILabel *locationLab = [[UILabel alloc] initWithFrame:CGRectMake(0, namelab.bottom+5, kScreenWidth, 20)];
    locationLab.text = self.storeData.Address;
    locationLab.textColor = [UIColor darkGrayColor];
    locationLab.textAlignment = NSTextAlignmentCenter;
    locationLab.font = [UIFont fontWithName:@"youyuan" size:13];
    [self.headerView addSubview:locationLab];
    
    UIView *btnBgView = [[UIView alloc] init];
    btnBgView.center = CGPointMake(kScreenWidth/2, locationLab.bottom+25);
    btnBgView.bounds = CGRectMake(0, 0, 180, 30);
    btnBgView.backgroundColor = [UIColor clearColor];
    [self.headerView addSubview:btnBgView];
    
    UIButton *chatBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    chatBtn.frame = CGRectMake(0, 0, 75, 30);
    [chatBtn setImage:[UIImage imageNamed:@"私聊white.png"] forState:(UIControlStateNormal)];
    [chatBtn setTitle:@"私聊" forState:(UIControlStateNormal)];
    chatBtn.backgroundColor = kCustomColor(25, 158, 162);
    [chatBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    chatBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    chatBtn.layer.cornerRadius = 4;
    [chatBtn addTarget:self action:@selector(didClickChat:) forControlEvents:(UIControlEventTouchUpInside)];
    [btnBgView addSubview:chatBtn];
    
    UIButton *attentionBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    attentionBtn.frame = CGRectMake(90+15, 0, 75, 30);
    
    if ([self.storeData.IsFollowing boolValue])
    {
        [attentionBtn setImage:nil forState:(UIControlStateNormal)];
        [attentionBtn setTitle:@"取消关注" forState:(UIControlStateNormal)];
        attentionBtn.backgroundColor = [UIColor grayColor];

    }
    else
    {
        [attentionBtn setImage:[UIImage imageNamed:@"关注white.png"] forState:(UIControlStateNormal)];
        [attentionBtn setTitle:@"关注" forState:(UIControlStateNormal)];
        attentionBtn.backgroundColor = kCustomColor(253, 162, 41);


    }
    [attentionBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    attentionBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    attentionBtn.layer.cornerRadius = 4;
    [attentionBtn addTarget:self action:@selector(didClickAttention:) forControlEvents:(UIControlEventTouchUpInside)];
    [btnBgView addSubview:attentionBtn];
    
    UIView *tempView = [[UIView alloc] init];
    tempView.center = CGPointMake(kScreenWidth/2, btnBgView.bottom+43);
    tempView.bounds = CGRectMake(0, 0, 240, 70);
    [self.headerView addSubview:tempView];
    
    NSArray *nameArr = @[@"关注",@"粉丝",@"圈子"];
    NSArray *numArr = @[self.storeData.FollowingCount,self.storeData.FollowerCount,self.storeData.CommunityCount];
    for (int i=0; i<3; i++)
    {
        UIButton *circleBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        circleBtn.frame = CGRectMake(tempView.width/3*i, 0, 80, 70);
        circleBtn.adjustsImageWhenHighlighted = NO;
        [circleBtn setImage:[UIImage imageNamed:@"圆.png"] forState:(UIControlStateNormal)];
        circleBtn.tag = 1000+i;
        [circleBtn addTarget:self action:@selector(didClickCircleBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        [tempView addSubview:circleBtn];
        
        UILabel *numLab = [[UILabel alloc] init];
        numLab.center = CGPointMake(circleBtn.width/2, circleBtn.height/2-10);
        numLab.bounds = CGRectMake(0, 0, 30, 13);
        numLab.font = [UIFont fontWithName:@"youyuan" size:12];
        numLab.textColor = [UIColor darkGrayColor];
        numLab.textAlignment = NSTextAlignmentCenter;
        numLab.text = [numArr objectAtIndex:i];
        [circleBtn addSubview:numLab];
        
        UILabel *titleLab = [[UILabel alloc] init];
        titleLab.center = CGPointMake(circleBtn.width/2, circleBtn.height/2+5);
        titleLab.bounds = CGRectMake(0, 0, 30, 20);
        titleLab.font = [UIFont fontWithName:@"youyuan" size:14];
        titleLab.textColor = [UIColor grayColor];
        titleLab.text = [nameArr objectAtIndex:i];
        titleLab.textAlignment = NSTextAlignmentCenter;
        [circleBtn addSubview:titleLab];
    }
    
    UILabel *descLab = [[UILabel alloc] init];
    descLab.text = self.storeData.Description;
    CGSize size = [self getContentSizeWith:descLab.text];
    descLab.numberOfLines = 0;
    descLab.font = [UIFont fontWithName:@"youyuan" size:14];
    descLab.textColor = [UIColor darkGrayColor];
    descLab.frame = CGRectMake(10, tempView.bottom+10, kScreenWidth-20, size.height);
    [self.headerView addSubview:descLab];
    
    headerHeight = size.height+320;
    self.headerView.frame = CGRectMake(0, -headerHeight, kScreenWidth, headerHeight);
    self.collectionView.contentInset = UIEdgeInsetsMake(headerHeight, 0, 0, 0);
    
    NSArray *btnNameArr = @[[NSString stringWithFormat:@"商品 %@",self.storeData.GoodCount],[NSString stringWithFormat:@"上新 %@",self.storeData.NewProductCount]];
    for (int i=0; i<btnNameArr.count; i++)
    {
        UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        btn.frame = CGRectMake(kScreenWidth/btnNameArr.count*i, self.headerView.height-40, kScreenWidth/btnNameArr.count-1, 40);
        btn.backgroundColor = [UIColor clearColor];
        [btn setTitle:[btnNameArr objectAtIndex:i] forState:(UIControlStateNormal)];
        [btn setTitleColor:[UIColor darkGrayColor] forState:(UIControlStateNormal)];
        [btn addTarget:self action:@selector(didClickclassify:) forControlEvents:(UIControlEventTouchUpInside)];
        btn.tag = 100+i;
        btn.titleLabel.font = [UIFont fontWithName:@"youyuan" size:14];
        [self.headerView addSubview:btn];
        
        UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth/btnNameArr.count*i, self.headerView.height-35, 1, 30)];
        verticalLine.backgroundColor = kCustomColor(239, 239, 239);
        [self.headerView addSubview:verticalLine];
    }
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.headerView.height, kScreenWidth, 0.5)];
    line.backgroundColor = kCustomColor(239, 239, 239);
    [self.headerView addSubview:line];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, self.headerView.height-40, kScreenWidth, 0.5)];
    line1.backgroundColor = kCustomColor(239, 239, 239);
    [self.headerView addSubview:line1];
    
    self.orangeLine = [[UIView alloc] initWithFrame:CGRectMake(20, self.headerView.height-2, kScreenWidth/btnNameArr.count-40, 2)];
    self.orangeLine.backgroundColor = [UIColor orangeColor];
    [self.headerView addSubview:self.orangeLine];
    
}

- (void)initializeDataSource {
    
    _dataSource = [[NSMutableArray alloc] init];
    _itemHeights = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 10; i ++) {
        
        [_dataSource addObject:@"1"];
        CGFloat itemHeight = arc4random() % 200 + 200;
        [_itemHeights addObject:@(itemHeight)];
    }
}

- (void)initializeUserInterface {
    
    layout = [[CustomCollectionViewLayout alloc] init];
    layout.layoutDelegate = self;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
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
    
    cell.backgroundColor = [UIColor yellowColor];
    
    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    [cell setCollectionData:nil andHeight:[_itemHeights[indexPath.row] intValue]];
    
    return cell;
}


#pragma mark - UICollectionViewDelegate

#pragma mark - CustomCollectionViewLayoutDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView collectionViewLayout:(CustomCollectionViewLayout *)collectionViewLayout sizeOfItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = [Public getContentSizeWith:@"啊实打实大师大师阿萨帝爱上啊实打实大师大师阿萨帝爱上啊实打实大师大师阿萨帝爱上" andFontSize:13 andWidth:(kScreenWidth-15)/2-10];
    
    return CGSizeMake((kScreenWidth-15)/2, [_itemHeights[indexPath.row] floatValue]+size.height+35);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kScreenWidth,70);
}


//点击私聊
-(void)didClickChat:(UIButton *)btn
{
    
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
    [HttpTool postWithURL:@"User/Favoite" params:dic success:^(id json) {
        
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

//点击圆形的button
-(void)didClickCircleBtn:(UIButton *)btn
{
    switch (btn.tag)
    {
        case 1000:
        {
            CusFansViewController *VC = [[CusFansViewController alloc] init];
            VC.titleStr = @"关注的人";
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        case 1001:
        {
            CusFansViewController *VC = [[CusFansViewController alloc] init];
            VC.titleStr = @"粉丝";
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        case 1002:
        {
            //圈子
            CusBuyerCircleViewController *VC = [[CusBuyerCircleViewController alloc] init];
            [self.navigationController pushViewController:VC animated:YES];
            
        }
            break;
        default:
            break;
    }
}

//点击3个button
-(void)didClickclassify:(UIButton *)btn
{
    NSInteger btnTag = btn.tag;
    if (btnTag==100)
    {
        self.orangeLine.frame =CGRectMake(20, self.headerView.height-2, kScreenWidth/2-40, 2);
    }
    else if (btnTag==101)
    {
        self.orangeLine.frame =CGRectMake(kScreenWidth/2+20, self.headerView.height-2, kScreenWidth/2-40, 2);
    }
}

-(CGSize)getContentSizeWith:(NSString *)content
{
    CGSize size = [content sizeWithFont:[UIFont fontWithName:@"youyuan" size:14] constrainedToSize:CGSizeMake(kScreenWidth-20, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    
    return size;
}

@end
