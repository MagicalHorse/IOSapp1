//
//  CusZProDetailViewController.m
//  joybar
//
//  Created by 123 on 15/10/14.
//  Copyright © 2015年 卢兴. All rights reserved.
//

#import "CusZProDetailViewController.h"
#import "CusCartViewController.h"
#import "CusChatViewController.h"
#import "ProDetailData.h"
#import "HomeUsers.h"
#import "ProductPicture.h"
#import "HomePicTag.h"
#import "CusBrandDetailViewController.h"
#import "CusHomeStoreViewController.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "CusZProDetailCell.h"
@interface CusZProDetailViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,handleSizeHeight>

@property (nonatomic ,strong) UIScrollView *scrollView;
@property (nonatomic ,strong) UIScrollView *imageScrollView;
@property (nonatomic ,strong) UIPageControl *pageControl;

@property (nonatomic ,strong) UITableView *proDetailTableView;
@property (nonatomic ,strong) NSArray *kuCunArr;

@property (nonatomic ,assign) CGFloat sizeHeight;

@end

@implementation CusZProDetailViewController

{
    ProDetailData *prodata;
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
    // Do any additional setup after loading the view.
    self.sizeHeight = 0;
    self.proDetailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64-49)];
    self.proDetailTableView.delegate = self;
    self.proDetailTableView.dataSource = self;
    [self.view addSubview:self.proDetailTableView];
    
    [self addNavBarViewAndTitle:@"商品详情"];
    
    UIButton *shareBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    shareBtn.frame = CGRectMake(kScreenWidth-54, 10, 64, 64);
    shareBtn.backgroundColor = [UIColor clearColor];
    [shareBtn setImage:[UIImage imageNamed:@"fenxiang-1"] forState:(UIControlStateNormal)];
    [shareBtn addTarget:self action:@selector(didClickShare:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.navView addSubview:shareBtn];
    
    [self getKuCunData];

    [self getDetailData];
}

-(void)getKuCunData
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.productId forKey:@"productId"];
    [HttpTool postWithURL:@"Product/GetProductSku" params:dic success:^(id json) {
        if ([[json objectForKey:@"isSuccessful"] boolValue])
        {
            self.kuCunArr = [json objectForKey:@"data"];
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:2];
            [self.proDetailTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexpath, nil] withRowAnimation:UITableViewRowAnimationNone];
        }
        else
        {
            [self showHudFailed:[json objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = kCustomColor(241, 241, 241);
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0)
    {
        return 0;
    }
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        CGSize size = [Public getContentSizeWith:prodata.ProductName andFontSize:14 andWidth:kScreenWidth-15];

        return kScreenWidth+size.height+36;
    }
    else if (indexPath.section==1)
    {
        return 100;
    }
    else if (indexPath.section==2)
    {
        if (self.kuCunArr.count>0)
        {
            NSInteger rank = self.kuCunArr.count/4;
            CGFloat x = 50+(55+10)*rank;

            if (self.sizeHeight>0)
            {
                return 155+x+self.sizeHeight;
            }
            else
            {
                NSArray *sizeArr = [self.kuCunArr[0] objectForKey:@"Size"];
                CGFloat width = 0;
                for (int i=0; i<sizeArr.count; i++)
                {
                    NSString *str = [sizeArr[i] objectForKey:@"SizeName"];
                    CGSize size = [Public getContentSizeWith:str andFontSize:15 andHigth:27.895];
                    width = size.width+width+10;
                }
               
                return 155+x+ (((width+50)/kScreenWidth)+1)*25;
            
            }
        }
        return 0;
    }
    else if (indexPath.section==3)
    {
        return 110;
    }
    else
    {
        return 250;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden = @"cell";
    CusZProDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell==nil)
    {
        cell = [[CusZProDetailCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:iden];
    }
    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.kuCunArr = self.kuCunArr;
    [cell setDetailData:prodata andIndex:indexPath];
    
    return cell;
}

-(void)getDetailData
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.productId forKey:@"productId"];
    NSString *userId =[[Public getUserInfo] objectForKey:@"id"];
    if (userId)
    {
        [dic setObject:userId forKey:@"UserId"];
    }
    else
    {
        [dic setObject:@"0" forKey:@"UserId"];
    }
    
    [self showInView:self.view WithPoint:CGPointMake(0, 64+40) andHeight:kScreenHeight-64-40];
    
    [HttpTool postWithURL:@"Product/GetProductDetailV3" params:dic success:^(id json) {
        
        NSLog(@"%@",json);
        if ([[json objectForKey:@"isSuccessful"] boolValue])
        {
            NSDictionary *dic = [json objectForKey:@"data"];
            prodata = [ProDetailData objectWithKeyValues:dic];
            
            [self.proDetailTableView reloadData];
          
            [self initWithFooterView];
        }
        else
        {
            [self showHudFailed:[json objectForKey:@"message"]];
        }
        [self activityDismiss];
        
    } failure:^(NSError *error) {
        [self showHudFailed:@"服务器正在维护,请稍后再试"];
        [self activityDismiss];
    }];
}

-(void)initWithFooterView
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-44, kScreenWidth, 44)];
    footerView.backgroundColor = kCustomColor(252, 251, 251);
    [self.view addSubview:footerView];
    
    NSArray *arr = @[@"立即购买"];
    NSArray *titleArr;
    NSArray *imageArr;
    
    if ([prodata.IsFavorite boolValue])
    {
        titleArr = @[@"私聊",@"取消收藏"];
        imageArr= @[@"liaotian",@"xingxing"];
    }
    else
    {
        titleArr = @[@"私聊",@"收藏"];
        imageArr= @[@"liaotian",@"xing"];
    }
    for (int i=0; i<3; i++)
    {
        UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        btn.tag = 1000+i;
        btn.frame = CGRectMake(kScreenWidth/4*i, 0, kScreenWidth/4, 44);
        
        [btn addTarget:self action:@selector(didClickBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        if (i<2)
        {
            btn.backgroundColor = kCustomColor(252, 251, 251);
            UIImageView *img =[[UIImageView alloc] init];
            img.center = CGPointMake(btn.width/2, btn.height/2-10);
            img.bounds = CGRectMake(0, 0, 15, 15);
            img.tag = 100+i;
            img.image = [UIImage imageNamed:[imageArr objectAtIndex:i]];
            [btn addSubview:img];
            
            UILabel *lab = [[UILabel alloc] init];
            lab.center = CGPointMake(btn.width/2, btn.height/2+10);
            lab.bounds = CGRectMake(0, 0, btn.width, 20);
            lab.textAlignment = NSTextAlignmentCenter;
            lab.text = [titleArr objectAtIndex:i];
            lab.tag = 10000+i;
            lab.font = [UIFont systemFontOfSize:12];
            [btn addSubview:lab];
        }
        else
        {
            btn.frame = CGRectMake(kScreenWidth/2, 0, kScreenWidth/2, 44);
            [btn setTitle:[arr objectAtIndex:i-2] forState:(UIControlStateNormal)];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
            btn.backgroundColor = kCustomColor(253, 137, 83);
        }
        [footerView addSubview:btn];
    }
}

-(void)didClickReturnBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)didClickBtn:(UIButton *)btn
{
    if (!TOKEN)
    {
        [Public showLoginVC:self];
        return;
    }

    switch (btn.tag) {
        case 1000:
        {
            //私聊
            CusChatViewController *VC = [[CusChatViewController alloc] initWithUserId:prodata.BuyerId AndTpye:2 andUserName:prodata.BuyerName];
            VC.detailData = prodata;
            VC.isFrom = isFromPrivateChat;
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        case 1001:
        {
            //收藏
            [self collect:btn];
        }
            break;
        case 1002:
        {
            //我要买
            CusChatViewController *VC = [[CusChatViewController alloc] initWithUserId:prodata.BuyerId AndTpye:2 andUserName:prodata.BuyerName];
            VC.detailData = prodata;
            VC.isFrom = isFromBuyPro;
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        default:
            break;
    }
}

//分享
-(void)didClickShare:(UIButton *)button
{
    if (!TOKEN)
    {
        [Public showLoginVC:self];
        return;
    }
    
    [UMSocialWechatHandler setWXAppId:APP_ID appSecret:APP_SECRET url:nil];
    
    
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:@""] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:@"55d43bf367e58eac01002b7f"
                                          shareText:[NSString stringWithFormat:@"快看！这里有一件超值的%@商品",@""]
                                         shareImage:image
                                    shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline]
                                           delegate:nil];
    }];
}

-(void)didClickBuyBtn:(UIButton *)button
{
    if (!TOKEN)
    {
        [Public showLoginVC:self];
        return;
    }
    //立即购买
    CusChatViewController *VC = [[CusChatViewController alloc] initWithUserId:prodata.BuyerId AndTpye:2 andUserName:prodata.BuyerName];
    VC.detailData = prodata;
    VC.isFrom = isFromBuyPro;
    [self.navigationController pushViewController:VC animated:YES];
}
-(void)collect:(UIButton *)btn
{
    UILabel *lab = (UILabel *)[btn viewWithTag:10001];
    UIImageView *img = (UIImageView *)[btn viewWithTag:101];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:prodata.ProductId forKey:@"Id"];
    if ([lab.text isEqualToString:@"收藏"])
    {
        [dic setValue:@"1" forKey:@"Status"];
    }
    else
    {
        [dic setValue:@"0" forKey:@"Status"];
    }
    [HttpTool postWithURL:@"Product/Favorite" params:dic isWrite:YES  success:^(id json) {
        
        if ([json objectForKey:@"isSuccessful"])
        {
            if ([lab.text isEqualToString:@"收藏"])
            {
                lab.text=@"取消收藏";
                img.image = [UIImage imageNamed:@"xingxing"];
            }
            else
            {
                lab.text=@"收藏";
                img.image = [UIImage imageNamed:@"xing"];
            }
        }
        else
        {
            [self showHudFailed:[json objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        
    }];
}
//UIScrollViewDelegate方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.imageScrollView == scrollView)
    {
        NSInteger index = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;
        
        [_pageControl setCurrentPage:index];
    }
}

-(void)didClickCollect:(UIButton *)btn
{
    if (!TOKEN)
    {
        [Public showLoginVC:self];
        return;
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:prodata.ProductId forKey:@"Id"];
    if (btn.selected==NO)
    {
        [dic setObject:@"1" forKey:@"Status"];
    }
    else
    {
        [dic setObject:@"0" forKey:@"Status"];
    }
    [HttpTool postWithURL:@"Product/Like" params:dic isWrite:YES success:^(id json) {
        
        if ([[json objectForKey:@"isSuccessful"] boolValue])
        {
            if (btn.selected==NO)
            {
                prodata.LikeUsers.Count = [NSString stringWithFormat:@"%ld",[prodata.LikeUsers.Count integerValue]+1];
                prodata.LikeUsers.IsLike = @"1";
                [btn setImage:[UIImage imageNamed:@"点赞h"] forState:(UIControlStateNormal)];
                [btn setTitle:prodata.LikeUsers.Count forState:(UIControlStateNormal)];
                btn.selected = YES;
            }
            else
            {
                prodata.LikeUsers.Count = [NSString stringWithFormat:@"%ld",[prodata.LikeUsers.Count integerValue]-1];
                prodata.LikeUsers.IsLike = @"0";
                
                [btn setImage:[UIImage imageNamed:@"点赞"] forState:(UIControlStateNormal)];
                [btn setTitle:prodata.LikeUsers.Count forState:(UIControlStateNormal)];
                btn.selected = NO;
            }
        }
        else
        {
            
        }
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)didClickImage:(UITapGestureRecognizer *)btn
{
    
}

//点击标签
-(void)didClickTag:(UITapGestureRecognizer *)tap
{
    ProductPicture *proPic = [prodata.ProductPic objectAtIndex:self.imageScrollView.contentOffset.x/(kScreenWidth-10)];
    HomePicTag *proTags = [proPic.Tags objectAtIndex:tap.view.tag-100-self.imageScrollView.contentOffset.x/(kScreenWidth-10)];
    CusBrandDetailViewController *VC = [[CusBrandDetailViewController alloc] init];
    VC.BrandId = proTags.SourceId;
    VC.BrandName = proTags.Name;
    [self.navigationController pushViewController:VC animated:YES];
}

//点击头像
-(void)didCLickToStore
{
    CusHomeStoreViewController *VC = [[CusHomeStoreViewController alloc] init];
    VC.userId = prodata.BuyerId;
    VC.userName = prodata.BuyerName;
    [self.navigationController pushViewController:VC animated:YES];
}

-(void)handleSizeHeight:(CGFloat)height
{
    self.sizeHeight = height;
}

@end
