//
//  BuyerTicketDetailsViewController.m
//  joybar
//
//  Created by joybar on 15/6/16.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "BuyerTicketDetailsViewController.h"

@interface BuyerTicketDetailsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableDictionary *dataArray;
@property (nonatomic,strong)NSMutableArray *historyArray;

@end

@implementation BuyerTicketDetailsViewController
-(NSMutableDictionary *)dataArray{
    if (_dataArray ==nil) {
        _dataArray =[[NSMutableDictionary alloc]init];
    }
    return _dataArray;
}
-(NSMutableArray *)historyArray{
    if (_historyArray ==nil) {
        _historyArray =[[NSMutableArray alloc]init];
    }
    return _historyArray;
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
    //tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) style:(UITableViewStyleGrouped)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.retBtn.hidden =YES;
    [self addNavBarViewAndTitle:self.Name];
    [self setData];
}
-(void)setData{
    [self showInView:self.view WithPoint:CGPointMake(0, 64) andHeight:kScreenHeight-64];

    NSMutableDictionary *dict= [[NSMutableDictionary alloc]init];
    [dict setObject:self.Id forKey:@"promotionId"];
    [HttpTool postWithURL:@"Promotion/Detail" params:dict success:^(id json) {
        BOOL  isSuccessful =[[json objectForKey:@"isSuccessful"] boolValue];
        if (isSuccessful) {
            self.dataArray =[json objectForKey:@"data"];
            self.historyArray =[[json objectForKey:@"data"] objectForKey:@"history"];
            [self.tableView reloadData];
        }else{
            [self showHudFailed:@"加载失败"];
        }
        [self activityDismiss];
    } failure:^(NSError *error) {
        [self activityDismiss];
    }];
}
#pragma mark tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.historyArray.count>0) {
        return 3;
    }
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section ==2) {
        return self.historyArray.count+1;
    }
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    
    cell.textLabel.font =[UIFont systemFontOfSize:16];
    if (indexPath.section==0 &&indexPath.row ==0) {
        cell.textLabel.text =@"奖励说明";
    }else if(indexPath.section == 0&&indexPath.row ==1){
        NSLog(@"%@",[self.dataArray objectForKey:@"desc"]);
        cell.textLabel.text=[self.dataArray objectForKey:@"desc"];
        cell.textLabel.numberOfLines =0;
        cell.textLabel.font =[UIFont systemFontOfSize:14];
        

    }else if(indexPath.section == 1&&indexPath.row ==0){
        cell.textLabel.text=@"当前进度";
    }else if(indexPath.section == 1&&indexPath.row ==1){
        cell.textLabel.text=[self.dataArray objectForKey:@"tip"];
        cell.textLabel.font =[UIFont systemFontOfSize:14];

    }else if(indexPath.section ==2&&indexPath.row ==0){
          cell.textLabel.text=@"历史记录";
    }else if(indexPath.section ==2 &&indexPath.row >0){
        cell.textLabel.text = [self.historyArray[indexPath.row-1] objectForKey:@"endtime"];
        cell.detailTextLabel.text =  [self.historyArray[indexPath.row-1] objectForKey:@"status_str"];
        cell.textLabel.font =[UIFont systemFontOfSize:14];
        cell.detailTextLabel.font =[UIFont systemFontOfSize:14];

    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0&& indexPath.row ==1) {
        
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        NSString *cellText = cell.textLabel.text;
        UIFont *cellFont = [UIFont systemFontOfSize:12];
        CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
        CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:0];
        
        return labelSize.height + 44-12;
        return cell.frame.size.height;
    }
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
@end
