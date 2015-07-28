//
//  BueryStoreDetailsController.m
//  joybar
//
//  Created by joybar on 15/5/28.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "BueryStoreDetailsController.h"

#import "BueryDetailsTableViewCell.h"
@interface BueryStoreDetailsController ()<UITableViewDataSource,UITableViewDelegate>{
    NSString *storeCode;
}
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableDictionary *dataArray;
@end

@implementation BueryStoreDetailsController
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
-(instancetype)initWithCode:(NSString *)code{
    if (self =[super init]) {
        storeCode=code;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavBarViewAndTitle:@"订单详情"];
    self.tableView =[[UITableView alloc]init];
    self.tableView.frame =CGRectMake(0, 64, kScreenWidth, kScreenHeight-64);
    self.tableView.restorationIdentifier =@"cell";
    self.tableView.delegate =self;
    self.tableView.dataSource =self;
    self.tableView.backgroundColor =kCustomColor(237, 237, 237);
    self.tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self setData:storeCode];
}

-(NSMutableDictionary *)dataArray{
    
    if (_dataArray ==nil) {
        _dataArray =[[NSMutableDictionary alloc]init];
    }
    return _dataArray;
}
-(void)setData:(NSString*)code
{
    [self showInView:self.tableView WithPoint:CGPointMake(0,0) andHeight:kScreenHeight-64];
    NSMutableDictionary * dict=[[NSMutableDictionary alloc]init];
    [dict setValue:code forKey:@"OrderNo"];
    [HttpTool postWithURL:@"Order/GetBuyerOrderDetail" params:dict success:^(id json) {
        BOOL isSuccessful = [[json objectForKey:@"isSuccessful"] boolValue];
        if (isSuccessful) {
            _dataArray = [json objectForKey:@"data"];
            [self.tableView reloadData];
        }else{
            [self showHudFailed:[json objectForKey:@"message"]];
        }
        [self activityDismiss];
    } failure:^(NSError *error) {
        [self showHudFailed:@"服务器正在维护,请稍后再试"];
        [self activityDismiss];
    }];
}
#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 440;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cell";
    BueryDetailsTableViewCell *  cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell =[[[NSBundle mainBundle] loadNibNamed:@"BueryDetailsTableViewCell" owner:self options:nil] lastObject];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (self.dataArray.count>0) {
        cell.orderNO.text = [self.dataArray objectForKey:@"OrderNo"];
        cell.orderState.text = [self.dataArray objectForKey:@"StatusName"];
        cell.orderPrice.text = [[self.dataArray objectForKey:@"RecAmount"] stringValue];
        cell.ordertoPrice.text = [[self.dataArray objectForKey:@"InCome"] stringValue];
        cell.userNO.text = [self.dataArray objectForKey:@"CustomerName"];
        cell.orderTime.text = [self.dataArray objectForKey:@"CreateTime"];
        NSString * temp =[NSString stringWithFormat:@"%@",[self.dataArray objectForKey:@"CustomerLogo"]];
        cell.userPic.layer.cornerRadius = cell.userPic.width/2;
        cell.userPic.clipsToBounds =YES;
        [cell.userPic sd_setImageWithURL:[NSURL URLWithString:temp] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        cell.userPhone.text = [self.dataArray objectForKey:@"CustomerMobile"];
        cell.userAddress.text = [self.dataArray objectForKey:@"CustomerAddress"];
        
    }

    return cell;
}


@end
