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
@interface BuyerHomeViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *homeTableView;
@property (nonatomic,strong)NSMutableDictionary * dataArray;


@end

@implementation BuyerHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self addNavBarViewAndTitle:@"首页"];
    self.view.backgroundColor =  kCustomColor(237, 237, 237);

    self.homeTableView.delegate =self;
    self.retBtn.hidden = YES;
    self.homeTableView.tableFooterView =  [[UIView alloc]initWithFrame:CGRectZero];
    if (kScreenWidth ==320) {
        self.homeTableView.rowHeight =65;
    }
    else{
        self.homeTableView.rowHeight =90;

    }
    [self setData];
}

-(NSMutableDictionary *)dataArray{

    if (_dataArray ==nil) {
        _dataArray =[[NSMutableDictionary alloc]init];
    }
    return _dataArray;
}

-(void)setData{

     [HttpTool postWithURL:@"Buyer/Index" params:nil success:^(id json) {
        
         BOOL isSuccessful = [[json objectForKey:@"isSuccessful"] boolValue];
         if (isSuccessful) {
             self.dataArray = [json objectForKey:@"data"];
             [self.homeTableView reloadData];
         }
     } failure:^(NSError *error) {
         
     }];

}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 160;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView * hearView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 160)];
    hearView.backgroundColor =kCustomColor(241, 241, 241);
    UIImageView * img=[[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth-120)*0.5, 12, 120, 120)];
    
    [img sd_setImageWithURL:[NSURL URLWithString:[self.dataArray objectForKey:@"barcode"]] placeholderImage:nil];
    [hearView addSubview:img];
    UILabel * lable =[[UILabel alloc]initWithFrame:CGRectMake(0, img.bottom+5, kScreenWidth, 15)];
    lable.textAlignment =NSTextAlignmentCenter;
    lable.text = [self.dataArray objectForKey:@"shopname"];
    lable.font =[UIFont fontWithName:@"youyuan" size:15];
    [hearView addSubview:lable];
    return hearView;
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
        NSString *tempPirce =[[[self.dataArray objectForKey:@"income"] objectForKey:@"today_income"] stringValue];
        if (tempPirce.length>0) {
            cell.pirceD1View.text =[NSString stringWithFormat:@"%@.00",tempPirce];
        }else{
            cell.pirceD1View.text=@"0.00";
        }
        NSString *tempPirceD2 =[[[self.dataArray objectForKey:@"income"] objectForKey:@"total_income"] stringValue];
        if (tempPirce.length >0) {
            cell.pirceD2View.text =[NSString stringWithFormat:@"%@.00",tempPirceD2];
        }else{
            cell.pirceD2View.text=@"0.00";
        }
        cell.pirceDd1View.hidden =NO;
        cell.pirceDd2View.hidden =NO;
    }
    else if(indexPath.row ==1){
        cell.iconView.image =[UIImage imageNamed:@"pic4"] ;
        cell.tilteView.text =@"收益管理";
        cell.tilteD1View.text =@"今日收益";
        cell.tilteD2View.text =@"累积收益";
        cell.pirceD1View.text =@"500";
        NSString *tempPirce =[[[self.dataArray objectForKey:@"income"] objectForKey:@"today_income"] stringValue];
        if (tempPirce.length>0) {
            cell.pirceD1View.text =[NSString stringWithFormat:@"%@.00",tempPirce];
        }else{
            cell.pirceD1View.text=@"0.00";
        }
        NSString *tempPirceD2 =[[[self.dataArray objectForKey:@"income"] objectForKey:@"total_income"] stringValue];
        if (tempPirce.length >0) {
            cell.pirceD2View.text =[NSString stringWithFormat:@"%@.00",tempPirceD2];
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
        cell.tilteView.text =@"好友管理";
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
        
        BuyerInComeViewController * income= [[BuyerInComeViewController alloc]initWithComeIn:come];
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


@end
