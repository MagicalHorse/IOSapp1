//
//  BuyerHomeViewController.m
//  joybar
//
//  Created by liyu on 15/5/4.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "BuyerHomeViewController.h"
#import "BuyerInComeViewController.h"
#import "BuyerSellViewController.h"
#import "BuyerHomeTableViewCell.h"
#import "BuyerStoreViewController.h"
#import "BuyerCircleViewController.h"
#import "BuyerPaymentViewController.h"
#import "UMSocialWechatHandler.h"
#import "UMSocial.h"
#import "SDWebImageManager.h"

@interface BuyerHomeViewController ()<UITableViewDataSource,UITableViewDelegate,UMSocialUIDelegate>
{
    BOOL isRefresh;

}
@property (strong, nonatomic)  BaseTableView *homeTableView;
@property (nonatomic,strong)NSMutableDictionary * dataArray;
@property (nonatomic,strong)UIImageView * img;
@property (nonatomic,strong)UILabel * label;


@end

@implementation BuyerHomeViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self setData];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self addNavBarViewAndTitle:@"首页"];
    self.retBtn.hidden = YES;
    
    //添加分享按钮
    UIButton *finishBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    finishBtn.frame = CGRectMake(kScreenWidth-64, 9, 64, 64);
    finishBtn.backgroundColor = [UIColor clearColor];
    [finishBtn setImage:[UIImage imageNamed:@"maishoufenxiang"] forState:(UIControlStateNormal)];
    [finishBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    finishBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [finishBtn addTarget:self action:@selector(didClickFinishBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.navView addSubview:finishBtn];
    
    self.homeTableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64-49) style:(UITableViewStylePlain)];
    self.homeTableView.isShowFooterView =NO;
    self.homeTableView.delegate = self;
    self.homeTableView.dataSource = self;
    [self.view addSubview:self.homeTableView];
    isRefresh=YES;
    self.homeTableView.tableHeaderView =[self tableHeaderViwe];
    self.homeTableView.tableFooterView =[[UIView alloc]init];
    __weak BuyerHomeViewController *VC = self;
    self.homeTableView.headerRereshingBlock = ^()
    {
        if (VC.dataArray.count>0) {
            VC.dataArray =nil;
        }
        [VC setData];
    };
    self.homeTableView.footerRereshingBlock=^(){
        [VC.homeTableView endRefresh];
        [VC.homeTableView hiddenFooter:YES];

    };
}


//分享
-(void)didClickFinishBtn:(UIButton *)btn
{
    if (!TOKEN)
    {
        [Public showLoginVC:self];
        return;
    }
    
    if (self.dataArray.count>0) {
     
        NSDictionary *dict =[self.dataArray objectForKey:@"share"];
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dict objectForKey:@"logo"]]] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            
            [UMSocialWechatHandler setWXAppId:APP_ID appSecret:APP_SECRET url:[dict objectForKey:@"share_link"]];
            
            [UMSocialSnsService presentSnsIconSheetView:self
                                        appKey:@"55d43bf367e58eac01002b7f"
                                        shareText:[dict objectForKey:@"desc"]
                                        shareImage:image
                                        shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline]
                                               delegate:self];
            [UMSocialData defaultData].extConfig.wechatSessionData.title = [dict objectForKey:@"title"];
            [UMSocialData defaultData].extConfig.wechatTimelineData.title = [dict objectForKey:@"title"];
        }];
    }else{
        [self showHudFailed:@"首页数据异常"];
    }
    
   
}
//实现回调方法（可选）：
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}

-(NSMutableDictionary *)dataArray{

    if (_dataArray ==nil) {
        _dataArray =[[NSMutableDictionary alloc]init];
    }
    return _dataArray;
}

-(void)setData{
    if (isRefresh) {
        [self showInView:self.homeTableView WithPoint:CGPointMake(0, 0) andHeight:kScreenHeight];
    }
     [HttpTool postWithURL:@"Buyer/Index" params:nil success:^(id json) {
         BOOL isSuccessful = [[json objectForKey:@"isSuccessful"] boolValue];
         if (isSuccessful) {
             self.dataArray = [json objectForKey:@"data"];
             [self.homeTableView reloadData];
             [self.homeTableView endRefresh];
             NSData *decodedImageData = [[NSData alloc]initWithBase64Encoding:[[json objectForKey:@"data"] objectForKey:@"barcode"]];
             UIImage *image = [UIImage imageWithData:decodedImageData];
             self.img.image =image;
             self.label.text = [self.dataArray objectForKey:@"shopname"];
         }else{
             [self showHudFailed:[json objectForKey:@"message"]];
         }
         [self.homeTableView hiddenFooter:YES];
         [self textHUDHiddle];
         [self activityDismiss];
         isRefresh=NO;
     } failure:^(NSError *error) {
         [self textHUDHiddle];
         [self activityDismiss];
         [self.homeTableView hiddenFooter:YES];


     }];
}
-(UIView *)tableHeaderViwe{
    
    UIView * hearView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    hearView.backgroundColor =kCustomColor(241, 241, 241);
    _img=[[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth-150)*0.5, 12, 150, 150)];
    [hearView addSubview:_img];
    
    _img.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickImage:)];
    [_img addGestureRecognizer:tap];
    
    _label =[[UILabel alloc]initWithFrame:CGRectMake(0, _img.bottom+10, kScreenWidth, 15)];
    _label.textAlignment =NSTextAlignmentCenter;
    _label.font =[UIFont systemFontOfSize:15];
    [hearView addSubview:_label];
    return hearView;
}

-(void)didClickImage:(UITapGestureRecognizer *)tgr{

    UIView  *bgView =[[UIView alloc]init];
    bgView.userInteractionEnabled=YES;
    bgView.backgroundColor =[UIColor blackColor];
    [self.view addSubview:bgView];
    bgView.frame =CGRectMake(0, 64, kScreenWidth, kScreenHeight);

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClick:)];
    [bgView addGestureRecognizer:tap];
    UIImageView *bgImg=(UIImageView *)tgr.view;
    UIImageView * img=[[UIImageView alloc]init];
    img.image = bgImg.image;
    
    [bgView addSubview:img];
    bgView.alpha=0;
    [UIView animateWithDuration:0.5 animations:^{

        img.center = CGPointMake(kScreenWidth/2, (kScreenHeight-64-49)/2);
        img.bounds = CGRectMake(0, 0, kScreenWidth-40, kScreenWidth-40);
        bgView.alpha=1;
    }];
    
}
-(void)didClick:(UITapGestureRecognizer *)tap
{
    tap.view.alpha =1;
    [UIView animateWithDuration:0.5 animations:^{
        tap.view.alpha =0;
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleIdentify = @"cell";
    BuyerHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleIdentify];
    if (cell == nil) {
        cell =[[[NSBundle mainBundle] loadNibNamed:@"BuyerHomeTableViewCell" owner:self options:nil] lastObject];
    }
    if (indexPath.row == 0) {
        cell.iconView.image =[UIImage imageNamed:@"pic3"] ;
        cell.tilteView.text =@"货款管理";
        cell.tilteD1View.text =@"今日货款";
        cell.tilteD2View.text =@"累计货款";
        CGFloat tempPirce =[[[self.dataArray objectForKey:@"goodsamount"] objectForKey:@"todaygoodsamount"] floatValue];
            cell.pirceD1View.text =[NSString stringWithFormat:@"%.2f",tempPirce];
        
        CGFloat  tempPirceD2 =[[[self.dataArray objectForKey:@"goodsamount"] objectForKey:@"totalgoodsamount"] floatValue];
            cell.pirceD2View.text =[NSString stringWithFormat:@"%.2f",tempPirceD2];
        
        cell.pirceDd1View.hidden =NO;
        cell.pirceDd2View.hidden =NO;
    }
    else if(indexPath.row ==1){
        cell.iconView.image =[UIImage imageNamed:@"shouyi3"] ;
        cell.tilteView.text =@"收益管理";
        cell.tilteD1View.text =@"今日收益";
        cell.tilteD2View.text =@"累计收益";
        CGFloat tempPirce = [[[self.dataArray objectForKey:@"income"]objectForKey:@"today_income"] floatValue];
        cell.pirceD1View.text =[NSString stringWithFormat:@"%.2f",tempPirce];
        
        CGFloat  tempPirceD2 =[[[self.dataArray objectForKey:@"income"] objectForKey:@"total_income"] floatValue];
        
        
        cell.pirceD2View.text =[NSString stringWithFormat:@"%.2f",tempPirceD2];
        
        cell.pirceDd1View.hidden =NO;
        cell.pirceDd2View.hidden =NO;
    }
    
    else if(indexPath.row ==2){
        cell.iconView.image =[UIImage imageNamed:@"pic4"] ;
        cell.tilteView.text =@"销售管理";
        cell.tilteD1View.text =@"今日订单";
        cell.tilteD2View.text =@"累计订单";
        
        NSString *tempPirceD1 =[[[self.dataArray objectForKey:@"order"] objectForKey:@"todayorder"] stringValue];
        if (tempPirceD1.length >0) {
            cell.pirceD1View.text =tempPirceD1;
        }else{
            cell.pirceD1View.text=@"0";
        }
        NSString *tempPirceD2 =[[[self.dataArray objectForKey:@"order"] objectForKey:@"allorder"] stringValue];
        if (tempPirceD2.length>0) {
            cell.pirceD2View.text =tempPirceD2;
        }else{
            cell.pirceD2View.text =@"0";
        }
        cell.pirceDd1View.hidden =YES;
        cell.pirceDd2View.hidden =YES;
    }else if(indexPath.row ==3){
        cell.iconView.image =[UIImage imageNamed:@"pic2"] ;
        cell.tilteView.text =@"商品管理";
        cell.tilteD1View.text =@"在线商品";
        cell.tilteD2View.text =@"即将下线";
        NSString *tempPirceD1 =[[[self.dataArray objectForKey:@"product"] objectForKey:@"onlineCount"] stringValue];
        if (tempPirceD1.length>0) {
            cell.pirceD1View.text =tempPirceD1;
        }else{
            cell.pirceD1View.text =@"0";
        }
        NSString *tempPirceD2 =[[[self.dataArray objectForKey:@"product"] objectForKey:@"soonDownCount"] stringValue];
        if (tempPirceD2.length>0) {
            cell.pirceD2View.text =tempPirceD2;
        }else{
            cell.pirceD2View.text =@"0";
        }
        cell.pirceDd1View.hidden =YES;
        cell.pirceDd2View.hidden =YES;
    }else if(indexPath.row ==4){
        cell.iconView.image =[UIImage imageNamed:@"pic1"] ;
        cell.tilteView.text =@"社交管理";
        cell.tilteD1View.text =@"我的粉丝";
        cell.tilteD2View.text =@"我的圈子";
        NSString *tempPirceD1 =[[[self.dataArray objectForKey:@"favorite"] objectForKey:@"favoritecount"] stringValue];
        if (tempPirceD1.length>0) {
            cell.pirceD1View.text =tempPirceD1;
        }else{
            cell.pirceD1View.text =@"0";
        }
        NSString *tempPirceD2 =[[[self.dataArray objectForKey:@"favorite"] objectForKey:@"groupcount"] stringValue];

        if (tempPirceD1.length>0) {
            cell.pirceD2View.text =tempPirceD2;
        }else{
            cell.pirceD2View.text =@"0";
        }
        cell.pirceDd1View.hidden =YES;
        cell.pirceDd2View.hidden =YES;
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.dataArray.count>0)
    {
        if (indexPath.row == 0) {
            BuyerPaymentViewController * income= [[BuyerPaymentViewController alloc]init];
            [self.navigationController pushViewController:income animated:YES];
        }else if (indexPath.row == 1) {
            BuyerInComeViewController * income= [[BuyerInComeViewController alloc]init];
            
            income.today_income =[[self.dataArray objectForKey:@"income"] objectForKey:@"today_income"];
            income.total_income =[[self.dataArray objectForKey:@"income"] objectForKey:@"total_income"];
            income.avail_amout =[[self.dataArray objectForKey:@"income"] objectForKey:@"avail_amount"];
            [self.navigationController pushViewController:income animated:YES];
        }else if(indexPath.row ==2){
            BuyerSellViewController * sell=[[BuyerSellViewController alloc]init];
            [self.navigationController pushViewController:sell animated:YES];
            
        }else if(indexPath.row ==3){
            BuyerStoreViewController * store = [[BuyerStoreViewController alloc]init];
            [self.navigationController pushViewController:store animated:YES];
        }else if(indexPath.row ==4){
            BuyerCircleViewController *circle = [[BuyerCircleViewController alloc]init];
            [self.navigationController pushViewController:circle animated:YES];
        }
    }
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

@end
