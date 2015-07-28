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
#import "OSSClient.h"
#import "OSSTool.h"
#import "OSSData.h"
#import "OSSLog.h"
#import "CusBuyerDetailViewController.h"
#import "ProductPicture.h"

@interface CusChatViewController ()<UITableViewDataSource,UITableViewDelegate,SendMessageTextDelegate,UIScrollViewDelegate,MessageMoreViewDelegate>

@property (nonatomic ,strong) BaseTableView *tableView;

@property (nonatomic ,strong) NSMutableArray *messageArr;

@property (nonatomic ,assign) NSInteger priceNum;
//规格ID
@property (nonatomic ,strong) NSString *sizeId;
//规格名字
@property (nonatomic ,strong) NSString *sizeName;
//库存
@property (nonatomic ,strong) NSString *sizeNum;
@property (nonatomic ,assign) NSInteger pageNum;

@property (nonatomic ,strong) NSData *selectImageData;

@property (nonatomic ,strong) NSMutableArray *selectProLinkArr;


@end

@implementation CusChatViewController
{
    ListView *listView;
    UILabel *buyNumLab;
    UIView *buyBgView;
    UIView *tempView;
    UILabel *kuCunLab;
    NSString *toUserId;
    int utype;
    NSString *toUserName;
    UILabel *titleNameLab;
    NSDictionary *chatRoomData;
    OSSData *osData;
}
-(instancetype)initWithUserId:(NSString *)userId AndTpye:(int)type andUserName:(NSString *)Username
{
    if (self=[super init])
    {
        toUserId =userId;
        utype =type;
        toUserName =Username;
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[SocketManager  socketManager].socket emit:@"leaveRoom"];
}



- (void)viewDidLoad
{
    [super viewDidLoad];

    [[SocketManager socketManager].socket on:@"new message" callback:^(NSArray *args) {
        NSDictionary *dic = args.firstObject;
        [self.messageArr addObject:dic];
        [self.tableView reloadData];
        [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height -self.tableView.bounds.size.height) animated:YES];
    }];

    self.priceNum = 0;
    self.pageNum = 1;
    self.messageArr = [[NSMutableArray alloc] init];
    self.selectProLinkArr = [[NSMutableArray alloc] init];
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
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickTableView)];
//    [self.tableView addGestureRecognizer:tap];
    
    __weak CusChatViewController *VC = self;
    self.tableView.headerRereshingBlock = ^{
        
        VC.pageNum++;
        [VC getMessageListData:YES];
    };
    
    [self.tableView hiddenHeader:YES];

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
        [faceDict setValue:face_Image forKey:faceName];
    }
    [[NSUserDefaults standardUserDefaults] setObject:faceDict forKey:@"faceInfo"];
    
    //    if ([chatRoomId isEqualToString:@""])
    //    {
    [self getRoomId];
    [self addTitleView];
    
}

-(void)getRoomId
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (self.isFrom==isFromPrivateChat||self.isFrom==isFromBuyPro)
    {
        [dic setValue:@"0" forKey:@"groupId"];
        [dic setValue:[[Public getUserInfo] objectForKey:@"id"] forKey:@"fromUser"];
        [dic setValue:toUserId forKey:@"toUser"];
    }
    else if (self.isFrom==isFromGroupChat)
    {
        [dic setValue:self.circleId forKey:@"groupId"];
        [dic setValue:@"0" forKey:@"fromUser"];
        [dic setValue:@"0" forKey:@"toUser"];
    }
    
    [HttpTool postWithURL:@"Community/GetRoom" params:dic success:^(id json) {
        
        if ([[json objectForKey:@"isSuccessful"] boolValue])
        {
            chatRoomData = [json objectForKey:@"data"];
            [self creatRoom];
            [self getMessageListData:NO];
        }
        else
        {
            [self showHudFailed:[json objectForKey:@"message"]];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)getMessageListData:(BOOL)isRefresh
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[chatRoomData objectForKey:@"id"] forKey:@"roomId"];
    [dic setValue:[NSString stringWithFormat:@"%ld",(long)self.pageNum] forKey:@"page"];
    [dic setValue:@"10" forKey:@"pagesize"];
    
    [HttpTool postWithURL:@"Community/GetMessages" params:dic success:^(id json) {
        
        [self.tableView endRefresh];

        if([[json objectForKey:@"isSuccessful"] boolValue])
        {
            titleNameLab.text = toUserName;
            NSArray *arr = [[json objectForKey:@"data"] objectForKey:@"items"];
            if (arr.count<10)
            {
                [self.tableView hiddenHeader:YES];
            }
            else
            {
                [self.tableView hiddenHeader:NO];
            }
            for (NSDictionary *dic in arr)
            {
                [self.messageArr insertObject:dic atIndex:0];
            }
            [self.tableView reloadData];
            
            if (isRefresh)
            {
                [self.tableView setContentOffset:CGPointMake(0, arr.count*170) animated:NO];
            }
            else
            {
                if (self.tableView.contentSize.height>kScreenHeight-64-49)
                {
                    [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height -self.tableView.bounds.size.height) animated:YES];
                }
                else
                {
                    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
                }
            }
        }
        else
        {
            [self showHudFailed:[json objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
    }];
    
}
-(void)creatRoom
{
    NSArray *arr;
    NSString *myId=[[Public getUserInfo]objectForKey:@"id"]; //买手
    NSString *type;
    
    if (self.isFrom==isFromPrivateChat||self.isFrom==isFromBuyPro)
    {
        type = @"private";
        arr = @[toUserId,myId];
    }
    else
    {
        type = @"group";
        arr = [chatRoomData objectForKey:@"userList"];
    }
    NSDictionary *dic = @{@"room_id":[chatRoomData objectForKey:@"id"],@"title":@"私聊",@"owner":[chatRoomData objectForKey:@"owner"],@"users":arr,@"type":type,@"sessionId":@"",@"signValue":@"",@"token":@"",@"userName":toUserName};
    
    [[SocketManager socketManager].socket emit:@"join room" args:@[myId,dic]];
}

#pragma mark - UI
- (void)_initWithBar
{
    if (listView == nil)
    {
        listView = [[[NSBundle mainBundle]loadNibNamed:@"ListView" owner:self options:nil] lastObject];
        listView.sendMessageDelegate = self;
        listView.moreView.messageMoreDelegate = self;
        [self.view addSubview:listView];
    }
}

-(void)addTitleView
{
    [self addNavBarViewAndTitle:@""];
    titleNameLab = [[UILabel alloc] init];
    titleNameLab.center = CGPointMake(kScreenWidth/2, 42);
    titleNameLab.bounds = CGRectMake(0, 0, 200, 44);
    titleNameLab.text = @"收取消息中...";
    titleNameLab.textAlignment = NSTextAlignmentCenter;
    titleNameLab.font = [UIFont systemFontOfSize:17];
    [self.navView addSubview:titleNameLab];
    
//    UILabel *statusLab = [[UILabel alloc] init];
//    statusLab.center = CGPointMake(kScreenWidth/2, titleNameLab.bottom+10);
//    statusLab.bounds = CGRectMake(0, 0, 100, 20);
//    statusLab.text = @"在线";
//    statusLab.textColor = [UIColor lightGrayColor];
//    statusLab.font = [UIFont fontWithName:@"youyuan" size:12];
//    statusLab.textAlignment = NSTextAlignmentCenter;
//    [self.navView addSubview:statusLab];
    
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
//        UIImageView *headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-50, 20, 40, 40)];
//        headerImage.layer.cornerRadius = headerImage.width/2;
//        headerImage.clipsToBounds = YES;
//        [headerImage sd_setImageWithURL:[NSURL URLWithString:self.detailData.BuyerLogo] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
//        [self.navView addSubview:headerImage];
    }
}

-(void)addProductView
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 60)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    UIImageView *productImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
    productImage.clipsToBounds = YES;
    ProductPicture *pic = self.detailData.ProductPic.firstObject;
    NSString *imageURL = [NSString stringWithFormat:@"%@",pic.Logo];

    [productImage sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    [bgView addSubview:productImage];
    
    UILabel *proNameLab = [[UILabel alloc] initWithFrame:CGRectMake(productImage.right+5, productImage.top, 200, 20)];
    proNameLab.text = self.detailData.ProductName;
    proNameLab.font = [UIFont systemFontOfSize:14];
    proNameLab.textColor = [UIColor darkGrayColor];
    [bgView addSubview:proNameLab];
    
    UILabel *priceLab = [[UILabel alloc] initWithFrame:CGRectMake(productImage.right+5, proNameLab.bottom+5, 200, 20)];
    priceLab.text = [NSString stringWithFormat:@"￥%@",self.detailData.Price];
    priceLab.textColor = [UIColor darkGrayColor];
    priceLab.font = [UIFont systemFontOfSize:13];
    [bgView addSubview:priceLab];
    
    UIButton *buyBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    buyBtn.frame = CGRectMake(kScreenWidth-80, 15, 65, 30);
    buyBtn.backgroundColor = [UIColor orangeColor];
    buyBtn.layer.cornerRadius = 3;
    [buyBtn setTitle:@"立即购买" forState:(UIControlStateNormal)];
    buyBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [buyBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [buyBtn addTarget:self action:@selector(didClickBuyBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [bgView addSubview:buyBtn];
    
}

//发送文字
- (void)sendMessageText:(UITextView *)textView withData:(NSDate *)date
{
    [self sendMessageWithType:@"发送文字" andText:textView.text];
}

-(void)selectImage:(NSData *)data
{
    self.selectImageData = data;
    
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYYMMddHHmmsss"];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    NSString *temp=[NSString stringWithFormat:@"%@.png",locationString];
    
    OSSBucket *bucket = [[OSSBucket alloc] initWithBucket:AlyBucket];
    osData = [[OSSData alloc] initWithBucket:bucket withKey:temp];
    [osData setData:data withType:@"image/png"];
    [self hudShow:@"正在发送..."];
    [osData uploadWithUploadCallback:^(BOOL isSuccess, NSError *error) {
        if (isSuccess)
        {
            [self textHUDHiddle];
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setValue:temp forKey:@"imageurl"];
            [HttpTool postWithURL:@"Community/UploadChatImage" params:dic success:^(id json) {
                
                [self textHUDHiddle];
                if ([json objectForKey:@"isSuccessful"])
                {
                    [self sendMessageWithType:@"发送图片" andText:[[json objectForKey:@"data"] objectForKey:@"imageurl"]];
                }
                else
                {
                    [self showHudFailed:@"上传失败"];
                }
                
            } failure:^(NSError *error) {
                
            }];
            
        }
        else
        {
            [self showHudFailed:@"上传失败"];
        }
        
    } withProgressCallback:^(float progress) {
        NSLog(@"%f",progress);
    }];

}

//选择商品回调
-(void)selectProLink:(NSArray *)arr
{
    [self.selectProLinkArr removeAllObjects];
    [self.selectProLinkArr addObjectsFromArray:arr];
    [self sendMessageWithType:@"发送商品" andText:@""];
}

-(void)sendMessageWithType:(NSString *)type andText:(NSString *)text
{
    NSString *myId=[[Public getUserInfo]objectForKey:@"id"];
    toUserName = [[Public getUserInfo] objectForKey:@"nickname"];
    
    //发送图片
    if ([type isEqualToString:@"发送图片"])
    {
        NSMutableDictionary *msgDic = [NSMutableDictionary dictionary];
        [msgDic setValue:@"" forKey:@"Id"];
        [msgDic setValue:@"0" forKey:@"__v"];
        [msgDic setValue:text forKey:@"body"];
        [msgDic setValue:@"" forKey:@"creationDate"];
        [msgDic setValue:myId forKey:@"fromUserId"];
        [msgDic setValue:[[Public getUserInfo] objectForKey:@"logo"] forKey:@"logo"];
        [msgDic setValue:[chatRoomData objectForKey:@"id"] forKey:@"roomId"];
        [msgDic setValue:@"" forKey:@"sharelink"];
        [msgDic setValue:toUserId forKey:@"toUserId"];
        [msgDic setValue:@"" forKey:@"type"];
        [msgDic setValue:@"" forKey:@"userIp"];
        [msgDic setValue:toUserName forKey:@"userName"];
        [msgDic setValue:@"" forKey:@"productId"];

        [msgDic setValue:@"img" forKey:@"type"];
        NSDictionary *dic = @{@"fromUserId":myId,@"toUserId":toUserId,@"userName":toUserName,@"productId":@"",@"body":text,@"fromUserType":@"buyer",@"type":@"img"};
        [[SocketManager socketManager].socket emit:@"sendMessage" args:@[dic]];
        [self.messageArr addObject:msgDic];
    }
    else if ([type isEqualToString:@"发送商品"])
    {
        NSLog(@"%lu",(unsigned long)self.selectProLinkArr.count);
        for (int i=0; i<self.selectProLinkArr.count; i++)
        {
            
            NSMutableDictionary *msgDic = [NSMutableDictionary dictionary];
            [msgDic setValue:@"" forKey:@"Id"];
            [msgDic setValue:@"0" forKey:@"__v"];
            [msgDic setValue:@"" forKey:@"creationDate"];
            [msgDic setValue:myId forKey:@"fromUserId"];
            [msgDic setValue:[[Public getUserInfo] objectForKey:@"logo"] forKey:@"logo"];
            [msgDic setValue:[chatRoomData objectForKey:@"id"] forKey:@"roomId"];
            [msgDic setValue:toUserId forKey:@"toUserId"];
            [msgDic setValue:@"" forKey:@"type"];
            [msgDic setValue:@"" forKey:@"userIp"];
            [msgDic setValue:toUserName forKey:@"userName"];

            [msgDic setValue:@"product_img" forKey:@"type"];
            [msgDic setValue:[[[self.selectProLinkArr objectAtIndex:i] objectForKey:@"pic"] objectForKey:@"pic"] forKey:@"body"];
            NSString *proId = [[self.selectProLinkArr objectAtIndex:i] objectForKey:@"Id"];
            [msgDic setValue:[[self.selectProLinkArr objectAtIndex:i] objectForKey:@"Id"] forKey:@"productId"];

            NSString *proLink = [[self.selectProLinkArr objectAtIndex:i] objectForKey:@"ShareLink"];
            [msgDic setValue:proLink forKey:@"sharelink"];
            
            NSString *imageURL = [NSString stringWithFormat:@"%@",[[[self.selectProLinkArr objectAtIndex:i] objectForKey:@"pic"] objectForKey:@"pic"]];

            NSDictionary *dic = @{@"fromUserId":myId,@"toUserId":toUserId,@"userName":toUserName,@"productId":proId,@"body":imageURL,@"fromUserType":@"",@"type":@"product_img"};
            [[SocketManager socketManager].socket emit:@"sendMessage" args:@[dic]];
            [self.messageArr addObject:msgDic];
        }
        NSLog(@"asdasdasdasda");
    }
    else
    {
        NSMutableDictionary *msgDic = [NSMutableDictionary dictionary];
        [msgDic setValue:@"" forKey:@"Id"];
        [msgDic setValue:@"0" forKey:@"__v"];
        [msgDic setValue:text forKey:@"body"];
        [msgDic setValue:@"" forKey:@"creationDate"];
        [msgDic setValue:myId forKey:@"fromUserId"];
        [msgDic setValue:[[Public getUserInfo] objectForKey:@"logo"] forKey:@"logo"];
        [msgDic setValue:[chatRoomData objectForKey:@"id"] forKey:@"roomId"];
        [msgDic setValue:@"" forKey:@"sharelink"];
        [msgDic setValue:toUserId forKey:@"toUserId"];
        [msgDic setValue:@"" forKey:@"type"];
        [msgDic setValue:@"" forKey:@"userIp"];
        [msgDic setValue:toUserName forKey:@"userName"];
        [msgDic setValue:@"" forKey:@"productId"];

        NSDictionary *dic = @{@"fromUserId":myId,@"toUserId":toUserId,@"userName":toUserName,@"productId":@"",@"body":text,@"fromUserType":@"buyer",@"type":@""};
        [[SocketManager socketManager].socket emit:@"sendMessage" args:@[dic]];
        
        [self.messageArr addObject:msgDic];
    }
    listView.messageTF.text = @"";
    [self.tableView reloadData];

     [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height -self.tableView.bounds.size.height) animated:YES];
}


-(void)changeTableViewFrameWhileShow:(BOOL)isAction
{
    if(isAction == NO){
        self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-216-49-64);
        if([self.messageArr count] != 0){
            NSIndexPath *index = [NSIndexPath indexPathForRow:[self.messageArr count]-1 inSection:0];
            [self.tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }else{
        self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-49-164);
        if([self.messageArr count] != 0){
            NSIndexPath *index = [NSIndexPath indexPathForRow:[self.messageArr count]-1 inSection:0];
            [self.tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }
}

-(void)changeTableViewFrameWhileHidden
{
    if (self.isFrom==isFromBuyPro)
    {
        self.tableView.frame = CGRectMake(0, 64+60, kScreenWidth, kScreenHeight-64-60-49);
    }
    else
    {
        self.tableView.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight-64-49);
    }
}

#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messageArr.count;
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
    
    if (self.messageArr.count>0)
    {
        NSDictionary *msgDic = [self.messageArr objectAtIndex:indexPath.row];

        //广播
        if ([[msgDic objectForKey:@"type"] isEqualToString:@"notice"])
        {
            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
            lab.text = [msgDic objectForKey:@"body"];
            lab.font = [UIFont systemFontOfSize:11];
            lab.textAlignment = NSTextAlignmentCenter;
            lab.textColor = [UIColor lightGrayColor];
            [cell.contentView addSubview:lab];
        }
        else
        {
            //日期标签
            UILabel *senderAndTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth-20, 20)];
            senderAndTimeLabel.text = [msgDic objectForKey:@"creationDate"];
            //居中显示
            senderAndTimeLabel.textAlignment = NSTextAlignmentCenter;
            senderAndTimeLabel.font = [UIFont systemFontOfSize:11.0];
            //文字颜色
            senderAndTimeLabel.textColor = [UIColor lightGrayColor];
            [cell.contentView addSubview:senderAndTimeLabel];
            
            //自己
            NSString *fromUserId = [NSString stringWithFormat:@"%@",[msgDic objectForKey:@"fromUserId"]];
            NSString *myId = [NSString stringWithFormat:@"%@",[[Public getUserInfo] objectForKey:@"id"]];
            if ([fromUserId isEqualToString:myId])
            {
                UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-10-150, 18, 100, 20)];
                nameLab.textAlignment = NSTextAlignmentRight;
                nameLab.text = @"我自己";
                nameLab.backgroundColor = [UIColor clearColor];
                nameLab.font = [UIFont systemFontOfSize:13];
                nameLab.textColor = [UIColor grayColor];
                [cell.contentView addSubview:nameLab];
                
                UIImageView *photo = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-10-40, 15, 40, 40)];
                photo.layer.cornerRadius = photo.width/2;
                photo.clipsToBounds = YES;
                [photo sd_setImageWithURL:[NSURL URLWithString:[msgDic objectForKey:@"logo"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                [cell.contentView addSubview:photo];
                
                //图片
                if ([[msgDic objectForKey:@"type"] isEqualToString:@"img"])
                {
                    [cell.contentView addSubview:[cell imageBubbleView:[msgDic objectForKey:@"body"] from:YES withPosition:60]];
                }
                //链接
                else if ([[msgDic objectForKey:@"type"] isEqualToString:@"product_img"])
                {
                    NSString *imageURL = [NSString stringWithFormat:@"%@",[msgDic objectForKey:@"body"]];
                    //发送链接
                    [cell.contentView addSubview:[cell productLinkBubbleView:imageURL AndProcuctLink:[msgDic objectForKey:@"sharelink"] from:YES withPosition:60]];
                }
                else if ([[msgDic objectForKey:@"type"] isEqualToString:@""])
                {
                    //发送文字
                    [cell.contentView addSubview:[cell bubbleView:[msgDic objectForKey:@"body"] from:YES withPosition:60]];
                }
            }
            else
            {
                UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(60, 18, 100, 20)];
                nameLab.textAlignment = NSTextAlignmentLeft;
                nameLab.text = [msgDic objectForKey:@"userName"];
                nameLab.backgroundColor = [UIColor clearColor];
                nameLab.font = [UIFont systemFontOfSize:13];
                nameLab.textColor = [UIColor grayColor];
                [cell.contentView addSubview:nameLab];
                
                UIImageView *photo = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 40, 40)];
                photo.layer.cornerRadius = photo.width/2;
                photo.clipsToBounds = YES;
                [photo sd_setImageWithURL:[NSURL URLWithString:[msgDic objectForKey:@"logo"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                [cell.contentView addSubview:photo];
                
                //图片
                if ([[msgDic objectForKey:@"type"] isEqualToString:@"img"])
                {
                    [cell.contentView addSubview:[cell imageBubbleView:[msgDic objectForKey:@"body"] from:NO withPosition:60]];
                }
                //链接
                else if ([[msgDic objectForKey:@"type"] isEqualToString:@"product_img"])
                {
                    //发送链接
                    [cell.contentView addSubview:[cell productLinkBubbleView:[msgDic objectForKey:@"body"] AndProcuctLink:[msgDic objectForKey:@"sharelink"] from:NO withPosition:60]];
                }
                else
                {
                    //发送文字
                    [cell.contentView addSubview:[cell bubbleView:[msgDic objectForKey:@"body"] from:NO withPosition:60]];
                }
            }
        }
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.messageArr.count>0)
    {
        NSMutableDictionary *msgDic = [self.messageArr objectAtIndex:indexPath.row];
        
        if ([[msgDic objectForKey:@"type"] isEqualToString:@"img"])
        {
            return 170;
        }
        //链接
        else if ([[msgDic objectForKey:@"type"] isEqualToString:@"product_img"])
        {
            return 170;
        }
        if ([[msgDic objectForKey:@"type"] isEqualToString:@""])
        {
            UIFont *font = [UIFont systemFontOfSize:15];
            CGSize size = [[msgDic objectForKey:@"body"] sizeWithFont:font constrainedToSize:CGSizeMake(180.0f, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
            return size.height+59;
        }
    }
    return 170;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *msgDic = [self.messageArr objectAtIndex:indexPath.row];
    if ([[msgDic objectForKey:@"type"] isEqualToString:@"product_img"])
    {
        CusBuyerDetailViewController *VC = [[CusBuyerDetailViewController alloc] init];
        VC.productId = [msgDic objectForKey:@"productId"];
        [self.navigationController pushViewController: VC animated:YES];
    }
    if ([[msgDic objectForKey:@"type"] isEqualToString:@"img"])
    {
        [self setBigImageView];
    }

}

-(void)setBigImageView
{
    UIImageView *bigImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    
}


//-(void)didClickTableView
//{
//    [listView.messageTF resignFirstResponder];
////    [listView moreBtnAction:nil];
//    [UIView animateWithDuration:0.25 animations:^{
//        listView.moreView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 164);
//        listView.frame = CGRectMake(0, self.view.frame.size.height-49, kScreenWidth, 49);
//        listView.faceView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 216-49);
//        [self changeTableViewFrameWhileHidden];
//    }];
//}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}


-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [listView.messageTF resignFirstResponder];
    //    [listView moreBtnAction:nil];
    [UIView animateWithDuration:0.25 animations:^{
        listView.moreView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 164);
        listView.frame = CGRectMake(0, self.view.frame.size.height-49, kScreenWidth, 49);
        listView.faceView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 216-49);
        [self changeTableViewFrameWhileHidden];
    }];

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
    ProductPicture *pic = self.detailData.ProductPic.firstObject;
    NSString *imageURL = [NSString stringWithFormat:@"%@",pic.Logo];
    [proImg sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    [buyBgView addSubview:proImg];
    
    UILabel *proLab = [[UILabel alloc] initWithFrame:CGRectMake(proImg.right+10, proImg.top, kScreenWidth-95, 40)];
    proLab.text = self.detailData.ProductName;
    proLab.numberOfLines = 2;
    proLab.font = [UIFont systemFontOfSize:14];
    [buyBgView addSubview:proLab];
    
    UILabel *priceLab = [[UILabel alloc] initWithFrame:CGRectMake(proImg.right+10, proLab.bottom, 200, 20)];
    priceLab.text =[NSString stringWithFormat:@"￥%@",self.detailData.Price];
    priceLab.textColor = [UIColor redColor];
    priceLab.font = [UIFont systemFontOfSize:16];
    [buyBgView addSubview:priceLab];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, proImg.bottom+10, kScreenWidth-10, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [buyBgView addSubview:line];
    
    UILabel *colorLab = [[UILabel alloc] initWithFrame:CGRectMake(10, line.bottom+10, 120, 20)];
    colorLab.text = @"颜色: 默认";
    colorLab.textColor = [UIColor grayColor];
    colorLab.font = [UIFont systemFontOfSize:14];
    [buyBgView addSubview:colorLab];
    
    UILabel *sizeLab = [[UILabel alloc] initWithFrame:CGRectMake(10, colorLab.bottom+10, 40, 20)];
    sizeLab.text = @"尺码:";
    sizeLab.font = [UIFont systemFontOfSize:15];
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

    UIView *line1 = [[UIView alloc] init];
    if (self.detailData.Sizes.count>0)
    {
        line1.frame =CGRectMake(10, sizeBtn.bottom+10, kScreenWidth-10, 0.5);
    }
    else
    {
        line1.frame =CGRectMake(10, sizeBtn.bottom+23, kScreenWidth-10, 0.5);

    }
    line1.backgroundColor = [UIColor lightGrayColor];
    [buyBgView addSubview:line1];
    
    buyBgView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 240+height+20);
    
    //数量
    UILabel *numLab = [[UILabel alloc] initWithFrame:CGRectMake(10, line1.bottom+20, 40, 20)];
    numLab.text = @"数量:";
    numLab.font = [UIFont systemFontOfSize:15];
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
    kuCunLab.font = [UIFont systemFontOfSize:15];
    [buyBgView addSubview:kuCunLab];
    
    UIButton *cancelBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    cancelBtn.frame = CGRectMake(20, numView.bottom+20, 80, 35);
    cancelBtn.backgroundColor = [UIColor grayColor];
    cancelBtn.layer.cornerRadius = 3;
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [cancelBtn setTitle:@"取消" forState:(UIControlStateNormal)];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [cancelBtn addTarget:self action:@selector(didClickCancelBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [buyBgView addSubview:cancelBtn];
    
    UIButton *finishBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    finishBtn.frame = CGRectMake(kScreenWidth-100, numView.bottom+20, 80, 35);
    finishBtn.backgroundColor = [UIColor orangeColor];
    finishBtn.layer.cornerRadius = 3;
    [finishBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [finishBtn setTitle:@"确定" forState:(UIControlStateNormal)];
    finishBtn.titleLabel.font = [UIFont systemFontOfSize:16];
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
