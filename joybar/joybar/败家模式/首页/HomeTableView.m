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
#import "CusZProDetailViewController.h"
@implementation HomeTableView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSelectionStyleNone;

    }
    return self;
}

#pragma mark tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
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
    
    [cell setData:nil andIndexPath:indexPath];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row==0)
    {
        return 100;
    }
    
    //商场
//    return (kScreenWidth-20)/3-10+150;
    //认证买手
    return (kScreenWidth-20)/3-10+190;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArr.count==0)
    {
        return;
    }
    CusZProDetailViewController *VC = [[CusZProDetailViewController alloc] init];
    HomeProduct *pro = [self.dataArr objectAtIndex:indexPath.row];
    VC.productId = pro.ProductId;
    [self.viewController.navigationController pushViewController:VC animated:YES];
    
//    CusBuyerDetailViewController *VC = [[CusBuyerDetailViewController alloc] init];
//    HomeProduct *pro = [self.dataArr objectAtIndex:indexPath.row];
//    VC.productId = pro.ProductId;
//    [self.viewController.navigationController pushViewController:VC animated:YES];
}

@end
