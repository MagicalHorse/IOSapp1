//
//  FindShopGuideViewController.m
//  joybar
//
//  Created by joybar on 15/11/23.
//  Copyright © 2015年 卢兴. All rights reserved.
//

#import "FindShopGuideViewController.h"
#import "HJCarouselViewLayout.h"
#import "HJCarouselViewCell.h"
@interface FindShopGuideViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic ,strong) UILabel *lineLab;
@property (nonatomic ,strong)UICollectionView *cusCollectView;
@end
static NSString * const reuseIdentifier = @"Cell";

@implementation FindShopGuideViewController{
    UIView *tempView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavBarViewAndTitle:@""];
    self.retBtn.hidden = YES;
    tempView = [[UIView alloc] initWithFrame:CGRectMake(75, 0, kScreenWidth-150, 64)];
    tempView.backgroundColor = [UIColor clearColor];
    tempView.center = self.navView.center;
    [self.navView addSubview:tempView];
    
    NSArray *nameArr = @[@"导购",@"关注"];
    for (int i=0; i<2; i++)
    {
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(tempView.width/2*i, 18, tempView.width/2, 50)];
        lab.userInteractionEnabled = YES;
        lab.font = [UIFont systemFontOfSize:15];
        lab.backgroundColor = [UIColor clearColor];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = [UIColor grayColor];
        lab.text = [nameArr objectAtIndex:i];
        lab.tag=1000+i;
        [tempView addSubview:lab];
        if (i==0)
        {
            lab.textColor = [UIColor orangeColor];
            lab.font = [UIFont systemFontOfSize:17];
            
            self.lineLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 3)];
            self.lineLab.center = CGPointMake(lab.center.x, 63);
            self.lineLab.backgroundColor = [UIColor orangeColor];
            [tempView addSubview:self.lineLab];
        }
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelect:)];
        [lab addGestureRecognizer:tap];
    }
    
    HJCarouselViewLayout *layout  = [[HJCarouselViewLayout alloc] initWithAnim:HJCarouselAnimLinear];
    layout.itemSize = CGSizeMake(kScreenWidth-70, kScreenHeight-168);
    layout.scrollDirection =UICollectionViewScrollDirectionHorizontal;
    
    _cusCollectView =[[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64-49) collectionViewLayout:layout];
    _cusCollectView.dataSource =self;
    _cusCollectView.delegate =self;
    _cusCollectView.showsHorizontalScrollIndicator = NO;
    _cusCollectView.showsVerticalScrollIndicator = NO;
    _cusCollectView.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:_cusCollectView];
    [self.cusCollectView registerNib:[UINib nibWithNibName:NSStringFromClass([HJCarouselViewCell class]) bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
}

- (NSIndexPath *)curIndexPath {
    NSArray *indexPaths = [self.cusCollectView indexPathsForVisibleItems];
    NSIndexPath *curIndexPath = nil;
    NSInteger curzIndex = 0;
    for (NSIndexPath *path in indexPaths.objectEnumerator) {
        UICollectionViewLayoutAttributes *attributes = [self.cusCollectView layoutAttributesForItemAtIndexPath:path];
        if (!curIndexPath) {
            curIndexPath = path;
            curzIndex = attributes.zIndex;
            continue;
        }
        if (attributes.zIndex > curzIndex) {
            curIndexPath = path;
            curzIndex = attributes.zIndex;
        }
    }
    return curIndexPath;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *curIndexPath = [self curIndexPath];
    if (indexPath.row == curIndexPath.row) {
        return YES;
    }
    
    [self.cusCollectView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    
    return NO;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"click %ld", indexPath.row);
}

#pragma mark <UICollectionViewDataSource>
//定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HJCarouselViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    return cell;
}


-(void)didSelect:(UITapGestureRecognizer *)tap
{
    if (tap.view.tag==1000)
    {
        [self scrollToMessage];
    }
    else
    {
        [self scrollToDynamic];
    }
}

//导购
-(void)scrollToMessage
{
    UILabel *lab1 = (UILabel *)[tempView viewWithTag:1000];
    UILabel *lab2 = (UILabel *)[tempView viewWithTag:1001];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.lineLab.center = CGPointMake(lab1.center.x, 63);
    }];
    lab1.textColor = [UIColor orangeColor];
    lab1.font = [UIFont systemFontOfSize:17];
    lab2.textColor = [UIColor grayColor];
    lab2.font = [UIFont systemFontOfSize:15];
}

//关注
-(void)scrollToDynamic
{
    UILabel *lab1 = (UILabel *)[tempView viewWithTag:1000];
    UILabel *lab2 = (UILabel *)[tempView viewWithTag:1001];
    [UIView animateWithDuration:0.25 animations:^{
        self.lineLab.center = CGPointMake(lab2.center.x, 63);
    }];
    lab2.textColor = [UIColor orangeColor];
    lab2.font = [UIFont systemFontOfSize:17];
    lab1.textColor = [UIColor grayColor];
    lab1.font = [UIFont systemFontOfSize:15];
    
}


@end
