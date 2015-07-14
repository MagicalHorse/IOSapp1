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
#import "ComeIn.h"
#import "BuyerCircleViewController.h"
#import "BuyerPaymentViewController.h"
#import "UMSocialWechatHandler.h"
#import "UMSocial.h"

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

- (void)viewDidLoad {
    [super viewDidLoad];

    [self addNavBarViewAndTitle:@"首页"];
    self.retBtn.hidden = YES;
    
    //添加分享按钮
    UIButton *finishBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    finishBtn.frame = CGRectMake(kScreenWidth-64, 9, 64, 64);
    finishBtn.backgroundColor = [UIColor clearColor];
    [finishBtn setImage:[UIImage imageNamed:@"分享.png"] forState:(UIControlStateNormal)];
    [finishBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    finishBtn.titleLabel.font = [UIFont fontWithName:@"youyuan" size:16];
    [finishBtn addTarget:self action:@selector(didClickFinishBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.navView addSubview:finishBtn];
    
    self.homeTableView.tableFooterView =  [[UIView alloc]initWithFrame:CGRectZero];
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
    [self setData];
}


//分享
-(void)didClickFinishBtn:(UIButton *)btn
{
    if (!TOKEN)
    {
        [Public showLoginVC:self];
        return;
    }
    [UMSocialWechatHandler setWXAppId:APP_ID appSecret:APP_SECRET url:@"http://www.umeng.com/social"];
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"557f8f1c67e58edf32000208"
                                      shareText:@"友盟社会化分享让您快速实现分享等社会化功能，www.umeng.com/social"
                                     shareImage:[UIImage imageNamed:@"test1.jpg"]
                                shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline]
                                       delegate:self];
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
        [self showInView:self.homeTableView WithPoint:CGPointMake(0, 0) andHeight:kScreenHeight-64-49];
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
//             [self showHudFailed:@"加载失败"];
         }
         [self textHUDHiddle];
         [self activityDismiss];
         isRefresh=NO;
     } failure:^(NSError *error) {
         [self activityDismiss];
     }];
}
-(UIView *)tableHeaderViwe{
    
    UIView * hearView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 160)];
    hearView.backgroundColor =kCustomColor(241, 241, 241);
    _img=[[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth-120)*0.5, 12, 120, 120)];
    [hearView addSubview:_img];
    
    _img.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickImage:)];
    [_img addGestureRecognizer:tap];
    
    _label =[[UILabel alloc]initWithFrame:CGRectMake(0, _img.bottom+5, kScreenWidth, 15)];
    _label.textAlignment =NSTextAlignmentCenter;
    _label.font =[UIFont fontWithName:@"youyuan" size:15];
    [hearView addSubview:_label];
    return hearView;
}

-(void)didClickImage:(UITapGestureRecognizer *)tgr{

    UIView  *bgView =[[UIView alloc]init];
    bgView.userInteractionEnabled=YES;
    bgView.backgroundColor =[UIColor blackColor];
    [self.homeTableView addSubview:bgView];
    bgView.frame =CGRectMake(0, 0, kScreenWidth, kScreenHeight);

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClick:)];
    [bgView addGestureRecognizer:tap];
    UIImageView *bgImg=(UIImageView *)tgr.view;
    UIImageView * img=[[UIImageView alloc]init];
    img.image = bgImg.image;
    
    [bgView addSubview:img];
    bgView.alpha=0;
    [UIView animateWithDuration:0.5 animations:^{
        img.frame =CGRectMake(25, 80, 280, 280);
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
        cell.tilteD2View.text =@"累积货款";
        NSString *tempPirce =[[[self.dataArray objectForKey:@"goodsamount"] objectForKey:@"todaygoodsamount"] stringValue];
        if (tempPirce.length>0) {
            cell.pirceD1View.text =[NSString stringWithFormat:@"%@",tempPirce];
        }else{
            cell.pirceD1View.text=@"0.00";
        }
        NSString *tempPirceD2 =[[[self.dataArray objectForKey:@"goodsamount"] objectForKey:@"totalgoodsamount"] stringValue];
        if (tempPirce.length >0) {
            cell.pirceD2View.text =[NSString stringWithFormat:@"%@",tempPirceD2];
        }else{
            cell.pirceD2View.text=@"0.00";
        }
        cell.pirceDd1View.hidden =NO;
        cell.pirceDd2View.hidden =NO;
    }
    else if(indexPath.row ==1){
        cell.iconView.image =[UIImage imageNamed:@"shouyi3"] ;
        cell.tilteView.text =@"收益管理";
        cell.tilteD1View.text =@"今日收益";
        cell.tilteD2View.text =@"累积收益";
        cell.pirceD1View.text =@"500";
        NSString *tempPirce =[[[self.dataArray objectForKey:@"income"] objectForKey:@"today_income"] stringValue];
        if (tempPirce.length>0) {
            cell.pirceD1View.text =[NSString stringWithFormat:@"%@",tempPirce];
        }else{
            cell.pirceD1View.text=@"0.00";
        }
        NSString *tempPirceD2 =[[[self.dataArray objectForKey:@"income"] objectForKey:@"total_income"] stringValue];
        if (tempPirce.length >0) {
            cell.pirceD2View.text =[NSString stringWithFormat:@"%@",tempPirceD2];
        }else{
            cell.pirceD2View.text=@"0.00";
        }
        cell.pirceDd1View.hidden =NO;
        cell.pirceDd2View.hidden =NO;
    }
    
    else if(indexPath.row ==2){
        cell.iconView.image =[UIImage imageNamed:@"pic4"] ;
        cell.tilteView.text =@"销售管理";
        cell.tilteD1View.text =@"今日订单";
        cell.tilteD2View.text =@"累积订单";
        
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
    if (indexPath.row == 0) {
        ComeIn *come = [[ComeIn alloc]init];
        come.today_income =[[[self.dataArray objectForKey:@"income"] objectForKey:@"today_income"]intValue];
        come.total_income =[[[self.dataArray objectForKey:@"income"] objectForKey:@"total_income"]intValue];
        come.avail_amout =[[[self.dataArray objectForKey:@"income"] objectForKey:@"avail_amout"]intValue];
        
        BuyerPaymentViewController * income= [[BuyerPaymentViewController alloc]init];
        [self.navigationController pushViewController:income animated:YES];
    }else if (indexPath.row == 1) {
        ComeIn *come = [[ComeIn alloc]init];
        come.today_income =[[[self.dataArray objectForKey:@"income"] objectForKey:@"today_income"]intValue];
        come.total_income =[[[self.dataArray objectForKey:@"income"] objectForKey:@"total_income"]intValue];
        come.avail_amout =[[[self.dataArray objectForKey:@"income"] objectForKey:@"avail_amout"]intValue];

        BuyerInComeViewController * income= [[BuyerInComeViewController alloc]initWithComeIn:come];
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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

@end
