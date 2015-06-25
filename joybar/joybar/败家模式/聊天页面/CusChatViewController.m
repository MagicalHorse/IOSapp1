//
//  ChatViewController.m
//  joybar
//
//  Created by 123 on 15/5/19.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "CusChatViewController.h"
#import "ListView.h"
#import "MessageTableViewCell.h"
#import "MakeSureOrderViewController.h"
#import "DWTagList.h"
#import "ProDetailSize.h"
#import "CusCircleDetailViewController.h"
@interface CusChatViewController ()<UITableViewDataSource,UITableViewDelegate,SendMessageTextDelegate,UIScrollViewDelegate>

@property (nonatomic ,strong) BaseTableView *tableView;

@property (nonatomic ,strong) NSMutableArray *messageArr;

@property (nonatomic ,assign) NSInteger priceNum;

//规格ID
@property (nonatomic ,strong) NSString *sizeId;

//规格名字
@property (nonatomic ,strong) NSString *sizeName;
//库存
@property (nonatomic ,strong) NSString *sizeNum;


@end

@implementation CusChatViewController
{
    ListView *listView;
    UILabel *buyNumLab;
    UIView *buyBgView;
    UIView *tempView;
    UILabel *kuCunLab;
    NSString *uid;
    int utype;
    NSString *name;

}
-(instancetype)initWithUserId:(NSString *)userId AndTpye:(int)type andUserName:(NSString *)Username{
    if (self=[super init]) {
        uid =userId;
        utype =type;
        name =Username;
    }
    return self;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.priceNum = 0;
    self.messageArr = [[NSMutableArray alloc] init];
    self.view.backgroundColor = kCustomColor(236, 240, 241);
    self.tableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, 64+60, kScreenWidth, kScreenHeight-64-60-49)];
    self.tableView.headerPullToRefreshText1 = @"下拉可以加载了";
    self.tableView.headerReleaseToRefreshText1 = @"松开马上加载";
    self.tableView.headerRefreshingText1 = @"正在帮你加载,不客气";
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView hiddenFooter:YES];
    });

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
//        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
//    headerReleaseToRefreshText
//    headerRefreshingText
    self.tableView.headerRereshingBlock = ^{
      
        
        
    };
    if (self.isFrom==isFromBuyPro)
    {
        self.tableView.frame = CGRectMake(0, 64+60, kScreenWidth, kScreenHeight-64-60-49);
        [self addProductView];
    }
    else
    {
        self.tableView.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight-64-49);
    }
    
    [self _initWithBar];
    
    NSMutableDictionary *faceDict = [NSMutableDictionary dictionary];
    NSString *emojPath = [[NSBundle mainBundle]pathForResource:@"FaceList" ofType:@"plist"];
    
    NSArray *emojItem = [NSArray arrayWithContentsOfFile:emojPath];
    
    //将表情的名称以及对应的图片存入字典,方便使用.
    for (NSDictionary *dict in emojItem)
    {
        NSString *face_Image = [dict objectForKey:@"png"];
        NSString *faceName = [dict objectForKey:@"chs"];
        [faceDict setObject:face_Image forKey:faceName];
    }
    [[NSUserDefaults standardUserDefaults] setObject:faceDict forKey:@"faceInfo"];
    
    [self creatRoom];
    [self addTitleView];
}

-(void)creatRoom
{

    NSArray *arr=[NSArray array];
    NSString *myId=[[Public getUserInfo]objectForKey:@"id"]; //买手
    NSString *tempDict;
    NSString *tempOwner;
    if (self.isFrom==isFromPrivateChat)
    {
        if (utype ==1) {
            arr = @[myId,uid]; //uid 败家
            tempDict=[NSString stringWithFormat:@"%@_%@",myId,uid];
            tempOwner=myId;
        }else{
            arr = @[uid,myId];
            tempDict =[NSString stringWithFormat:@"%@_%@",uid,myId];
            tempOwner =uid;
        }
        NSDictionary *dic = @{@"room_id":tempDict,@"title":@"私聊",@"owner":tempDict,@"users":arr,@"type":@"private",@"sessionId":@"",@"signValue":@"",@"token":@"",@"userName":name};
        [[SocketManager socketManager].socket emit:@"join room" args:@[tempOwner,dic]];

    }
}

#pragma mark - UI
- (void)_initWithBar
{
    if (listView == nil) {
        listView = [[[NSBundle mainBundle]loadNibNamed:@"ListView" owner:self options:nil] lastObject];
        listView.sendMessageDelegate = self;
        [self.view addSubview:listView];
    }
}

-(void)addTitleView
{
    [self addNavBarViewAndTitle:@""];
    UILabel *nameLab = [[UILabel alloc] init];
    nameLab.center = CGPointMake(kScreenWidth/2, 32);
    nameLab.bounds = CGRectMake(0, 0, 200, 20);
    nameLab.text = name;
    nameLab.textAlignment = NSTextAlignmentCenter;
    nameLab.font = [UIFont fontWithName:@"youyuan" size:17];
    [self.navView addSubview:nameLab];
    
    UILabel *statusLab = [[UILabel alloc] init];
    statusLab.center = CGPointMake(kScreenWidth/2, nameLab.bottom+10);
    statusLab.bounds = CGRectMake(0, 0, 100, 20);
    statusLab.text = @"在线";
    statusLab.textColor = [UIColor lightGrayColor];
    statusLab.font = [UIFont fontWithName:@"youyuan" size:12];
    statusLab.textAlignment = NSTextAlignmentCenter;
    [self.navView addSubview:statusLab];
    
    if (self.isFrom==isFromGroupChat)
    {
        UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        btn.frame = CGRectMake(kScreenWidth-50, 20, 40, 40);
        [btn setImage:[UIImage imageNamed:@"设置icon"] forState:(UIControlStateNormal)];
        [btn addTarget:self action:@selector(didClickToDetail) forControlEvents:(UIControlEventTouchUpInside)];
        [self.navView addSubview:btn];
    }
    else
    {
        UIImageView *headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-50, 20, 40, 40)];
        headerImage.layer.cornerRadius = headerImage.width/2;
        headerImage.clipsToBounds = YES;
        [headerImage sd_setImageWithURL:[NSURL URLWithString:self.detailData.BuyerLogo] placeholderImage:nil];
        [self.navView addSubview:headerImage];

    }

}

-(void)addProductView
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 60)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    UIImageView *productImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
    productImage.clipsToBounds = YES;
    NSString *imageURL = [NSString stringWithFormat:@"%@_320x0.jpg",self.detailData.ProductPic.firstObject];
    [productImage sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:nil];
    [bgView addSubview:productImage];
    
    UILabel *proNameLab = [[UILabel alloc] initWithFrame:CGRectMake(productImage.right+5, productImage.top, 200, 20)];
    proNameLab.text = self.detailData.ProductName;
    proNameLab.font = [UIFont fontWithName:@"youyuan" size:14];
    proNameLab.textColor = [UIColor darkGrayColor];
    [bgView addSubview:proNameLab];
    
    UILabel *priceLab = [[UILabel alloc] initWithFrame:CGRectMake(productImage.right+5, proNameLab.bottom+5, 200, 20)];
    priceLab.text = [NSString stringWithFormat:@"￥%@",self.detailData.Price];
    priceLab.textColor = [UIColor darkGrayColor];
    priceLab.font = [UIFont fontWithName:@"youyuan" size:13];
    [bgView addSubview:priceLab];
    
    UIButton *buyBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    buyBtn.frame = CGRectMake(kScreenWidth-80, 15, 65, 30);
    buyBtn.backgroundColor = [UIColor orangeColor];
    buyBtn.layer.cornerRadius = 3;
    [buyBtn setTitle:@"立即购买" forState:(UIControlStateNormal)];
    buyBtn.titleLabel.font = [UIFont fontWithName:@"youyuan" size:13];
    [buyBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [buyBtn addTarget:self action:@selector(didClickBuyBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [bgView addSubview:buyBtn];
    
}

- (void)sendMessageText:(UITextView *)textView withData:(NSDate *)date
{
    NSString *fomeId;
    NSString *toId;
    NSString *myId=[[Public getUserInfo]objectForKey:@"id"];
    if (utype ==1) {
        fomeId =myId;
        toId =uid;
    }else{
        fomeId=uid;
        toId=myId;
    }
    NSDictionary *dic = @{@"fromUserId":fomeId,@"toUserId":toId,@"userName":name,@"productId":@"1",@"body":@"几乎不会结婚空间看机会",@"fromUserType":@"buyer",@"type":@"private"};
    [[SocketManager socketManager].socket emit:@"sendMessage" args:@[dic]];
    
    [self.tableView reloadData];
}

//-(void)changeTableViewFrameWhileShow:(BOOL)isAction
//{
//    if(isAction == NO){
//        self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-216-49-64);
//        if([self.tableView.messages count] != 0){
//            NSIndexPath *index = [NSIndexPath indexPathForRow:[self.tableView.messages count]-1 inSection:0];
//            [self.tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionBottom animated:NO];
//        }
//    }else{
//        self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-49-164);
//        if([self.tableView.messages count] != 0){
//            NSIndexPath *index = [NSIndexPath indexPathForRow:[self.tableView.messages count]-1 inSection:0];
//            [self.tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionBottom animated:NO];
//        }
//    }
//}

#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden = @"cell";
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell==nil)
    {
        cell = [[MessageTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:iden];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    for (UIView *sView in cell.contentView.subviews)
    {
        [sView removeFromSuperview];
    }
    
    //日期标签
    UILabel *senderAndTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth-20, 20)];
    senderAndTimeLabel.text = [self getCurrentTime];
    //居中显示
    senderAndTimeLabel.textAlignment = NSTextAlignmentCenter;
    senderAndTimeLabel.font = [UIFont systemFontOfSize:11.0];
    //文字颜色
    senderAndTimeLabel.textColor = [UIColor lightGrayColor];
    [cell.contentView addSubview:senderAndTimeLabel];
    
    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-10-150, 18, 100, 20)];
    nameLab.textAlignment = NSTextAlignmentRight;
    nameLab.text = @"我自己";
    nameLab.backgroundColor = [UIColor clearColor];
    nameLab.font = [UIFont fontWithName:@"youyuan" size:13];
    nameLab.textColor = [UIColor grayColor];
    [cell.contentView addSubview:nameLab];
    
    UIImageView *photo = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-10-40, 15, 40, 40)];
    photo.layer.cornerRadius = photo.width/2;
    photo.backgroundColor = [UIColor magentaColor];
    [cell.contentView addSubview:photo];

    //发送文字
//   [cell.contentView addSubview:[cell bubbleView:@"[吃惊]啊实打实SDFKLSDF乐山大佛;撒地方就爱上;离开的房间爱上对方as大师安师大奥斯丁" from:YES withPosition:60]];
    
    //发送链接
//    [cell.contentView addSubview:[cell productLinkBubbleView:nil AndProcuctLink:@"https://developer.apple.com/account/ios/certificate/certificateLanding.action" from:YES withPosition:60]];
    
    [cell.contentView addSubview:[cell imageBubbleView:nil from:YES withPosition:60]];
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 170;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [listView.messageTF resignFirstResponder];
}

//获取当前时间（接收和发送消息的时间）
-(NSString *)getCurrentTime
{
    NSDate *nowUTC = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    return [dateFormatter stringFromDate:nowUTC];
}

//立即购买
-(void)didClickBuyBtn
{
    tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    tempView.backgroundColor = [UIColor blackColor];
    tempView.alpha = 0.7;
    [self.view addSubview:tempView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickCancelBtn)];
    [tempView addGestureRecognizer:tap];
    
    buyBgView = [[UIView alloc] init];
    buyBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:buyBgView];
    
    UIImageView *proImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 65, 65)];
    NSString *imageURL = [NSString stringWithFormat:@"%@_320x0.jpg",self.detailData.ProductPic.firstObject];

    [proImg sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:nil];
    [buyBgView addSubview:proImg];
    
    UILabel *proLab = [[UILabel alloc] initWithFrame:CGRectMake(proImg.right+10, proImg.top, kScreenWidth-95, 40)];
    proLab.text = self.detailData.ProductName;
    proLab.numberOfLines = 2;
    proLab.font = [UIFont fontWithName:@"youyuan" size:14];
    [buyBgView addSubview:proLab];
    
    UILabel *priceLab = [[UILabel alloc] initWithFrame:CGRectMake(proImg.right+10, proLab.bottom, 200, 20)];
    priceLab.text =[NSString stringWithFormat:@"￥%@",self.detailData.Price];
    priceLab.textColor = [UIColor redColor];
    priceLab.font = [UIFont fontWithName:@"youyuan" size:16];
    [buyBgView addSubview:priceLab];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, proImg.bottom+10, kScreenWidth-10, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [buyBgView addSubview:line];
    
    UILabel *colorLab = [[UILabel alloc] initWithFrame:CGRectMake(10, line.bottom+10, 120, 20)];
    colorLab.text = @"颜色: 默认";
    colorLab.textColor = [UIColor grayColor];
    colorLab.font = [UIFont fontWithName:@"youyuan" size:14];
    [buyBgView addSubview:colorLab];
    
    UILabel *sizeLab = [[UILabel alloc] initWithFrame:CGRectMake(10, colorLab.bottom+10, 40, 20)];
    sizeLab.text = @"尺码:";
    sizeLab.font = [UIFont fontWithName:@"youyuan" size:15];
    [buyBgView addSubview:sizeLab];
    
    
    NSMutableArray *array = [NSMutableArray array];
    for (int i=0; i<self.detailData.Sizes.count; i++)
    {
        ProDetailSize *size = [self.detailData.Sizes objectAtIndex:i];
        [array addObject:size.Size];
    }
    DWTagList*sizeBtn = [[DWTagList alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-100, 300.0f)];
    sizeBtn.backgroundColor = [UIColor clearColor];
    [sizeBtn setTags:array];
    [buyBgView addSubview:sizeBtn];
    CGFloat height = [sizeBtn fittedSize].height;
    sizeBtn.frame = CGRectMake(sizeLab.right+5, colorLab.bottom+12, kScreenWidth-100, height);

    sizeBtn.clickBtnBlock = ^(UIButton *btn,NSInteger index)
    {
        ProDetailSize *size = [self.detailData.Sizes objectAtIndex:index];
        
        self.sizeId = size.SizeId;
        self.sizeNum = size.Inventory;
        self.sizeName = size.Size;
        kuCunLab.text = [NSString stringWithFormat:@"库存%@件",size.Inventory];
    };
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(10, sizeBtn.bottom+10, kScreenWidth-10, 0.5)];
    line1.backgroundColor = [UIColor lightGrayColor];
    [buyBgView addSubview:line1];
    
    buyBgView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 240+height+20);
    
    //数量
    UILabel *numLab = [[UILabel alloc] initWithFrame:CGRectMake(10, line1.bottom+20, 40, 20)];
    numLab.text = @"数量:";
    numLab.font = [UIFont fontWithName:@"youyuan" size:15];
    [buyBgView addSubview:numLab];
    
    UIView *numView = [[UIView alloc] initWithFrame:CGRectMake(numLab.right+6, line1.bottom+15, 120, 30)];
    numView.backgroundColor = kCustomColor(240, 240, 240);
    numView.layer.cornerRadius = 4;
    numView.layer.borderWidth = 0.5f;
    numView.layer.borderColor = kCustomColor(223, 223, 223).CGColor;
    [buyBgView addSubview:numView];
    
    UIButton *addBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    addBtn.frame = CGRectMake(numView.width-44, 0, 44, numView.height);
    [addBtn setImage:[UIImage imageNamed:@"加号icon"] forState:(UIControlStateNormal)];
    [addBtn setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    addBtn.backgroundColor = [UIColor clearColor];
    [addBtn addTarget:self action:@selector(didCLickAddNum) forControlEvents:(UIControlEventTouchUpInside)];
    [numView addSubview:addBtn];
    
    UIButton *minusBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    minusBtn.frame = CGRectMake(0, 0, 44, numView.height);
    [minusBtn setImage:[UIImage imageNamed:@"减号可点击icon"] forState:(UIControlStateNormal)];
    [minusBtn setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
    minusBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    minusBtn.backgroundColor = [UIColor clearColor];
    [minusBtn addTarget:self action:@selector(didClickDecrease) forControlEvents:(UIControlEventTouchUpInside)];
    [numView addSubview:minusBtn];
    
    buyNumLab = [[UILabel alloc] initWithFrame:CGRectMake(44, 0, numView.width-88, numView.height)];
    buyNumLab.backgroundColor = [UIColor whiteColor];
    buyNumLab.text = [NSString stringWithFormat:@"%ld",(long)self.priceNum];
    buyNumLab.textAlignment = NSTextAlignmentCenter;
    [numView addSubview:buyNumLab];
    
    kuCunLab = [[UILabel alloc] initWithFrame:CGRectMake(numView.right+10, numView.top+5, 150, 20)];
    kuCunLab.textColor = [UIColor redColor];
    kuCunLab.font = [UIFont fontWithName:@"youyuan" size:15];
    [buyBgView addSubview:kuCunLab];

    UIButton *cancelBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    cancelBtn.frame = CGRectMake(20, numView.bottom+20, 80, 35);
    cancelBtn.backgroundColor = [UIColor grayColor];
    cancelBtn.layer.cornerRadius = 3;
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [cancelBtn setTitle:@"取消" forState:(UIControlStateNormal)];
    cancelBtn.titleLabel.font = [UIFont fontWithName:@"youyuan" size:16];
    [cancelBtn addTarget:self action:@selector(didClickCancelBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [buyBgView addSubview:cancelBtn];
    
    UIButton *finishBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    finishBtn.frame = CGRectMake(kScreenWidth-100, numView.bottom+20, 80, 35);
    finishBtn.backgroundColor = [UIColor orangeColor];
    finishBtn.layer.cornerRadius = 3;
    [finishBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [finishBtn setTitle:@"确定" forState:(UIControlStateNormal)];
    finishBtn.titleLabel.font = [UIFont fontWithName:@"youyuan" size:16];
    [finishBtn addTarget:self action:@selector(didClickFinishlBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [buyBgView addSubview:finishBtn];

    [UIView animateWithDuration:0.25 animations:^{
        
        buyBgView.frame = CGRectMake(0, kScreenHeight-240-height-20, kScreenWidth, 240+height+20);
        
    }];
    
}

//增加
-(void)didCLickAddNum
{
    if (!self.sizeId)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择尺码" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好", nil];
        [alert show];
        return;
    }
    
    if (self.priceNum>=[self.sizeNum integerValue])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"库存不足" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好", nil];
        [alert show];
        return;
    }
    
    self.priceNum+=1;
    buyNumLab.text = [NSString stringWithFormat:@"%ld",(long)self.priceNum];
}

//减少
-(void)didClickDecrease
{
    if (self.priceNum<1)
    {
        return;
    }
    else
    {
        self.priceNum-=1;
        buyNumLab.text = [NSString stringWithFormat:@"%ld",(long)self.priceNum];
    }
}

//取消
-(void)didClickCancelBtn
{
    [tempView removeFromSuperview];
    self.sizeId = @"";
    self.priceNum = 0;
    
    [UIView animateWithDuration:0.25 animations:^{
        buyBgView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 240);
    } completion:^(BOOL finished) {
        [buyBgView removeFromSuperview];
    }];
}

//确定
-(void)didClickFinishlBtn
{
    if ([buyNumLab.text isEqualToString:@"0"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择购买数量" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好", nil];
        [alert show];
        return;
    }
    MakeSureOrderViewController *VC = [[MakeSureOrderViewController alloc] init];
    VC.detailData = self.detailData;
    VC.buyNum = buyNumLab.text;
    VC.sizeId = self.sizeId;
    VC.sizeName = self.sizeName;
    [self.navigationController pushViewController:VC animated:YES];
}

//圈子详情
-(void)didClickToDetail
{
    CusCircleDetailViewController *VC = [[CusCircleDetailViewController alloc] init];
    VC.circleId = self.circleId;
    [self.navigationController pushViewController:VC animated:YES];
}

@end
