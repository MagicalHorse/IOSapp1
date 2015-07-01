//
//  HomeTableView.m
//  joybar
//
//  Created by 123 on 15/6/9.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "HomeTableView.h"
#import "CusHomeTableViewCell.h"
#import "CusBuyerDetailViewController.h"
#import "HomeProduct.h"
@implementation HomeTableView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        self.delegate = self;
        self.dataSource = self;
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
    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    

    if (self.dataArr.count>0)
    {
        HomeProduct *homePro = [self.dataArr objectAtIndex:indexPath.row];
        cell.homePro = homePro;
        [cell setData:nil];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeProduct *pro = [self.dataArr objectAtIndex:indexPath.row];
    if (pro.Promotion)
    {
        return kScreenHeight-100;
    }
    return kScreenHeight-150;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArr.count==0)
    {
        return;
    }
    CusBuyerDetailViewController *VC = [[CusBuyerDetailViewController alloc] init];
    HomeProduct *pro = [self.dataArr objectAtIndex:indexPath.row];
    VC.productId = pro.ProductId;
    [self.viewController.navigationController pushViewController:VC animated:YES];
}


@end
