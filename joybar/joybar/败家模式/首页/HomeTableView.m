//
//  HomeTableView.m
//  joybar
//
//  Created by 123 on 15/6/9.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "HomeTableView.h"
#import "CusHomeTableViewCell.h"
#import "CusRProDetailViewController.h"
#import "HomeProduct.h"
#import "CusZProDetailViewController.h"
#import "CusMarketViewController.h"
@implementation HomeTableView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        self.dataArr = [NSMutableArray array];
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSelectionStyleNone;

    }
    return self;
}

#pragma mark tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden = @"cell";
    CusHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell==nil)
    {
        cell = [[CusHomeTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:iden];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (self.dataArr.count>0)
    {
        [cell setData:self.dataArr[indexPath.row] andIndexPath:indexPath];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArr.count>0)
    {
        NSString *StoreLeave = [NSString stringWithFormat:@"%@",[self.dataArr[indexPath.row] objectForKey:@"StoreLeave"]];
        if ([StoreLeave isEqualToString:@"8"])
        {
            //认证买手
            return (kScreenWidth-20)/3-10+190;
        }
        else
        {
            //商场
            return (kScreenWidth-20)/3-10+150;
        }
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CusMarketViewController *VC = [[CusMarketViewController alloc] init];
    
    NSDictionary *dic = self.dataArr[indexPath.row];
    
    NSString *StoreLeave = [NSString stringWithFormat:@"%@",[self.dataArr[indexPath.row] objectForKey:@"StoreLeave"]];
    
    if ([StoreLeave isEqualToString:@"8"])
    {
        //认证买手
        VC.marketName = @"认证买手";
        VC.locationStr = [dic objectForKey:@"Location"];
        
    }
    else
    {
        //商场
        VC.storeId = [dic objectForKey:@"StoreId"];
        VC.marketName = [dic objectForKey:@"StoreName"];
        [VC.brandArr addObjectsFromArray:[dic objectForKey:@"Brands"]];
        VC.describeStr = [dic objectForKey:@"Description"];
    }
    
    [self.viewController.navigationController pushViewController:VC animated:YES];
//    if (self.dataArr.count==0)
//    {
//        return;
//    }
//    CusZProDetailViewController *VC = [[CusZProDetailViewController alloc] init];
//    HomeProduct *pro = [self.dataArr objectAtIndex:indexPath.row];
//    VC.productId = pro.ProductId;
//    [self.viewController.navigationController pushViewController:VC animated:YES];
    
//    CusBuyerDetailViewController *VC = [[CusBuyerDetailViewController alloc] init];
//    HomeProduct *pro = [self.dataArr objectAtIndex:indexPath.row];
//    VC.productId = pro.ProductId;
//    [self.viewController.navigationController pushViewController:VC animated:YES];
}

@end
