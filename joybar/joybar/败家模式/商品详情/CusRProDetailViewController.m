//
//  CusBuyerDetailViewController.m
//  joybar
//
//  Created by 123 on 15/5/13.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "CusRProDetailViewController.h"
#import "CusCartViewController.h"
#import "CusChatViewController.h"
#import "ProDetailData.h"
#import "HomeUsers.h"
#import "ProductPicture.h"
#import "HomePicTag.h"
//#import "CusBrandDetailViewController.h"
#import "CusHomeStoreViewController.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "CusRProDetailCell.h"
#import "MZTimerLabel.h"
@interface CusRProDetailViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,MZTimerLabelDelegate>

@property (nonatomic ,strong) UIScrollView *scrollView;
@property (nonatomic ,strong) UIScrollView *imageScrollView;
@property (nonatomic ,strong) UIPageControl *pageControl;

@property (nonatomic ,strong) UITableView *proDetailTableView;

@end

@implementation CusRProDetailViewController
{
    ProDetailData *prodata;
    UILabel *timerLab;
    UILabel *buyLab;
    UIButton *timeBtn;

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
    
    [self getDetailData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
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
        return 110;
    }
    else
    {
        return (kScreenWidth*2.3)/1.1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden = @"cell";
    CusRProDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell==nil)
    {
        cell = [[CusRProDetailCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:iden];
    }
    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setDetailData:prodata andIndex:indexPath];
    
    return cell;
}


-(void)getDetailData
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:self.productId forKey:@"productId"];
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

//-(void)initWithFooterView
//{
//    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-44, kScreenWidth, 44)];
//    footerView.backgroundColor = kCustomColor(252, 251, 251);
//    [self.view addSubview:footerView];
//    
//    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    btn.frame = CGRectMake(kScreenWidth/2, 0, kScreenWidth/2, 44);
//    [btn setTitle:@"我要买" forState:(UIControlStateNormal)];
//    btn.titleLabel.font = [UIFont systemFontOfSize:14];
//    [btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
//    btn.backgroundColor = kCustomColor(253, 137, 83);
//    [btn addTarget:self action:@selector(didClickBuyBtn:) forControlEvents:(UIControlEventTouchUpInside)];
//    [footerView addSubview:btn];
//    
//    UIButton *collectBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    collectBtn.frame = CGRectMake(kScreenWidth/4/2, 10, kScreenWidth/4/1.1, kScreenWidth/4/1.1*82/310);
//    [collectBtn addTarget:self action:@selector(didClickCollectProBtn:) forControlEvents:(UIControlEventTouchUpInside)];
//    collectBtn.backgroundColor = kCustomColor(252, 251, 251);
//    collectBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    if ([prodata.IsFavorite boolValue])
//    {
//        [collectBtn setImage:[UIImage imageNamed:@"yishoucang"] forState:(UIControlStateNormal)];
//        [collectBtn setTitle:@" 已收藏" forState:(UIControlStateNormal)];
//        [collectBtn setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
//        collectBtn.selected = YES;
//    }
//    else
//    {
//        [collectBtn setImage:[UIImage imageNamed:@"weishoucang"] forState:(UIControlStateNormal)];
//        [collectBtn setTitle:@" 收藏" forState:(UIControlStateNormal)];
//        [collectBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
//        collectBtn.selected = NO;
//
//    }
//    [footerView addSubview:collectBtn];
//}

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
            timeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
            timeBtn.frame = CGRectMake(kScreenWidth/2, 0, kScreenWidth/2, 44);
            timeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [timeBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
            timeBtn.backgroundColor = kCustomColor(253, 137, 83);
            [timeBtn addTarget:self action:@selector(didClickBuy:) forControlEvents:(UIControlEventTouchUpInside)];
            [footerView addSubview:timeBtn];
            
            buyLab = [[UILabel alloc] initWithFrame:CGRectMake(90, 0, timeBtn.width-90, timeBtn.height)];
            buyLab.backgroundColor = [UIColor clearColor];
            buyLab.textColor = [UIColor whiteColor];
            buyLab.font = [UIFont systemFontOfSize:13];
            [timeBtn addSubview:buyLab];
            
            MZTimerLabel *timeLab = [[MZTimerLabel alloc] initWithLabel:buyLab andTimerType:MZTimerLabelTypeTimer];
            timeLab.delegate = self;
            
            timerLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, timeBtn.width, timeBtn.height)];
            timerLab.textColor = [UIColor whiteColor];
            timerLab.font =[UIFont systemFontOfSize:13];
            [timeBtn addSubview:timerLab];
            
            if ([prodata.IsStart boolValue])
            {
                [timeLab setCountDownTime:[prodata.RemainTime integerValue]];
                timerLab.text = @"立即购买";
                timerLab.textAlignment = NSTextAlignmentCenter;
                buyLab.hidden = YES;
                timeBtn.userInteractionEnabled = YES;
            }
            else
            {
                [timeLab setCountDownTime:[prodata.BusinessTime intValue]];
                timerLab.text = @" 剩余开始时间:";
                timerLab.textAlignment = NSTextAlignmentLeft;
                buyLab.hidden = NO;
                timeBtn.userInteractionEnabled = NO;
            }
            [timeLab start];
        }
        [footerView addSubview:btn];
    }
}

-(void)timerLabel:(MZTimerLabel*)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime
{
    if ([prodata.IsStart boolValue])
    {
        [timerLabel setCountDownTime:[prodata.BusinessTime integerValue]];
        prodata.IsStart = @"0";
        timerLab.text = @" 剩余开始时间:";
        timerLab.textAlignment = NSTextAlignmentLeft;
        buyLab.hidden = NO;
        timeBtn.userInteractionEnabled = NO;
    }
    else
    {
        [timerLabel setCountDownTime:[prodata.RemainTime integerValue]];
        prodata.IsStart =@"1";
        timerLab.text = @"立即购买";
        timerLab.textAlignment = NSTextAlignmentCenter;
        buyLab.hidden = YES;
        timeBtn.userInteractionEnabled = YES;
    }
    [timerLabel start];
}

-(void)didClickBuy:(UIButton *)btn
{
    //我要买
    CusChatViewController *VC = [[CusChatViewController alloc] initWithUserId:prodata.BuyerId AndTpye:2 andUserName:prodata.BuyerName];
    VC.detailData = prodata;
    VC.isFrom = isFromBuyPro;
    [self.navigationController pushViewController:VC animated:YES];
    
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
            [self didClickCollectProBtn:btn];
        }
            break;
//        case 1002:
//        {
//            //我要买
//            CusChatViewController *VC = [[CusChatViewController alloc] initWithUserId:prodata.BuyerId AndTpye:2 andUserName:prodata.BuyerName];
//            VC.detailData = prodata;
//            VC.isFrom = isFromBuyPro;
//            [self.navigationController pushViewController:VC animated:YES];
//        }
//            break;
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
    //我要买
    CusChatViewController *VC = [[CusChatViewController alloc] initWithUserId:prodata.BuyerId AndTpye:2 andUserName:prodata.BuyerName];
    VC.detailData = prodata;
    VC.isFrom = isFromBuyPro;
    [self.navigationController pushViewController:VC animated:YES];
}
-(void)didClickCollectProBtn:(UIButton *)button
{
    if (!TOKEN)
    {
        [Public showLoginVC:self];
        return;
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:prodata.ProductId forKey:@"Id"];
    if (!button.selected)
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
            if (button.selected)
            {
                [button setImage:[UIImage imageNamed:@"weishoucang"] forState:(UIControlStateNormal)];
                [button setTitle:@" 收藏" forState:(UIControlStateNormal)];
                [button setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
                button.selected = NO;
            }
            else
            {
                [button setImage:[UIImage imageNamed:@"yishoucang"] forState:(UIControlStateNormal)];
                [button setTitle:@" 已收藏" forState:(UIControlStateNormal)];
                [button setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
                button.selected = YES;
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

////点击标签
//-(void)didClickTag:(UITapGestureRecognizer *)tap
//{
//    ProductPicture *proPic = [prodata.ProductPic objectAtIndex:self.imageScrollView.contentOffset.x/(kScreenWidth-10)];
//    HomePicTag *proTags = [proPic.Tags objectAtIndex:tap.view.tag-100-self.imageScrollView.contentOffset.x/(kScreenWidth-10)];
//    CusBrandDetailViewController *VC = [[CusBrandDetailViewController alloc] init];
//    VC.BrandId = proTags.SourceId;
//    VC.BrandName = proTags.Name;
//    [self.navigationController pushViewController:VC animated:YES];
//}

//点击头像
-(void)didCLickToStore
{
    CusHomeStoreViewController *VC = [[CusHomeStoreViewController alloc] init];
    VC.userId = prodata.BuyerId;
    VC.userName = prodata.BuyerName;
    [self.navigationController pushViewController:VC animated:YES];
}

@end
