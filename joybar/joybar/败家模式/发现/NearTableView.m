//
//  NearTableView.m
//  joybar
//
//  Created by 123 on 15/6/10.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//
#import "NearTableView.h"
#import "CusNearTableViewCell.h"
#import "CusBuyerDetailViewController.h"
#import "NearItems.h"
@implementation NearTableView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        self.dataSource = self;
        self.delegate = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    CusNearTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell==nil)
    {
        cell = [[CusNearTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:iden];
    }
    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.dataArr.count>0)
    {
        cell.nearItems = [self.dataArr objectAtIndex:indexPath.row];
        [cell setData:nil];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kScreenWidth/3+55+25;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArr.count>0)
    {
        NearItems *items = [self.dataArr objectAtIndex:indexPath.row];
        CusBuyerDetailViewController *VC = [[CusBuyerDetailViewController alloc] init];
        VC.productId = items.ProductId;
        [self.viewController.navigationController pushViewController:VC animated:YES];
    }
}
@end
