//
//  ChatViewController.m
//  joybar
//
//  Created by 123 on 15/5/19.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "CircleViewController.h"
#import "ListView.h"
#import "MessageTableViewCell.h"
#import "MakeSureOrderViewController.h"
#import "MakeSureVipOrderViewController.h"
#import "DWTagList.h"
#import "ProDetailSize.h"
#import "CusCircleDetailViewController.h"
#import "OSSClient.h"
#import "OSSTool.h"
#import "OSSData.h"
#import "OSSLog.h"
#import "CusRProDetailViewController.h"
#import "ProductPicture.h"
#import "CusHomeStoreViewController.h"
@interface CircleViewController ()<UITableViewDataSource,UITableViewDelegate,SendMessageTextDelegate,UIScrollViewDelegate,MessageMoreViewDelegate>

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

@implementation CircleViewController
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

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[SocketManager  socketManager].socket emit:@"leaveRoom"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    toUserId = self.userId;
//    toUserName = self.userName;
    UIView *bgView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    UILabel *notice = [[UILabel alloc] init];
    notice.text = @"阿打算打算大神大神大神大神大神的";
    notice.numberOfLines = 1;
    notice.font =[UIFont systemFontOfSize:14];
    notice.adjustsFontSizeToFitWidth = YES;
    //    CGSize size = [Public getContentSizeWith:notice.text andFontSize:14 andWidth:kScreenWidth-60];
    notice.frame =CGRectMake(10, 0, kScreenWidth-70, 50);
    [bgView addSubview:notice];
    
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = CGRectMake(kScreenWidth-50, 5, 40, 40);
    [btn setImage:[UIImage imageNamed:@"设置icon"] forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(didClickToDetail) forControlEvents:(UIControlEventTouchUpInside)];
    [bgView addSubview:btn];

    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[[Public getUserInfo] objectForKey:@"id"] forKey:@"userId"];
    [dic setValue:self.userId forKey:@"buyerId"];

    [HttpTool postWithURL:@"Community/GetBuyerBaseGroup" params:dic success:^(id json) {
        
        if ([[json objectForKey:@"isSuccessful"] boolValue])
        {
            NSDictionary *dic = [json objectForKey:@"data"];
            self.circleId = [dic objectForKey:@"GroupId"];
            
            [self getRoomId];
        }
        else
        {
            [self showHudFailed:[json objectForKey:@"message"]];
        }
        
    } failure:^(NSError *error) {
        
    }];
    
    
    [[SocketManager socketManager].socket on:@"new message" callback:^(NSArray *args) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:args.firstObject];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:[dic objectForKey:@"fromUserId"] forKey:@"userId"];
        [HttpTool postWithURL:@"User/GetUserLogo" params:dict success:^(id json) {
            
            [dic setObject:[json objectForKey:@"logo"] forKey:@"logo"];
            [self.messageArr addObject:dic];
            [self.tableView reloadData];
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.messageArr.count-1 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionBottom];
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
    self.priceNum = 0;
    self.pageNum = 1;
    self.messageArr = [[NSMutableArray alloc] init];
    self.selectProLinkArr = [[NSMutableArray alloc] init];
    self.view.backgroundColor = kCustomColor(236, 240, 241);
    
    self.tableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, 50, kScreenWidth, kScreenHeight-49)];
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
    
    __weak CircleViewController *VC = self;
    self.tableView.headerRereshingBlock = ^{
        
        VC.pageNum++;
        [VC getMessageListData:YES];
    };
    
    [self.tableView hiddenHeader:YES];
    
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
    
}

-(void)getRoomId
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:self.circleId forKey:@"groupId"];
    [dic setValue:@"0" forKey:@"fromUser"];
    [dic setValue:@"0" forKey:@"toUser"];
    
    [HttpTool postWithURL:@"Community/GetRoom" params:dic isWrite:YES success:^(id json) {
        
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
    [self hudShowWithText:@"正在获取消息中..."];
    [HttpTool postWithURL:@"Community/GetMessages" params:dic success:^(id json) {
        
        [self textHUDHiddle];
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
                if (arr.count>0)
                {
                    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:arr.count inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
                }
            }
            else
            {
                if (self.messageArr.count>0)
                {
                    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.messageArr.count-1 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionBottom];
                }
            }
        }
        else
        {
            [self showHudFailed:[json objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [self textHUDHiddle];
    }];
}
-(void)creatRoom
{
    NSArray *arr;
    NSString *myId=[[Public getUserInfo]objectForKey:@"id"]; //买手
    NSString *type;
    
    type = @"group";
    arr = [chatRoomData objectForKey:@"userList"];
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
        listView.frame = CGRectMake(0, self.view.frame.size.height-49-64, kScreenWidth, 49);
        [self.view addSubview:listView];
    }
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
            [HttpTool postWithURL:@"Community/UploadChatImage" params:dic  isWrite:YES success:^(id json) {
                
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
    toUserId=@"0";
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
        NSDictionary *dic = @{@"fromUserId":myId,@"toUserId":toUserId,@"userName":toUserName,@"productId":@"",@"body":text,@"fromUserType":@"buyer",@"type":@"img",@"roomId":[chatRoomData objectForKey:@"id"]};
        [[SocketManager socketManager].socket emit:@"sendMessage" args:@[dic]];
        [self.messageArr addObject:msgDic];
    }
    else if ([type isEqualToString:@"发送商品"])
    {
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
            
            NSDictionary *dic = @{@"fromUserId":myId,@"toUserId":toUserId,@"userName":toUserName,@"productId":proId,@"body":imageURL,@"fromUserType":@"",@"type":@"product_img",@"roomId":[chatRoomData objectForKey:@"id"]};
            [[SocketManager socketManager].socket emit:@"sendMessage" args:@[dic]];
            [self.messageArr addObject:msgDic];
        }
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
        
        NSDictionary *dic = @{@"fromUserId":myId,@"toUserId":toUserId,@"userName":toUserName,@"productId":@"",@"body":text,@"fromUserType":@"buyer",@"type":@"",@"roomId":[chatRoomData objectForKey:@"id"]};
        [[SocketManager socketManager].socket emit:@"sendMessage" args:@[dic]];
        
        [self.messageArr addObject:msgDic];
    }
    listView.messageTF.text = @"";
    [self.tableView reloadData];
    
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.messageArr.count-1 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionBottom];
}


-(void)changeTableViewFrameWhileShow:(BOOL)isAction
{
    if(isAction == NO){
        self.tableView.frame = CGRectMake(0, 50, kScreenWidth, self.view.height-216-49);
        if([self.messageArr count] != 0){
            NSIndexPath *index = [NSIndexPath indexPathForRow:[self.messageArr count]-1 inSection:0];
            [self.tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }else{
        self.tableView.frame = CGRectMake(0, 50, kScreenWidth, self.view.height-49-164);
        if([self.messageArr count] != 0){
            NSIndexPath *index = [NSIndexPath indexPathForRow:[self.messageArr count]-1 inSection:0];
            [self.tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }
}

-(void)changeTableViewFrameWhileHidden
{
    self.tableView.frame = CGRectMake(0, 50, kScreenWidth, self.view.height-49-50);
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
                
                UIImageView *headerImage = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-10-40, 15, 40, 40)];
                headerImage.layer.cornerRadius = headerImage.width/2;
                headerImage.clipsToBounds = YES;
                [headerImage sd_setImageWithURL:[NSURL URLWithString:[msgDic objectForKey:@"logo"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                headerImage.tag = 1000+indexPath.row;
                headerImage.userInteractionEnabled = YES;
                [cell.contentView addSubview:headerImage];
                
                UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickHeaderImage:)];
                [headerImage addGestureRecognizer:tap];
                
                //图片
                NSString *type= [msgDic objectForKey:@"type"];
                if ([type isEqualToString:@"img"])
                {
                    [cell.contentView addSubview:[cell imageBubbleView:[msgDic objectForKey:@"body"] from:YES withPosition:60]];
                }
                //链接
                else if ([type isEqualToString:@"product_img"])
                {
                    NSString *imageURL = [NSString stringWithFormat:@"%@",[msgDic objectForKey:@"body"]];
                    //发送链接
                    [cell.contentView addSubview:[cell productLinkBubbleView:imageURL AndProcuctLink:[msgDic objectForKey:@"sharelink"] from:YES withPosition:60]];
                }
                else if ([type isEqualToString:@""]||!type)
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
                
                UIImageView *headerImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 40, 40)];
                headerImage.layer.cornerRadius = headerImage.width/2;
                headerImage.clipsToBounds = YES;
                [headerImage sd_setImageWithURL:[NSURL URLWithString:[msgDic objectForKey:@"logo"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                headerImage.tag = 1000+indexPath.row;
                headerImage.userInteractionEnabled = YES;
                [cell.contentView addSubview:headerImage];
                
                UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickHeaderImage:)];
                [headerImage addGestureRecognizer:tap];
                
                
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
        
        NSString *type = [msgDic objectForKey:@"type"];
        if ([type isEqualToString:@"img"])
        {
            return 170;
        }
        //链接
        else if ([type isEqualToString:@"product_img"])
        {
            return 170;
        }
        if ([type isEqualToString:@""]||!type)
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
    if (self.messageArr.count==0)
    {
        return;
    }
    NSMutableDictionary *msgDic = [self.messageArr objectAtIndex:indexPath.row];
    if ([[msgDic objectForKey:@"type"] isEqualToString:@"product_img"])
    {
        CusRProDetailViewController *VC = [[CusRProDetailViewController alloc] init];
        VC.productId = [msgDic objectForKey:@"productId"];
        [self.navigationController pushViewController: VC animated:YES];
    }
    
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


//圈子详情
-(void)didClickToDetail
{
    CusCircleDetailViewController *VC = [[CusCircleDetailViewController alloc] init];
    VC.circleId = self.circleId;
    [self.navigationController pushViewController:VC animated:YES];
}


//点击头像
-(void)didClickHeaderImage:(UITapGestureRecognizer *)tap
{
    NSDictionary *msgDic = [self.messageArr objectAtIndex:tap.view.tag-1000];
    //自己
    NSString *fromUserId = [NSString stringWithFormat:@"%@",[msgDic objectForKey:@"fromUserId"]];
    
    CusHomeStoreViewController *VC = [[CusHomeStoreViewController alloc] init];
    VC.userName = [msgDic objectForKey:@"userName"];
    VC.userId = fromUserId;
    [self.navigationController pushViewController:VC animated:YES];
}


@end
