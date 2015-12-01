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
#import "HJConcernCell.h"
#import "HJHeaderViewCell.h"
#import "HistorySearchViewController.h"

@interface FindShopGuideViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic ,strong) UILabel *lineLab;
@property (nonatomic ,strong)UICollectionView *cusCollectView;
@property (nonatomic ,strong)UICollectionView *cusCollectView1;
@property (nonatomic ,strong)UICollectionView *cusCollectView2;
@property (nonatomic ,strong)NSMutableArray *dataArray;
@property (nonatomic ,strong)NSMutableArray *dataArray1;
@property (nonatomic ,strong)NSMutableArray *dataArray2;



@property (nonatomic ,strong) UIScrollView *messageScroll;

@end
static NSString * const reuseIdentifier = @"Cell";

@implementation FindShopGuideViewController{
    UIView *tempView;
    BOOL isRefresh;
    BOOL isRefresh1;
    int type;
    UILabel *adLabel;
    UILabel *countLabel;

}
-(NSMutableArray *)dataArray{
    if (_dataArray ==nil) {
        _dataArray =[NSMutableArray array];
    }
    return _dataArray;
}
-(NSMutableArray *)dataArray1{
    if (_dataArray1 ==nil) {
        _dataArray1 =[NSMutableArray array];
    }
    return _dataArray1;
}
-(NSMutableArray *)dataArray2{
    if (_dataArray2 ==nil) {
        _dataArray2 =[NSMutableArray array];
    }
    return _dataArray2;
}

-(void)setData{
    
    if (isRefresh||isRefresh1) {
        [self showInView:self.view WithPoint:CGPointMake(0, 64) andHeight:kScreenHeight-64];
    }
   
    
    NSString *url;
    if (type==1) {
        url =@"BuyerV3/RecommondBuyerlist";
    }else{
        url =@"/BuyerV3/FavBuyers";
    }
    NSMutableDictionary *dict =[[NSMutableDictionary alloc]init];
    [dict setValue:[NSString stringWithFormat:@"%d",1] forKey:@"Page"];
    [dict setObject:@"20" forKey:@"Pagesize"];

    [HttpTool postWithURL:url params:dict  success:^(id json) {
        BOOL  isSuccessful =[[json objectForKey:@"isSuccessful"] boolValue];
        if (isSuccessful) {
            NSMutableArray *array =[[json objectForKey:@"data"]objectForKey:@"Buyers"];
            if (type ==1) {
                self.dataArray =array;
                isRefresh=NO;
                [self.cusCollectView reloadData];
                

            }else if(type ==2){
                self.dataArray1 =array;
                isRefresh1=NO;
                [self.cusCollectView2 reloadData];
                [self setDataForStore];

            }
            
        }else{
            [self showHudFailed:[json objectForKey:@"message"]];
        }

        [self activityDismiss];
        
    } failure:^(NSError *error) {
        [self showHudFailed:@"服务器正在维护,请稍后再试"];
        [self activityDismiss];
        
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    CGFloat x =self.lineLab.frame.origin.x;
    if (x>50) {
        self.messageScroll.contentOffset = CGPointMake(kScreenWidth, 0);
    }else{
        self.messageScroll.contentOffset = CGPointMake(0, 0);
    }
}

-(void)didClickCancelBtn{
    HistorySearchViewController *history =[[HistorySearchViewController alloc]init];
    history.clickType=@"FindShopGuideViewController";
    [self.navigationController pushViewController:history animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavBarViewAndTitle:@""];
    self.retBtn.hidden = YES;
    isRefresh=YES;
    isRefresh1=YES;

    type=1;
    tempView = [[UIView alloc] initWithFrame:CGRectMake(75, 0, kScreenWidth-150, 64)];
    tempView.backgroundColor = [UIColor clearColor];
    tempView.center = self.navView.center;
    [self.navView addSubview:tempView];
    
    UIButton *cancelBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    cancelBtn.frame = CGRectMake(kScreenWidth-35, 25, 30, 30);
    [cancelBtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelBtn addTarget:self action:@selector(didClickCancelBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.navView addSubview:cancelBtn];

    
    
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
    
    self.messageScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64)];
    self.messageScroll.alwaysBounceVertical = NO;
    self.messageScroll.pagingEnabled = YES;
    self.messageScroll.delegate = self;
    self.messageScroll.directionalLockEnabled = YES;
    self.messageScroll.showsHorizontalScrollIndicator = NO;
    self.messageScroll.bounces = NO;
    [self.view addSubview:self.messageScroll];

    
    
    HJCarouselViewLayout *layout  = [[HJCarouselViewLayout alloc] initWithAnim:HJCarouselAnimLinear];
    layout.itemSize = CGSizeMake(kScreenWidth-70, kScreenHeight-168);
    layout.scrollDirection =UICollectionViewScrollDirectionHorizontal;
    
    _cusCollectView =[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-49) collectionViewLayout:layout];
    self.cusCollectView.tag =2001;

    _cusCollectView.dataSource =self;
    _cusCollectView.delegate =self;
    _cusCollectView.showsHorizontalScrollIndicator = NO;
    _cusCollectView.showsVerticalScrollIndicator = NO;
    _cusCollectView.backgroundColor = kCustomColor(228, 234, 238);
    [self.messageScroll addSubview:_cusCollectView];
    [self.cusCollectView registerNib:[UINib nibWithNibName:NSStringFromClass([HJCarouselViewCell class]) bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    //关注
    UIView *gzView =[[UIView alloc]initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth*2, kScreenHeight)];
    gzView.backgroundColor =kCustomColor(228, 234, 238);
    [self.messageScroll addSubview:gzView];
    
    HJCarouselViewLayout *layout1  = [[HJCarouselViewLayout alloc] initWithAnim:HJCarouselAnimLinear];
    layout1.scrollDirection =UICollectionViewScrollDirectionHorizontal;
    layout1.itemSize = CGSizeMake(kScreenWidth-70, kScreenHeight-298);
    
    _cusCollectView1 =[[UICollectionView alloc]initWithFrame:CGRectMake(0, 135, kScreenWidth, kScreenHeight-298) collectionViewLayout:layout1];

    self.cusCollectView1.tag =2002;

    _cusCollectView1.dataSource =self;
    _cusCollectView1.delegate =self;
    _cusCollectView1.showsHorizontalScrollIndicator = NO;
    _cusCollectView1.showsVerticalScrollIndicator = NO;
    _cusCollectView1.backgroundColor =kCustomColor(228, 234, 238);
    [gzView addSubview:_cusCollectView1];

    [self.cusCollectView1 registerNib:[UINib nibWithNibName:NSStringFromClass([HJConcernCell class]) bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    UIImageView *image =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"location"]];
    image.frame =CGRectMake(40, _cusCollectView1.bottom+20, 12, 12);
    [gzView addSubview:image];

    
    adLabel =[[UILabel alloc]initWithFrame:CGRectMake(image.right, _cusCollectView1.bottom+20, 200, 14)];
    adLabel.font =[UIFont systemFontOfSize:12];
    adLabel.textColor = [UIColor grayColor];
    adLabel.text =@"未知";
    [gzView addSubview:adLabel];
    
    countLabel =[[UILabel alloc]initWithFrame:CGRectMake(adLabel.right, _cusCollectView1.bottom+20, 60, 14)];
    countLabel.font =[UIFont systemFontOfSize:12];
    countLabel.textColor = [UIColor grayColor];
    countLabel.text =@"0/0";
    [gzView addSubview:countLabel];


    
    //头
    HJCarouselViewLayout *layout2  = [[HJCarouselViewLayout alloc] initWithAnim:HJCarouselAnimLinear];
    layout2.itemSize = CGSizeMake(85, 125);
    layout2.scrollDirection =UICollectionViewScrollDirectionHorizontal;
    _cusCollectView2 =[[UICollectionView alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth-20, 125) collectionViewLayout:layout2];
    self.cusCollectView2.tag =2003;
    _cusCollectView2.dataSource =self;
    _cusCollectView2.delegate =self;
    _cusCollectView2.showsHorizontalScrollIndicator = NO;
    _cusCollectView2.showsVerticalScrollIndicator = NO;
    _cusCollectView2.backgroundColor =kCustomColor(228, 234, 238);
    [gzView addSubview:_cusCollectView2];
    [self.cusCollectView2 registerNib:[UINib nibWithNibName:NSStringFromClass([HJHeaderViewCell class]) bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];

    [gzView addSubview:_cusCollectView2];
    
    
    [self setData];
    
}



- (NSIndexPath *)curIndexPath {
    NSArray *indexPaths = [self.cusCollectView2 indexPathsForVisibleItems];
    NSIndexPath *curIndexPath = nil;
    NSInteger curzIndex = 0;
    for (NSIndexPath *path in indexPaths.objectEnumerator) {
        UICollectionViewLayoutAttributes *attributes = [self.cusCollectView2 layoutAttributesForItemAtIndexPath:path];
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



#pragma mark <UICollectionViewDataSource>
//定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView.tag ==2001) {
        return self.dataArray.count;
    }else if(collectionView.tag ==2003){
        return self.dataArray1.count;;
    }
    return self.dataArray2.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView.tag ==2002) {
        HJConcernCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
        [[cell layer]setCornerRadius:8];
        cell.backgroundColor =[UIColor whiteColor];
        NSString * temp =[NSString stringWithFormat:@"%@",[self.dataArray2[indexPath.row] objectForKey:@"Pic"]];
        [cell.iconView sd_setImageWithURL:[NSURL URLWithString:temp] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        
   
        cell.priceLab.text =[self.dataArray2[indexPath.row]objectForKey:@"Price"];
        cell.dscLab.text =[self.dataArray2[indexPath.row]objectForKey:@"ProductName"];
        BOOL slected =[[self.dataArray2[indexPath.row]objectForKey:@"IsFavorite"]boolValue];
        if (slected)cell.shCBtn.selected=YES;
        else cell.shCBtn.selected=NO;
        
        return cell;
    }else if (collectionView.tag ==2003){
        HJHeaderViewCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
        NSString * temp =[NSString stringWithFormat:@"%@",[self.dataArray1[indexPath.row] objectForKey:@"Logo"]];
        [cell.iconView sd_setImageWithURL:[NSURL URLWithString:temp] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        cell.nameLab.text =[self.dataArray1[indexPath.row]objectForKey:@"NickName"];
        return cell;
    }else if (collectionView.tag ==2001) {
        HJCarouselViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
        cell.backgroundColor =[UIColor whiteColor];
        [[cell layer]setCornerRadius:8];
        if (self.dataArray.count>0) {
           
            if (self.dataArray1.count>1) {
                adLabel.text  =[self.dataArray1[indexPath.row] objectForKey:@"Address"];

            }
            
//            countLabel.text =

            NSString * temp =[NSString stringWithFormat:@"%@",[self.dataArray[indexPath.row] objectForKey:@"Logo"]];
            [cell.ShopView sd_setImageWithURL:[NSURL URLWithString:temp] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            cell.addressView.text =[self.dataArray[indexPath.row]objectForKey:@"StoreName"];
            cell.addreView.text =[self.dataArray[indexPath.row]objectForKey:@"Address"];
            cell.nameView.text =[self.dataArray[indexPath.row]objectForKey:@"BrandName"];
            NSArray *shopArray =[self.dataArray[indexPath.row]objectForKey:@"Products"];
            if (shopArray.count>0) {
                for (UIView *view in cell.bgView.subviews) {
                    [view removeFromSuperview];
                }
                if (shopArray.count ==4) {
                    
                    UIImageView *image =[[UIImageView alloc]init];
                    image.frame =CGRectMake(0, 0, (cell.bgView.width-5)*0.5, (cell.bgView.width-5)*0.5);
                    NSString * str =[NSString stringWithFormat:@"%@",[shopArray[0] objectForKey:@"Pic"]];
                    [image sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                    [cell.bgView addSubview:image];
                    
                    UIImageView *image1 =[[UIImageView alloc]init];
                    image1.backgroundColor =[UIColor redColor];
                    image1.frame =CGRectMake(image.right+5, 0, image.width,image.height);
                    NSString * str1 =[NSString stringWithFormat:@"%@",[shopArray[1] objectForKey:@"Pic"]];
                    [image1 sd_setImageWithURL:[NSURL URLWithString:str1] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                    [cell.bgView addSubview:image1];
                    
                    UIImageView *image2 =[[UIImageView alloc]init];
                    image2.frame =CGRectMake(0, image.bottom+5, image.width,image.height);
                    NSString * str2 =[NSString stringWithFormat:@"%@",[shopArray[2] objectForKey:@"Pic"]];
                    [image2 sd_setImageWithURL:[NSURL URLWithString:str2] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                    [cell.bgView addSubview:image2];
                    
                    UIImageView *image3 =[[UIImageView alloc]init];
                    image3.frame =CGRectMake(image2.right+5, image.bottom+5, image.width,image.height);
                    NSString * str3 =[NSString stringWithFormat:@"%@",[shopArray[3] objectForKey:@"Pic"]];
                    [image3 sd_setImageWithURL:[NSURL URLWithString:str3] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                    [cell.bgView addSubview:image3];
                    
                    
                }else if(shopArray.count ==3){
                    UIImageView *image =[[UIImageView alloc]init];
                    image.frame =CGRectMake(0, 0, (cell.bgView.width-5)*0.5, (cell.bgView.width-5)*0.5);
                    NSString * str =[NSString stringWithFormat:@"%@",[shopArray[0] objectForKey:@"Pic"]];
                    [image sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                    [cell.bgView addSubview:image];
                    
                    UIImageView *image1 =[[UIImageView alloc]init];
                    image1.backgroundColor =[UIColor redColor];
                    image1.frame =CGRectMake(image.right+5, 0, image.width,image.height);
                    NSString * str1 =[NSString stringWithFormat:@"%@",[shopArray[1] objectForKey:@"Pic"]];
                    [image1 sd_setImageWithURL:[NSURL URLWithString:str1] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                    [cell.bgView addSubview:image1];
                    
                    UIImageView *image2 =[[UIImageView alloc]init];
                    image2.frame =CGRectMake((cell.bgView.width-image.width)*0.5, image.bottom+5, image.width,image.height);
                    NSString * str2 =[NSString stringWithFormat:@"%@",[shopArray[2] objectForKey:@"Pic"]];
                    [image2 sd_setImageWithURL:[NSURL URLWithString:str2] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                    [cell.bgView addSubview:image2];
                    
                    
                }else if(shopArray.count ==2){
                    
                    UIImageView *image =[[UIImageView alloc]init];
                    image.frame =CGRectMake(0, 0, (cell.bgView.width-5)*0.5, (cell.bgView.height)*1);
                    NSString * str =[NSString stringWithFormat:@"%@",[shopArray[0] objectForKey:@"Pic"]];
                    [image sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                    [cell.bgView addSubview:image];
                    
                    UIImageView *image1 =[[UIImageView alloc]init];
                    image1.backgroundColor =[UIColor redColor];
                    image1.frame =CGRectMake(image.right+5, 0, image.width,image.height);
                    NSString * str1 =[NSString stringWithFormat:@"%@",[shopArray[1] objectForKey:@"Pic"]];
                    [image1 sd_setImageWithURL:[NSURL URLWithString:str1] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                    [cell.bgView addSubview:image1];
                    
                }else if(shopArray.count ==1){
                    UIImageView *image =[[UIImageView alloc]init];
                    image.frame =CGRectMake(0, 0, cell.bgView.width, cell.bgView.width);
                    NSString * str =[NSString stringWithFormat:@"%@",[shopArray[0] objectForKey:@"Pic"]];
                    [image sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                    [cell.bgView addSubview:image];
                }
            }
            
        }
        return cell;

    }
    
    return nil;
}

-(void)didSelect:(UITapGestureRecognizer *)tap
{
    if (tap.view.tag==1000)
    {
        if (isRefresh1) {
            [self setData];
        }
        type=1;
        self.messageScroll.contentOffset = CGPointMake(0, 0);
        [self scrollToMessage];
    }
    else
    {
        if (isRefresh1) {
            [self setData];
        }
        type=2;
        self.messageScroll.contentOffset = CGPointMake(kScreenWidth, 0);
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



-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSIndexPath *indexPath= [self curIndexPath];
    adLabel.text  =[self.dataArray1[indexPath.row] objectForKey:@"Address"];

    for (UIView *view in scrollView.subviews) {
        
        if ([view isKindOfClass:[ HJHeaderViewCell class]]) {
            [self setDataForStore];
        }
        
    }
}
-(void)setDataForStore{
    NSIndexPath *indexPath= [self curIndexPath];
    NSString *BuyerId= [self.dataArray1[indexPath.row]objectForKey:@"BuyerId"];
    NSMutableDictionary *dict =[[NSMutableDictionary alloc]init];
    [dict setValue:[NSString stringWithFormat:@"%d",1] forKey:@"Page"];
    [dict setObject:@"20" forKey:@"Pagesize"];
    [dict setObject:BuyerId forKey:@"BuyerId"];
    [HttpTool postWithURL:@"BuyerV3/BuyersProducts" params:dict  success:^(id json) {
        BOOL  isSuccessful =[[json objectForKey:@"isSuccessful"] boolValue];
        if (isSuccessful) {
            NSMutableArray *array =[[json objectForKey:@"data"]objectForKey:@"Products"];
            self.dataArray2 =array;
            [self.cusCollectView1 reloadData];
            
        }else{
            [self showHudFailed:[json objectForKey:@"message"]];
        }
        
    } failure:^(NSError *error) {
        [self showHudFailed:@"服务器正在维护,请稍后再试"];
        
    }];
}




@end
