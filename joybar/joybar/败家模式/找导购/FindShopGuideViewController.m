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
#import "HistorySearchViewController.h"
#import "CusBueryTableViewCell.h"
#import "CusZProDetailViewController.h"
#import "CusRProDetailViewController.h"
#import "CusMainStoreViewController.h"

@interface FindShopGuideViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,
UITableViewDataSource,UITableViewDelegate>
@property (nonatomic ,strong) BaseTableView *tableView;
@property (nonatomic ,strong) UILabel *lineLab;
@property (nonatomic ,strong)UICollectionView *cusCollectView;
@property (nonatomic ,strong)NSMutableArray *dataArray; //推荐
@property (nonatomic ,strong)NSMutableArray *cusDataArray; //关注
@property (nonatomic ,strong) UIScrollView *messageScroll;
@property (nonatomic ,assign) NSInteger pageNum;
@property (nonatomic ,assign) NSInteger pageNumScroll;



@end
static NSString * const reuseIdentifier = @"Cell";

@implementation FindShopGuideViewController{
    UIView *tempView;
    BOOL isRefresh;
    BOOL isRefresh1;
    int type;
    CGFloat contentOffsetX;
}
-(NSMutableArray *)dataArray{
    if (_dataArray ==nil) {
        _dataArray =[NSMutableArray array];
    }
    return _dataArray;
}
-(NSMutableArray *)cusDataArray{
    if (_cusDataArray ==nil) {
        _cusDataArray =[NSMutableArray array];
    }
    return _cusDataArray;
}

-(void)setData{
    
    if (isRefresh) {
        [self showInView:self.view WithPoint:CGPointMake(0, 64) andHeight:kScreenHeight-64];
    }
    
 
    NSMutableDictionary *dict =[[NSMutableDictionary alloc]init];
    [dict setValue:[NSString stringWithFormat:@"%ld",(long)self.pageNumScroll] forKey:@"Page"];
    [dict setObject:@"6" forKey:@"Pagesize"];
    
    [HttpTool postWithURL:@"BuyerV3/RecommondBuyerlist" params:dict  success:^(id json) {
        BOOL  isSuccessful =[[json objectForKey:@"isSuccessful"] boolValue];
        if (isSuccessful) {
            isRefresh=NO;
            NSMutableArray *array =[[json objectForKey:@"data"]objectForKey:@"Buyers"];
            
            
            
            [self.dataArray addObjectsFromArray:array];
            
            
            
        }else{
            [self showHudFailed:[json objectForKey:@"message"]];
        }
        [self.cusCollectView reloadData];
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
    contentOffsetX=0;
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

    self.tableView = [[BaseTableView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight-49-64) style:(UITableViewStylePlain)];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.messageScroll addSubview:self.tableView];
    
    self.tableView.tableFooterView =[[UIView alloc]init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor =kCustomColor(228, 234, 238);
    
    self.pageNum=1;
    self.pageNumScroll=1;
    self.tableView.tableFooterView =[[UIView alloc]init];
    __weak FindShopGuideViewController *VC = self;
    self.tableView.headerRereshingBlock = ^()
    {
        if (VC.dataArray.count>0) {
            VC.dataArray =nil;
        }
        VC.pageNum=1;
        [VC setTableData];
    };
    self.tableView.footerRereshingBlock = ^()
    {
        VC.pageNum++;
        [VC setTableData];
    };
    
    [self setData];
}

-(void)setTableData{
    
    
    if (isRefresh1) {
        [self showInView:self.view WithPoint:CGPointMake(0, 64) andHeight:kScreenHeight-64-49];
    }
    
    NSString *userId =[NSString stringWithFormat:@"%@",[[Public getUserInfo] objectForKey:@"id"]];
    NSMutableDictionary *dict =[[NSMutableDictionary alloc]init];
    //    [dict setObject:searchText.text forKey:@"key"];
    [dict setObject:@"" forKey:@"key"];
    
    [dict setValue:[NSString stringWithFormat:@"%ld",(long)self.pageNum] forKey:@"Page"];
    [dict setObject:@"6" forKey:@"Pagesize"];
    [dict setObject:userId forKey:@"userId"];
    [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"] forKey:@"longitude"];
    [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"] forKey:@"latitude"];
    
    [HttpTool postWithURL:@"v3/FavBuyers" params:dict  success:^(id json) {
        BOOL  isSuccessful =[[json objectForKey:@"isSuccessful"] boolValue];
        if (isSuccessful) {
            NSMutableArray *array =[[json objectForKey:@"data"]objectForKey:@"items"];
            isRefresh1 =NO;
            if (array.count<6) {
                [self.tableView hiddenFooter:YES];
            }
            else
            {
                [self.tableView hiddenFooter:NO];
            }
            if (self.pageNum==1) {
                [self.cusDataArray removeAllObjects];
                [self.cusDataArray addObjectsFromArray:array];
            }else{
                [self.cusDataArray addObjectsFromArray:array];
            }
        }else{
            [self showHudFailed:[json objectForKey:@"message"]];
        }
        [self.tableView endRefresh];
        [self.tableView reloadData];
        [self activityDismiss];
        
    } failure:^(NSError *error) {
        [self showHudFailed:@"服务器正在维护,请稍后再试"];
        [self.tableView endRefresh];
        [self activityDismiss];
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.cusDataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *iden = @"cell";
    CusBueryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    
    if (cell == nil) {
        cell =[[[NSBundle mainBundle] loadNibNamed:@"CusBueryTableViewCell" owner:self options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.cusDataArray.count>0) {
        
        [cell.iconView sd_setImageWithURL:[NSURL URLWithString:[self.cusDataArray[indexPath.row]objectForKey:@"Logo"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        cell.shopName.text = [self.cusDataArray[indexPath.row]objectForKey:@"Nickname"];
        cell.addressLab.text =[self.cusDataArray[indexPath.row]objectForKey:@"BrandName"];
        [cell.guanzhuBtn addTarget:self action:@selector(guanzhuTClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.bgView.tag =indexPath.row+10;
        NSArray *array =[self.cusDataArray[indexPath.row]objectForKey:@"Products"];
        if (array.count>0) {
            if(array.count ==2){
                cell.shopBtn1.hidden =NO;
                cell.shopBtn2.hidden =YES;
                
                [cell.shopBtn sd_setImageWithURL:[NSURL URLWithString:[array[0]objectForKey:@"Pic"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                [cell.shopBtn1 sd_setImageWithURL:[NSURL URLWithString:[array[1]objectForKey:@"Pic"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                UITapGestureRecognizer *proTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(did1ClickProView:)];
                [cell.shopBtn addGestureRecognizer:proTap];
                proTap.view.tag =[[array[0]objectForKey:@"ProductId"] integerValue] ;
                
                UITapGestureRecognizer *proTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(did2ClickProView:)];
                [cell.shopBtn1 addGestureRecognizer:proTap1];
                proTap1.view.tag =[[array[1]objectForKey:@"ProductId"] integerValue];
                
                
            }else if(array.count ==3){
                cell.shopBtn1.hidden =NO;
                cell.shopBtn2.hidden =NO;
                [cell.shopBtn sd_setImageWithURL:[NSURL URLWithString:[array[0]objectForKey:@"Pic"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                [cell.shopBtn1 sd_setImageWithURL:[NSURL URLWithString:[array[1]objectForKey:@"Pic"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                [cell.shopBtn2 sd_setImageWithURL:[NSURL URLWithString:[array[2]objectForKey:@"Pic"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                UITapGestureRecognizer *proTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(did1ClickProView:)];
                [cell.shopBtn addGestureRecognizer:proTap];
                proTap.view.tag =[[array[0]objectForKey:@"ProductId"] integerValue];
                
                UITapGestureRecognizer *proTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(did2ClickProView:)];
                [cell.shopBtn1 addGestureRecognizer:proTap1];
                proTap1.view.tag =[[array[1]objectForKey:@"ProductId"] integerValue];
                
                UITapGestureRecognizer *proTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(did3ClickProView:)];
                [cell.shopBtn2 addGestureRecognizer:proTap2];
                proTap2.view.tag =[[array[2]objectForKey:@"ProductId"] integerValue];
                
            }else{
                cell.shopBtn1.hidden =YES;
                cell.shopBtn2.hidden =YES;
                
                [cell.shopBtn sd_setImageWithURL:[NSURL URLWithString:[array[0]objectForKey:@"Pic"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                UITapGestureRecognizer *proTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(did1ClickProView:)];
                [cell.shopBtn addGestureRecognizer:proTap];
                proTap.view.tag =[[array[0]objectForKey:@"ProductId"] integerValue];
            }
        }else{
            cell.shopBtn.hidden =YES;
            cell.shopBtn1.hidden =YES;
            cell.shopBtn2.hidden =YES;
            UILabel *lable =[[UILabel alloc]initWithFrame:CGRectMake(0, cell.shopBtn.top+10, cell.width, 20)];
            lable.text =@"店铺什么都没有，戳一下，提醒上新~";
            lable.textAlignment =NSTextAlignmentCenter;
            lable.font =[UIFont systemFontOfSize:13];
            lable.textColor =[UIColor grayColor];
            [cell addSubview:lable];
            
            UIButton *btn=  [[UIButton alloc]initWithFrame:CGRectMake((cell.width-100)*0.5, lable.bottom+10, 100, 40)];
            
            btn.backgroundColor =[UIColor orangeColor];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setTitle:@"提醒上新" forState:UIControlStateNormal];
            btn.titleLabel.font =[UIFont systemFontOfSize:13];
            [cell addSubview:btn];
        }
        
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 200;
}

#pragma mark <UICollectionViewDataSource>
//定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat w =0;
    if (kScreenWidth ==320) {
        w =122.5;
    }else if(kScreenWidth ==375){
        w =150;
    }else{
        w =170;
    }
    HJCarouselViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor =[UIColor whiteColor];
    [[cell layer]setCornerRadius:8];
    if (self.dataArray.count>0) {
        NSString * temp =[NSString stringWithFormat:@"%@",[self.dataArray[indexPath.row] objectForKey:@"Logo"]];
        [cell.ShopView sd_setImageWithURL:[NSURL URLWithString:temp] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        UITapGestureRecognizer *proTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didHeadViewClick:)];
        [cell.ShopView addGestureRecognizer:proTap];
        
        proTap.view.tag =[[self.dataArray[indexPath.row]objectForKey:@"BuyerId"] integerValue] ;

        cell.addressView.text =[self.dataArray[indexPath.row]objectForKey:@"StoreName"];
        cell.addreView.text =[self.dataArray[indexPath.row]objectForKey:@"Address"];
        cell.nameView.text =[self.dataArray[indexPath.row]objectForKey:@"BrandName"];
        BOOL isFavite =[[self.dataArray[indexPath.row]objectForKey:@"IsFavorited"]boolValue];
        if (isFavite) {
            cell.guanzhuView.selected =YES;
            cell.guanzhuView.backgroundColor =[UIColor lightGrayColor];
            [cell.guanzhuView setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [cell.guanzhuView setTitle:@"已关注" forState:UIControlStateSelected];
        }else{
            cell.guanzhuView.selected =NO;
            cell.guanzhuView.backgroundColor =[UIColor orangeColor];
            [cell.guanzhuView setTitle:@"关注" forState:UIControlStateNormal];
            [cell.guanzhuView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        [cell.guanzhuView addTarget:self action:@selector(guanzhuClick:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.guanzhuView.tag =indexPath.row +100;
        cell.bgView.tag =indexPath.row+10;
        NSArray *shopArray =[self.dataArray[indexPath.row]objectForKey:@"Products"];
        if (shopArray.count>0) {
            for (UIView *view in cell.bgView.subviews) {
                [view removeFromSuperview];
            }
            if (shopArray.count ==4) {
                UIImageView *image =[[UIImageView alloc]init];
                image.frame =CGRectMake(0, 0, w, w);
                image.userInteractionEnabled =YES;
                image.contentMode= UIViewContentModeCenter;
                image.clipsToBounds =YES;
                image.backgroundColor =[UIColor lightGrayColor];
                NSString * str =[NSString stringWithFormat:@"%@",[shopArray[0] objectForKey:@"Pic"]];
                
                [image sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                [cell.bgView addSubview:image];
                
                UIImageView *image1 =[[UIImageView alloc]init];
                image1.userInteractionEnabled =YES;
                image1.contentMode= UIViewContentModeCenter;
                image1.clipsToBounds =YES;
                image1.backgroundColor =[UIColor lightGrayColor];
                image1.frame =CGRectMake(image.right+5, 0, image.width,image.height);
                NSString * str1 =[NSString stringWithFormat:@"%@",[shopArray[1] objectForKey:@"Pic"]];
                [image1 sd_setImageWithURL:[NSURL URLWithString:str1] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                [cell.bgView addSubview:image1];
                
                UIImageView *image2 =[[UIImageView alloc]init];
                image2.userInteractionEnabled =YES;
                image2.contentMode= UIViewContentModeCenter;
                image2.clipsToBounds =YES;
                image2.backgroundColor =[UIColor lightGrayColor];
                image2.frame =CGRectMake(0, image.bottom+5, image.width,image.height);
                NSString * str2 =[NSString stringWithFormat:@"%@",[shopArray[2] objectForKey:@"Pic"]];
                [image2 sd_setImageWithURL:[NSURL URLWithString:str2] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                [cell.bgView addSubview:image2];
                
                UIImageView *image3 =[[UIImageView alloc]init];
                image3.userInteractionEnabled =YES;
                image3.contentMode= UIViewContentModeCenter;
                image3.clipsToBounds =YES;
                image3.backgroundColor =[UIColor lightGrayColor];
                image3.frame =CGRectMake(image2.right+5, image.bottom+5, image.width,image.height);
                NSString * str3 =[NSString stringWithFormat:@"%@",[shopArray[3] objectForKey:@"Pic"]];
                [image3 sd_setImageWithURL:[NSURL URLWithString:str3] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                [cell.bgView addSubview:image3];
                
                UITapGestureRecognizer *proTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didProViewClick:)];
                [image addGestureRecognizer:proTap];
                proTap.view.tag =[[shopArray[0]objectForKey:@"ProductId"] integerValue];
                
                UITapGestureRecognizer *proTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(did1ProViewClick:)];
                [image1 addGestureRecognizer:proTap1];
                proTap1.view.tag =[[shopArray[1]objectForKey:@"ProductId"] integerValue];
                
                UITapGestureRecognizer *proTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(did2ProViewClick:)];
                [image2 addGestureRecognizer:proTap2];
                 proTap2.view.tag =[[shopArray[2] objectForKey:@"ProductId"] integerValue];
                
                UITapGestureRecognizer *proTap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(did3ProViewClick:)];
                [image3 addGestureRecognizer:proTap3];
                proTap3.view.tag =[[shopArray[3]objectForKey:@"ProductId"] integerValue];
                
                
            }else if(shopArray.count ==3){
                UIImageView *image =[[UIImageView alloc]init];
                image.userInteractionEnabled =YES;

                image.contentMode= UIViewContentModeCenter;
                image.clipsToBounds =YES;
                image.backgroundColor =[UIColor lightGrayColor];

                image.frame =CGRectMake(0, 0, w, w);
                NSString * str =[NSString stringWithFormat:@"%@",[shopArray[0] objectForKey:@"Pic"]];
                [image sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                [cell.bgView addSubview:image];
                
                UIImageView *image1 =[[UIImageView alloc]init];
                image1.userInteractionEnabled =YES;
                image1.contentMode= UIViewContentModeCenter;
                image1.clipsToBounds =YES;
                image1.backgroundColor =[UIColor lightGrayColor];
                image1.frame =CGRectMake(image.right+5, 0, image.width,image.height);
                NSString * str1 =[NSString stringWithFormat:@"%@",[shopArray[1] objectForKey:@"Pic"]];
                [image1 sd_setImageWithURL:[NSURL URLWithString:str1] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                [cell.bgView addSubview:image1];
                
                UIImageView *image2 =[[UIImageView alloc]init];
                image2.userInteractionEnabled =YES;

                image2.contentMode= UIViewContentModeCenter;
                image2.clipsToBounds =YES;
                image2.backgroundColor =[UIColor lightGrayColor];
                image2.frame =CGRectMake((w-image.width)*0.5, image.bottom+5, image.width,image.height);
                NSString * str2 =[NSString stringWithFormat:@"%@",[shopArray[2] objectForKey:@"Pic"]];
                [image2 sd_setImageWithURL:[NSURL URLWithString:str2] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                [cell.bgView addSubview:image2];
                
                UITapGestureRecognizer *proTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didProViewClick:)];
                [image addGestureRecognizer:proTap];
                proTap.view.tag =[[shopArray[0]objectForKey:@"ProductId"] integerValue];
                
                UITapGestureRecognizer *proTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(did1ProViewClick:)];
                [image1 addGestureRecognizer:proTap1];
                proTap1.view.tag =[[shopArray[1]objectForKey:@"ProductId"] integerValue];
                
                UITapGestureRecognizer *proTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(did2ProViewClick:)];
                [image2 addGestureRecognizer:proTap2];
                proTap2.view.tag =[[shopArray[2] objectForKey:@"ProductId"] integerValue];
                
                
            }else if(shopArray.count ==2){
                
                UIImageView *image =[[UIImageView alloc]init];
                image.userInteractionEnabled =YES;

                image.contentMode= UIViewContentModeCenter;
                image.clipsToBounds =YES;
                image.backgroundColor =[UIColor lightGrayColor];
                image.frame =CGRectMake(0, 0, w, w*2);
                NSString * str =[NSString stringWithFormat:@"%@",[shopArray[0] objectForKey:@"Pic"]];
                [image sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                [cell.bgView addSubview:image];
                
                UIImageView *image1 =[[UIImageView alloc]init];
                image1.userInteractionEnabled =YES;
                image1.contentMode= UIViewContentModeCenter;
                image1.clipsToBounds =YES;
                image1.backgroundColor =[UIColor lightGrayColor];
                image1.frame =CGRectMake(image.right+5, 0, image.width,image.height);
                NSString * str1 =[NSString stringWithFormat:@"%@",[shopArray[1] objectForKey:@"Pic"]];
                [image1 sd_setImageWithURL:[NSURL URLWithString:str1] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                [cell.bgView addSubview:image1];
                UITapGestureRecognizer *proTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didProViewClick:)];
                [image addGestureRecognizer:proTap];
                proTap.view.tag =[[shopArray[0]objectForKey:@"ProductId"] integerValue];
                
                UITapGestureRecognizer *proTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(did1ProViewClick:)];
                [image1 addGestureRecognizer:proTap1];
                proTap1.view.tag =[[shopArray[1]objectForKey:@"ProductId"] integerValue];
                
                
                
                
            }else if(shopArray.count ==1){
                UIImageView *image =[[UIImageView alloc]init];
                image.userInteractionEnabled =YES;
                image.contentMode= UIViewContentModeCenter;
                image.clipsToBounds =YES;
                image.backgroundColor =[UIColor lightGrayColor];
                image.frame =CGRectMake(0, 0, (w+5)*2, (w+5)*2);
                NSString * str =[NSString stringWithFormat:@"%@",[shopArray[0] objectForKey:@"Pic"]];
                [image sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                [cell.bgView addSubview:image];
                UITapGestureRecognizer *proTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didProViewClick:)];
                [image addGestureRecognizer:proTap];
                proTap.view.tag =[[shopArray[0]objectForKey:@"ProductId"] integerValue];
                
               
            }
            
        }
    }
    return cell;

}


-(void)didSelect:(UITapGestureRecognizer *)tap
{
    if (tap.view.tag==1000)
    {
        [self activityDismiss];
        type=1;
        if (isRefresh) {
            [self setData];
        }
        self.messageScroll.contentOffset = CGPointMake(0, 0);
        [self scrollToMessage];
    }
    else
    {
        [self activityDismiss];
        type=2;
        if (isRefresh1) {
            [self setTableData];
        }
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
-(void)didProViewClick:(UITapGestureRecognizer *)tap{
    
    NSInteger tag= [tap.view superview].tag-10;
    NSString *Userleave = [NSString stringWithFormat:@"%@",[self.dataArray[tag]objectForKey:@"UserLevel"]];
    if ([Userleave isEqualToString:@"4"])
    {
        //认证买手
        CusRProDetailViewController *VC = [[CusRProDetailViewController alloc] init];
        VC.productId = [NSString stringWithFormat:@"%ld", tap.view.tag];
        [self.navigationController pushViewController:VC animated:YES];
        
    }
    else
    {
        CusZProDetailViewController *VC = [[CusZProDetailViewController alloc] init];
        VC.productId = [NSString stringWithFormat:@"%ld", tap.view.tag];
        [self.navigationController pushViewController:VC animated:YES];
    }
    
}
-(void)did1ProViewClick:(UITapGestureRecognizer *)tap{
    
    NSInteger tag= [tap.view superview].tag-10;
    NSString *Userleave = [NSString stringWithFormat:@"%@",[self.dataArray[tag]objectForKey:@"UserLevel"]];
    if ([Userleave isEqualToString:@"4"])
    {
        //认证买手
        CusRProDetailViewController *VC = [[CusRProDetailViewController alloc] init];
        VC.productId = [NSString stringWithFormat:@"%ld", tap.view.tag];
        [self.navigationController pushViewController:VC animated:YES];
        
    }
    else
    {
        CusZProDetailViewController *VC = [[CusZProDetailViewController alloc] init];
        VC.productId = [NSString stringWithFormat:@"%ld", tap.view.tag];
        [self.navigationController pushViewController:VC animated:YES];
    }
    
}
-(void)did2ProViewClick:(UITapGestureRecognizer *)tap{
    
    NSInteger tag= [tap.view superview].tag-10;
    NSString *Userleave = [NSString stringWithFormat:@"%@",[self.dataArray[tag]objectForKey:@"UserLevel"]];
    if ([Userleave isEqualToString:@"4"])
    {
        //认证买手
        CusRProDetailViewController *VC = [[CusRProDetailViewController alloc] init];
        VC.productId = [NSString stringWithFormat:@"%ld", tap.view.tag];
        [self.navigationController pushViewController:VC animated:YES];
        
    }
    else
    {
        CusZProDetailViewController *VC = [[CusZProDetailViewController alloc] init];
        VC.productId = [NSString stringWithFormat:@"%ld", tap.view.tag];
        [self.navigationController pushViewController:VC animated:YES];
    }
}
-(void)did3ProViewClick:(UITapGestureRecognizer *)tap{
    
    NSInteger tag= [tap.view superview].tag-10;
    NSString *Userleave = [NSString stringWithFormat:@"%@",[self.dataArray[tag]objectForKey:@"UserLevel"]];
    if ([Userleave isEqualToString:@"4"])
    {
        //认证买手
        CusRProDetailViewController *VC = [[CusRProDetailViewController alloc] init];
        VC.productId = [NSString stringWithFormat:@"%ld", tap.view.tag];
        [self.navigationController pushViewController:VC animated:YES];
        
    }
    else
    {
        CusZProDetailViewController *VC = [[CusZProDetailViewController alloc] init];
        VC.productId = [NSString stringWithFormat:@"%ld", tap.view.tag];
        [self.navigationController pushViewController:VC animated:YES];
    }
}

-(void)did1ClickProView:(UITapGestureRecognizer *)tap{
    
    NSInteger tag= [tap.view superview].tag-10;
    NSString *Userleave = [NSString stringWithFormat:@"%@",[self.cusDataArray[tag]objectForKey:@"Userleave"]];
    if ([Userleave isEqualToString:@"4"])
    {
        //认证买手
        CusRProDetailViewController *VC = [[CusRProDetailViewController alloc] init];
        VC.productId = [NSString stringWithFormat:@"%ld", tap.view.tag];
        [self.navigationController pushViewController:VC animated:YES];
        
    }
    else
    {
        CusZProDetailViewController *VC = [[CusZProDetailViewController alloc] init];
        VC.productId = [NSString stringWithFormat:@"%ld", tap.view.tag];
        [self.navigationController pushViewController:VC animated:YES];
    }
    
}
-(void)did2ClickProView:(UITapGestureRecognizer *)tap{
    
    NSInteger tag= [tap.view superview].tag-10;
    NSString *Userleave = [NSString stringWithFormat:@"%@",[self.cusDataArray[tag]objectForKey:@"Userleave"]];
    if ([Userleave isEqualToString:@"4"])
    {
        //认证买手
        CusRProDetailViewController *VC = [[CusRProDetailViewController alloc] init];
        VC.productId = [NSString stringWithFormat:@"%ld", tap.view.tag];
        [self.navigationController pushViewController:VC animated:YES];
        
    }
    else
    {
        CusZProDetailViewController *VC = [[CusZProDetailViewController alloc] init];
        VC.productId = [NSString stringWithFormat:@"%ld", tap.view.tag];
        [self.navigationController pushViewController:VC animated:YES];
    }
    
}
-(void)did3ClickProView:(UITapGestureRecognizer *)tap{
    
    NSInteger tag= [tap.view superview].tag-10;
    NSString *Userleave = [NSString stringWithFormat:@"%@",[self.cusDataArray[tag]objectForKey:@"Userleave"]];
    if ([Userleave isEqualToString:@"4"])
    {
        //认证买手
        CusRProDetailViewController *VC = [[CusRProDetailViewController alloc] init];
        VC.productId = [NSString stringWithFormat:@"%ld", tap.view.tag];
        [self.navigationController pushViewController:VC animated:YES];
        
    }
    else
    {
        CusZProDetailViewController *VC = [[CusZProDetailViewController alloc] init];
        VC.productId = [NSString stringWithFormat:@"%ld", tap.view.tag];
        [self.navigationController pushViewController:VC animated:YES];
    }
}

-(void)guanzhuClick:(UIButton *)btn{
    NSString *buyerId =[self.dataArray[btn.tag-100]objectForKey:@"BuyerId"];
    BOOL tempState =[[self.dataArray[btn.tag-100]objectForKey:@"IsFavorited"]boolValue];

 
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (tempState)
    {
        
        [dic setValue:@"0" forKey:@"Status"];
    }
    else
    {
        [dic setValue:@"1" forKey:@"Status"];
    }
    [dic setValue:buyerId forKey:@"FavoriteId"];
    
    [HttpTool postWithURL:@"User/Favoite" params:dic isWrite:YES  success:^(id json) {
        
        if ([json objectForKey:@"isSuccessful"])
        {
            
            if (tempState)
            {
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.dataArray[btn.tag-100]];
                [dic setObject:@"0" forKey:@"IsFavorited"];
                [self.dataArray removeObject:self.dataArray[btn.tag-100]];
                [self.dataArray insertObject:dic atIndex:btn.tag-100];                btn.selected =NO;
           
            }
            else
            {
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.dataArray[btn.tag-100]];
                [dic setObject:@"1" forKey:@"IsFavorited"];
                [self.dataArray removeObject:self.dataArray[btn.tag-100]];
                [self.dataArray insertObject:dic atIndex:btn.tag-100];
                btn.selected = YES;
               
            }
        }
        else
        {
            [self showHudFailed:[json objectForKey:@"message"]];
        }
        [self.cusCollectView reloadData];
        
    } failure:^(NSError *error) {
    }];
    
    
}
-(void)didHeadViewClick:(UITapGestureRecognizer *)btn{
    CusMainStoreViewController * mainStore =[[CusMainStoreViewController alloc]init];
    mainStore.userId =[NSString stringWithFormat:@"%ld",btn.view.tag];
    [self.navigationController pushViewController:mainStore animated:YES];
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
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
  
    CGFloat contentOffsetPoint = scrollView.contentOffset.x;
    if (contentOffsetPoint>contentOffsetX) {
        contentOffsetX=contentOffsetPoint;
        NSIndexPath *indexPath =[self curIndexPath];
        int index =(int)indexPath.row+1;
        if (index %3==0&&indexPath.row!=0)
        {
            self.pageNumScroll =index/3+1;
            [self setData];
        }
    }
   
   
    
}


@end
